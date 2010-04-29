#!/usr/bin/python

import re, string, sys, struct

format_rev = 1

patterns = {
  'dion': {
    'line': r"^(\[pid\s+[0-9]+\])?\s+([0-9.]+)\s+(.+?)\s*$",
    },
  'daniel': {
    'line': r"^([0-9]+)\s+([0-9.]+)\s+(.+)$",
    'func': r"^(\w+)\((.*)\)\s*=\s*(.+)$",
    'sig': r"^---\s+(.*?)\s+---$",
    },
  'stefan': {
    'line': r"^([0-9]+)\s+(.+)$",
    'func': r"^(\w+)\((.*)\)\s*=\s*([-\w]+)\s*(.*)$",
    'func-unfinished': r"^(\w+)\((.*)\s* <unfinished \.\.\.>$",
    'func-resumed': r"^<\.\.\. (\w+) resumed> (.*)\)\s*=\s*([-\w]+)\s*(.*)$",
    'sig': r"^---\s+(.*?)\s+---$",
    },
  }

p = patterns['stefan']

def debug_on(*text):
  for x in text:
    print x,
  print

def debug_off(*text):
  pass

debug = debug_off

hextable = ''
for i in range(256):
  if chr(i) in string.whitespace:
    hextable += '.'
  elif chr(i) in string.printable:
    hextable += chr(i)
  else:
    hextable += '.'

def hexdump( chars, width=16 ):
  offset = 0
  while chars:
    line = chars[0:width]
    chars = chars[width:]
    filler = width - len(line)
    print "%s%s%s%s" % ( '%08x ' % offset, ' '.join( map( lambda c: "%02x" % ord(c), line ) + ['  ']*filler),
                       '   ', line.translate(hextable) + ' '*filler)
    offset += 16

PIDs = {}

class PID(object):
  def __init__(self, FDs=None):
    self.funcs = {
      'open': self._open,
      'write': self._write,
      'writev': self._writev,
      'read': self._read,
      'close': self._close,
      'clone': self._clone,
      }
    self.FHs_closed = []
    if FDs:
      self.FHs = FDs
    else:
      self.FHs = {}
    self.unfinished = None
  def elapse(self, time):
    pass
  def handle(self, data):
    mo = re.match(p['func'], data)
    if mo:
      debug('FUNC:', mo.groups())
      name, params, result, rest = mo.groups()
      if name in pid.funcs:
        pid.funcs[name](params, result)
      return
    mo = re.match(p['func-unfinished'], data)
    if mo:
      debug('FUNC-UNFINISHED:', mo.groups())
      name, params = mo.groups()
      self.unfinished = (name, params)
      return
    mo = re.match(p['func-resumed'], data)
    if mo:
      debug('FUNC-RESUMED:', mo.groups(), self.unfinished)
      name1, params1 = self.unfinished
      self.unfinished = None
      name2, params2, result, rest = mo.groups()
      assert name1 == name2
      name = name1
      params = params1 + params2
      if name in pid.funcs:
        pid.funcs[name](params, result)
      return
    mo = re.match(p['sig'], data)
    if mo:
      debug('SIG:', mo.groups())
      return
    debug('FIXME:', data)
  def _clone(self, params, result):
    if 'CLONE_FILES' in params:
      PIDs[int(result)] = PID(FDs=self.FHs)
  def _open(self, params, result):
    if int(result) < 0:
      debug( "OPEN: ERROR" )
      return
    mo = re.match(r"\"(.*?)(?<!\\)\", ([[\w|_]+)", params)
    debug( mo.groups() )
    filename, flags = mo.groups()
    filename = eval("str('%s')" % filename)

    assert not int(result) in self.FHs
    self.FHs[int(result)] = FH(id=int(result), filename=filename)
    debug( "OPEN:", repr(filename), flags, result )
  def _close(self, params, result):
    (fd,) = eval('('+params+',)')
    if fd not in self.FHs:
      debug( "CLOSE: unkown fd %i" % fd )
      return
    filename = self.FHs[fd].filename
    self.FHs_closed.append(self.FHs[fd])
    del self.FHs[fd]
    debug( "CLOSE:", fd, repr(filename), result )
  def _write(self, params, result):
    mo = re.match(r"([0-9]+), \"(.*?)(?<!\\)\", ([0-9]+)", params)
    debug( mo.groups() )
    fh, data, length = mo.groups()
    fh = int(fh)

    data = eval("str('%s')" % data)
    length = int(length)
    fh = self.FHs.setdefault(fh, FH(id=fh))
    debug( "WRITE:", fh, repr(data), length )
    fh.write(data)
  def _writev(self, params, result):
    pass
    """
    mo = re.match(r"([0-9]+), \[({[^\]]*})\], ([0-9]+)", params)
    debug( mo.groups() )
    fh, dataarray, length = mo.groups()
    fh = int(fh)

    data = ""
    for mo in re.finditer(r"{\"([^}]*)\", ([0-9]+)[^{]*}", dataarray):
      data += mo.group(1)
    data = eval("str('%s')" % data)
    length = int(length)
    fh = self.FHs.setdefault(fh, FH(id=fh))
    debug( "WRITEV:", fh, repr(data), length )
    fh.write(data)
    """
  def _read(self, params, result):
    if int(result) < 0:
      debug( "READ: ERROR" )
      return
    mo = re.match(r"([0-9]+), \"(.*?)(?<!\\)\", ([0-9]+)", params)
    debug( mo.groups() )
    fh, data, length = mo.groups()
    fh = int(fh)

    data = eval("str('%s')" % data)
    length = int(length)
    fh = self.FHs.setdefault(fh, FH(id=fh))
    debug( "READ:", fh, repr(data), length )
    fh.read(data)

class Packetizer(object):
  def __init__(self):
    self.input = ''
    self.output = []
  def feed(self, data):
    self.input += data
    start = self.input.find('\xfa')
    if start < 0:
      return
    elif start > 0:
      self.input = self.input[start:]
    end = self.input.find('\x7e')
    if end < 0:
      return
    packet = self.input[:end+1]
    packet = packet.replace('\x7d\x5d', '\x7d')
    packet = packet.replace('\x7d\x5e', '\x7e')
    self.input = self.input[end+1:]
    self.output.append(packet)
    return packet

class FHBase(object):
  def __init__(self, id=None, filename=None):
    self.id = id
    self.filename = filename
    debug( "NEW FH:", self )
  def __repr__(self):
    return "<file handle %s for %s>" % (self.id, repr(self.filename))
  def read(self, data):
    pass
  def write(self, data):
    pass


class FHLogger(FHBase):
  def __init__(self, id=None, filename=None):
    FHBase.__init__(self, id, filename)
    if filename == '/dev/modemuart':
      self.packets_r = Packetizer()
      self.packets_w = Packetizer()
    else:
      self.packets_r = None
      self.packets_w = None
  def read(self, data):
    if not self.filename == "/dev/modemuart":
        return
    packet = None
    if self.packets_w:
      packet = self.packets_r.feed( data )
    if packet:
      self.write_packet_header(len(packet), 0x1)
      fout.write(packet)

  def write(self, data):
    if not self.filename == "/dev/modemuart":
      return
    packet = None
    if self.packets_w:
      packet = self.packets_w.feed( data )
    if packet:
      self.write_packet_header(len(packet), 0x2)
      fout.write(packet)

  def write_packet_header(self, len, type):
    # this packet is from a read or write operation?
    fout.write(struct.pack("b", type))

    # len of the data 
    fout.write(struct.pack("i", len))


FH = FHLogger



fout = open(sys.argv[2], "wb")

# write dump header
fout.write(struct.pack("I", 0xdeadbeef))
fout.write(struct.pack("b", format_rev))

for line in file(sys.argv[1]):
  line = line.rstrip('\n')
  if not line or line[0] == ' ':
    continue
  debug( line )
  pid, rest = line.split(None, 1)
  pid = PIDs.setdefault(int(pid), PID())
  pid.handle(rest)

fout.close()

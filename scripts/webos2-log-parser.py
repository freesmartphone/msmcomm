#!/usr/bin/python

import re, string, sys

patterns = {
    'other-line': "^.*}:\s(.*)$",
    'hci-line': "^.*{TIL\.HCI}: (.*)$",
    'hci-header': "^HCI Header",
    'hci-message-description': "^\[HCI\]\s<(.*),\s(.*)>\s:\s<(.*),\s(.*)>$",
    'hci-message-description2': "^<(.*),\s(.*)>\s:\s<(.*),\s(.*)>$",
    'hci-message-body': "^HCI Message Body",
    'hci-separator': "************************************************",
}

def hexdump( bytes, width=16 ):
    if len(bytes) < 1:
        return

    i = -1
    hexline = ""
    ascline = ""
    offset = 0
    for byte in bytes:
        i += 1
        b = int("0x%s" % byte, 0)
        hexline += "%02x " % b
        if b > 31 and b < 128:
            ascline += "%c" % b
        else:
            ascline += "."

        if i % width +1 == width:
            hexline += ascline
            print "%08x %s" % (offset, hexline)
            offset += width
            hexline = ""
            ascline = ""

    if i % width + 1 != width:
        while len(hexline) < 52:
            hexline += ' '
        hexline += ascline
        print "%08x %s" % (offset, hexline)

STATE_INVALID = 0
STATE_HEADER = 1
STATE_BODY = 2

class Parser:
    def __init__(self):
        self.state = STATE_INVALID
        self.current_message = { }

    def print_message(self, message):
        print "".join(['='] * 80)
        print "MESSAGE: subsys = %s, message = %s" % (message["subsys_type"], message["message_type"])
        print "MESSAGE: group_id = %s, message_id = %s" % (message["group_id"], message["msg_id"])
        print "MESSAGE: data_len = %i" % len(message["data"])
        print "".join(['-'] * 80)
        hexdump(message["data"])
        print "".join(['='] * 80)

    def feed(self, data):
        # do we have a hci relevant line?
        line = self.parse_hci(data)
        if line == None:
            if self.state != STATE_INVALID:
                if len(self.current_message) == 5:
                    self.print_message(self.current_message)
                self.current_message = {}
                self.state = STATE_INVALID
            parts = self.check_pattern(patterns["other-line"], data)
            print parts[0]
            return

        line = line[0]

        if self.state == STATE_INVALID:
            if not self.check_pattern(patterns["hci-header"], line) == None:
                self.state = STATE_HEADER
                return

        elif self.state == STATE_HEADER:
            if not self.check_pattern(patterns["hci-message-body"], line) == None:
                self.state = STATE_BODY
                return
            elif line.startswith("[HCI]") or line.startswith("<"):
                line = line.lstrip("[HCI] ")
                group_id, msg_id, subsys_type, message_type = self.check_pattern(patterns["hci-message-description2"], line)
                self.current_message["group_id"] = group_id
                self.current_message["msg_id"] = msg_id
                self.current_message["subsys_type"] = subsys_type
                self.current_message["message_type"] = message_type

        elif self.state == STATE_BODY:
            if line == patterns["hci-separator"]:
                return
            elif not line.startswith("-"):
                bytes = line.split(" ")
                if not self.current_message.has_key("data"):
                    self.current_message["data"] = []
                self.current_message["data"] += bytes

    def parse_hci(self, data):
        return self.check_pattern(patterns["hci-line"], data)

    def check_pattern(self, pattern, data):
        result = None
        mo = re.match(pattern, data)
        if mo:
            result = mo.groups()
        return result

if __name__ == "__main__":
    parser = Parser()
    for line in file(sys.argv[1]):
        line = line.rstrip('\n')
        if not line or line[0] == ' ':
            continue
        line = line.rstrip(' ')
        parser.feed(line)


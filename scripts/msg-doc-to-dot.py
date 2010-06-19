#!/usr/bin/python

import sys,  xml.sax.handler

class Doc2DotHandler(xml.sax.handler.ContentHandler):
    def __init__(self):
        self.commands = { }
        self.current_command = ""

    def startElement(self, name, attributes):
        if name == "command":
            self.current_command = attributes["name"]
            self.commands[self.current_command] = []
        elif name == "response-is":
            self.commands[self.current_command].append(attributes["name"])
    def endElement(self, name):
        if name == "messages":
            print self.commands
            print "digraph depends {"
            for cmd, response in self.commands.items():
                print "\"%s\" [label=\"%s\"]" %(cmd,cmd)
                for r in response:
                    print "\"%s\" -> \"%s\"" % (cmd,r)
            print "}"

if __name__ == "__main__":
    parser = xml.sax.make_parser()
    handler = Doc2DotHandler()
    parser.setContentHandler(handler)
    parser.parse(sys.argv[1])

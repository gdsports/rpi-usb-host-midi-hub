#!/usr/bin/python

import re, os
from subprocess import Popen, PIPE

def os_system(command):
    process = Popen(command, stdout=PIPE, shell=True)
    while True:
        line = process.stdout.readline()
        if not line:
            break
        yield line

midiout = []
midiin = []

for line in os_system("/usr/bin/aconnect -l -o"):
    client=re.search("client (\d*)\:", line)
    if client and not re.search("Through", line):
        if client.group(1) != '0':
                midiin.append(client.group(1))

for line in os_system("/usr/bin/aconnect -l -i"):
    client=re.search("client (\d*)\:", line)
    if client and not re.search("Through", line):
        if client.group(1) != '0':
                midiout.append(client.group(1))

for midi_o in midiout:
    for midi_i in midiin:
        if midi_o != midi_i:
            os.system("/usr/bin/aconnect " + midi_o + ":0 " + midi_i + ":0")

#!/usr/bin/python

import sys
import subprocess
import os

afile = "prog_mem.vhd"
ofile = "prog_mem_orig.vhd"
progfile = "rawOutput.hex"
destination = open(afile, "w") #Overwrites entire file
source = open(ofile, "r")
prog = open(progfile, "r")
for line in source: #Replace lines in the file
  if (line.find("--PROGRAM HERE") != -1):
    for writeline in prog:
	  destination.write("\tx\"%04X\",\n" % (int(writeline, 16)))
  else:
    destination.write(line)
source.close()
destination.close()
prog.close()



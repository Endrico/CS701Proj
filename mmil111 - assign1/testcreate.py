#!/usr/bin/python

import sys
import subprocess
import os

afile = "mem.vhd"
ofile = "mem_orig.vhd"
progfile = "test.asm"
destination = open(afile, "w") #Overwrites entire file
source = open(ofile, "r")
prog = open(progfile, "r")
for line in source: #Replace lines in the file
  if (line.find("--PROGRAM HERE") != -1):
    for writeline in prog:
      if(writeline.find("LDR") != -1):
        op = 0x40
        part = writeline.split()
        rz = int(part[1].strip('$'))
        if(part[2].find("0b") != -1):
          operand = int(part[2][2:18],2)
        else:
          operand = int(part[2])
        destination.write("x\"%02X%1X0\",x\"%04X\",x\"0000\",\n" % (op, rz, operand))
      elif (writeline.find("ADD") != -1):
        op = 0xF8
        part = writeline.split()
        rz = int(part[1].strip('$'))
        rx = int(part[3].strip('$'))
        destination.write("x\"%02X%1X%1X\",x\"0000\",x\"0000\",\n" % (op, rz, rx))
      elif (writeline.find("AND") != -1):
        op = 0xC8
        part = writeline.split()
        rz = int(part[1].strip('$'))
        rx = int(part[3].strip('$'))
        destination.write("x\"%02X%1X%1X\",x\"0000\",x\"0000\",\n" % (op, rz, rx))
  else:
    destination.write(line)
source.close()
destination.close()
prog.close()



afile = "Task1Code.h"
progfile = "test.asm"
destination = open(afile, "w") #Overwrites entire file
num_lines = sum(1 for line in open(progfile))
prog = open(progfile, "r")
destination.write("#ifndef __Task1Code_H_\n#define __Task1Code_H_\n\n")
destination.write("#define I_REG_SIZE %d\n" % (num_lines*3))
destination.write("int I_reg[I_REG_SIZE] = {\n")
for writeline in prog:
  if(writeline.find("LDR") != -1):
    op = 0x40
    part = writeline.split()
    rz = int(part[1].strip('$'))
    if(part[2].find("0b") != -1):
      operand = int(part[2][2:18],2)
    else:
      operand = int(part[2])
    destination.write("  0x%02X%1X0,0x%04X,0x0000,\n" % (op, rz, operand))
  elif (writeline.find("ADD") != -1):
    op = 0xF8
    part = writeline.split()
    rz = int(part[1].strip('$'))
    rx = int(part[3].strip('$'))
    destination.write("  0x%02X%1X%1X,0x0000,0x0000,\n" % (op, rz, rx))
  elif (writeline.find("AND") != -1):
    op = 0xC8
    part = writeline.split()
    rz = int(part[1].strip('$'))
    rx = int(part[3].strip('$'))
    destination.write("  0x%02X%1X%1X,0x0000,0x0000,\n" % (op, rz, rx))
destination.write("};\n\n")
destination.write("#endif /* __Task1Code_H_ */\n")
destination.close()
prog.close()

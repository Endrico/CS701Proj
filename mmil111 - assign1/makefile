SOURCES=proc_test_bench.cpp proc_test_bench_2.cpp ALU.cpp ControlUnit.cpp IR.cpp Mul2.cpp Mul4.cpp RF.cpp
VHDLSRC=counter.vhd mem.vhd
OBJECTS=$(SOURCES:.cpp=.o)
VHDOBJ=$(SOURCES:.vhd=.o)

all: $(SOURCES) $(VHDLSRC) link vhdl

link: $(OBJECTS)
	sccom -link -work work

.cpp.o:
	sccom -reportprogress -work work $<

vhdl: $(VHDOBJ)
	
.vhd.o:
	vcom -reportprogress 300 -work work $<

clean:
	rm work/_sc/win32_gcc-4.2.1/*.o


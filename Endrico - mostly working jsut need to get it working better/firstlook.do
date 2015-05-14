onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/RST
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/CLK
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/sel_x
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/sel_z
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/wr_en
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/wr_dest
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/wr_data
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/X
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/Z
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/ccd
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/pcd
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_ALU/out
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/alu_op
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/sel_x
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/sel_z
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/wr_dest
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/wr_en
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/zout
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/state
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_IR/IReg
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/instruction
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/operand
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_IR/I_in
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_PC/PC_reg_ld
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_IR/ld_IR
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/operand
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/instruction
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/Rx
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/Rz
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/AM
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_PC/PCMux_out
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_PC/Prog_mem_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
configure wave -valuecolwidth 70
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {125 ns}

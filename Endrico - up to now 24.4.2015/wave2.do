onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/state
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/AM
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/CLK
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/Opcode
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/Rx
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/Rz
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/sel_x
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/sel_z
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_controlunit/wr_dest
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/RF_sel/in1
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/RF_sel/out
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/RF_sel/select
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/wr_data
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/wr_dest
add wave -noupdate -radix hexadecimal /assignment_test_bench/my_processor/my_datapath/my_RF/wr_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {150 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 208
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {575 ns}

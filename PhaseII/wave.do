onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_bench/uut/b2v_ControlUnit/STATE
add wave -noupdate /test_bench/uut/b2v_ControlUnit/CLK
add wave -noupdate /test_bench/uut/b2v_ControlUnit/AM
add wave -noupdate /test_bench/uut/b2v_ControlUnit/OPCODE
add wave -noupdate /test_bench/uut/b2v_ControlUnit/RX
add wave -noupdate /test_bench/uut/b2v_ControlUnit/RZ
add wave -noupdate -radix hexadecimal /test_bench/uut/b2v_Datapath/b2v_RF_inst/data
add wave -noupdate -radix hexadecimal -childformat {{/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(0) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(1) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(2) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(3) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(4) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(5) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(6) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(7) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(8) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(9) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(10) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(11) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(12) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(13) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(14) -radix hexadecimal} {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(15) -radix hexadecimal}} -expand -subitemconfig {/test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(0) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(1) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(2) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(3) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(4) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(5) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(6) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(7) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(8) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(9) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(10) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(11) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(12) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(13) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(14) {-height 15 -radix hexadecimal} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM(15) {-height 15 -radix hexadecimal}} /test_bench/uut/b2v_Datapath/b2v_RF_inst/DATA_MEM
add wave -noupdate -radix hexadecimal /test_bench/uut/b2v_Datapath/b2v_DCPR_reg/output
add wave -noupdate -radix hexadecimal /test_bench/uut/b2v_Datapath/b2v_DPRR_reg/output
add wave -noupdate -radix hexadecimal /test_bench/uut/b2v_Datapath/b2v_DM_inst/DATA_MEM(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109356 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits us
update
WaveRestoreZoom {156800 ps} {412800 ps}

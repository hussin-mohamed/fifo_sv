vlib work
vlog +define+assertion -f src_files.list +cover -covercells
vsim -voptargs=+acc work.fifo_top -cover
add wave -position insertpoint  \
sim:/fifo_top/inter/almostempty \
sim:/fifo_top/inter/almostfull \
sim:/fifo_top/inter/clk \
sim:/fifo_top/inter/data_in \
sim:/fifo_top/inter/data_out \
sim:/fifo_top/inter/empty \
sim:/fifo_top/inter/full \
sim:/fifo_top/inter/overflow \
sim:/fifo_top/inter/rd_en \
sim:/fifo_top/inter/rst_n \
sim:/fifo_top/inter/underflow \
sim:/fifo_top/inter/wr_ack \
sim:/fifo_top/inter/wr_en
add wave -position insertpoint  \
sim:/fifo_top/DUT/count
run -all
coverage save fifo.ucdb -onexit
#vcover report fifo.ucdb -details -all -output coverage_rpt_fifo.txt
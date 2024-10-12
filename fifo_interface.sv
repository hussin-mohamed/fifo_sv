interface inter(clk);
    parameter FIFO_WIDTH = 16;
    input clk;
    logic [FIFO_WIDTH-1:0] data_in;
    logic  rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    modport DUT (
    input clk,data_in,rst_n,wr_en,rd_en,
    output data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow
    );
    modport TB (
    input clk,rd_en,data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow,
    output data_in,rst_n,wr_en
    );
    modport MONITOR (
    input clk,rd_en,data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow,data_in,rst_n,wr_en
    );    
endinterface //inter
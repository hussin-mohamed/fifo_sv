////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(inter.DUT intt);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8; 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge intt.clk or negedge intt.rst_n) begin
	if (!intt.rst_n) begin
		wr_ptr <= 0;
	end
	else if (intt.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= intt.data_in;
		intt.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		intt.wr_ack <= 0; 
		if (intt.full & intt.wr_en)
			intt.overflow <= 1;
		else
			intt.overflow <= 0;
	end
end

always @(posedge intt.clk or negedge intt.rst_n) begin
	if (!intt.rst_n) begin
		rd_ptr <= 0;
	end
	else if (intt.rd_en && count != 0) begin
		intt.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge intt.clk or negedge intt.rst_n) begin
	if (!intt.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({intt.wr_en, intt.rd_en} == 2'b10) && !intt.full) 
			count <= count + 1;
		else if ( ({intt.wr_en, intt.rd_en} == 2'b01) && !intt.empty)
			count <= count - 1;
	end
end

assign intt.full = (count == FIFO_DEPTH)? 1 : 0;
assign intt.empty = (count == 0)? 1 : 0;
assign intt.underflow = (intt.empty && intt.rd_en)? 1 : 0; 
assign intt.almostfull = (count == FIFO_DEPTH-2)? 1 : 0; 
assign intt.almostempty = (count == 1)? 1 : 0;

endmodule

////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO_corrected(inter.DUT intt);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8; 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);
reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge intt.clk or negedge intt.rst_n) begin
	if (!intt.rst_n) begin
		wr_ptr <= 0;
		//
		intt.overflow <= 0;
		intt.wr_ack <= 0;
	end
	else if (intt.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= intt.data_in;
		intt.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		//
		intt.overflow <= 0;
	end
	else begin 
		intt.wr_ack <= 0; 
		if (intt.full && intt.wr_en) begin
			intt.overflow <= 1;
		end
			
		else begin
			intt.overflow <= 0;
		end
			
	end
end

always @(posedge intt.clk or negedge intt.rst_n) begin
	if (!intt.rst_n) begin
		rd_ptr <= 0;
		//
		intt.underflow <= 0;
	end
	else if (intt.rd_en && count != 0) begin
		intt.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		//
		intt.underflow <= 0;
	end
	//
	else begin 
		if (intt.empty && intt.rd_en) begin
			intt.underflow <= 1;
		end
			
		else begin
			intt.underflow <= 0;
		end
			
	end
end

always @(posedge intt.clk or negedge intt.rst_n) begin
	if (!intt.rst_n) begin
		count <= 0;
	end
	else begin
		//
		if (({intt.wr_en, intt.rd_en} == 2'b11)) begin
			if (intt.full) begin
				count<=count-1;
			end
			if (intt.empty) begin
				count<=count+1;
			end
		end
		else begin
			if	( ({intt.wr_en, intt.rd_en} == 2'b10) && !intt.full) 
			count <= count + 1;
		else if ( ({intt.wr_en, intt.rd_en} == 2'b01) && !intt.empty)//
			count <= count - 1;
		end
	end
end
//

assign intt.full = (count == FIFO_DEPTH)? 1 : 0;
assign intt.empty = (count == 0)? 1 : 0;
assign intt.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; //
assign intt.almostempty = (count == 1)? 1 : 0;
///////////////////////////////////////////////////////
`ifdef assertion
always_comb begin : blockName
	if (!intt.rst_n) begin
		RESET:assert final(count==3'b0 && !intt.full && intt.empty && !intt.almostempty && !intt.almostfull && !rd_ptr && !wr_ptr && !intt.overflow && !intt.underflow );
	end
end
WR_ACK : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b1 && !intt.full |=> intt.wr_ack==1);
full : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) (count)==FIFO_DEPTH |-> intt.full==1'b1);
empty : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) (count)==3'b0 |-> intt.empty==1'b1);
almostfull : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) (count)==FIFO_DEPTH-1'b1 |-> intt.almostfull==1'b1);
almostempty : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) (count)==3'b1 |-> intt.almostempty==1);
COUNTER_UP : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b1 && intt.rd_en==1'b0 && !intt.full |=> count==$past(count)+1'b1);
COUNTER_DOWN : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b0 && intt.rd_en==1'b1 && !intt.empty |=> count==$past(count)-1'b1);
COUNTER_FULL : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b1 && intt.rd_en==1'b1 && intt.full |=> count==$past(count)-1'b1);
COUNTER_EMPTY : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b1 && intt.rd_en==1'b1 && intt.empty |=> count==$past(count)+1'b1);
OVERFLOW : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b1 && intt.full |=> intt.overflow==1);
UNDERFLOW : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.rd_en==1'b1 && intt.empty |=> intt.underflow==1);
RD_POINTER : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.rd_en==1'b1 && count != 1'b0 |=> rd_ptr==$past(rd_ptr)+1'b1);
WR_POINTER : assert property (@(posedge intt.clk) disable iff(!intt.rst_n) intt.wr_en==1'b1 && count < FIFO_DEPTH |=> wr_ptr==$past(wr_ptr)+1'b1);
`endif 
endmodule
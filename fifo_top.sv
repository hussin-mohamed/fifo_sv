module fifo_top ();
    bit clk;
    initial begin
        forever begin
            #10;
            clk=!clk;
        end
    end
    inter inter(clk);
    FIFO_corrected DUT (inter);
    fifo_tb TB(inter);
    fifo_monitor MONITOR (inter);
endmodule
import score::*;
import trans::*;
module fifo_tb (inter.TB intt); 
    FIFO_transaction c=new();
    FIFO_scoreboard cc=new();
    initial begin
        intt.rst_n=0;
        intt.data_in=0;
        intt.wr_en=0;
        intt.rd_en=0;
       repeat(2)
        @(negedge intt.clk);

        intt.rst_n=1;
        c.rand_mode(0);
        c.data_in.rand_mode(1);
        c.constraint_mode(0);
        repeat(5000) begin
            intt.wr_en=1;
            intt.rd_en=0;
            repeat(9) begin
                assert (c.randomize);
                intt.data_in=c.data_in;
                @(negedge intt.clk);
            end
            intt.wr_en=0;
            intt.rd_en=1;
            repeat(9) begin
                @(negedge intt.clk);
            end
        end
        c.rand_mode(0);
        c.rand_mode(1);
        c.constraint_mode(1);
        repeat (5000) begin
            assert (c.randomize);
            intt.wr_en=c.wr_en;
            intt.rd_en=c.rd_en;
            intt.data_in=c.data_in;
            intt.rst_n=c.rst_n;
            @(negedge intt.clk);
        end
        cc.test_finished=1;
    end
endmodule
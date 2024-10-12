import score::*;
import coverr::*;
import trans::*;
module fifo_monitor (inter.MONITOR intt);
    FIFO_transaction obj_trans;
    FIFO_scoreboard obj2_score;
    FIFO_coverage obj3_cover;
    always @(*) begin
        obj_trans.rst_n=intt.rst_n;
            obj_trans.data_in=intt.data_in;
            obj_trans.wr_en=intt.wr_en;
            obj_trans.rd_en=intt.rd_en;
            obj_trans.data_out=intt.data_out;
            obj_trans.full=intt.full;
            obj_trans.almostfull=intt.almostfull;
            obj_trans.empty=intt.empty;
            obj_trans.almostempty=intt.almostempty;
            obj_trans.wr_ack=intt.wr_ack;
            obj_trans.overflow=intt.overflow;
            obj_trans.underflow=intt.underflow;
    end
    initial begin
        obj_trans=new();
        obj2_score=new();
        obj3_cover=new();
        forever begin
            @(negedge intt.clk);
            // obj_trans.rst_n=intt.rst_n;
            // obj_trans.data_in=intt.data_in;
            // obj_trans.wr_en=intt.wr_en;
            // obj_trans.rd_en=intt.rd_en;
            // obj_trans.data_out=intt.data_out;
            // obj_trans.full=intt.full;
            // obj_trans.almostfull=intt.almostfull;
            // obj_trans.empty=intt.almostempty;
            // obj_trans.almostempty=intt.almostempty;
            // obj_trans.wr_ack=intt.wr_ack;
            // obj_trans.overflow=intt.overflow;
            // obj_trans.underflow=intt.underflow;
            fork
                //sample
                begin
                   obj3_cover.sample_data(obj_trans); 
                end
                begin
                    obj2_score.check_data(obj_trans);
                end
            join
            if (obj2_score.test_finished) begin
                $display("error_count=%0d ,  right_count=%0d",obj2_score.error_count,obj2_score.right_count);
                $stop;
            end
        end
    end
endmodule
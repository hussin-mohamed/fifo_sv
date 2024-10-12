package coverr;
    import trans::*;
    FIFO_transaction F_cvg_txn = new();
    class FIFO_coverage;
        covergroup p1 ;
            rd_enable: coverpoint F_cvg_txn.rd_en iff(F_cvg_txn.rst_n);
            wr_enable: coverpoint F_cvg_txn.wr_en iff(F_cvg_txn.rst_n);
            wr_acknowledge: coverpoint F_cvg_txn.wr_ack iff(F_cvg_txn.rst_n);
            overfloww: coverpoint F_cvg_txn.overflow iff(F_cvg_txn.rst_n);
            underfloww: coverpoint F_cvg_txn.underflow iff(F_cvg_txn.rst_n);
            fulll: coverpoint F_cvg_txn.full iff(F_cvg_txn.rst_n);
            almostfulll: coverpoint F_cvg_txn.almostfull iff(F_cvg_txn.rst_n);
            emptyy: coverpoint F_cvg_txn.empty iff(F_cvg_txn.rst_n);
            almostemptyy: coverpoint F_cvg_txn.almostempty iff(F_cvg_txn.rst_n);
            rd_enable_with_empty:cross rd_enable,emptyy;
            rd_enable_with_almostempty:cross rd_enable,almostemptyy;
            rd_enable_with_underflow : cross rd_enable,underfloww {
                option.cross_auto_bin_max=0;
                bins rd_on_under_off = binsof(rd_enable) intersect {1} && binsof(underfloww) intersect {0};
                bins rd_off_under_off = binsof(rd_enable) intersect {0} && binsof(underfloww) intersect {0};
                bins rd_on_under_on = binsof(rd_enable) intersect {1} && binsof(underfloww) intersect {1};
            }
            wr_enable_with_full : cross wr_enable,fulll;
            wr_enable_with_almostfull : cross wr_enable,almostfulll;
            wr_enable_with_overflow : cross wr_enable,overfloww{
                option.cross_auto_bin_max=0;
                bins wr_on_over_off = binsof(wr_enable) intersect {1} && binsof(overfloww) intersect {0};
                bins wr_off_over_off = binsof(wr_enable) intersect {0} && binsof(overfloww) intersect {0};
                bins wr_on_over_on = binsof(wr_enable) intersect {1} && binsof(overfloww) intersect {1};
            }
            wr_enable_with_wr_acknowledge : cross wr_enable,wr_acknowledge{
                option.cross_auto_bin_max=0;
                bins wr_on_wr_acknowledge_off = binsof(wr_enable) intersect {1} && binsof(wr_acknowledge) intersect {0};
                bins wr_off_wr_acknowledge_off = binsof(wr_enable) intersect {0} && binsof(wr_acknowledge) intersect {0};
                bins wr_on_wr_acknowledge_on = binsof(wr_enable) intersect {1} && binsof(wr_acknowledge) intersect {1};
            }
        endgroup

        function new();
            p1=new();
        endfunction //new()

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn=F_txn;
            p1.sample();
        endfunction
        
    endclass //className
    
endpackage
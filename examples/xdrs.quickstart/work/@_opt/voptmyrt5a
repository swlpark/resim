library verilog;
use verilog.vl_types.all;
entity filter_sync is
    generic(
        INVALUE         : integer := 1;
        OUTVALUE        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        is_data_in      : in     vl_logic;
        is_data_out     : in     vl_logic;
        rc_reqn         : in     vl_logic;
        rc_ackn         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INVALUE : constant is 1;
    attribute mti_svvh_generic_type of OUTVALUE : constant is 1;
end filter_sync;

library verilog;
use verilog.vl_types.all;
entity stat_cnt is
    generic(
        C_CNT_BW        : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        din             : in     vl_logic_vector(31 downto 0);
        dout            : in     vl_logic_vector(31 downto 0);
        din_valid       : in     vl_logic;
        dout_valid      : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of C_CNT_BW : constant is 1;
end stat_cnt;

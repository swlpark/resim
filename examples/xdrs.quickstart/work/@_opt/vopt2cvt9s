library verilog;
use verilog.vl_types.all;
entity icapi is
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        rc_start        : in     vl_logic;
        rc_bop          : in     vl_logic;
        rc_baddr        : in     vl_logic_vector(31 downto 0);
        rc_bsize        : in     vl_logic_vector(31 downto 0);
        rc_done         : out    vl_logic;
        ma_req          : out    vl_logic;
        xbm_gnt         : in     vl_logic;
        ma_select       : out    vl_logic;
        ma_addr         : out    vl_logic_vector(31 downto 0);
        ma_data         : out    vl_logic_vector(31 downto 0);
        ma_rnw          : out    vl_logic;
        ma_be           : out    vl_logic_vector(3 downto 0);
        xbm_ack         : in     vl_logic;
        xbm_data        : in     vl_logic_vector(31 downto 0)
    );
end icapi;

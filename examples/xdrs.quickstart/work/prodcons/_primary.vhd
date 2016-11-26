library verilog;
use verilog.vl_types.all;
entity prodcons is
    generic(
        C_RETRY_DELAY   : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        p_prdy          : out    vl_logic;
        p_crdy          : in     vl_logic;
        p_cerr          : in     vl_logic;
        p_data          : out    vl_logic_vector(31 downto 0);
        c_prdy          : in     vl_logic;
        c_crdy          : out    vl_logic;
        c_cerr          : out    vl_logic;
        c_data          : in     vl_logic_vector(31 downto 0);
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of C_RETRY_DELAY : constant is 1;
end prodcons;

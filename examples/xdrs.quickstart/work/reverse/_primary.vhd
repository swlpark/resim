library verilog;
use verilog.vl_types.all;
entity reverse is
    generic(
        C_CNT_BW        : integer := 32;
        C_RETRY_DELAY   : integer := 16
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
        rc_reqn         : in     vl_logic;
        rc_ackn         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of C_CNT_BW : constant is 1;
    attribute mti_svvh_generic_type of C_RETRY_DELAY : constant is 1;
end reverse;

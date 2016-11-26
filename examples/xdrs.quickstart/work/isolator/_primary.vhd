library verilog;
use verilog.vl_types.all;
entity isolator is
    port(
        rc_ackn_rr      : in     vl_logic;
        rc_ackn         : out    vl_logic;
        p_prdy          : out    vl_logic;
        p_data          : out    vl_logic_vector(31 downto 0);
        c_crdy          : out    vl_logic;
        c_cerr          : out    vl_logic;
        p_prdy_rr       : in     vl_logic;
        p_data_rr       : in     vl_logic_vector(31 downto 0);
        c_crdy_rr       : in     vl_logic;
        c_cerr_rr       : in     vl_logic;
        is_reconfn      : in     vl_logic
    );
end isolator;

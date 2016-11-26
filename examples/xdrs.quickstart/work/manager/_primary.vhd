library verilog;
use verilog.vl_types.all;
entity manager is
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        rc_start        : out    vl_logic;
        rc_bop          : out    vl_logic;
        rc_baddr        : out    vl_logic_vector(31 downto 0);
        rc_bsize        : out    vl_logic_vector(31 downto 0);
        rc_done         : in     vl_logic;
        rc0_reqn        : out    vl_logic;
        rc0_ackn        : in     vl_logic;
        rc0_clk         : out    vl_logic;
        rc0_rstn        : out    vl_logic;
        rc0_reconfn     : out    vl_logic;
        rc1_reqn        : out    vl_logic;
        rc1_ackn        : in     vl_logic;
        rc1_clk         : out    vl_logic;
        rc1_rstn        : out    vl_logic;
        rc1_reconfn     : out    vl_logic;
        rc2_reqn        : out    vl_logic;
        rc2_ackn        : in     vl_logic;
        rc2_clk         : out    vl_logic;
        rc2_rstn        : out    vl_logic;
        rc2_reconfn     : out    vl_logic;
        rc3_reqn        : out    vl_logic;
        rc3_ackn        : in     vl_logic;
        rc3_clk         : out    vl_logic;
        rc3_rstn        : out    vl_logic;
        rc3_reconfn     : out    vl_logic
    );
end manager;

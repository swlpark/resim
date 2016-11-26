library verilog;
use verilog.vl_types.all;
entity memctrl is
    generic(
        MEMDELAY        : integer := 1
    );
    port(
        clk             : in     vl_logic;
        rstn            : in     vl_logic;
        xbs_select      : in     vl_logic;
        xbs_addr        : in     vl_logic_vector(31 downto 0);
        xbs_data        : in     vl_logic_vector(31 downto 0);
        xbs_rnw         : in     vl_logic;
        xbs_be          : in     vl_logic_vector(3 downto 0);
        sl_ack          : out    vl_logic;
        sl_data         : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEMDELAY : constant is 1;
end memctrl;

library verilog;
use verilog.vl_types.all;
entity ICAP_VIRTEX4_WRAPPER is
    generic(
        ICAP_WIDTH      : string  := "X8"
    );
    port(
        BUSY            : out    vl_logic;
        O               : out    vl_logic_vector(31 downto 0);
        CE              : in     vl_logic;
        CLK             : in     vl_logic;
        I               : in     vl_logic_vector(31 downto 0);
        WRITE           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ICAP_WIDTH : constant is 1;
end ICAP_VIRTEX4_WRAPPER;

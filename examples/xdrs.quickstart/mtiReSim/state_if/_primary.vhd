library verilog;
use verilog.vl_types.all;
entity state_if is
    generic(
        NUM             : integer := 1
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM : constant is 1;
end state_if;

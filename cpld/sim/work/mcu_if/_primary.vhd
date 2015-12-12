library verilog;
use verilog.vl_types.all;
entity mcu_if is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        mcu_wr_n        : in     vl_logic;
        mcu_rd_n        : in     vl_logic;
        mcu_ale         : in     vl_logic;
        mcu_psen_n      : in     vl_logic;
        mcu_p0          : inout  vl_logic_vector(7 downto 0);
        mcu_p2          : in     vl_logic_vector(7 downto 0);
        leds_o          : out    vl_logic_vector(7 downto 0)
    );
end mcu_if;

library verilog;
use verilog.vl_types.all;
entity sd_reg is
    port(
        mcu_rst_i       : in     vl_logic;
        mcu_cs_i        : in     vl_logic;
        mcu_wr_i        : in     vl_logic;
        mcu_rd_i        : in     vl_logic;
        mcu_addr_i8     : in     vl_logic_vector(7 downto 0);
        mcu_wrdat_i8    : in     vl_logic_vector(7 downto 0);
        mcu_rddat_o8    : out    vl_logic_vector(7 downto 0);
        mcu_int_o       : out    vl_logic;
        sspshif_o       : out    vl_logic;
        ssppres_o8      : out    vl_logic_vector(7 downto 0);
        ssptdat_o8      : out    vl_logic_vector(7 downto 0);
        ssprdat_i8      : in     vl_logic_vector(7 downto 0);
        sspstat_i8      : in     vl_logic_vector(7 downto 0)
    );
end sd_reg;

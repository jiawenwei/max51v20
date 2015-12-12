library verilog;
use verilog.vl_types.all;
entity sd is
    port(
        mcu_rst_i       : in     vl_logic;
        mcu_cs_i        : in     vl_logic;
        mcu_wr_i        : in     vl_logic;
        mcu_rd_i        : in     vl_logic;
        mcu_addr_i8     : in     vl_logic_vector(7 downto 0);
        mcu_wrdat_i8    : in     vl_logic_vector(7 downto 0);
        mcu_rddat_o8    : out    vl_logic_vector(7 downto 0);
        clk_i           : in     vl_logic;
        spi_sck_o       : out    vl_logic;
        spi_sdo_o       : out    vl_logic;
        spi_sdi_i       : in     vl_logic;
        sspshif_o       : out    vl_logic;
        current_state_dgo: out    vl_logic_vector(3 downto 0)
    );
end sd;

library verilog;
use verilog.vl_types.all;
entity sd_ctrl is
    generic(
        IDLE            : integer := 1;
        READY           : integer := 2;
        POSEDGE         : integer := 4;
        NEGEDGE         : integer := 8;
        DELAY           : integer := 16
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        sttshift_i      : in     vl_logic;
        ssppres_i8      : in     vl_logic_vector(7 downto 0);
        ssptdat_i8      : in     vl_logic_vector(7 downto 0);
        sspsreg_o8      : out    vl_logic_vector(7 downto 0);
        sspstat_o8      : out    vl_logic_vector(7 downto 0);
        spi_sck_o       : out    vl_logic;
        spi_sdo_o       : out    vl_logic;
        spi_sdi_i       : in     vl_logic;
        current_state_dgo: out    vl_logic_vector(3 downto 0)
    );
end sd_ctrl;

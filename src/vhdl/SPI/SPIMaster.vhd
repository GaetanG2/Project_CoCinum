
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPIMaster is
    port(
        clk_i     : in  std_logic;
        reset_i   : in  std_logic;
        write_i   : in  std_logic;
        address_i : in  std_logic_vector(1 downto 0);
        wdata_i   : in  std_logic_vector(7 downto 0);
        rdata_o   : out std_logic_vector(7 downto 0);
        done_o    : out std_logic;
        miso_i    : in  std_logic;
        mosi_o    : out std_logic;
        sclk_o    : out std_logic;
        cs_n_o    : out std_logic
    );
end SPIMaster;

architecture Behavioral of SPIMaster is
    signal busy_reg      : std_logic := '0';

    signal polarity_reg  : std_logic := '0';
    signal phase_reg     : std_logic := '0';
    signal cs_reg        : std_logic := '0';
    signal timer_max_reg : integer range 0 to 255;
    signal timer_reg     : integer range 0 to 255;
    signal bit_index_reg : integer range 0 to 7;
    signal data_reg      : std_logic_vector(7 downto 0);

    signal sclk_half     : std_logic;
    signal sclk_cycle    : std_logic;
    signal sclk_reg      : std_logic := '0';
begin
    p_addressable_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_i = '1' then
                polarity_reg  <= '0';
                phase_reg     <= '0';
                cs_reg        <= '0';
                timer_max_reg <= 255;
            elsif write_i = '1' then
                case address_i is
                    when "00" => data_reg      <= wdata_i;
                    when "01" => polarity_reg  <= wdata_i(2);
                                 phase_reg     <= wdata_i(1);
                                 cs_reg        <= wdata_i(0);
                    when "10" => timer_max_reg <= to_integer(unsigned(wdata_i));
                    when others =>
                end case;
            elsif ... then
                data_reg <= ...;
            end if;
        end if;
    end process p_addressable_reg;

    with address_i select
        rdata_o <= data_reg                                        when "00",
                   "00000" & polarity_reg & phase_reg & cs_reg     when "01",
                   std_logic_vector(to_unsigned(timer_max_reg, 8)) when "10",
                   "00000000"                                      when others;

    p_busy_reg : process(clk_i)
    begin
        -- ...
    end process p_busy_reg;

    p_done_o : process(clk_i)
    begin
        -- ...
    end process p_done_o;

    p_timer_reg : process(clk_i)
    begin
        -- ...
    end process p_timer_reg;

    p_bit_index_reg : process(clk_i)
    begin
        -- ...
    end process p_bit_index_reg;

    sclk_half  <= ...;
    sclk_cycle <= ...;

    p_sclk_reg : process(clk_i)
    begin
        -- ...
    end process p_sclk_reg;

    p_mosi_o : process(clk_i)
    begin
        -- ...
    end process p_mosi_o;

    cs_n_o  <= not cs_reg;
    sclk_o  <= sclk_reg;
    rdata_o <= data_reg;
end Behavioral;

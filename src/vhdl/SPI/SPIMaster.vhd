
library ieee;
use ieee.std_logic_1164.all;

entity SPIMaster is
    generic(
        CLK_FREQUENCY_HZ : positive;
        BIT_RATE_HZ      : positive;
        DATA_WIDTH       : positive;
        POLARITY         : std_logic;
        PHASE            : std_logic
    );
    port(
        clk_i   : in  std_logic;
        reset_i : in  std_logic;
        write_i : in  std_logic;
        wdata_i : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        rdata_o : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        done_o  : out std_logic;
        miso_i  : in  std_logic;
        mosi_o  : out std_logic;
        sclk_o  : out std_logic
    );
end SPIMaster;

architecture Behavioral of SPIMaster is
    signal busy_reg         : std_logic := '0';

    constant CYCLES_PER_BIT : positive  := ...;
    constant TIMER_HALF     : integer   := CYCLES_PER_BIT / 2 - 1;
    constant TIMER_MAX      : integer   := CYCLES_PER_BIT     - 1;
    signal timer_reg        : integer range 0 to TIMER_MAX;

    signal index_reg        : integer range 0 to DATA_WIDTH - 1;

    signal sclk_half        : std_logic;
    signal sclk_cycle       : std_logic;
    signal sclk_reg         : std_logic := POLARITY;

    signal data_reg         : std_logic_vector(DATA_WIDTH - 1 downto 0);
begin
    -- Concurrent statements
end Behavioral;

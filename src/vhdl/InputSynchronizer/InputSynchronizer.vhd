
library ieee;
use ieee.std_logic_1164.all;

-- An synchronizer for input signals, or signals from another clock domain,
-- to prevent metastability effects.
entity InputSynchronizer is
    generic(
        -- The number of bits to synchronize.
        WIDTH : positive
    );
    port(
        -- The global clock signal.
        clk_i  : in  std_logic;
        -- The inputs to synchronize.
        data_i : in  std_logic_vector(WIDTH - 1 downto 0);
        -- A synchronized copy of the inputs.
        data_o : out std_logic_vector(WIDTH - 1 downto 0)
    );
end InputSynchronizer;

architecture Behavioral of InputSynchronizer is
    -- A intermediate register that will synchronize data_i.
    signal data_reg : std_logic_vector(WIDTH - 1 downto 0);

    -- The ASYNC_REG attribute informs Xilinx Vivado that each flip-flop pair
    -- data_reg(i)/data_o(i) should be placed in the same slice.
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of data_reg : signal is "true";
    attribute ASYNC_REG of data_o   : signal is "true";
begin
    -- This is a simple two-stage delay line.
    p_data_o : process(clk_i)
    begin
        if rising_edge(clk_i) then
            data_reg <= data_i;
            data_o   <= data_reg;
        end if;
    end process p_data_o;
end Behavioral;

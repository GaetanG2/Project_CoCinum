
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Virgule_pkg.all;

entity Timer is
    port(
        clk_i     : in  std_logic;
        reset_i   : in  std_logic;
        address_i : in  std_logic;
        write_i   : in  std_logic;
        data_i    : in  word_t;
        data_o    : out word_t;
        irq_o     : out std_logic
    );
end Timer;

architecture Behavioral of Timer is
    signal limit_reg, count_reg : unsigned(31 downto 0);
begin
    p_limit_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_i = '1' then
                limit_reg <= to_unsigned(0, limit_reg'length);
            elsif write_i = '1' and address_i = '0' then
                limit_reg <= unsigned(data_i);
            end if;
        end if;
    end process p_limit_reg;

    p_count_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_i = '1' then
                count_reg <= to_unsigned(0, count_reg'length);
            elsif write_i = '1' and address_i = '1' then
                count_reg <= unsigned(data_i);
            elsif count_reg >= limit_reg then
                count_reg <= to_unsigned(0, count_reg'length);
            else
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process p_count_reg;

    data_o <= word_t(limit_reg) when address_i = '0' else
              word_t(count_reg);
    irq_o  <= '1' when count_reg >= limit_reg and limit_reg > 0 else '0';
end Behavioral;

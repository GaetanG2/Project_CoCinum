
library ieee;
use ieee.std_logic_1164.all;

use work.Virgule_pkg.all;

entity VInterruptController is
    port(
        clk_i     : in  std_logic;
        reset_i   : in  std_logic;
        events_i  : in  word_t;
        address_i : in  std_logic;
        data_i    : in  word_t;
        data_o    : out word_t;
        write_i   : in  std_logic;
        irq_o     : out std_logic
    );
end VInterruptController;

architecture Behavioral of VInterruptController is
    signal mask_reg, events_reg : word_t := WORD0;
begin
    p_mask_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_i = '1' then
                mask_reg <= WORD0;
            elsif write_i = '1' and address_i = '0' then
                mask_reg <= data_i;
            end if;
        end if;
    end process p_mask_reg;

    p_events_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            for k in events_i'range loop
                if reset_i = '1' then
                    events_reg(k) <= '0';
                elsif events_i(k) = '1' then
                    events_reg(k) <= '1';
                elsif write_i = '1' and address_i = '1' and data_i(k) = '1' then
                    events_reg(k) <= '0';
                end if;
            end loop;
        end if;
    end process p_events_reg;

    data_o <= mask_reg when address_i = '0' else events_reg;
    irq_o  <= '1' when (events_reg and mask_reg) /= WORD0 else '0';
end Behavioral;

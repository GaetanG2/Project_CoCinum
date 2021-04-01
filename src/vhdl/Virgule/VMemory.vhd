
library ieee;
use ieee.std_logic_1164.all;

use work.Virgule_pkg.all;

entity VMemory is
    generic(
        CONTENT : word_vector_t
    );
    port (
        clk_i     : in  std_logic;
        reset_i   : in  std_logic;
        address_i : in  word_t;
        data_i    : in  word_t;
        data_o    : out word_t;
        write_i   : in  std_logic;
        select_i  : in  std_logic_vector(3 downto 0);
        done_o    : out std_logic
    );
end VMemory;

architecture Behavioral of VMemory is
    signal data_reg   : word_vector_t(CONTENT'range) := CONTENT;
    signal byte_write : std_logic_vector(0 to 3);
    signal enable     : std_logic;
    signal done_reg   : std_logic := '0';
begin
    enable <= '1' when select_i /= "0000" else '0';

    byte_write_gen : for i in 0 to 3 generate
        byte_write(i) <= write_i and select_i(i);
    end generate byte_write_gen;

    p_data_reg_o : process(clk_i)
        variable word_address : natural range CONTENT'range;
    begin
        if rising_edge(clk_i) then
            if enable = '1' then
                word_address := to_natural(address_i(address_i'high downto 2));
                data_o <= data_reg(word_address);
                for i in 0 to 3 loop
                    if byte_write(i) = '1' then
                        data_reg(word_address)(i * 8 + 7 downto i * 8) <= data_i(i * 8 + 7 downto i * 8);
                    end if;
                end loop;
            end if;
        end if;
    end process p_data_reg_o;

    p_done_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if reset_i = '1' then
                done_reg <= '0';
            elsif enable = '1' and write_i = '0' then
                done_reg <= not done_reg;
            end if;
        end if;
    end process p_done_reg;

    done_o <= done_reg or write_i;
end Behavioral;

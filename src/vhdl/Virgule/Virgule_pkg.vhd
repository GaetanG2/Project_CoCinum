
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.math_real.all;

package Virgule_pkg is

    subtype byte_t        is std_logic_vector(7 downto 0);
    subtype half_word_t   is std_logic_vector(15 downto 0);
    subtype word_t        is std_logic_vector(31 downto 0);
    type    byte_vector_t is array(natural range <>) of byte_t;
    type    word_vector_t is array(natural range <>) of word_t;

    constant WORD0 : word_t := (others => '0');
    constant WORD1 : word_t := (0 => '1', others => '0');
    constant BYTE0 : byte_t := (others => '0');

    -- -------------------------------------------------------------------------
    -- Instruction field definition.
    -- -------------------------------------------------------------------------

    -- -------------------------------------------------------------------------
    -- Decoded ALU operations and instruction data.
    -- -------------------------------------------------------------------------

    -- -------------------------------------------------------------------------
    -- Utility functions and operators.
    -- -------------------------------------------------------------------------

    function to_unsigned_word(a : std_logic_vector) return word_t;
    function to_unsigned_word(a : natural) return word_t;
    function to_signed_word(a : std_logic_vector) return word_t;
    function to_signed_word(a : integer) return word_t;
    function to_natural(a : std_logic_vector) return natural;

end Virgule_pkg;

package body Virgule_pkg is

    function to_unsigned_word(a : std_logic_vector) return word_t is
    begin
        return word_t(resize(unsigned(a), word_t'length));
    end to_unsigned_word;

    function to_unsigned_word(a : natural) return word_t is
    begin
        return word_t(to_unsigned(a, word_t'length));
    end to_unsigned_word;

    function to_signed_word(a : std_logic_vector) return word_t is
    begin
        return word_t(resize(signed(a), word_t'length));
    end to_signed_word;

    function to_signed_word(a : integer) return word_t is
    begin
        return word_t(to_signed(a, word_t'length));
    end to_signed_word;

    function to_natural(a : std_logic_vector) return natural is
        variable u : unsigned(a'length - 1 downto 0) := unsigned(a);
    begin
        return to_integer(u);
    end to_natural;

end Virgule_pkg;

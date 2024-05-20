
library ieee;
use ieee.std_logic_1164.all;

entity StopWatch is
    port(
        clk_i             : in  std_logic;
        btn_center_i      : in  std_logic;
        switches_i        : in  std_logic_vector(15 downto 0);
        leds_o            : out std_logic_vector(15 downto 0);
        disp_segments_n_o : out std_logic_vector(0 to 6);
        disp_point_n_o    : out std_logic;
        disp_select_n_o   : out std_logic_vector(3 downto 0)
    );
end StopWatch;

architecture Structural of StopWatch is
    -- Declarations
    signal cycle_5ms, cycle_20ms, cycle_100ms, inc_100ms, cycle_1sec, cycle_10sec, cycle_1min : std_logic;
    signal digit_100ms, digit_1sec, digit_10sec, digit_1min, digit : integer range 0 to 500000;
    signal digit_index : integer range 0 to 3;
    signal segments : std_logic_vector(0 to 6);
begin
    -- Concurrent statements
    divider_5ms_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 500000
    )
    port map(
        clk_i => clk_i,
        reset_i => '0',
        inc_i => '1',
        cycle_o => cycle_5ms
    );
    divider_20ms_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 4
    )
    port map(
        clk_i => clk_i,
        reset_i => '0',
        inc_i => cycle_5ms,
        cycle_o => cycle_20ms,
        value_o => digit_index
    );
    divider_100ms_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 5
    )
    port map(
        clk_i => clk_i,
        reset_i => '0',
        inc_i => cycle_20ms,
        cycle_o => cycle_100ms
    );  
    counter_10x100ms_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 10
    )
    port map(
        clk_i => clk_i,
        reset_i => btn_center_i,
        inc_i => inc_100ms,
        cycle_o => cycle_1sec,
        value_o => digit_100ms
    );
    counter_10x1sec_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 10
    )
    port map(
        clk_i => clk_i,
        reset_i => btn_center_i,
        inc_i => cycle_1sec,
        cycle_o => cycle_10sec,
        value_o => digit_1sec
    );
    counter_6x10sec_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 6
    )
    port map(
        clk_i => clk_i,
        reset_i => btn_center_i,
        inc_i => cycle_10sec,
        cycle_o => cycle_1min,
        value_o => digit_10sec
    );
    counter_10x1min_inst : entity work.CounterModN(Behavioral)
    generic map(
        N => 10
    )
    port map(
        clk_i => clk_i,
        reset_i => btn_center_i,
        inc_i => cycle_1min,
        value_o => digit_1min
    );
    decoder_inst : entity work.SegmentDecoder(TruthTable)
    port map(
        segments_o => segments,
        digit_i => digit
    );
        
    leds_o(10 downto 9) <= "00";
    disp_point_n_o <= '1';
    inc_100ms <= cycle_100ms and switches_i(15);
                
                
    p_digit : process(digit_index)
    begin
        case digit_index is
            when 0 => 
                digit <= digit_100ms;
            when 1 => 
                digit <= digit_1sec;
            when 2 => 
                digit <= digit_10sec;
            when 3 => 
                digit <= digit_1min;  
         end case;
    end process p_digit;
    
    p_leds_o_10sec : process(digit_10sec)
    begin
        case digit_10sec is
           when 0 =>  
                leds_o(15 downto 11) <= "00000";
           when 1 =>  
                leds_o(15 downto 11) <= "00001";
           when 2 =>  
                leds_o(15 downto 11) <= "00011";
           when 3 =>  
                leds_o(15 downto 11) <= "00111";
           when 4 =>  
                leds_o(15 downto 11) <= "01111";
           when 5 =>  
                leds_o(15 downto 11) <= "11111";
         end case;
    end process p_leds_o_10sec;
    
    p_leds_o_1sec : process(digit_1sec)
    begin
           for k in 0 to 8 loop
                if digit_1sec = 0 then
                    leds_o(8 downto 0) <= "000000000";
                elsif digit_1sec = 1 then
                    leds_o(8 downto 0) <= "000000001";
                elsif digit_1sec = 2 then
                    leds_o(8 downto 0) <= "000000011";
                elsif digit_1sec = 3 then
                    leds_o(8 downto 0) <= "000000111";
                elsif digit_1sec = 4 then
                    leds_o(8 downto 0) <= "000001111";       
                elsif digit_1sec = 5 then
                    leds_o(8 downto 0) <= "000011111";
                elsif digit_1sec = 6 then
                    leds_o(8 downto 0) <= "000111111";
                elsif digit_1sec = 7 then
                    leds_o(8 downto 0) <= "001111111";
                elsif digit_1sec = 8 then
                    leds_o(8 downto 0) <= "011111111";
                else 
                    leds_o(8 downto 0) <= "111111111";
                end if;
         end loop;
    end process p_leds_o_1sec;
    
    p_disp_select_n_o : process(digit_index)
    begin
        for k in 0 to 3 loop
            if digit_index /= k then
                disp_select_n_o(k) <= '1';
            else 
                disp_select_n_o(k) <= '0';
            end if;
         end loop;
    end process p_disp_select_n_o;
    
   
    disp_segments_n_o <= not segments;
                    
          
    
end Structural;

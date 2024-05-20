
architecture Debouncer of EventDetector is
    -- Declarations
    type state_t is (OFF_STABLE, ON_EVENT, ON_UNSTABLE, ON_STABLE, OFF_EVENT, OFF_UNSTABLE);
    signal state_reg : state_t;
    signal on_timer_reg : integer range 0 to DURATION;
    signal off_timer_reg : integer range 0 to DURATION;
    
begin
    -- Concurrent statements
    p_debounce : process(clk_i)  
    begin
       -- on_timer_reg <= 0;
       -- off_timer_reg <= 0;
        if clk_i'event and clk_i = '1' then
            if src_i = '0' then
                on_timer_reg <= 0;
                if off_timer_reg < DURATION then
                    off_timer_reg <= off_timer_reg + 1;
                else
                    off_timer_reg <= 0;
                end if;
            elsif src_i = '1' then
                off_timer_reg <= 0;
                if on_timer_reg < DURATION then
                    on_timer_reg <= on_timer_reg + 1;
                else
                    on_timer_reg <= 0;
                end if;
            end if;
        end if;
    end process p_debounce;
      
    p_change_state : process(clk_i)
        begin
            if clk_i'event and clk_i = '1' then
                case state_reg is
                    when OFF_STABLE =>
                        if src_i = '1' then
                            state_reg <= ON_EVENT;
                        end if;
                    when ON_EVENT =>
                        state_reg <= ON_UNSTABLE;
                    when ON_UNSTABLE =>
                        if src_i = '1' and on_timer_reg = DURATION then
                            state_reg <= ON_STABLE;
                        end if;
                    when ON_STABLE =>
                        if src_i = '0' then
                            state_reg <= OFF_EVENT;
                        end if;
                    when OFF_EVENT =>
                        state_reg <= OFF_UNSTABLE;
                    when OFF_UNSTABLE =>
                        if src_i = '0' and off_timer_reg = DURATION then
                            state_reg <= OFF_STABLE;
                        end if;
                    when others =>
                        state_reg <= OFF_STABLE;
                end case;
            end if;
    end process p_change_state;
    
    on_evt_o <= '1' when state_reg = ON_EVENT else '0';
    off_evt_o <= '1' when state_reg = OFF_EVENT else '0'; 
    status_o <= '1' when state_reg = ON_EVENT or  state_reg = ON_UNSTABLE or state_reg = ON_STABLE else '0';
        
    
        
end Debouncer;

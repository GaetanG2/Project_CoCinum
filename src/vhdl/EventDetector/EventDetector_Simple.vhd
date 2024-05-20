
architecture Simple of EventDetector is
    -- Declarations
    signal src_reg : std_logic_vector(0 to 1) := "00";
begin
    p_compteur_bouton : process(clk_i)
    begin
        if clk_i'event and clk_i = '1' then
            src_reg(0) <= src_i;
        end if;
        if clk_i'event and clk_i = '1' then
            src_reg(1) <= src_reg(0);
        end if;
    end process p_compteur_bouton;
    on_evt_o <= src_reg(0) and (not src_reg(1));
    off_evt_o <= src_reg(1) and (not src_reg(0));
    status_o <= src_reg(0);
end Simple;

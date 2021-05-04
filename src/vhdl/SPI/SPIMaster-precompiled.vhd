library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity SPIMaster is
  port (
    clk_i: in std_logic;
    reset_i: in std_logic;
    write_i: in std_logic;
    address_i: in std_logic_vector (1 downto 0);
    wdata_i: in std_logic_vector (7 downto 0);
    rdata_o: out std_logic_vector (7 downto 0);
    done_o: out std_logic;
    miso_i: in std_logic;
    mosi_o: out std_logic;
    sclk_o: out std_logic;
    cs_n_o: out std_logic
  );
end SPIMaster;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of spimaster is
  signal wrap_clk_i: std_logic;
  signal wrap_reset_i: std_logic;
  signal wrap_write_i: std_logic;
  subtype typwrap_address_i is std_logic_vector (1 downto 0);
  signal wrap_address_i: typwrap_address_i;
  subtype typwrap_wdata_i is std_logic_vector (7 downto 0);
  signal wrap_wdata_i: typwrap_wdata_i;
  signal wrap_miso_i: std_logic;
  subtype typwrap_rdata_o is std_logic_vector (7 downto 0);
  signal wrap_rdata_o: typwrap_rdata_o;
  signal wrap_done_o: std_logic;
  signal wrap_mosi_o: std_logic;
  signal wrap_sclk_o: std_logic;
  signal wrap_cs_n_o: std_logic;
  signal start : std_logic;
  signal busy_reg : std_logic;
  signal polarity_reg : std_logic;
  signal phase_reg : std_logic;
  signal cs_reg : std_logic;
  signal timer_max_reg : std_logic_vector (7 downto 0);
  signal timer_reg : std_logic_vector (7 downto 0);
  signal bit_index_reg : std_logic_vector (2 downto 0);
  signal data_reg : std_logic_vector (7 downto 0);
  signal sclk_half : std_logic;
  signal sclk_cycle : std_logic;
  signal sclk_reg : std_logic;
  signal n13_o : std_logic;
  signal n14_o : std_logic;
  signal n15_o : std_logic;
  signal n16_o : std_logic;
  signal n18_o : std_logic;
  signal n21_o : std_logic;
  signal n22_o : std_logic_vector (2 downto 0);
  signal n23_o : std_logic;
  signal n24_o : std_logic;
  signal n25_o : std_logic;
  signal n26_o : std_logic_vector (7 downto 0);
  signal n27_o : std_logic_vector (7 downto 0);
  signal n28_o : std_logic;
  signal n29_o : std_logic;
  signal n30_o : std_logic;
  signal n31_o : std_logic;
  signal n32_o : std_logic_vector (6 downto 0);
  signal n33_o : std_logic_vector (7 downto 0);
  signal n34_o : std_logic_vector (7 downto 0);
  signal n35_o : std_logic;
  signal n36_o : std_logic;
  signal n37_o : std_logic;
  signal n38_o : std_logic_vector (7 downto 0);
  signal n39_o : std_logic_vector (7 downto 0);
  signal n41_o : std_logic;
  signal n43_o : std_logic;
  signal n45_o : std_logic;
  signal n47_o : std_logic_vector (7 downto 0);
  signal n48_o : std_logic_vector (7 downto 0);
  signal n55_q : std_logic := '0';
  signal n56_q : std_logic := '0';
  signal n57_q : std_logic := '0';
  signal n58_q : std_logic_vector (7 downto 0);
  signal n59_q : std_logic_vector (7 downto 0);
  signal n61_o : std_logic;
  signal n63_o : std_logic_vector (5 downto 0);
  signal n64_o : std_logic_vector (6 downto 0);
  signal n65_o : std_logic_vector (7 downto 0);
  signal n67_o : std_logic;
  signal n70_o : std_logic;
  signal n72_o : std_logic_vector (2 downto 0);
  signal n73_o : std_logic_vector (7 downto 0);
  signal n75_o : std_logic;
  signal n76_o : std_logic;
  signal n80_o : std_logic_vector (31 downto 0);
  signal n82_o : std_logic;
  signal n83_o : std_logic;
  signal n85_o : std_logic;
  signal n87_o : std_logic;
  signal n89_o : std_logic;
  signal n92_q : std_logic := '0';
  signal n95_o : std_logic_vector (31 downto 0);
  signal n97_o : std_logic;
  signal n99_o : std_logic;
  signal n101_o : std_logic;
  signal n104_q : std_logic;
  signal n107_o : std_logic_vector (31 downto 0);
  signal n109_o : std_logic_vector (31 downto 0);
  signal n110_o : std_logic_vector (7 downto 0);
  signal n112_o : std_logic_vector (7 downto 0);
  signal n113_o : std_logic_vector (7 downto 0);
  signal n115_o : std_logic_vector (7 downto 0);
  signal n118_q : std_logic_vector (7 downto 0);
  signal n121_o : std_logic_vector (31 downto 0);
  signal n123_o : std_logic;
  signal n124_o : std_logic_vector (31 downto 0);
  signal n126_o : std_logic_vector (31 downto 0);
  signal n127_o : std_logic_vector (2 downto 0);
  signal n129_o : std_logic_vector (2 downto 0);
  signal n130_o : std_logic_vector (2 downto 0);
  signal n132_o : std_logic_vector (2 downto 0);
  signal n135_q : std_logic_vector (2 downto 0);
  signal n137_o : std_logic_vector (31 downto 0);
  signal n138_o : std_logic_vector (31 downto 0);
  signal n140_o : std_logic_vector (31 downto 0);
  signal n141_o : std_logic;
  signal n142_o : std_logic;
  signal n145_o : std_logic_vector (31 downto 0);
  signal n146_o : std_logic_vector (31 downto 0);
  signal n147_o : std_logic;
  signal n148_o : std_logic;
  signal n152_o : std_logic;
  signal n153_o : std_logic;
  signal n154_o : std_logic;
  signal n155_o : std_logic;
  signal n158_q : std_logic := '0';
  signal n161_o : std_logic;
  signal n162_o : std_logic;
  signal n163_o : std_logic;
  signal n164_o : std_logic;
  signal n165_o : std_logic;
  signal n166_o : std_logic;
  signal n167_o : std_logic;
  signal n168_o : std_logic;
  signal n169_o : std_logic;
  signal n170_o : std_logic;
  signal n173_q : std_logic;
  signal n174_o : std_logic;
begin
  wrap_clk_i <= clk_i;
  wrap_reset_i <= reset_i;
  wrap_write_i <= write_i;
  wrap_address_i <= address_i;
  wrap_wdata_i <= wdata_i;
  wrap_miso_i <= miso_i;
  rdata_o <= wrap_rdata_o;
  done_o <= wrap_done_o;
  mosi_o <= wrap_mosi_o;
  sclk_o <= wrap_sclk_o;
  cs_n_o <= wrap_cs_n_o;
  wrap_rdata_o <= n73_o;
  wrap_done_o <= n104_q;
  wrap_mosi_o <= n173_q;
  wrap_sclk_o <= sclk_reg;
  wrap_cs_n_o <= n174_o;
  -- SPIMaster.vhd:30:12
  start <= n76_o; -- (signal)
  -- SPIMaster.vhd:31:12
  busy_reg <= n92_q; -- (isignal)
  -- SPIMaster.vhd:33:12
  polarity_reg <= n55_q; -- (isignal)
  -- SPIMaster.vhd:34:12
  phase_reg <= n56_q; -- (isignal)
  -- SPIMaster.vhd:35:12
  cs_reg <= n57_q; -- (isignal)
  -- SPIMaster.vhd:36:12
  timer_max_reg <= n58_q; -- (signal)
  -- SPIMaster.vhd:37:12
  timer_reg <= n118_q; -- (signal)
  -- SPIMaster.vhd:38:12
  bit_index_reg <= n135_q; -- (signal)
  -- SPIMaster.vhd:39:12
  data_reg <= n59_q; -- (signal)
  -- SPIMaster.vhd:41:12
  sclk_half <= n142_o; -- (signal)
  -- SPIMaster.vhd:42:12
  sclk_cycle <= n148_o; -- (signal)
  -- SPIMaster.vhd:43:12
  sclk_reg <= n158_q; -- (isignal)
  -- SPIMaster.vhd:55:21
  n13_o <= '1' when wrap_address_i = "00" else '0';
  -- SPIMaster.vhd:56:58
  n14_o <= wrap_wdata_i (2);
  -- SPIMaster.vhd:57:58
  n15_o <= wrap_wdata_i (1);
  -- SPIMaster.vhd:58:58
  n16_o <= wrap_wdata_i (0);
  -- SPIMaster.vhd:56:21
  n18_o <= '1' when wrap_address_i = "01" else '0';
  -- SPIMaster.vhd:59:21
  n21_o <= '1' when wrap_address_i = "10" else '0';
  n22_o <= n21_o & n18_o & n13_o;
  -- SPIMaster.vhd:54:17
  with n22_o select n23_o <=
    polarity_reg when "100",
    n14_o when "010",
    polarity_reg when "001",
    polarity_reg when others;
  -- SPIMaster.vhd:54:17
  with n22_o select n24_o <=
    phase_reg when "100",
    n15_o when "010",
    phase_reg when "001",
    phase_reg when others;
  -- SPIMaster.vhd:54:17
  with n22_o select n25_o <=
    cs_reg when "100",
    n16_o when "010",
    cs_reg when "001",
    cs_reg when others;
  -- SPIMaster.vhd:54:17
  with n22_o select n26_o <=
    wrap_wdata_i when "100",
    timer_max_reg when "010",
    timer_max_reg when "001",
    timer_max_reg when others;
  -- SPIMaster.vhd:54:17
  with n22_o select n27_o <=
    data_reg when "100",
    data_reg when "010",
    wrap_wdata_i when "001",
    data_reg when others;
  -- SPIMaster.vhd:62:50
  n28_o <= not phase_reg;
  -- SPIMaster.vhd:62:36
  n29_o <= sclk_half and n28_o;
  -- SPIMaster.vhd:62:78
  n30_o <= sclk_cycle and phase_reg;
  -- SPIMaster.vhd:62:57
  n31_o <= n29_o or n30_o;
  -- SPIMaster.vhd:63:37
  n32_o <= data_reg (6 downto 0);
  -- SPIMaster.vhd:63:50
  n33_o <= n32_o & wrap_miso_i;
  -- SPIMaster.vhd:62:13
  n34_o <= data_reg when n31_o = '0' else n33_o;
  -- SPIMaster.vhd:53:13
  n35_o <= polarity_reg when wrap_write_i = '0' else n23_o;
  -- SPIMaster.vhd:53:13
  n36_o <= phase_reg when wrap_write_i = '0' else n24_o;
  -- SPIMaster.vhd:53:13
  n37_o <= cs_reg when wrap_write_i = '0' else n25_o;
  -- SPIMaster.vhd:53:13
  n38_o <= timer_max_reg when wrap_write_i = '0' else n26_o;
  -- SPIMaster.vhd:53:13
  n39_o <= n34_o when wrap_write_i = '0' else n27_o;
  -- SPIMaster.vhd:48:13
  n41_o <= n35_o when wrap_reset_i = '0' else '0';
  -- SPIMaster.vhd:48:13
  n43_o <= n36_o when wrap_reset_i = '0' else '0';
  -- SPIMaster.vhd:48:13
  n45_o <= n37_o when wrap_reset_i = '0' else '0';
  -- SPIMaster.vhd:48:13
  n47_o <= n38_o when wrap_reset_i = '0' else "11111111";
  -- SPIMaster.vhd:48:13
  n48_o <= n39_o when wrap_reset_i = '0' else data_reg;
  -- SPIMaster.vhd:47:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n55_q <= n41_o;
    end if;
  end process;
  -- SPIMaster.vhd:47:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n56_q <= n43_o;
    end if;
  end process;
  -- SPIMaster.vhd:47:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n57_q <= n45_o;
    end if;
  end process;
  -- SPIMaster.vhd:47:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n58_q <= n47_o;
    end if;
  end process;
  -- SPIMaster.vhd:47:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n59_q <= n48_o;
    end if;
  end process;
  -- SPIMaster.vhd:69:68
  n61_o <= '1' when wrap_address_i = "00" else '0';
  -- SPIMaster.vhd:70:28
  n63_o <= "00000" & polarity_reg;
  -- SPIMaster.vhd:70:43
  n64_o <= n63_o & phase_reg;
  -- SPIMaster.vhd:70:55
  n65_o <= n64_o & cs_reg;
  -- SPIMaster.vhd:70:68
  n67_o <= '1' when wrap_address_i = "01" else '0';
  -- SPIMaster.vhd:71:68
  n70_o <= '1' when wrap_address_i = "10" else '0';
  n72_o <= n70_o & n67_o & n61_o;
  -- SPIMaster.vhd:68:5
  with n72_o select n73_o <=
    timer_max_reg when "100",
    n65_o when "010",
    data_reg when "001",
    "00000000" when others;
  -- SPIMaster.vhd:74:37
  n75_o <= '1' when wrap_address_i = "00" else '0';
  -- SPIMaster.vhd:74:22
  n76_o <= '0' when n75_o = '0' else wrap_write_i;
  -- SPIMaster.vhd:83:54
  n80_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- SPIMaster.vhd:83:54
  n82_o <= '1' when n80_o = "00000000000000000000000000000111" else '0';
  -- SPIMaster.vhd:83:36
  n83_o <= sclk_cycle and n82_o;
  -- SPIMaster.vhd:83:13
  n85_o <= busy_reg when n83_o = '0' else '0';
  -- SPIMaster.vhd:81:13
  n87_o <= n85_o when start = '0' else '1';
  -- SPIMaster.vhd:79:13
  n89_o <= n87_o when wrap_reset_i = '0' else '0';
  -- SPIMaster.vhd:78:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n92_q <= n89_o;
    end if;
  end process;
  -- SPIMaster.vhd:94:33
  n95_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- SPIMaster.vhd:94:33
  n97_o <= '1' when n95_o = "00000000000000000000000000000111" else '0';
  -- SPIMaster.vhd:94:13
  n99_o <= '0' when n97_o = '0' else sclk_cycle;
  -- SPIMaster.vhd:92:13
  n101_o <= n99_o when wrap_reset_i = '0' else '0';
  -- SPIMaster.vhd:91:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n104_q <= n101_o;
    end if;
  end process;
  -- SPIMaster.vhd:111:44
  n107_o <= "000000000000000000000000" & timer_reg;  --  uext
  -- SPIMaster.vhd:111:44
  n109_o <= std_logic_vector (unsigned (n107_o) + unsigned'("00000000000000000000000000000001"));
  -- SPIMaster.vhd:111:34
  n110_o <= n109_o (7 downto 0);  --  trunc
  -- SPIMaster.vhd:108:17
  n112_o <= n110_o when sclk_cycle = '0' else "00000000";
  -- SPIMaster.vhd:107:13
  n113_o <= timer_reg when busy_reg = '0' else n112_o;
  -- SPIMaster.vhd:105:13
  n115_o <= n113_o when wrap_reset_i = '0' else "00000000";
  -- SPIMaster.vhd:104:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n118_q <= n115_o;
    end if;
  end process;
  -- SPIMaster.vhd:123:34
  n121_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- SPIMaster.vhd:123:34
  n123_o <= '1' when n121_o = "00000000000000000000000000000111" else '0';
  -- SPIMaster.vhd:126:52
  n124_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- SPIMaster.vhd:126:52
  n126_o <= std_logic_vector (unsigned (n124_o) + unsigned'("00000000000000000000000000000001"));
  -- SPIMaster.vhd:126:38
  n127_o <= n126_o (2 downto 0);  --  trunc
  -- SPIMaster.vhd:123:17
  n129_o <= n127_o when n123_o = '0' else "000";
  -- SPIMaster.vhd:122:13
  n130_o <= bit_index_reg when sclk_cycle = '0' else n129_o;
  -- SPIMaster.vhd:120:13
  n132_o <= n130_o when wrap_reset_i = '0' else "000";
  -- SPIMaster.vhd:119:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n135_q <= n132_o;
    end if;
  end process;
  -- SPIMaster.vhd:132:38
  n137_o <= "000000000000000000000000" & timer_reg;  --  uext
  -- SPIMaster.vhd:132:54
  n138_o <= "000000000000000000000000" & timer_max_reg;  --  uext
  -- SPIMaster.vhd:132:54
  n140_o <= std_logic_vector (signed (n138_o) / signed'("00000000000000000000000000000010"));
  -- SPIMaster.vhd:132:38
  n141_o <= '1' when n137_o = n140_o else '0';
  -- SPIMaster.vhd:132:23
  n142_o <= '0' when n141_o = '0' else '1';
  -- SPIMaster.vhd:133:38
  n145_o <= "000000000000000000000000" & timer_reg;  --  uext
  -- SPIMaster.vhd:133:38
  n146_o <= "000000000000000000000000" & timer_max_reg;  --  uext
  -- SPIMaster.vhd:133:38
  n147_o <= '1' when n145_o = n146_o else '0';
  -- SPIMaster.vhd:133:23
  n148_o <= '0' when n147_o = '0' else '1';
  -- SPIMaster.vhd:140:35
  n152_o <= sclk_half or sclk_cycle;
  -- SPIMaster.vhd:141:29
  n153_o <= not sclk_reg;
  -- SPIMaster.vhd:140:13
  n154_o <= sclk_reg when n152_o = '0' else n153_o;
  -- SPIMaster.vhd:138:13
  n155_o <= n154_o when wrap_reset_i = '0' else polarity_reg;
  -- SPIMaster.vhd:137:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n158_q <= n155_o;
    end if;
  end process;
  -- SPIMaster.vhd:149:42
  n161_o <= not phase_reg;
  -- SPIMaster.vhd:149:28
  n162_o <= start and n161_o;
  -- SPIMaster.vhd:150:34
  n163_o <= wrap_wdata_i (7);
  -- SPIMaster.vhd:151:51
  n164_o <= not phase_reg;
  -- SPIMaster.vhd:151:37
  n165_o <= sclk_cycle and n164_o;
  -- SPIMaster.vhd:151:78
  n166_o <= sclk_half and phase_reg;
  -- SPIMaster.vhd:151:58
  n167_o <= n165_o or n166_o;
  -- SPIMaster.vhd:152:35
  n168_o <= data_reg (7);
  -- SPIMaster.vhd:151:13
  n169_o <= n173_q when n167_o = '0' else n168_o;
  -- SPIMaster.vhd:149:13
  n170_o <= n169_o when n162_o = '0' else n163_o;
  -- SPIMaster.vhd:148:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n173_q <= n170_o;
    end if;
  end process;
  -- SPIMaster.vhd:157:16
  n174_o <= not cs_reg;
end rtl;

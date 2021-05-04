library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.virgule_pkg.all;
entity I2CMaster is
  generic (
    CLK_FREQUENCY_HZ: positive := 100000000;
    I2C_FREQUENCY_HZ: positive := 100e3
  );
  port (
    clk_i: in std_logic;
    reset_i: in std_logic;
    write_i: in std_logic;
    address_i: in std_logic;
    wdata_i: in word_t;
    rdata_o: out word_t;
    done_o: out std_logic;
    error_o: out std_logic;
    scl_io: inout std_logic;
    sda_io: inout std_logic
  );
end I2CMaster;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of i2cmaster is
  signal wrap_clk_i: std_logic;
  signal wrap_reset_i: std_logic;
  signal wrap_write_i: std_logic;
  signal wrap_address_i: std_logic;
  subtype typwrap_wdata_i is std_logic_vector (31 downto 0);
  signal wrap_wdata_i: typwrap_wdata_i;
  subtype typwrap_rdata_o is std_logic_vector (31 downto 0);
  signal wrap_rdata_o: typwrap_rdata_o;
  signal wrap_done_o: std_logic;
  signal wrap_error_o: std_logic;
  signal n3_o : std_logic;
  signal n3_oport : std_logic;
  signal n4_o : std_logic;
  signal n4_oport : std_logic;
  signal start : std_logic;
  signal sda_i : std_logic;
  signal sda_o : std_logic;
  signal scl_i : std_logic;
  signal scl_o : std_logic;
  signal scl_low_pulse : std_logic;
  signal scl_high_pulse : std_logic;
  signal slave_address_reg : std_logic_vector (6 downto 0);
  signal send_len_reg : std_logic_vector (2 downto 0);
  signal recv_len_reg : std_logic_vector (2 downto 0);
  signal buffer_reg : std_logic_vector (39 downto 0);
  signal timer_reg : std_logic_vector (8 downto 0);
  signal bit_index_reg : std_logic_vector (2 downto 0);
  signal byte_index_reg : std_logic_vector (1 downto 0);
  signal arb_error : std_logic;
  signal state_reg : std_logic_vector (3 downto 0);
  signal scl_state_reg : std_logic_vector (1 downto 0);
  signal n7_o : std_logic;
  signal n9_o : std_logic;
  signal n10_o : std_logic;
  signal n11_o : std_logic_vector (2 downto 0);
  signal n13_o : std_logic_vector (2 downto 0);
  signal n15_o : std_logic_vector (6 downto 0);
  signal n23_o : std_logic_vector (6 downto 0);
  signal n24_q : std_logic_vector (6 downto 0);
  signal n25_o : std_logic_vector (2 downto 0);
  signal n26_q : std_logic_vector (2 downto 0);
  signal n27_o : std_logic_vector (2 downto 0);
  signal n28_q : std_logic_vector (2 downto 0);
  signal n29_o : std_logic_vector (31 downto 0);
  signal n31_o : std_logic;
  signal n32_o : std_logic;
  signal n35_o : std_logic;
  signal n36_o : std_logic;
  signal n38_o : std_logic;
  signal n39_o : std_logic;
  signal n42_o : std_logic_vector (31 downto 0);
  signal n44_o : std_logic;
  signal n45_o : std_logic_vector (31 downto 0);
  signal n47_o : std_logic;
  signal n48_o : std_logic;
  signal n51_o : std_logic_vector (3 downto 0);
  signal n52_o : std_logic_vector (3 downto 0);
  signal n54_o : std_logic;
  signal n55_o : std_logic;
  signal n57_o : std_logic_vector (3 downto 0);
  signal n59_o : std_logic;
  signal n60_o : std_logic;
  signal n61_o : std_logic;
  signal n62_o : std_logic;
  signal n63_o : std_logic_vector (31 downto 0);
  signal n65_o : std_logic;
  signal n67_o : std_logic_vector (3 downto 0);
  signal n69_o : std_logic_vector (3 downto 0);
  signal n71_o : std_logic;
  signal n72_o : std_logic_vector (31 downto 0);
  signal n74_o : std_logic;
  signal n77_o : std_logic_vector (3 downto 0);
  signal n78_o : std_logic_vector (3 downto 0);
  signal n80_o : std_logic;
  signal n81_o : std_logic_vector (31 downto 0);
  signal n83_o : std_logic;
  signal n84_o : std_logic;
  signal n86_o : std_logic_vector (3 downto 0);
  signal n88_o : std_logic_vector (3 downto 0);
  signal n90_o : std_logic;
  signal n91_o : std_logic;
  signal n92_o : std_logic_vector (31 downto 0);
  signal n93_o : std_logic_vector (31 downto 0);
  signal n94_o : std_logic;
  signal n95_o : std_logic_vector (31 downto 0);
  signal n97_o : std_logic;
  signal n100_o : std_logic_vector (3 downto 0);
  signal n102_o : std_logic_vector (3 downto 0);
  signal n103_o : std_logic_vector (3 downto 0);
  signal n105_o : std_logic_vector (3 downto 0);
  signal n107_o : std_logic;
  signal n109_o : std_logic_vector (3 downto 0);
  signal n111_o : std_logic_vector (3 downto 0);
  signal n113_o : std_logic;
  signal n115_o : std_logic_vector (3 downto 0);
  signal n117_o : std_logic;
  signal n118_o : std_logic_vector (31 downto 0);
  signal n120_o : std_logic;
  signal n121_o : std_logic;
  signal n123_o : std_logic_vector (3 downto 0);
  signal n125_o : std_logic_vector (3 downto 0);
  signal n127_o : std_logic;
  signal n128_o : std_logic;
  signal n130_o : std_logic_vector (3 downto 0);
  signal n132_o : std_logic_vector (3 downto 0);
  signal n134_o : std_logic;
  signal n135_o : std_logic_vector (31 downto 0);
  signal n137_o : std_logic;
  signal n138_o : std_logic;
  signal n140_o : std_logic_vector (3 downto 0);
  signal n142_o : std_logic;
  signal n143_o : std_logic_vector (31 downto 0);
  signal n144_o : std_logic_vector (31 downto 0);
  signal n145_o : std_logic;
  signal n148_o : std_logic_vector (3 downto 0);
  signal n149_o : std_logic_vector (3 downto 0);
  signal n151_o : std_logic;
  signal n153_o : std_logic_vector (3 downto 0);
  signal n155_o : std_logic;
  signal n156_o : std_logic_vector (31 downto 0);
  signal n158_o : std_logic;
  signal n160_o : std_logic_vector (3 downto 0);
  signal n162_o : std_logic;
  signal n164_o : std_logic;
  signal n166_o : std_logic;
  signal n167_o : std_logic;
  signal n168_o : std_logic_vector (14 downto 0);
  signal n171_o : std_logic_vector (3 downto 0);
  signal n174_q : std_logic_vector (3 downto 0);
  signal n177_o : std_logic;
  signal n178_o : std_logic;
  signal n182_o : std_logic;
  signal n183_o : std_logic;
  signal n187_o : std_logic_vector (31 downto 0);
  signal n189_o : std_logic;
  signal n190_o : std_logic_vector (31 downto 0);
  signal n192_o : std_logic_vector (31 downto 0);
  signal n193_o : std_logic_vector (8 downto 0);
  signal n195_o : std_logic_vector (8 downto 0);
  signal n197_o : std_logic;
  signal n199_o : std_logic;
  signal n200_o : std_logic;
  signal n202_o : std_logic;
  signal n203_o : std_logic;
  signal n204_o : std_logic_vector (31 downto 0);
  signal n206_o : std_logic;
  signal n207_o : std_logic_vector (31 downto 0);
  signal n209_o : std_logic_vector (31 downto 0);
  signal n210_o : std_logic_vector (8 downto 0);
  signal n211_o : std_logic_vector (8 downto 0);
  signal n213_o : std_logic;
  signal n214_o : std_logic;
  signal n215_o : std_logic_vector (31 downto 0);
  signal n217_o : std_logic;
  signal n218_o : std_logic;
  signal n219_o : std_logic_vector (31 downto 0);
  signal n221_o : std_logic_vector (31 downto 0);
  signal n222_o : std_logic_vector (8 downto 0);
  signal n224_o : std_logic_vector (8 downto 0);
  signal n226_o : std_logic;
  signal n228_o : std_logic;
  signal n230_o : std_logic;
  signal n231_o : std_logic;
  signal n232_o : std_logic_vector (2 downto 0);
  signal n235_o : std_logic_vector (8 downto 0);
  signal n237_o : std_logic;
  signal n239_o : std_logic;
  signal n240_o : std_logic;
  signal n242_o : std_logic;
  signal n243_o : std_logic;
  signal n245_o : std_logic;
  signal n246_o : std_logic;
  signal n248_o : std_logic;
  signal n249_o : std_logic;
  signal n251_o : std_logic;
  signal n252_o : std_logic;
  signal n254_o : std_logic;
  signal n255_o : std_logic;
  signal n257_o : std_logic;
  signal n258_o : std_logic;
  signal n260_o : std_logic;
  signal n261_o : std_logic;
  signal n262_o : std_logic_vector (1 downto 0);
  signal n264_o : std_logic_vector (8 downto 0);
  signal n267_q : std_logic_vector (8 downto 0);
  signal n271_o : std_logic;
  signal n272_o : std_logic_vector (31 downto 0);
  signal n274_o : std_logic;
  signal n275_o : std_logic;
  signal n277_o : std_logic_vector (1 downto 0);
  signal n279_o : std_logic;
  signal n280_o : std_logic_vector (31 downto 0);
  signal n282_o : std_logic;
  signal n284_o : std_logic_vector (1 downto 0);
  signal n286_o : std_logic;
  signal n288_o : std_logic_vector (1 downto 0);
  signal n290_o : std_logic;
  signal n291_o : std_logic;
  signal n292_o : std_logic_vector (31 downto 0);
  signal n294_o : std_logic;
  signal n295_o : std_logic;
  signal n297_o : std_logic_vector (1 downto 0);
  signal n299_o : std_logic;
  signal n300_o : std_logic_vector (3 downto 0);
  signal n302_o : std_logic_vector (1 downto 0);
  signal n304_o : std_logic;
  signal n306_o : std_logic;
  signal n307_o : std_logic;
  signal n309_o : std_logic;
  signal n310_o : std_logic;
  signal n312_o : std_logic;
  signal n313_o : std_logic;
  signal n315_o : std_logic;
  signal n316_o : std_logic;
  signal n318_o : std_logic;
  signal n319_o : std_logic;
  signal n321_o : std_logic;
  signal n322_o : std_logic;
  signal n324_o : std_logic;
  signal n325_o : std_logic;
  signal n327_o : std_logic;
  signal n328_o : std_logic;
  signal n330_o : std_logic;
  signal n331_o : std_logic;
  signal n333_o : std_logic_vector (1 downto 0);
  signal n336_q : std_logic_vector (1 downto 0);
  signal n339_o : std_logic;
  signal n340_o : std_logic;
  signal n344_o : std_logic;
  signal n345_o : std_logic_vector (31 downto 0);
  signal n347_o : std_logic;
  signal n348_o : std_logic;
  signal n349_o : std_logic;
  signal n353_o : std_logic;
  signal n354_o : std_logic_vector (31 downto 0);
  signal n356_o : std_logic;
  signal n357_o : std_logic;
  signal n358_o : std_logic;
  signal n362_o : std_logic;
  signal n364_o : std_logic;
  signal n365_o : std_logic;
  signal n367_o : std_logic;
  signal n368_o : std_logic;
  signal n370_o : std_logic;
  signal n371_o : std_logic;
  signal n373_o : std_logic;
  signal n374_o : std_logic;
  signal n375_o : std_logic;
  signal n377_o : std_logic;
  signal n379_o : std_logic;
  signal n380_o : std_logic;
  signal n382_o : std_logic_vector (1 downto 0);
  signal n383_o : std_logic;
  signal n385_o : std_logic;
  signal n386_o : std_logic;
  signal n387_o : std_logic;
  signal n392_o : std_logic_vector (31 downto 0);
  signal n394_o : std_logic;
  signal n397_o : std_logic;
  signal n398_o : std_logic_vector (7 downto 0);
  signal n399_o : std_logic_vector (39 downto 0);
  signal n400_o : std_logic_vector (39 downto 0);
  signal n403_o : std_logic;
  signal n405_o : std_logic_vector (7 downto 0);
  signal n407_o : std_logic;
  signal n408_o : std_logic_vector (38 downto 0);
  signal n410_o : std_logic_vector (39 downto 0);
  signal n411_o : std_logic_vector (39 downto 0);
  signal n413_o : std_logic;
  signal n415_o : std_logic;
  signal n416_o : std_logic;
  signal n417_o : std_logic_vector (38 downto 0);
  signal n418_o : std_logic_vector (39 downto 0);
  signal n419_o : std_logic_vector (39 downto 0);
  signal n421_o : std_logic;
  signal n422_o : std_logic_vector (3 downto 0);
  signal n423_o : std_logic_vector (31 downto 0);
  signal n424_o : std_logic_vector (31 downto 0);
  signal n425_o : std_logic_vector (31 downto 0);
  signal n426_o : std_logic_vector (31 downto 0);
  signal n427_o : std_logic_vector (31 downto 0);
  signal n428_o : std_logic_vector (7 downto 0);
  signal n429_o : std_logic_vector (7 downto 0);
  signal n430_o : std_logic_vector (7 downto 0);
  signal n431_o : std_logic_vector (7 downto 0);
  signal n432_o : std_logic_vector (7 downto 0);
  signal n434_o : std_logic_vector (39 downto 0);
  signal n438_q : std_logic_vector (39 downto 0);
  signal n443_o : std_logic;
  signal n444_o : std_logic_vector (31 downto 0);
  signal n446_o : std_logic;
  signal n447_o : std_logic_vector (31 downto 0);
  signal n449_o : std_logic_vector (31 downto 0);
  signal n450_o : std_logic_vector (2 downto 0);
  signal n452_o : std_logic_vector (2 downto 0);
  signal n453_o : std_logic_vector (2 downto 0);
  signal n455_o : std_logic;
  signal n457_o : std_logic;
  signal n458_o : std_logic;
  signal n460_o : std_logic;
  signal n461_o : std_logic;
  signal n462_o : std_logic_vector (31 downto 0);
  signal n463_o : std_logic_vector (31 downto 0);
  signal n464_o : std_logic;
  signal n465_o : std_logic;
  signal n466_o : std_logic_vector (31 downto 0);
  signal n468_o : std_logic_vector (31 downto 0);
  signal n469_o : std_logic_vector (1 downto 0);
  signal n470_o : std_logic_vector (1 downto 0);
  signal n472_o : std_logic;
  signal n474_o : std_logic;
  signal n475_o : std_logic;
  signal n477_o : std_logic;
  signal n478_o : std_logic_vector (31 downto 0);
  signal n479_o : std_logic_vector (31 downto 0);
  signal n480_o : std_logic;
  signal n481_o : std_logic;
  signal n482_o : std_logic_vector (31 downto 0);
  signal n484_o : std_logic_vector (31 downto 0);
  signal n485_o : std_logic_vector (1 downto 0);
  signal n486_o : std_logic_vector (1 downto 0);
  signal n488_o : std_logic;
  signal n489_o : std_logic_vector (4 downto 0);
  signal n491_o : std_logic_vector (2 downto 0);
  signal n494_o : std_logic_vector (1 downto 0);
  signal n498_q : std_logic_vector (2 downto 0);
  signal n499_q : std_logic_vector (1 downto 0);
begin
  wrap_clk_i <= clk_i;
  wrap_reset_i <= reset_i;
  wrap_write_i <= write_i;
  wrap_address_i <= address_i;
  wrap_wdata_i <= wdata_i;
  rdata_o <= wrap_rdata_o;
  done_o <= wrap_done_o;
  error_o <= wrap_error_o;
  wrap_rdata_o <= n29_o;
  wrap_done_o <= n183_o;
  wrap_error_o <= n178_o;
  scl_io <= n3_oport;
  sda_io <= n4_oport;
  -- I2CMaster.vhd:21:9
  n3_oport <= n32_o; -- (inout - port)
  n3_o <= scl_io; -- (inout - read)
  -- I2CMaster.vhd:22:9
  n4_oport <= n36_o; -- (inout - port)
  n4_o <= sda_io; -- (inout - read)
  -- I2CMaster.vhd:28:12
  start <= n39_o; -- (signal)
  -- I2CMaster.vhd:30:12
  sda_i <= n4_o; -- (signal)
  -- I2CMaster.vhd:30:19
  sda_o <= n383_o; -- (signal)
  -- I2CMaster.vhd:31:12
  scl_i <= n3_o; -- (signal)
  -- I2CMaster.vhd:31:19
  scl_o <= n340_o; -- (signal)
  -- I2CMaster.vhd:33:12
  scl_low_pulse <= n349_o; -- (signal)
  -- I2CMaster.vhd:34:12
  scl_high_pulse <= n358_o; -- (signal)
  -- I2CMaster.vhd:36:12
  slave_address_reg <= n24_q; -- (signal)
  -- I2CMaster.vhd:37:12
  send_len_reg <= n26_q; -- (signal)
  -- I2CMaster.vhd:38:12
  recv_len_reg <= n28_q; -- (signal)
  -- I2CMaster.vhd:41:12
  buffer_reg <= n438_q; -- (signal)
  -- I2CMaster.vhd:44:12
  timer_reg <= n267_q; -- (signal)
  -- I2CMaster.vhd:46:12
  bit_index_reg <= n498_q; -- (signal)
  -- I2CMaster.vhd:47:12
  byte_index_reg <= n499_q; -- (signal)
  -- I2CMaster.vhd:49:12
  arb_error <= n387_o; -- (signal)
  -- I2CMaster.vhd:61:12
  state_reg <= n174_q; -- (signal)
  -- I2CMaster.vhd:64:12
  scl_state_reg <= n336_q; -- (signal)
  -- I2CMaster.vhd:69:30
  n7_o <= wrap_write_i and wrap_address_i;
  -- I2CMaster.vhd:69:64
  n9_o <= '1' when state_reg = "0000" else '0';
  -- I2CMaster.vhd:69:50
  n10_o <= n7_o and n9_o;
  -- I2CMaster.vhd:70:65
  n11_o <= wrap_wdata_i (14 downto 12);
  -- I2CMaster.vhd:71:65
  n13_o <= wrap_wdata_i (10 downto 8);
  -- I2CMaster.vhd:72:45
  n15_o <= wrap_wdata_i (6 downto 0);
  -- I2CMaster.vhd:69:50
  n23_o <= slave_address_reg when n10_o = '0' else n15_o;
  -- I2CMaster.vhd:68:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n24_q <= n23_o;
    end if;
  end process;
  -- I2CMaster.vhd:69:50
  n25_o <= send_len_reg when n10_o = '0' else n11_o;
  -- I2CMaster.vhd:68:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n26_q <= n25_o;
    end if;
  end process;
  -- I2CMaster.vhd:69:50
  n27_o <= recv_len_reg when n10_o = '0' else n13_o;
  -- I2CMaster.vhd:68:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n28_q <= n27_o;
    end if;
  end process;
  -- I2CMaster.vhd:77:26
  n29_o <= buffer_reg (31 downto 0);
  -- I2CMaster.vhd:80:30
  n31_o <= not scl_o;
  -- I2CMaster.vhd:80:19
  n32_o <= 'Z' when n31_o = '0' else '0';
  -- I2CMaster.vhd:81:30
  n35_o <= not sda_o;
  -- I2CMaster.vhd:81:19
  n36_o <= 'Z' when n35_o = '0' else '0';
  -- I2CMaster.vhd:88:26
  n38_o <= not wrap_address_i;
  -- I2CMaster.vhd:88:22
  n39_o <= wrap_write_i and n38_o;
  -- I2CMaster.vhd:99:41
  n42_o <= "00000000000000000000000000000" & send_len_reg;  --  uext
  -- I2CMaster.vhd:99:41
  n44_o <= '1' when n42_o = "00000000000000000000000000000000" else '0';
  -- I2CMaster.vhd:99:62
  n45_o <= "00000000000000000000000000000" & recv_len_reg;  --  uext
  -- I2CMaster.vhd:99:62
  n47_o <= '1' when n45_o = "00000000000000000000000000000000" else '0';
  -- I2CMaster.vhd:99:45
  n48_o <= n44_o and n47_o;
  -- I2CMaster.vhd:99:25
  n51_o <= "0001" when n48_o = '0' else "1111";
  -- I2CMaster.vhd:98:21
  n52_o <= state_reg when start = '0' else n51_o;
  -- I2CMaster.vhd:95:17
  n54_o <= '1' when state_reg = "0000" else '0';
  -- I2CMaster.vhd:108:36
  n55_o <= scl_i and sda_i;
  -- I2CMaster.vhd:108:21
  n57_o <= state_reg when n55_o = '0' else "0010";
  -- I2CMaster.vhd:106:17
  n59_o <= '1' when state_reg = "0001" else '0';
  -- I2CMaster.vhd:115:30
  n60_o <= not scl_i;
  -- I2CMaster.vhd:115:45
  n61_o <= not sda_i;
  -- I2CMaster.vhd:115:36
  n62_o <= n60_o or n61_o;
  -- I2CMaster.vhd:117:37
  n63_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:117:37
  n65_o <= '1' when n63_o = "00000000000000000000000111110011" else '0';
  -- I2CMaster.vhd:117:21
  n67_o <= state_reg when n65_o = '0' else "0011";
  -- I2CMaster.vhd:115:21
  n69_o <= n67_o when n62_o = '0' else "0001";
  -- I2CMaster.vhd:112:17
  n71_o <= '1' when state_reg = "0010" else '0';
  -- I2CMaster.vhd:125:41
  n72_o <= "00000000000000000000000000000" & send_len_reg;  --  uext
  -- I2CMaster.vhd:125:41
  n74_o <= '1' when signed (n72_o) > signed'("00000000000000000000000000000000") else '0';
  -- I2CMaster.vhd:125:25
  n77_o <= "1000" when n74_o = '0' else "0100";
  -- I2CMaster.vhd:124:21
  n78_o <= state_reg when scl_low_pulse = '0' else n77_o;
  -- I2CMaster.vhd:121:17
  n80_o <= '1' when state_reg = "0011" else '0';
  -- I2CMaster.vhd:138:65
  n81_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- I2CMaster.vhd:138:65
  n83_o <= '1' when n81_o = "00000000000000000000000000000111" else '0';
  -- I2CMaster.vhd:138:47
  n84_o <= scl_low_pulse and n83_o;
  -- I2CMaster.vhd:138:21
  n86_o <= state_reg when n84_o = '0' else "0101";
  -- I2CMaster.vhd:136:21
  n88_o <= n86_o when arb_error = '0' else "1110";
  -- I2CMaster.vhd:132:17
  n90_o <= '1' when state_reg = "0100" else '0';
  -- I2CMaster.vhd:147:36
  n91_o <= scl_i and sda_i;
  -- I2CMaster.vhd:150:43
  n92_o <= "000000000000000000000000000000" & byte_index_reg;  --  uext
  -- I2CMaster.vhd:150:43
  n93_o <= "00000000000000000000000000000" & send_len_reg;  --  uext
  -- I2CMaster.vhd:150:43
  n94_o <= '1' when n92_o /= n93_o else '0';
  -- I2CMaster.vhd:152:44
  n95_o <= "00000000000000000000000000000" & recv_len_reg;  --  uext
  -- I2CMaster.vhd:152:44
  n97_o <= '1' when n95_o = "00000000000000000000000000000000" else '0';
  -- I2CMaster.vhd:152:25
  n100_o <= "0110" when n97_o = '0' else "1100";
  -- I2CMaster.vhd:150:25
  n102_o <= n100_o when n94_o = '0' else "0100";
  -- I2CMaster.vhd:149:21
  n103_o <= state_reg when scl_low_pulse = '0' else n102_o;
  -- I2CMaster.vhd:147:21
  n105_o <= n103_o when n91_o = '0' else "1110";
  -- I2CMaster.vhd:142:17
  n107_o <= '1' when state_reg = "0101" else '0';
  -- I2CMaster.vhd:166:21
  n109_o <= state_reg when scl_high_pulse = '0' else "0111";
  -- I2CMaster.vhd:164:21
  n111_o <= n109_o when arb_error = '0' else "1110";
  -- I2CMaster.vhd:159:17
  n113_o <= '1' when state_reg = "0110" else '0';
  -- I2CMaster.vhd:173:21
  n115_o <= state_reg when scl_low_pulse = '0' else "1000";
  -- I2CMaster.vhd:170:17
  n117_o <= '1' when state_reg = "0111" else '0';
  -- I2CMaster.vhd:183:65
  n118_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- I2CMaster.vhd:183:65
  n120_o <= '1' when n118_o = "00000000000000000000000000000111" else '0';
  -- I2CMaster.vhd:183:47
  n121_o <= scl_low_pulse and n120_o;
  -- I2CMaster.vhd:183:21
  n123_o <= state_reg when n121_o = '0' else "1001";
  -- I2CMaster.vhd:181:21
  n125_o <= n123_o when arb_error = '0' else "1110";
  -- I2CMaster.vhd:177:17
  n127_o <= '1' when state_reg = "1000" else '0';
  -- I2CMaster.vhd:190:36
  n128_o <= scl_i and sda_i;
  -- I2CMaster.vhd:192:21
  n130_o <= state_reg when scl_low_pulse = '0' else "1010";
  -- I2CMaster.vhd:190:21
  n132_o <= n130_o when n128_o = '0' else "1110";
  -- I2CMaster.vhd:187:17
  n134_o <= '1' when state_reg = "1001" else '0';
  -- I2CMaster.vhd:199:62
  n135_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- I2CMaster.vhd:199:62
  n137_o <= '1' when n135_o = "00000000000000000000000000000111" else '0';
  -- I2CMaster.vhd:199:44
  n138_o <= scl_low_pulse and n137_o;
  -- I2CMaster.vhd:199:21
  n140_o <= state_reg when n138_o = '0' else "1011";
  -- I2CMaster.vhd:196:17
  n142_o <= '1' when state_reg = "1010" else '0';
  -- I2CMaster.vhd:209:43
  n143_o <= "000000000000000000000000000000" & byte_index_reg;  --  uext
  -- I2CMaster.vhd:209:43
  n144_o <= "00000000000000000000000000000" & recv_len_reg;  --  uext
  -- I2CMaster.vhd:209:43
  n145_o <= '1' when n143_o /= n144_o else '0';
  -- I2CMaster.vhd:209:25
  n148_o <= "1100" when n145_o = '0' else "1010";
  -- I2CMaster.vhd:208:21
  n149_o <= state_reg when scl_low_pulse = '0' else n148_o;
  -- I2CMaster.vhd:203:17
  n151_o <= '1' when state_reg = "1011" else '0';
  -- I2CMaster.vhd:219:21
  n153_o <= state_reg when scl_high_pulse = '0' else "1101";
  -- I2CMaster.vhd:216:17
  n155_o <= '1' when state_reg = "1100" else '0';
  -- I2CMaster.vhd:226:34
  n156_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:226:34
  n158_o <= '1' when n156_o = "00000000000000000000000111110011" else '0';
  -- I2CMaster.vhd:226:21
  n160_o <= state_reg when n158_o = '0' else "1111";
  -- I2CMaster.vhd:223:17
  n162_o <= '1' when state_reg = "1101" else '0';
  -- I2CMaster.vhd:230:17
  n164_o <= '1' when state_reg = "1110" else '0';
  -- I2CMaster.vhd:230:34
  n166_o <= '1' when state_reg = "1111" else '0';
  -- I2CMaster.vhd:230:34
  n167_o <= n164_o or n166_o;
  n168_o <= n167_o & n162_o & n155_o & n151_o & n142_o & n134_o & n127_o & n117_o & n113_o & n107_o & n90_o & n80_o & n71_o & n59_o & n54_o;
  -- I2CMaster.vhd:94:13
  with n168_o select n171_o <=
    "0000" when "100000000000000",
    n160_o when "010000000000000",
    n153_o when "001000000000000",
    n149_o when "000100000000000",
    n140_o when "000010000000000",
    n132_o when "000001000000000",
    n125_o when "000000100000000",
    n115_o when "000000010000000",
    n111_o when "000000001000000",
    n105_o when "000000000100000",
    n88_o when "000000000010000",
    n78_o when "000000000001000",
    n69_o when "000000000000100",
    n57_o when "000000000000010",
    n52_o when "000000000000001",
    "XXXX" when others;
  -- I2CMaster.vhd:93:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n174_q <= n171_o;
    end if;
  end process;
  -- I2CMaster.vhd:239:35
  n177_o <= '1' when state_reg = "1110" else '0';
  -- I2CMaster.vhd:239:20
  n178_o <= '0' when n177_o = '0' else '1';
  -- I2CMaster.vhd:243:34
  n182_o <= '1' when state_reg = "1111" else '0';
  -- I2CMaster.vhd:243:19
  n183_o <= '0' when n182_o = '0' else '1';
  -- I2CMaster.vhd:255:34
  n187_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:255:34
  n189_o <= '1' when signed (n187_o) < signed'("00000000000000000000000111110011") else '0';
  -- I2CMaster.vhd:256:48
  n190_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:256:48
  n192_o <= std_logic_vector (unsigned (n190_o) + unsigned'("00000000000000000000000000000001"));
  -- I2CMaster.vhd:256:38
  n193_o <= n192_o (8 downto 0);  --  trunc
  -- I2CMaster.vhd:255:21
  n195_o <= "000000000" when n189_o = '0' else n193_o;
  -- I2CMaster.vhd:251:17
  n197_o <= '1' when state_reg = "0010" else '0';
  -- I2CMaster.vhd:251:45
  n199_o <= '1' when state_reg = "0011" else '0';
  -- I2CMaster.vhd:251:45
  n200_o <= n197_o or n199_o;
  -- I2CMaster.vhd:251:63
  n202_o <= '1' when state_reg = "1101" else '0';
  -- I2CMaster.vhd:251:63
  n203_o <= n200_o or n202_o;
  -- I2CMaster.vhd:271:42
  n204_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:271:42
  n206_o <= '1' when signed (n204_o) < signed'("00000000000000000000000111110011") else '0';
  -- I2CMaster.vhd:272:56
  n207_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:272:56
  n209_o <= std_logic_vector (unsigned (n207_o) + unsigned'("00000000000000000000000000000001"));
  -- I2CMaster.vhd:272:46
  n210_o <= n209_o (8 downto 0);  --  trunc
  -- I2CMaster.vhd:271:29
  n211_o <= timer_reg when n206_o = '0' else n210_o;
  -- I2CMaster.vhd:268:25
  n213_o <= '1' when scl_state_reg = "01" else '0';
  -- I2CMaster.vhd:279:38
  n214_o <= not scl_i;
  -- I2CMaster.vhd:279:57
  n215_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:279:57
  n217_o <= '1' when n215_o = "00000000000000000000000111110011" else '0';
  -- I2CMaster.vhd:279:44
  n218_o <= n214_o or n217_o;
  -- I2CMaster.vhd:282:56
  n219_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:282:56
  n221_o <= std_logic_vector (unsigned (n219_o) + unsigned'("00000000000000000000000000000001"));
  -- I2CMaster.vhd:282:46
  n222_o <= n221_o (8 downto 0);  --  trunc
  -- I2CMaster.vhd:279:29
  n224_o <= n222_o when n218_o = '0' else "000000000";
  -- I2CMaster.vhd:275:25
  n226_o <= '1' when scl_state_reg = "11" else '0';
  -- I2CMaster.vhd:285:25
  n228_o <= '1' when scl_state_reg = "00" else '0';
  -- I2CMaster.vhd:285:39
  n230_o <= '1' when scl_state_reg = "10" else '0';
  -- I2CMaster.vhd:285:39
  n231_o <= n228_o or n230_o;
  n232_o <= n231_o & n226_o & n213_o;
  -- I2CMaster.vhd:267:21
  with n232_o select n235_o <=
    "000000000" when "100",
    n224_o when "010",
    n211_o when "001",
    (8 downto 0 => 'X') when others;
  -- I2CMaster.vhd:261:17
  n237_o <= '1' when state_reg = "0100" else '0';
  -- I2CMaster.vhd:261:35
  n239_o <= '1' when state_reg = "0101" else '0';
  -- I2CMaster.vhd:261:35
  n240_o <= n237_o or n239_o;
  -- I2CMaster.vhd:261:54
  n242_o <= '1' when state_reg = "0110" else '0';
  -- I2CMaster.vhd:261:54
  n243_o <= n240_o or n242_o;
  -- I2CMaster.vhd:262:47
  n245_o <= '1' when state_reg = "0111" else '0';
  -- I2CMaster.vhd:262:47
  n246_o <= n243_o or n245_o;
  -- I2CMaster.vhd:262:74
  n248_o <= '1' when state_reg = "1000" else '0';
  -- I2CMaster.vhd:262:74
  n249_o <= n246_o or n248_o;
  -- I2CMaster.vhd:263:38
  n251_o <= '1' when state_reg = "1001" else '0';
  -- I2CMaster.vhd:263:38
  n252_o <= n249_o or n251_o;
  -- I2CMaster.vhd:263:60
  n254_o <= '1' when state_reg = "1010" else '0';
  -- I2CMaster.vhd:263:60
  n255_o <= n252_o or n254_o;
  -- I2CMaster.vhd:264:37
  n257_o <= '1' when state_reg = "1011" else '0';
  -- I2CMaster.vhd:264:37
  n258_o <= n255_o or n257_o;
  -- I2CMaster.vhd:264:51
  n260_o <= '1' when state_reg = "1100" else '0';
  -- I2CMaster.vhd:264:51
  n261_o <= n258_o or n260_o;
  n262_o <= n261_o & n203_o;
  -- I2CMaster.vhd:250:13
  with n262_o select n264_o <=
    n235_o when "10",
    n195_o when "01",
    "000000000" when others;
  -- I2CMaster.vhd:249:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n267_q <= n264_o;
    end if;
  end process;
  -- I2CMaster.vhd:313:42
  n271_o <= '1' when state_reg = "0011" else '0';
  -- I2CMaster.vhd:313:74
  n272_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:313:74
  n274_o <= '1' when n272_o = "00000000000000000000000111110011" else '0';
  -- I2CMaster.vhd:313:60
  n275_o <= n271_o and n274_o;
  -- I2CMaster.vhd:313:29
  n277_o <= scl_state_reg when n275_o = '0' else "01";
  -- I2CMaster.vhd:310:25
  n279_o <= '1' when scl_state_reg = "00" else '0';
  -- I2CMaster.vhd:319:42
  n280_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:319:42
  n282_o <= '1' when n280_o = "00000000000000000000000111110011" else '0';
  -- I2CMaster.vhd:319:29
  n284_o <= scl_state_reg when n282_o = '0' else "10";
  -- I2CMaster.vhd:317:25
  n286_o <= '1' when scl_state_reg = "01" else '0';
  -- I2CMaster.vhd:325:29
  n288_o <= scl_state_reg when scl_i = '0' else "11";
  -- I2CMaster.vhd:323:25
  n290_o <= '1' when scl_state_reg = "10" else '0';
  -- I2CMaster.vhd:333:38
  n291_o <= not scl_i;
  -- I2CMaster.vhd:333:57
  n292_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:333:57
  n294_o <= '1' when n292_o = "00000000000000000000000111110011" else '0';
  -- I2CMaster.vhd:333:44
  n295_o <= n291_o or n294_o;
  -- I2CMaster.vhd:333:29
  n297_o <= scl_state_reg when n295_o = '0' else "01";
  -- I2CMaster.vhd:329:25
  n299_o <= '1' when scl_state_reg = "11" else '0';
  n300_o <= n299_o & n290_o & n286_o & n279_o;
  -- I2CMaster.vhd:309:21
  with n300_o select n302_o <=
    n297_o when "1000",
    n288_o when "0100",
    n284_o when "0010",
    n277_o when "0001",
    "XX" when others;
  -- I2CMaster.vhd:302:17
  n304_o <= '1' when state_reg = "0011" else '0';
  -- I2CMaster.vhd:302:38
  n306_o <= '1' when state_reg = "0100" else '0';
  -- I2CMaster.vhd:302:38
  n307_o <= n304_o or n306_o;
  -- I2CMaster.vhd:302:53
  n309_o <= '1' when state_reg = "0101" else '0';
  -- I2CMaster.vhd:302:53
  n310_o <= n307_o or n309_o;
  -- I2CMaster.vhd:302:72
  n312_o <= '1' when state_reg = "0110" else '0';
  -- I2CMaster.vhd:302:72
  n313_o <= n310_o or n312_o;
  -- I2CMaster.vhd:303:47
  n315_o <= '1' when state_reg = "0111" else '0';
  -- I2CMaster.vhd:303:47
  n316_o <= n313_o or n315_o;
  -- I2CMaster.vhd:303:74
  n318_o <= '1' when state_reg = "1000" else '0';
  -- I2CMaster.vhd:303:74
  n319_o <= n316_o or n318_o;
  -- I2CMaster.vhd:304:38
  n321_o <= '1' when state_reg = "1001" else '0';
  -- I2CMaster.vhd:304:38
  n322_o <= n319_o or n321_o;
  -- I2CMaster.vhd:304:60
  n324_o <= '1' when state_reg = "1010" else '0';
  -- I2CMaster.vhd:304:60
  n325_o <= n322_o or n324_o;
  -- I2CMaster.vhd:305:37
  n327_o <= '1' when state_reg = "1011" else '0';
  -- I2CMaster.vhd:305:37
  n328_o <= n325_o or n327_o;
  -- I2CMaster.vhd:305:51
  n330_o <= '1' when state_reg = "1100" else '0';
  -- I2CMaster.vhd:305:51
  n331_o <= n328_o or n330_o;
  -- I2CMaster.vhd:301:13
  with n331_o select n333_o <=
    n302_o when '1',
    "00" when others;
  -- I2CMaster.vhd:300:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n336_q <= n333_o;
    end if;
  end process;
  -- I2CMaster.vhd:347:37
  n339_o <= '1' when scl_state_reg = "01" else '0';
  -- I2CMaster.vhd:347:18
  n340_o <= '1' when n339_o = '0' else '0';
  -- I2CMaster.vhd:352:46
  n344_o <= '1' when scl_state_reg = "01" else '0';
  -- I2CMaster.vhd:352:71
  n345_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:352:71
  n347_o <= '1' when n345_o = "00000000000000000000000011111001" else '0';
  -- I2CMaster.vhd:352:57
  n348_o <= n344_o and n347_o;
  -- I2CMaster.vhd:352:27
  n349_o <= '0' when n348_o = '0' else '1';
  -- I2CMaster.vhd:353:46
  n353_o <= '1' when scl_state_reg = "11" else '0';
  -- I2CMaster.vhd:353:71
  n354_o <= "00000000000000000000000" & timer_reg;  --  uext
  -- I2CMaster.vhd:353:71
  n356_o <= '1' when n354_o = "00000000000000000000000011111001" else '0';
  -- I2CMaster.vhd:353:57
  n357_o <= n353_o and n356_o;
  -- I2CMaster.vhd:353:27
  n358_o <= '0' when n357_o = '0' else '1';
  -- I2CMaster.vhd:360:17
  n362_o <= '1' when state_reg = "0011" else '0';
  -- I2CMaster.vhd:360:38
  n364_o <= '1' when state_reg = "0111" else '0';
  -- I2CMaster.vhd:360:38
  n365_o <= n362_o or n364_o;
  -- I2CMaster.vhd:360:65
  n367_o <= '1' when state_reg = "1011" else '0';
  -- I2CMaster.vhd:360:65
  n368_o <= n365_o or n367_o;
  -- I2CMaster.vhd:360:79
  n370_o <= '1' when state_reg = "1100" else '0';
  -- I2CMaster.vhd:360:79
  n371_o <= n368_o or n370_o;
  -- I2CMaster.vhd:360:106
  n373_o <= '1' when state_reg = "1101" else '0';
  -- I2CMaster.vhd:360:106
  n374_o <= n371_o or n373_o;
  -- I2CMaster.vhd:361:23
  n375_o <= buffer_reg (39);
  -- I2CMaster.vhd:361:40
  n377_o <= '1' when state_reg = "0100" else '0';
  -- I2CMaster.vhd:361:58
  n379_o <= '1' when state_reg = "1000" else '0';
  -- I2CMaster.vhd:361:58
  n380_o <= n377_o or n379_o;
  n382_o <= n380_o & n374_o;
  -- I2CMaster.vhd:358:5
  with n382_o select n383_o <=
    n375_o when "10",
    '0' when "01",
    '1' when others;
  -- I2CMaster.vhd:367:49
  n385_o <= '1' when sda_i /= sda_o else '0';
  -- I2CMaster.vhd:367:39
  n386_o <= scl_i and n385_o;
  -- I2CMaster.vhd:367:22
  n387_o <= '0' when n386_o = '0' else '1';
  -- I2CMaster.vhd:381:41
  n392_o <= "00000000000000000000000000000" & send_len_reg;  --  uext
  -- I2CMaster.vhd:381:41
  n394_o <= '1' when n392_o = "00000000000000000000000000000000" else '0';
  -- I2CMaster.vhd:381:25
  n397_o <= '0' when n394_o = '0' else '1';
  -- I2CMaster.vhd:386:57
  n398_o <= slave_address_reg & n397_o;
  -- I2CMaster.vhd:386:62
  n399_o <= n398_o & wrap_wdata_i;
  -- I2CMaster.vhd:380:21
  n400_o <= buffer_reg when start = '0' else n399_o;
  -- I2CMaster.vhd:376:17
  n403_o <= '1' when state_reg = "0000" else '0';
  -- I2CMaster.vhd:392:91
  n405_o <= slave_address_reg & '1';
  -- I2CMaster.vhd:389:17
  n407_o <= '1' when state_reg = "0111" else '0';
  -- I2CMaster.vhd:398:49
  n408_o <= buffer_reg (38 downto 0);
  -- I2CMaster.vhd:398:75
  n410_o <= n408_o & '0';
  -- I2CMaster.vhd:397:21
  n411_o <= buffer_reg when scl_low_pulse = '0' else n410_o;
  -- I2CMaster.vhd:394:17
  n413_o <= '1' when state_reg = "0100" else '0';
  -- I2CMaster.vhd:394:35
  n415_o <= '1' when state_reg = "1000" else '0';
  -- I2CMaster.vhd:394:35
  n416_o <= n413_o or n415_o;
  -- I2CMaster.vhd:406:49
  n417_o <= buffer_reg (38 downto 0);
  -- I2CMaster.vhd:406:75
  n418_o <= n417_o & sda_i;
  -- I2CMaster.vhd:405:21
  n419_o <= buffer_reg when scl_high_pulse = '0' else n418_o;
  -- I2CMaster.vhd:401:17
  n421_o <= '1' when state_reg = "1010" else '0';
  n422_o <= n421_o & n416_o & n407_o & n403_o;
  n423_o <= n400_o (31 downto 0);
  n424_o <= n411_o (31 downto 0);
  n425_o <= n419_o (31 downto 0);
  n426_o <= buffer_reg (31 downto 0);
  -- I2CMaster.vhd:375:13
  with n422_o select n427_o <=
    n425_o when "1000",
    n424_o when "0100",
    n426_o when "0010",
    n423_o when "0001",
    n426_o when others;
  n428_o <= n400_o (39 downto 32);
  n429_o <= n411_o (39 downto 32);
  n430_o <= n419_o (39 downto 32);
  n431_o <= buffer_reg (39 downto 32);
  -- I2CMaster.vhd:375:13
  with n422_o select n432_o <=
    n430_o when "1000",
    n429_o when "0100",
    n405_o when "0010",
    n428_o when "0001",
    n431_o when others;
  n434_o <= n432_o & n427_o;
  -- I2CMaster.vhd:374:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n438_q <= n434_o;
    end if;
  end process;
  -- I2CMaster.vhd:419:17
  n443_o <= '1' when state_reg = "0000" else '0';
  -- I2CMaster.vhd:427:42
  n444_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- I2CMaster.vhd:427:42
  n446_o <= '1' when n444_o /= "00000000000000000000000000000111" else '0';
  -- I2CMaster.vhd:428:60
  n447_o <= "00000000000000000000000000000" & bit_index_reg;  --  uext
  -- I2CMaster.vhd:428:60
  n449_o <= std_logic_vector (unsigned (n447_o) + unsigned'("00000000000000000000000000000001"));
  -- I2CMaster.vhd:428:46
  n450_o <= n449_o (2 downto 0);  --  trunc
  -- I2CMaster.vhd:427:25
  n452_o <= "000" when n446_o = '0' else n450_o;
  -- I2CMaster.vhd:426:21
  n453_o <= bit_index_reg when scl_low_pulse = '0' else n452_o;
  -- I2CMaster.vhd:423:17
  n455_o <= '1' when state_reg = "0100" else '0';
  -- I2CMaster.vhd:423:35
  n457_o <= '1' when state_reg = "1000" else '0';
  -- I2CMaster.vhd:423:35
  n458_o <= n455_o or n457_o;
  -- I2CMaster.vhd:423:53
  n460_o <= '1' when state_reg = "1010" else '0';
  -- I2CMaster.vhd:423:53
  n461_o <= n458_o or n460_o;
  -- I2CMaster.vhd:437:63
  n462_o <= "000000000000000000000000000000" & byte_index_reg;  --  uext
  -- I2CMaster.vhd:437:63
  n463_o <= "00000000000000000000000000000" & send_len_reg;  --  uext
  -- I2CMaster.vhd:437:63
  n464_o <= '1' when n462_o /= n463_o else '0';
  -- I2CMaster.vhd:437:44
  n465_o <= scl_low_pulse and n464_o;
  -- I2CMaster.vhd:438:58
  n466_o <= "000000000000000000000000000000" & byte_index_reg;  --  uext
  -- I2CMaster.vhd:438:58
  n468_o <= std_logic_vector (unsigned (n466_o) + unsigned'("00000000000000000000000000000001"));
  -- I2CMaster.vhd:438:43
  n469_o <= n468_o (1 downto 0);  --  trunc
  -- I2CMaster.vhd:437:21
  n470_o <= byte_index_reg when n465_o = '0' else n469_o;
  -- I2CMaster.vhd:434:17
  n472_o <= '1' when state_reg = "0101" else '0';
  -- I2CMaster.vhd:434:39
  n474_o <= '1' when state_reg = "1001" else '0';
  -- I2CMaster.vhd:434:39
  n475_o <= n472_o or n474_o;
  -- I2CMaster.vhd:441:17
  n477_o <= '1' when state_reg = "0110" else '0';
  -- I2CMaster.vhd:448:63
  n478_o <= "000000000000000000000000000000" & byte_index_reg;  --  uext
  -- I2CMaster.vhd:448:63
  n479_o <= "00000000000000000000000000000" & recv_len_reg;  --  uext
  -- I2CMaster.vhd:448:63
  n480_o <= '1' when n478_o /= n479_o else '0';
  -- I2CMaster.vhd:448:44
  n481_o <= scl_low_pulse and n480_o;
  -- I2CMaster.vhd:449:58
  n482_o <= "000000000000000000000000000000" & byte_index_reg;  --  uext
  -- I2CMaster.vhd:449:58
  n484_o <= std_logic_vector (unsigned (n482_o) + unsigned'("00000000000000000000000000000001"));
  -- I2CMaster.vhd:449:43
  n485_o <= n484_o (1 downto 0);  --  trunc
  -- I2CMaster.vhd:448:21
  n486_o <= byte_index_reg when n481_o = '0' else n485_o;
  -- I2CMaster.vhd:445:17
  n488_o <= '1' when state_reg = "1011" else '0';
  n489_o <= n488_o & n477_o & n475_o & n461_o & n443_o;
  -- I2CMaster.vhd:418:13
  with n489_o select n491_o <=
    bit_index_reg when "10000",
    bit_index_reg when "01000",
    bit_index_reg when "00100",
    n453_o when "00010",
    "000" when "00001",
    bit_index_reg when others;
  -- I2CMaster.vhd:418:13
  with n489_o select n494_o <=
    n486_o when "10000",
    "00" when "01000",
    n470_o when "00100",
    byte_index_reg when "00010",
    "00" when "00001",
    byte_index_reg when others;
  -- I2CMaster.vhd:417:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n498_q <= n491_o;
    end if;
  end process;
  -- I2CMaster.vhd:417:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n499_q <= n494_o;
    end if;
  end process;
end rtl;

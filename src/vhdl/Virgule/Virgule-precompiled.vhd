library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.virgule_pkg.all;
entity Virgule is
  port (
    clk_i: in std_logic;
    reset_i: in std_logic;
    address_o: out word_t;
    data_i: in word_t;
    data_o: out word_t;
    write_o: out std_logic;
    select_o: out std_logic_vector (3 downto 0);
    done_i: in std_logic;
    irq_i: in std_logic
  );
end Virgule;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vloadstoreunit is
  port (
    enable_i : in std_logic;
    funct3_i : in std_logic_vector (2 downto 0);
    store_data_i : in std_logic_vector (31 downto 0);
    address_i : in std_logic_vector (31 downto 0);
    bus_data_i : in std_logic_vector (31 downto 0);
    load_data_o : out std_logic_vector (31 downto 0);
    bus_data_o : out std_logic_vector (31 downto 0);
    select_o : out std_logic_vector (3 downto 0));
end entity vloadstoreunit;

architecture rtl of vloadstoreunit is
  signal align : std_logic_vector (1 downto 0);
  signal aligned_data : std_logic_vector (31 downto 0);
  signal size : std_logic_vector (2 downto 0);
  signal n898_o : std_logic_vector (7 downto 0);
  signal n899_o : std_logic_vector (15 downto 0);
  signal n901_o : std_logic_vector (1 downto 0);
  signal n907_o : std_logic_vector (31 downto 0);
  signal n909_o : std_logic_vector (31 downto 0);
  signal n910_o : std_logic_vector (30 downto 0);
  signal n911_o : std_logic_vector (31 downto 0);
  signal n914_o : std_logic;
  signal n916_o : std_logic;
  signal n917_o : std_logic;
  signal n920_o : std_logic;
  signal n922_o : std_logic;
  signal n923_o : std_logic;
  signal n926_o : std_logic;
  signal n928_o : std_logic_vector (2 downto 0);
  signal n929_o : std_logic_vector (2 downto 0);
  signal n931_o : std_logic_vector (31 downto 0);
  signal n933_o : std_logic;
  signal n934_o : std_logic;
  signal n935_o : std_logic_vector (31 downto 0);
  signal n936_o : std_logic_vector (31 downto 0);
  signal n937_o : std_logic_vector (31 downto 0);
  signal n939_o : std_logic;
  signal n940_o : std_logic;
  signal n941_o : std_logic;
  signal n944_o : std_logic_vector (31 downto 0);
  signal n946_o : std_logic;
  signal n947_o : std_logic;
  signal n948_o : std_logic_vector (31 downto 0);
  signal n949_o : std_logic_vector (31 downto 0);
  signal n950_o : std_logic_vector (31 downto 0);
  signal n952_o : std_logic;
  signal n953_o : std_logic;
  signal n954_o : std_logic;
  signal n957_o : std_logic_vector (31 downto 0);
  signal n959_o : std_logic;
  signal n960_o : std_logic;
  signal n961_o : std_logic_vector (31 downto 0);
  signal n962_o : std_logic_vector (31 downto 0);
  signal n963_o : std_logic_vector (31 downto 0);
  signal n965_o : std_logic;
  signal n966_o : std_logic;
  signal n967_o : std_logic;
  signal n970_o : std_logic_vector (31 downto 0);
  signal n972_o : std_logic;
  signal n973_o : std_logic;
  signal n974_o : std_logic_vector (31 downto 0);
  signal n975_o : std_logic_vector (31 downto 0);
  signal n976_o : std_logic_vector (31 downto 0);
  signal n978_o : std_logic;
  signal n979_o : std_logic;
  signal n980_o : std_logic;
  signal n982_o : std_logic_vector (15 downto 0);
  signal n983_o : std_logic_vector (23 downto 0);
  signal n984_o : std_logic_vector (31 downto 0);
  signal n986_o : std_logic;
  signal n987_o : std_logic_vector (31 downto 0);
  signal n989_o : std_logic;
  signal n990_o : std_logic_vector (1 downto 0);
  signal n991_o : std_logic_vector (31 downto 0);
  signal n997_o : std_logic_vector (7 downto 0);
  signal n998_o : std_logic_vector (31 downto 0);
  signal n1000_o : std_logic;
  signal n1006_o : std_logic_vector (15 downto 0);
  signal n1007_o : std_logic_vector (31 downto 0);
  signal n1009_o : std_logic;
  signal n1015_o : std_logic_vector (7 downto 0);
  signal n1016_o : std_logic_vector (31 downto 0);
  signal n1018_o : std_logic;
  signal n1024_o : std_logic_vector (15 downto 0);
  signal n1025_o : std_logic_vector (31 downto 0);
  signal n1027_o : std_logic;
  signal n1028_o : std_logic_vector (3 downto 0);
  signal n1029_o : std_logic_vector (31 downto 0);
  signal n1030_o : std_logic_vector (3 downto 0);
begin
  load_data_o <= n1029_o;
  bus_data_o <= n991_o;
  select_o <= n1030_o;
  -- VLoadStoreUnit.vhd:23:12
  align <= n901_o; -- (signal)
  -- VLoadStoreUnit.vhd:24:12
  aligned_data <= n911_o; -- (signal)
  -- VLoadStoreUnit.vhd:25:12
  size <= n929_o; -- (signal)
  n898_o <= store_data_i (7 downto 0);
  n899_o <= store_data_i (15 downto 0);
  -- VLoadStoreUnit.vhd:32:41
  n901_o <= address_i (1 downto 0);
  -- VLoadStoreUnit.vhd:33:68
  n907_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:33:68
  n909_o <= std_logic_vector (resize (signed (n907_o) * signed'("00000000000000000000000000001000"), 32));
  -- VLoadStoreUnit.vhd:33:62
  n910_o <= n909_o (30 downto 0);  --  trunc
  -- VLoadStoreUnit.vhd:33:28
  n911_o <= std_logic_vector (shift_right (unsigned (bus_data_i), to_integer(unsigned (n910_o))));
  -- VLoadStoreUnit.vhd:36:19
  n914_o <= '1' when funct3_i = "000" else '0';
  -- VLoadStoreUnit.vhd:36:33
  n916_o <= '1' when funct3_i = "100" else '0';
  -- VLoadStoreUnit.vhd:36:33
  n917_o <= n914_o or n916_o;
  -- VLoadStoreUnit.vhd:37:19
  n920_o <= '1' when funct3_i = "001" else '0';
  -- VLoadStoreUnit.vhd:37:33
  n922_o <= '1' when funct3_i = "101" else '0';
  -- VLoadStoreUnit.vhd:37:33
  n923_o <= n920_o or n922_o;
  -- VLoadStoreUnit.vhd:38:19
  n926_o <= '1' when funct3_i = "010" else '0';
  n928_o <= n926_o & n923_o & n917_o;
  -- VLoadStoreUnit.vhd:35:5
  with n928_o select n929_o <=
    "100" when "100",
    "010" when "010",
    "001" when "001",
    "000" when others;
  -- VLoadStoreUnit.vhd:42:48
  n931_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:48
  n933_o <= '1' when signed'("00000000000000000000000000000011") >= signed (n931_o) else '0';
  -- VLoadStoreUnit.vhd:42:42
  n934_o <= enable_i and n933_o;
  -- VLoadStoreUnit.vhd:42:71
  n935_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n936_o <= "00000000000000000000000000000" & size;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n937_o <= std_logic_vector (unsigned (n935_o) + unsigned (n936_o));
  -- VLoadStoreUnit.vhd:42:63
  n939_o <= '1' when signed'("00000000000000000000000000000011") < signed (n937_o) else '0';
  -- VLoadStoreUnit.vhd:42:57
  n940_o <= n934_o and n939_o;
  -- VLoadStoreUnit.vhd:42:28
  n941_o <= '0' when n940_o = '0' else '1';
  -- VLoadStoreUnit.vhd:42:48
  n944_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:48
  n946_o <= '1' when signed'("00000000000000000000000000000010") >= signed (n944_o) else '0';
  -- VLoadStoreUnit.vhd:42:42
  n947_o <= enable_i and n946_o;
  -- VLoadStoreUnit.vhd:42:71
  n948_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n949_o <= "00000000000000000000000000000" & size;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n950_o <= std_logic_vector (unsigned (n948_o) + unsigned (n949_o));
  -- VLoadStoreUnit.vhd:42:63
  n952_o <= '1' when signed'("00000000000000000000000000000010") < signed (n950_o) else '0';
  -- VLoadStoreUnit.vhd:42:57
  n953_o <= n947_o and n952_o;
  -- VLoadStoreUnit.vhd:42:28
  n954_o <= '0' when n953_o = '0' else '1';
  -- VLoadStoreUnit.vhd:42:48
  n957_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:48
  n959_o <= '1' when signed'("00000000000000000000000000000001") >= signed (n957_o) else '0';
  -- VLoadStoreUnit.vhd:42:42
  n960_o <= enable_i and n959_o;
  -- VLoadStoreUnit.vhd:42:71
  n961_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n962_o <= "00000000000000000000000000000" & size;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n963_o <= std_logic_vector (unsigned (n961_o) + unsigned (n962_o));
  -- VLoadStoreUnit.vhd:42:63
  n965_o <= '1' when signed'("00000000000000000000000000000001") < signed (n963_o) else '0';
  -- VLoadStoreUnit.vhd:42:57
  n966_o <= n960_o and n965_o;
  -- VLoadStoreUnit.vhd:42:28
  n967_o <= '0' when n966_o = '0' else '1';
  -- VLoadStoreUnit.vhd:42:48
  n970_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:48
  n972_o <= '1' when signed'("00000000000000000000000000000000") >= signed (n970_o) else '0';
  -- VLoadStoreUnit.vhd:42:42
  n973_o <= enable_i and n972_o;
  -- VLoadStoreUnit.vhd:42:71
  n974_o <= "000000000000000000000000000000" & align;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n975_o <= "00000000000000000000000000000" & size;  --  uext
  -- VLoadStoreUnit.vhd:42:71
  n976_o <= std_logic_vector (unsigned (n974_o) + unsigned (n975_o));
  -- VLoadStoreUnit.vhd:42:63
  n978_o <= '1' when signed'("00000000000000000000000000000000") < signed (n976_o) else '0';
  -- VLoadStoreUnit.vhd:42:57
  n979_o <= n973_o and n978_o;
  -- VLoadStoreUnit.vhd:42:28
  n980_o <= '0' when n979_o = '0' else '1';
  -- VLoadStoreUnit.vhd:46:34
  n982_o <= n898_o & n898_o;
  -- VLoadStoreUnit.vhd:46:47
  n983_o <= n982_o & n898_o;
  -- VLoadStoreUnit.vhd:46:60
  n984_o <= n983_o & n898_o;
  -- VLoadStoreUnit.vhd:46:73
  n986_o <= '1' when funct3_i = "000" else '0';
  -- VLoadStoreUnit.vhd:47:47
  n987_o <= n899_o & n899_o;
  -- VLoadStoreUnit.vhd:47:73
  n989_o <= '1' when funct3_i = "001" else '0';
  n990_o <= n989_o & n986_o;
  -- VLoadStoreUnit.vhd:45:5
  with n990_o select n991_o <=
    n987_o when "10",
    n984_o when "01",
    store_data_i when others;
  n997_o <= aligned_data (7 downto 0);
  -- Virgule_pkg.vhd:54:23
  n998_o <= std_logic_vector (resize (signed (n997_o), 32));  --  sext
  -- VLoadStoreUnit.vhd:51:52
  n1000_o <= '1' when funct3_i = "000" else '0';
  n1006_o <= aligned_data (15 downto 0);
  -- Virgule_pkg.vhd:54:23
  n1007_o <= std_logic_vector (resize (signed (n1006_o), 32));  --  sext
  -- VLoadStoreUnit.vhd:52:52
  n1009_o <= '1' when funct3_i = "001" else '0';
  n1015_o <= aligned_data (7 downto 0);
  -- Virgule_pkg.vhd:44:23
  n1016_o <= "000000000000000000000000" & n1015_o;  --  uext
  -- VLoadStoreUnit.vhd:53:52
  n1018_o <= '1' when funct3_i = "100" else '0';
  n1024_o <= aligned_data (15 downto 0);
  -- Virgule_pkg.vhd:44:23
  n1025_o <= "0000000000000000" & n1024_o;  --  uext
  -- VLoadStoreUnit.vhd:54:52
  n1027_o <= '1' when funct3_i = "101" else '0';
  n1028_o <= n1027_o & n1018_o & n1009_o & n1000_o;
  -- VLoadStoreUnit.vhd:50:5
  with n1028_o select n1029_o <=
    n1025_o when "1000",
    n1016_o when "0100",
    n1007_o when "0010",
    n998_o when "0001",
    bus_data_i when others;
  n1030_o <= n941_o & n954_o & n967_o & n980_o;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vbranchunit is
  port (
    clk_i : in std_logic;
    reset_i : in std_logic;
    enable_i : in std_logic;
    irq_i : in std_logic;
    is_jump_i : in std_logic;
    is_branch_i : in std_logic;
    is_mret_i : in std_logic;
    taken_i : in std_logic;
    branch_address_i : in std_logic_vector (31 downto 0);
    pc_next_i : in std_logic_vector (31 downto 0);
    pc_o : out std_logic_vector (31 downto 0);
    will_jump_o : out std_logic);
end entity vbranchunit;

architecture rtl of vbranchunit is
  signal mepc_reg : std_logic_vector (31 downto 0);
  signal pc_target : std_logic_vector (31 downto 0);
  signal irq_state_reg : std_logic;
  signal accept_irq : std_logic;
  signal n856_o : std_logic_vector (31 downto 0);
  signal n857_o : std_logic_vector (29 downto 0);
  signal n859_o : std_logic_vector (31 downto 0);
  signal n860_o : std_logic_vector (31 downto 0);
  signal n861_o : std_logic_vector (29 downto 0);
  signal n863_o : std_logic_vector (31 downto 0);
  signal n864_o : std_logic;
  signal n865_o : std_logic_vector (31 downto 0);
  signal n869_o : std_logic;
  signal n871_o : std_logic;
  signal n872_o : std_logic;
  signal n874_o : std_logic;
  signal n877_q : std_logic;
  signal n878_o : std_logic;
  signal n879_o : std_logic;
  signal n882_o : std_logic;
  signal n883_o : std_logic_vector (31 downto 0);
  signal n885_o : std_logic_vector (31 downto 0);
  signal n888_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n890_o : std_logic_vector (31 downto 0);
  signal n891_o : std_logic;
  signal n892_o : std_logic;
  signal n893_o : std_logic;
  signal n894_o : std_logic;
begin
  pc_o <= n890_o;
  will_jump_o <= n894_o;
  -- VBranchUnit.vhd:27:12
  mepc_reg <= n888_q; -- (isignal)
  -- VBranchUnit.vhd:28:12
  pc_target <= n856_o; -- (signal)
  -- VBranchUnit.vhd:29:12
  irq_state_reg <= n877_q; -- (signal)
  -- VBranchUnit.vhd:30:12
  accept_irq <= n879_o; -- (signal)
  -- VBranchUnit.vhd:32:55
  n856_o <= n860_o when is_mret_i = '0' else mepc_reg;
  -- VBranchUnit.vhd:33:34
  n857_o <= branch_address_i (31 downto 2);
  -- VBranchUnit.vhd:33:48
  n859_o <= n857_o & "00";
  -- VBranchUnit.vhd:32:84
  n860_o <= n865_o when is_jump_i = '0' else n859_o;
  -- VBranchUnit.vhd:34:34
  n861_o <= branch_address_i (31 downto 2);
  -- VBranchUnit.vhd:34:48
  n863_o <= n861_o & "00";
  -- VBranchUnit.vhd:34:72
  n864_o <= is_branch_i and taken_i;
  -- VBranchUnit.vhd:33:84
  n865_o <= pc_next_i when n864_o = '0' else n863_o;
  -- VBranchUnit.vhd:45:17
  n869_o <= irq_state_reg when irq_i = '0' else '1';
  -- VBranchUnit.vhd:43:17
  n871_o <= n869_o when is_mret_i = '0' else '0';
  -- VBranchUnit.vhd:42:13
  n872_o <= irq_state_reg when enable_i = '0' else n871_o;
  -- VBranchUnit.vhd:40:13
  n874_o <= n872_o when reset_i = '0' else '0';
  -- VBranchUnit.vhd:39:9
  process (clk_i)
  begin
    if rising_edge (clk_i) then
      n877_q <= n874_o;
    end if;
  end process;
  -- VBranchUnit.vhd:52:35
  n878_o <= not irq_state_reg;
  -- VBranchUnit.vhd:52:31
  n879_o <= irq_i and n878_o;
  -- VBranchUnit.vhd:59:28
  n882_o <= enable_i and accept_irq;
  -- VBranchUnit.vhd:59:13
  n883_o <= mepc_reg when n882_o = '0' else pc_target;
  -- VBranchUnit.vhd:57:13
  n885_o <= n883_o when reset_i = '0' else "00000000000000000000000000000000";
  -- VBranchUnit.vhd:56:9
  process (clk_i)
  begin
    if rising_edge (clk_i) then
      n888_q <= n885_o;
    end if;
  end process;
  -- VBranchUnit.vhd:65:24
  n890_o <= pc_target when accept_irq = '0' else "00000000000000000000000000000100";
  -- VBranchUnit.vhd:67:31
  n891_o <= accept_irq or is_jump_i;
  -- VBranchUnit.vhd:67:44
  n892_o <= n891_o or is_mret_i;
  -- VBranchUnit.vhd:67:73
  n893_o <= is_branch_i and taken_i;
  -- VBranchUnit.vhd:67:57
  n894_o <= n892_o or n893_o;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vcomparator is
  port (
    funct3_i : in std_logic_vector (2 downto 0);
    a_i : in std_logic_vector (31 downto 0);
    b_i : in std_logic_vector (31 downto 0);
    r_o : out std_logic);
end entity vcomparator;

architecture rtl of vcomparator is
  signal n833_o : std_logic;
  signal n835_o : std_logic;
  signal n836_o : std_logic;
  signal n838_o : std_logic;
  signal n839_o : std_logic;
  signal n841_o : std_logic;
  signal n842_o : std_logic;
  signal n844_o : std_logic;
  signal n845_o : std_logic;
  signal n847_o : std_logic;
  signal n848_o : std_logic;
  signal n850_o : std_logic;
  signal n852_o : std_logic_vector (5 downto 0);
  signal n853_o : std_logic;
begin
  r_o <= n853_o;
  -- VComparator.vhd:21:30
  n833_o <= '1' when a_i = b_i else '0';
  -- VComparator.vhd:21:47
  n835_o <= '1' when funct3_i = "000" else '0';
  -- VComparator.vhd:22:30
  n836_o <= '1' when a_i /= b_i else '0';
  -- VComparator.vhd:22:47
  n838_o <= '1' when funct3_i = "001" else '0';
  -- VComparator.vhd:23:30
  n839_o <= '1' when signed (a_i) < signed (b_i) else '0';
  -- VComparator.vhd:23:47
  n841_o <= '1' when funct3_i = "100" else '0';
  -- VComparator.vhd:24:30
  n842_o <= '1' when signed (a_i) >= signed (b_i) else '0';
  -- VComparator.vhd:24:47
  n844_o <= '1' when funct3_i = "101" else '0';
  -- VComparator.vhd:25:30
  n845_o <= '1' when unsigned (a_i) < unsigned (b_i) else '0';
  -- VComparator.vhd:25:47
  n847_o <= '1' when funct3_i = "110" else '0';
  -- VComparator.vhd:26:30
  n848_o <= '1' when unsigned (a_i) >= unsigned (b_i) else '0';
  -- VComparator.vhd:26:47
  n850_o <= '1' when funct3_i = "111" else '0';
  n852_o <= n850_o & n847_o & n844_o & n841_o & n838_o & n835_o;
  -- VComparator.vhd:20:5
  with n852_o select n853_o <=
    n848_o when "100000",
    n845_o when "010000",
    n842_o when "001000",
    n839_o when "000100",
    n836_o when "000010",
    n833_o when "000001",
    '0' when others;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity varithmeticandlogicunit is
  port (
    fn_i : in std_logic_vector (3 downto 0);
    a_i : in std_logic_vector (31 downto 0);
    b_i : in std_logic_vector (31 downto 0);
    r_o : out std_logic_vector (31 downto 0));
end entity varithmeticandlogicunit;

architecture rtl of varithmeticandlogicunit is
  signal sa : std_logic_vector (31 downto 0);
  signal sb : std_logic_vector (31 downto 0);
  signal ua : std_logic_vector (31 downto 0);
  signal ub : std_logic_vector (31 downto 0);
  signal slt : std_logic_vector (31 downto 0);
  signal sltu : std_logic_vector (31 downto 0);
  signal sh : std_logic_vector (4 downto 0);
  signal n789_o : std_logic_vector (4 downto 0);
  signal n792_o : std_logic;
  signal n793_o : std_logic_vector (31 downto 0);
  signal n794_o : std_logic;
  signal n795_o : std_logic_vector (31 downto 0);
  signal n797_o : std_logic;
  signal n798_o : std_logic_vector (31 downto 0);
  signal n800_o : std_logic;
  signal n801_o : std_logic_vector (31 downto 0);
  signal n803_o : std_logic;
  signal n805_o : std_logic;
  signal n807_o : std_logic;
  signal n808_o : std_logic_vector (31 downto 0);
  signal n810_o : std_logic;
  signal n811_o : std_logic_vector (31 downto 0);
  signal n813_o : std_logic;
  signal n814_o : std_logic_vector (31 downto 0);
  signal n816_o : std_logic;
  signal n817_o : std_logic_vector (30 downto 0);
  signal n818_o : std_logic_vector (31 downto 0);
  signal n820_o : std_logic;
  signal n821_o : std_logic_vector (30 downto 0);
  signal n822_o : std_logic_vector (31 downto 0);
  signal n824_o : std_logic;
  signal n825_o : std_logic_vector (30 downto 0);
  signal n826_o : std_logic_vector (31 downto 0);
  signal n828_o : std_logic;
  signal n829_o : std_logic_vector (10 downto 0);
  signal n831_o : std_logic_vector (31 downto 0);
begin
  r_o <= n831_o;
  -- VArithmeticAndLogicUnit.vhd:36:12
  sa <= a_i; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:36:16
  sb <= b_i; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:37:12
  ua <= a_i; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:37:16
  ub <= b_i; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:38:12
  slt <= n793_o; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:38:17
  sltu <= n795_o; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:39:12
  sh <= n789_o; -- (signal)
  -- VArithmeticAndLogicUnit.vhd:45:34
  n789_o <= b_i (4 downto 0);
  -- VArithmeticAndLogicUnit.vhd:47:27
  n792_o <= '1' when signed (sa) < signed (sb) else '0';
  -- VArithmeticAndLogicUnit.vhd:47:19
  n793_o <= "00000000000000000000000000000000" when n792_o = '0' else "00000000000000000000000000000001";
  -- VArithmeticAndLogicUnit.vhd:48:27
  n794_o <= '1' when unsigned (ua) < unsigned (ub) else '0';
  -- VArithmeticAndLogicUnit.vhd:48:19
  n795_o <= "00000000000000000000000000000000" when n794_o = '0' else "00000000000000000000000000000001";
  -- VArithmeticAndLogicUnit.vhd:51:44
  n797_o <= '1' when fn_i = "0000" else '0';
  -- VArithmeticAndLogicUnit.vhd:52:26
  n798_o <= std_logic_vector (unsigned (sa) + unsigned (sb));
  -- VArithmeticAndLogicUnit.vhd:52:44
  n800_o <= '1' when fn_i = "0001" else '0';
  -- VArithmeticAndLogicUnit.vhd:53:26
  n801_o <= std_logic_vector (unsigned (sa) - unsigned (sb));
  -- VArithmeticAndLogicUnit.vhd:53:44
  n803_o <= '1' when fn_i = "0010" else '0';
  -- VArithmeticAndLogicUnit.vhd:54:44
  n805_o <= '1' when fn_i = "0011" else '0';
  -- VArithmeticAndLogicUnit.vhd:55:44
  n807_o <= '1' when fn_i = "0100" else '0';
  -- VArithmeticAndLogicUnit.vhd:56:20
  n808_o <= a_i xor b_i;
  -- VArithmeticAndLogicUnit.vhd:56:44
  n810_o <= '1' when fn_i = "0101" else '0';
  -- VArithmeticAndLogicUnit.vhd:57:20
  n811_o <= a_i or b_i;
  -- VArithmeticAndLogicUnit.vhd:57:44
  n813_o <= '1' when fn_i = "0110" else '0';
  -- VArithmeticAndLogicUnit.vhd:58:20
  n814_o <= a_i and b_i;
  -- VArithmeticAndLogicUnit.vhd:58:44
  n816_o <= '1' when fn_i = "0111" else '0';
  -- VArithmeticAndLogicUnit.vhd:59:39
  n817_o <= "00000000000000000000000000" & sh;  --  uext
  -- VArithmeticAndLogicUnit.vhd:59:23
  n818_o <= std_logic_vector (shift_left (unsigned (ua), to_integer (unsigned (n817_o))));
  -- VArithmeticAndLogicUnit.vhd:59:44
  n820_o <= '1' when fn_i = "1000" else '0';
  -- VArithmeticAndLogicUnit.vhd:60:39
  n821_o <= "00000000000000000000000000" & sh;  --  uext
  -- VArithmeticAndLogicUnit.vhd:60:23
  n822_o <= std_logic_vector (shift_right (unsigned (ua), to_integer(unsigned (n821_o))));
  -- VArithmeticAndLogicUnit.vhd:60:44
  n824_o <= '1' when fn_i = "1001" else '0';
  -- VArithmeticAndLogicUnit.vhd:61:39
  n825_o <= "00000000000000000000000000" & sh;  --  uext
  -- VArithmeticAndLogicUnit.vhd:61:23
  n826_o <= std_logic_vector (shift_right (signed (sa), to_integer (unsigned (n825_o))));
  -- VArithmeticAndLogicUnit.vhd:61:44
  n828_o <= '1' when fn_i = "1010" else '0';
  n829_o <= n828_o & n824_o & n820_o & n816_o & n813_o & n810_o & n807_o & n805_o & n803_o & n800_o & n797_o;
  -- VArithmeticAndLogicUnit.vhd:50:5
  with n829_o select n831_o <=
    n826_o when "10000000000",
    n822_o when "01000000000",
    n818_o when "00100000000",
    n814_o when "00010000000",
    n811_o when "00001000000",
    n808_o when "00000100000",
    sltu when "00000010000",
    slt when "00000001000",
    n801_o when "00000000100",
    n798_o when "00000000010",
    b_i when "00000000001",
    (31 downto 0 => 'X') when others;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vregisters is
  port (
    clk_i : in std_logic;
    reset_i : in std_logic;
    write_i : in std_logic;
    rs1_i : in std_logic_vector (4 downto 0);
    rs2_i : in std_logic_vector (4 downto 0);
    rd_i : in std_logic_vector (4 downto 0);
    xd_i : in std_logic_vector (31 downto 0);
    x1_o : out std_logic_vector (31 downto 0);
    x2_o : out std_logic_vector (31 downto 0));
end entity vregisters;

architecture rtl of vregisters is
  signal x_reg : std_logic_vector (1023 downto 0);
  signal n522_o : std_logic_vector (4 downto 0);
  signal n526_o : std_logic_vector (4 downto 0);
  signal n531_o : std_logic_vector (31 downto 0);
  signal n533_o : std_logic;
  signal n534_o : std_logic;
  signal n536_o : std_logic_vector (4 downto 0);
  signal n539_o : std_logic_vector (1023 downto 0);
  signal n541_o : std_logic_vector (1023 downto 0);
  signal n544_q : std_logic_vector (1023 downto 0);
  signal n545_o : std_logic_vector (31 downto 0);
  signal n546_o : std_logic_vector (31 downto 0);
  signal n547_o : std_logic_vector (31 downto 0);
  signal n548_o : std_logic_vector (31 downto 0);
  signal n549_o : std_logic_vector (31 downto 0);
  signal n550_o : std_logic_vector (31 downto 0);
  signal n551_o : std_logic_vector (31 downto 0);
  signal n552_o : std_logic_vector (31 downto 0);
  signal n553_o : std_logic_vector (31 downto 0);
  signal n554_o : std_logic_vector (31 downto 0);
  signal n555_o : std_logic_vector (31 downto 0);
  signal n556_o : std_logic_vector (31 downto 0);
  signal n557_o : std_logic_vector (31 downto 0);
  signal n558_o : std_logic_vector (31 downto 0);
  signal n559_o : std_logic_vector (31 downto 0);
  signal n560_o : std_logic_vector (31 downto 0);
  signal n561_o : std_logic_vector (31 downto 0);
  signal n562_o : std_logic_vector (31 downto 0);
  signal n563_o : std_logic_vector (31 downto 0);
  signal n564_o : std_logic_vector (31 downto 0);
  signal n565_o : std_logic_vector (31 downto 0);
  signal n566_o : std_logic_vector (31 downto 0);
  signal n567_o : std_logic_vector (31 downto 0);
  signal n568_o : std_logic_vector (31 downto 0);
  signal n569_o : std_logic_vector (31 downto 0);
  signal n570_o : std_logic_vector (31 downto 0);
  signal n571_o : std_logic_vector (31 downto 0);
  signal n572_o : std_logic_vector (31 downto 0);
  signal n573_o : std_logic_vector (31 downto 0);
  signal n574_o : std_logic_vector (31 downto 0);
  signal n575_o : std_logic_vector (31 downto 0);
  signal n576_o : std_logic_vector (31 downto 0);
  signal n577_o : std_logic_vector (1 downto 0);
  signal n578_o : std_logic_vector (31 downto 0);
  signal n579_o : std_logic_vector (1 downto 0);
  signal n580_o : std_logic_vector (31 downto 0);
  signal n581_o : std_logic_vector (1 downto 0);
  signal n582_o : std_logic_vector (31 downto 0);
  signal n583_o : std_logic_vector (1 downto 0);
  signal n584_o : std_logic_vector (31 downto 0);
  signal n585_o : std_logic_vector (1 downto 0);
  signal n586_o : std_logic_vector (31 downto 0);
  signal n587_o : std_logic_vector (1 downto 0);
  signal n588_o : std_logic_vector (31 downto 0);
  signal n589_o : std_logic_vector (1 downto 0);
  signal n590_o : std_logic_vector (31 downto 0);
  signal n591_o : std_logic_vector (1 downto 0);
  signal n592_o : std_logic_vector (31 downto 0);
  signal n593_o : std_logic_vector (1 downto 0);
  signal n594_o : std_logic_vector (31 downto 0);
  signal n595_o : std_logic_vector (1 downto 0);
  signal n596_o : std_logic_vector (31 downto 0);
  signal n597_o : std_logic;
  signal n598_o : std_logic_vector (31 downto 0);
  signal n599_o : std_logic_vector (31 downto 0);
  signal n600_o : std_logic_vector (31 downto 0);
  signal n601_o : std_logic_vector (31 downto 0);
  signal n602_o : std_logic_vector (31 downto 0);
  signal n603_o : std_logic_vector (31 downto 0);
  signal n604_o : std_logic_vector (31 downto 0);
  signal n605_o : std_logic_vector (31 downto 0);
  signal n606_o : std_logic_vector (31 downto 0);
  signal n607_o : std_logic_vector (31 downto 0);
  signal n608_o : std_logic_vector (31 downto 0);
  signal n609_o : std_logic_vector (31 downto 0);
  signal n610_o : std_logic_vector (31 downto 0);
  signal n611_o : std_logic_vector (31 downto 0);
  signal n612_o : std_logic_vector (31 downto 0);
  signal n613_o : std_logic_vector (31 downto 0);
  signal n614_o : std_logic_vector (31 downto 0);
  signal n615_o : std_logic_vector (31 downto 0);
  signal n616_o : std_logic_vector (31 downto 0);
  signal n617_o : std_logic_vector (31 downto 0);
  signal n618_o : std_logic_vector (31 downto 0);
  signal n619_o : std_logic_vector (31 downto 0);
  signal n620_o : std_logic_vector (31 downto 0);
  signal n621_o : std_logic_vector (31 downto 0);
  signal n622_o : std_logic_vector (31 downto 0);
  signal n623_o : std_logic_vector (31 downto 0);
  signal n624_o : std_logic_vector (31 downto 0);
  signal n625_o : std_logic_vector (31 downto 0);
  signal n626_o : std_logic_vector (31 downto 0);
  signal n627_o : std_logic_vector (31 downto 0);
  signal n628_o : std_logic_vector (31 downto 0);
  signal n629_o : std_logic_vector (31 downto 0);
  signal n630_o : std_logic_vector (31 downto 0);
  signal n631_o : std_logic_vector (1 downto 0);
  signal n632_o : std_logic_vector (31 downto 0);
  signal n633_o : std_logic_vector (1 downto 0);
  signal n634_o : std_logic_vector (31 downto 0);
  signal n635_o : std_logic_vector (1 downto 0);
  signal n636_o : std_logic_vector (31 downto 0);
  signal n637_o : std_logic_vector (1 downto 0);
  signal n638_o : std_logic_vector (31 downto 0);
  signal n639_o : std_logic_vector (1 downto 0);
  signal n640_o : std_logic_vector (31 downto 0);
  signal n641_o : std_logic_vector (1 downto 0);
  signal n642_o : std_logic_vector (31 downto 0);
  signal n643_o : std_logic_vector (1 downto 0);
  signal n644_o : std_logic_vector (31 downto 0);
  signal n645_o : std_logic_vector (1 downto 0);
  signal n646_o : std_logic_vector (31 downto 0);
  signal n647_o : std_logic_vector (1 downto 0);
  signal n648_o : std_logic_vector (31 downto 0);
  signal n649_o : std_logic_vector (1 downto 0);
  signal n650_o : std_logic_vector (31 downto 0);
  signal n651_o : std_logic;
  signal n652_o : std_logic_vector (31 downto 0);
  signal n653_o : std_logic;
  signal n654_o : std_logic;
  signal n655_o : std_logic;
  signal n656_o : std_logic;
  signal n657_o : std_logic;
  signal n658_o : std_logic;
  signal n659_o : std_logic;
  signal n660_o : std_logic;
  signal n661_o : std_logic;
  signal n662_o : std_logic;
  signal n663_o : std_logic;
  signal n664_o : std_logic;
  signal n665_o : std_logic;
  signal n666_o : std_logic;
  signal n667_o : std_logic;
  signal n668_o : std_logic;
  signal n669_o : std_logic;
  signal n670_o : std_logic;
  signal n671_o : std_logic;
  signal n672_o : std_logic;
  signal n673_o : std_logic;
  signal n674_o : std_logic;
  signal n675_o : std_logic;
  signal n676_o : std_logic;
  signal n677_o : std_logic;
  signal n678_o : std_logic;
  signal n679_o : std_logic;
  signal n680_o : std_logic;
  signal n681_o : std_logic;
  signal n682_o : std_logic;
  signal n683_o : std_logic;
  signal n684_o : std_logic;
  signal n685_o : std_logic;
  signal n686_o : std_logic;
  signal n687_o : std_logic;
  signal n688_o : std_logic;
  signal n689_o : std_logic;
  signal n690_o : std_logic;
  signal n691_o : std_logic;
  signal n692_o : std_logic;
  signal n693_o : std_logic;
  signal n694_o : std_logic;
  signal n695_o : std_logic;
  signal n696_o : std_logic;
  signal n697_o : std_logic;
  signal n698_o : std_logic;
  signal n699_o : std_logic;
  signal n700_o : std_logic;
  signal n701_o : std_logic;
  signal n702_o : std_logic;
  signal n703_o : std_logic;
  signal n704_o : std_logic;
  signal n705_o : std_logic;
  signal n706_o : std_logic;
  signal n707_o : std_logic;
  signal n708_o : std_logic;
  signal n709_o : std_logic;
  signal n710_o : std_logic;
  signal n711_o : std_logic;
  signal n712_o : std_logic;
  signal n713_o : std_logic;
  signal n714_o : std_logic;
  signal n715_o : std_logic;
  signal n716_o : std_logic;
  signal n717_o : std_logic;
  signal n718_o : std_logic;
  signal n719_o : std_logic;
  signal n720_o : std_logic;
  signal n721_o : std_logic;
  signal n722_o : std_logic;
  signal n723_o : std_logic_vector (31 downto 0);
  signal n724_o : std_logic_vector (31 downto 0);
  signal n725_o : std_logic_vector (31 downto 0);
  signal n726_o : std_logic_vector (31 downto 0);
  signal n727_o : std_logic_vector (31 downto 0);
  signal n728_o : std_logic_vector (31 downto 0);
  signal n729_o : std_logic_vector (31 downto 0);
  signal n730_o : std_logic_vector (31 downto 0);
  signal n731_o : std_logic_vector (31 downto 0);
  signal n732_o : std_logic_vector (31 downto 0);
  signal n733_o : std_logic_vector (31 downto 0);
  signal n734_o : std_logic_vector (31 downto 0);
  signal n735_o : std_logic_vector (31 downto 0);
  signal n736_o : std_logic_vector (31 downto 0);
  signal n737_o : std_logic_vector (31 downto 0);
  signal n738_o : std_logic_vector (31 downto 0);
  signal n739_o : std_logic_vector (31 downto 0);
  signal n740_o : std_logic_vector (31 downto 0);
  signal n741_o : std_logic_vector (31 downto 0);
  signal n742_o : std_logic_vector (31 downto 0);
  signal n743_o : std_logic_vector (31 downto 0);
  signal n744_o : std_logic_vector (31 downto 0);
  signal n745_o : std_logic_vector (31 downto 0);
  signal n746_o : std_logic_vector (31 downto 0);
  signal n747_o : std_logic_vector (31 downto 0);
  signal n748_o : std_logic_vector (31 downto 0);
  signal n749_o : std_logic_vector (31 downto 0);
  signal n750_o : std_logic_vector (31 downto 0);
  signal n751_o : std_logic_vector (31 downto 0);
  signal n752_o : std_logic_vector (31 downto 0);
  signal n753_o : std_logic_vector (31 downto 0);
  signal n754_o : std_logic_vector (31 downto 0);
  signal n755_o : std_logic_vector (31 downto 0);
  signal n756_o : std_logic_vector (31 downto 0);
  signal n757_o : std_logic_vector (31 downto 0);
  signal n758_o : std_logic_vector (31 downto 0);
  signal n759_o : std_logic_vector (31 downto 0);
  signal n760_o : std_logic_vector (31 downto 0);
  signal n761_o : std_logic_vector (31 downto 0);
  signal n762_o : std_logic_vector (31 downto 0);
  signal n763_o : std_logic_vector (31 downto 0);
  signal n764_o : std_logic_vector (31 downto 0);
  signal n765_o : std_logic_vector (31 downto 0);
  signal n766_o : std_logic_vector (31 downto 0);
  signal n767_o : std_logic_vector (31 downto 0);
  signal n768_o : std_logic_vector (31 downto 0);
  signal n769_o : std_logic_vector (31 downto 0);
  signal n770_o : std_logic_vector (31 downto 0);
  signal n771_o : std_logic_vector (31 downto 0);
  signal n772_o : std_logic_vector (31 downto 0);
  signal n773_o : std_logic_vector (31 downto 0);
  signal n774_o : std_logic_vector (31 downto 0);
  signal n775_o : std_logic_vector (31 downto 0);
  signal n776_o : std_logic_vector (31 downto 0);
  signal n777_o : std_logic_vector (31 downto 0);
  signal n778_o : std_logic_vector (31 downto 0);
  signal n779_o : std_logic_vector (31 downto 0);
  signal n780_o : std_logic_vector (31 downto 0);
  signal n781_o : std_logic_vector (31 downto 0);
  signal n782_o : std_logic_vector (31 downto 0);
  signal n783_o : std_logic_vector (31 downto 0);
  signal n784_o : std_logic_vector (31 downto 0);
  signal n785_o : std_logic_vector (31 downto 0);
  signal n786_o : std_logic_vector (31 downto 0);
  signal n787_o : std_logic_vector (1023 downto 0);
begin
  x1_o <= n598_o;
  x2_o <= n652_o;
  -- VRegisters.vhd:20:12
  x_reg <= n544_q; -- (signal)
  -- VRegisters.vhd:22:18
  n522_o <= std_logic_vector (unsigned'("11111") - unsigned (rs1_i));
  -- VRegisters.vhd:23:18
  n526_o <= std_logic_vector (unsigned'("11111") - unsigned (rs2_i));
  -- VRegisters.vhd:30:36
  n531_o <= "000000000000000000000000000" & rd_i;  --  uext
  -- VRegisters.vhd:30:36
  n533_o <= '1' when n531_o /= "00000000000000000000000000000000" else '0';
  -- VRegisters.vhd:30:27
  n534_o <= write_i and n533_o;
  -- VRegisters.vhd:31:22
  n536_o <= std_logic_vector (unsigned'("11111") - unsigned (rd_i));
  -- VRegisters.vhd:30:13
  n539_o <= x_reg when n534_o = '0' else n787_o;
  -- VRegisters.vhd:28:13
  n541_o <= n539_o when reset_i = '0' else "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  -- VRegisters.vhd:27:9
  process (clk_i)
  begin
    if rising_edge (clk_i) then
      n544_q <= n541_o;
    end if;
  end process;
  -- VRegisters.vhd:14:15
  n545_o <= x_reg (31 downto 0);
  -- VRegisters.vhd:14:9
  n546_o <= x_reg (63 downto 32);
  n547_o <= x_reg (95 downto 64);
  -- VRegisters.vhd:25:5
  n548_o <= x_reg (127 downto 96);
  -- VRegisters.vhd:27:9
  n549_o <= x_reg (159 downto 128);
  -- Virgule_pkg.vhd:34:14
  n550_o <= x_reg (191 downto 160);
  -- Virgule_pkg.vhd:34:14
  n551_o <= x_reg (223 downto 192);
  n552_o <= x_reg (255 downto 224);
  -- Virgule_pkg.vhd:34:14
  n553_o <= x_reg (287 downto 256);
  -- Virgule_pkg.vhd:34:14
  n554_o <= x_reg (319 downto 288);
  -- Virgule_pkg.vhd:34:14
  n555_o <= x_reg (351 downto 320);
  n556_o <= x_reg (383 downto 352);
  -- Virgule_pkg.vhd:34:14
  n557_o <= x_reg (415 downto 384);
  -- Virgule_pkg.vhd:34:14
  n558_o <= x_reg (447 downto 416);
  -- Virgule_pkg.vhd:34:14
  n559_o <= x_reg (479 downto 448);
  n560_o <= x_reg (511 downto 480);
  -- Virgule_pkg.vhd:34:14
  n561_o <= x_reg (543 downto 512);
  -- Virgule_pkg.vhd:34:14
  n562_o <= x_reg (575 downto 544);
  -- Virgule_pkg.vhd:34:14
  n563_o <= x_reg (607 downto 576);
  n564_o <= x_reg (639 downto 608);
  -- Virgule_pkg.vhd:34:14
  n565_o <= x_reg (671 downto 640);
  n566_o <= x_reg (703 downto 672);
  n567_o <= x_reg (735 downto 704);
  n568_o <= x_reg (767 downto 736);
  n569_o <= x_reg (799 downto 768);
  n570_o <= x_reg (831 downto 800);
  n571_o <= x_reg (863 downto 832);
  n572_o <= x_reg (895 downto 864);
  n573_o <= x_reg (927 downto 896);
  n574_o <= x_reg (959 downto 928);
  n575_o <= x_reg (991 downto 960);
  n576_o <= x_reg (1023 downto 992);
  -- VRegisters.vhd:22:18
  n577_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n577_o select n578_o <=
    n545_o when "00",
    n546_o when "01",
    n547_o when "10",
    n548_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n579_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n579_o select n580_o <=
    n549_o when "00",
    n550_o when "01",
    n551_o when "10",
    n552_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n581_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n581_o select n582_o <=
    n553_o when "00",
    n554_o when "01",
    n555_o when "10",
    n556_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n583_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n583_o select n584_o <=
    n557_o when "00",
    n558_o when "01",
    n559_o when "10",
    n560_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n585_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n585_o select n586_o <=
    n561_o when "00",
    n562_o when "01",
    n563_o when "10",
    n564_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n587_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n587_o select n588_o <=
    n565_o when "00",
    n566_o when "01",
    n567_o when "10",
    n568_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n589_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n589_o select n590_o <=
    n569_o when "00",
    n570_o when "01",
    n571_o when "10",
    n572_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n591_o <= n522_o (1 downto 0);
  -- VRegisters.vhd:22:18
  with n591_o select n592_o <=
    n573_o when "00",
    n574_o when "01",
    n575_o when "10",
    n576_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n593_o <= n522_o (3 downto 2);
  -- VRegisters.vhd:22:18
  with n593_o select n594_o <=
    n578_o when "00",
    n580_o when "01",
    n582_o when "10",
    n584_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n595_o <= n522_o (3 downto 2);
  -- VRegisters.vhd:22:18
  with n595_o select n596_o <=
    n586_o when "00",
    n588_o when "01",
    n590_o when "10",
    n592_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:22:18
  n597_o <= n522_o (4);
  -- VRegisters.vhd:22:18
  n598_o <= n594_o when n597_o = '0' else n596_o;
  -- VRegisters.vhd:22:19
  n599_o <= x_reg (31 downto 0);
  -- VRegisters.vhd:22:18
  n600_o <= x_reg (63 downto 32);
  n601_o <= x_reg (95 downto 64);
  n602_o <= x_reg (127 downto 96);
  n603_o <= x_reg (159 downto 128);
  n604_o <= x_reg (191 downto 160);
  n605_o <= x_reg (223 downto 192);
  n606_o <= x_reg (255 downto 224);
  n607_o <= x_reg (287 downto 256);
  n608_o <= x_reg (319 downto 288);
  n609_o <= x_reg (351 downto 320);
  n610_o <= x_reg (383 downto 352);
  n611_o <= x_reg (415 downto 384);
  n612_o <= x_reg (447 downto 416);
  n613_o <= x_reg (479 downto 448);
  n614_o <= x_reg (511 downto 480);
  n615_o <= x_reg (543 downto 512);
  n616_o <= x_reg (575 downto 544);
  n617_o <= x_reg (607 downto 576);
  n618_o <= x_reg (639 downto 608);
  n619_o <= x_reg (671 downto 640);
  n620_o <= x_reg (703 downto 672);
  n621_o <= x_reg (735 downto 704);
  n622_o <= x_reg (767 downto 736);
  n623_o <= x_reg (799 downto 768);
  n624_o <= x_reg (831 downto 800);
  n625_o <= x_reg (863 downto 832);
  n626_o <= x_reg (895 downto 864);
  n627_o <= x_reg (927 downto 896);
  n628_o <= x_reg (959 downto 928);
  n629_o <= x_reg (991 downto 960);
  n630_o <= x_reg (1023 downto 992);
  -- VRegisters.vhd:23:18
  n631_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n631_o select n632_o <=
    n599_o when "00",
    n600_o when "01",
    n601_o when "10",
    n602_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n633_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n633_o select n634_o <=
    n603_o when "00",
    n604_o when "01",
    n605_o when "10",
    n606_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n635_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n635_o select n636_o <=
    n607_o when "00",
    n608_o when "01",
    n609_o when "10",
    n610_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n637_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n637_o select n638_o <=
    n611_o when "00",
    n612_o when "01",
    n613_o when "10",
    n614_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n639_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n639_o select n640_o <=
    n615_o when "00",
    n616_o when "01",
    n617_o when "10",
    n618_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n641_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n641_o select n642_o <=
    n619_o when "00",
    n620_o when "01",
    n621_o when "10",
    n622_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n643_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n643_o select n644_o <=
    n623_o when "00",
    n624_o when "01",
    n625_o when "10",
    n626_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n645_o <= n526_o (1 downto 0);
  -- VRegisters.vhd:23:18
  with n645_o select n646_o <=
    n627_o when "00",
    n628_o when "01",
    n629_o when "10",
    n630_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n647_o <= n526_o (3 downto 2);
  -- VRegisters.vhd:23:18
  with n647_o select n648_o <=
    n632_o when "00",
    n634_o when "01",
    n636_o when "10",
    n638_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n649_o <= n526_o (3 downto 2);
  -- VRegisters.vhd:23:18
  with n649_o select n650_o <=
    n640_o when "00",
    n642_o when "01",
    n644_o when "10",
    n646_o when "11",
    (31 downto 0 => 'X') when others;
  -- VRegisters.vhd:23:18
  n651_o <= n526_o (4);
  -- VRegisters.vhd:23:18
  n652_o <= n648_o when n651_o = '0' else n650_o;
  -- VRegisters.vhd:31:17
  n653_o <= n536_o (4);
  -- VRegisters.vhd:31:17
  n654_o <= not n653_o;
  -- VRegisters.vhd:31:17
  n655_o <= n536_o (3);
  -- VRegisters.vhd:31:17
  n656_o <= not n655_o;
  -- VRegisters.vhd:31:17
  n657_o <= n654_o and n656_o;
  -- VRegisters.vhd:31:17
  n658_o <= n654_o and n655_o;
  -- VRegisters.vhd:31:17
  n659_o <= n653_o and n656_o;
  -- VRegisters.vhd:31:17
  n660_o <= n653_o and n655_o;
  -- VRegisters.vhd:31:17
  n661_o <= n536_o (2);
  -- VRegisters.vhd:31:17
  n662_o <= not n661_o;
  -- VRegisters.vhd:31:17
  n663_o <= n657_o and n662_o;
  -- VRegisters.vhd:31:17
  n664_o <= n657_o and n661_o;
  -- VRegisters.vhd:31:17
  n665_o <= n658_o and n662_o;
  -- VRegisters.vhd:31:17
  n666_o <= n658_o and n661_o;
  -- VRegisters.vhd:31:17
  n667_o <= n659_o and n662_o;
  -- VRegisters.vhd:31:17
  n668_o <= n659_o and n661_o;
  -- VRegisters.vhd:31:17
  n669_o <= n660_o and n662_o;
  -- VRegisters.vhd:31:17
  n670_o <= n660_o and n661_o;
  -- VRegisters.vhd:31:17
  n671_o <= n536_o (1);
  -- VRegisters.vhd:31:17
  n672_o <= not n671_o;
  -- VRegisters.vhd:31:17
  n673_o <= n663_o and n672_o;
  -- VRegisters.vhd:31:17
  n674_o <= n663_o and n671_o;
  -- VRegisters.vhd:31:17
  n675_o <= n664_o and n672_o;
  -- VRegisters.vhd:31:17
  n676_o <= n664_o and n671_o;
  -- VRegisters.vhd:31:17
  n677_o <= n665_o and n672_o;
  -- VRegisters.vhd:31:17
  n678_o <= n665_o and n671_o;
  -- VRegisters.vhd:31:17
  n679_o <= n666_o and n672_o;
  -- VRegisters.vhd:31:17
  n680_o <= n666_o and n671_o;
  -- VRegisters.vhd:31:17
  n681_o <= n667_o and n672_o;
  -- VRegisters.vhd:31:17
  n682_o <= n667_o and n671_o;
  -- VRegisters.vhd:31:17
  n683_o <= n668_o and n672_o;
  -- VRegisters.vhd:31:17
  n684_o <= n668_o and n671_o;
  -- VRegisters.vhd:31:17
  n685_o <= n669_o and n672_o;
  -- VRegisters.vhd:31:17
  n686_o <= n669_o and n671_o;
  -- VRegisters.vhd:31:17
  n687_o <= n670_o and n672_o;
  -- VRegisters.vhd:31:17
  n688_o <= n670_o and n671_o;
  -- VRegisters.vhd:31:17
  n689_o <= n536_o (0);
  -- VRegisters.vhd:31:17
  n690_o <= not n689_o;
  -- VRegisters.vhd:31:17
  n691_o <= n673_o and n690_o;
  -- VRegisters.vhd:31:17
  n692_o <= n673_o and n689_o;
  -- VRegisters.vhd:31:17
  n693_o <= n674_o and n690_o;
  -- VRegisters.vhd:31:17
  n694_o <= n674_o and n689_o;
  -- VRegisters.vhd:31:17
  n695_o <= n675_o and n690_o;
  -- VRegisters.vhd:31:17
  n696_o <= n675_o and n689_o;
  -- VRegisters.vhd:31:17
  n697_o <= n676_o and n690_o;
  -- VRegisters.vhd:31:17
  n698_o <= n676_o and n689_o;
  -- VRegisters.vhd:31:17
  n699_o <= n677_o and n690_o;
  -- VRegisters.vhd:31:17
  n700_o <= n677_o and n689_o;
  -- VRegisters.vhd:31:17
  n701_o <= n678_o and n690_o;
  -- VRegisters.vhd:31:17
  n702_o <= n678_o and n689_o;
  -- VRegisters.vhd:31:17
  n703_o <= n679_o and n690_o;
  -- VRegisters.vhd:31:17
  n704_o <= n679_o and n689_o;
  -- VRegisters.vhd:31:17
  n705_o <= n680_o and n690_o;
  -- VRegisters.vhd:31:17
  n706_o <= n680_o and n689_o;
  -- VRegisters.vhd:31:17
  n707_o <= n681_o and n690_o;
  -- VRegisters.vhd:31:17
  n708_o <= n681_o and n689_o;
  -- VRegisters.vhd:31:17
  n709_o <= n682_o and n690_o;
  -- VRegisters.vhd:31:17
  n710_o <= n682_o and n689_o;
  -- VRegisters.vhd:31:17
  n711_o <= n683_o and n690_o;
  -- VRegisters.vhd:31:17
  n712_o <= n683_o and n689_o;
  -- VRegisters.vhd:31:17
  n713_o <= n684_o and n690_o;
  -- VRegisters.vhd:31:17
  n714_o <= n684_o and n689_o;
  -- VRegisters.vhd:31:17
  n715_o <= n685_o and n690_o;
  -- VRegisters.vhd:31:17
  n716_o <= n685_o and n689_o;
  -- VRegisters.vhd:31:17
  n717_o <= n686_o and n690_o;
  -- VRegisters.vhd:31:17
  n718_o <= n686_o and n689_o;
  -- VRegisters.vhd:31:17
  n719_o <= n687_o and n690_o;
  -- VRegisters.vhd:31:17
  n720_o <= n687_o and n689_o;
  -- VRegisters.vhd:31:17
  n721_o <= n688_o and n690_o;
  -- VRegisters.vhd:31:17
  n722_o <= n688_o and n689_o;
  n723_o <= x_reg (31 downto 0);
  -- VRegisters.vhd:31:17
  n724_o <= n723_o when n691_o = '0' else xd_i;
  n725_o <= x_reg (63 downto 32);
  -- VRegisters.vhd:31:17
  n726_o <= n725_o when n692_o = '0' else xd_i;
  n727_o <= x_reg (95 downto 64);
  -- VRegisters.vhd:31:17
  n728_o <= n727_o when n693_o = '0' else xd_i;
  n729_o <= x_reg (127 downto 96);
  -- VRegisters.vhd:31:17
  n730_o <= n729_o when n694_o = '0' else xd_i;
  n731_o <= x_reg (159 downto 128);
  -- VRegisters.vhd:31:17
  n732_o <= n731_o when n695_o = '0' else xd_i;
  n733_o <= x_reg (191 downto 160);
  -- VRegisters.vhd:31:17
  n734_o <= n733_o when n696_o = '0' else xd_i;
  n735_o <= x_reg (223 downto 192);
  -- VRegisters.vhd:31:17
  n736_o <= n735_o when n697_o = '0' else xd_i;
  n737_o <= x_reg (255 downto 224);
  -- VRegisters.vhd:31:17
  n738_o <= n737_o when n698_o = '0' else xd_i;
  n739_o <= x_reg (287 downto 256);
  -- VRegisters.vhd:31:17
  n740_o <= n739_o when n699_o = '0' else xd_i;
  n741_o <= x_reg (319 downto 288);
  -- VRegisters.vhd:31:17
  n742_o <= n741_o when n700_o = '0' else xd_i;
  n743_o <= x_reg (351 downto 320);
  -- VRegisters.vhd:31:17
  n744_o <= n743_o when n701_o = '0' else xd_i;
  n745_o <= x_reg (383 downto 352);
  -- VRegisters.vhd:31:17
  n746_o <= n745_o when n702_o = '0' else xd_i;
  n747_o <= x_reg (415 downto 384);
  -- VRegisters.vhd:31:17
  n748_o <= n747_o when n703_o = '0' else xd_i;
  n749_o <= x_reg (447 downto 416);
  -- VRegisters.vhd:31:17
  n750_o <= n749_o when n704_o = '0' else xd_i;
  n751_o <= x_reg (479 downto 448);
  -- VRegisters.vhd:31:17
  n752_o <= n751_o when n705_o = '0' else xd_i;
  n753_o <= x_reg (511 downto 480);
  -- VRegisters.vhd:31:17
  n754_o <= n753_o when n706_o = '0' else xd_i;
  n755_o <= x_reg (543 downto 512);
  -- VRegisters.vhd:31:17
  n756_o <= n755_o when n707_o = '0' else xd_i;
  n757_o <= x_reg (575 downto 544);
  -- VRegisters.vhd:31:17
  n758_o <= n757_o when n708_o = '0' else xd_i;
  n759_o <= x_reg (607 downto 576);
  -- VRegisters.vhd:31:17
  n760_o <= n759_o when n709_o = '0' else xd_i;
  n761_o <= x_reg (639 downto 608);
  -- VRegisters.vhd:31:17
  n762_o <= n761_o when n710_o = '0' else xd_i;
  n763_o <= x_reg (671 downto 640);
  -- VRegisters.vhd:31:17
  n764_o <= n763_o when n711_o = '0' else xd_i;
  n765_o <= x_reg (703 downto 672);
  -- VRegisters.vhd:31:17
  n766_o <= n765_o when n712_o = '0' else xd_i;
  n767_o <= x_reg (735 downto 704);
  -- VRegisters.vhd:31:17
  n768_o <= n767_o when n713_o = '0' else xd_i;
  n769_o <= x_reg (767 downto 736);
  -- VRegisters.vhd:31:17
  n770_o <= n769_o when n714_o = '0' else xd_i;
  n771_o <= x_reg (799 downto 768);
  -- VRegisters.vhd:31:17
  n772_o <= n771_o when n715_o = '0' else xd_i;
  n773_o <= x_reg (831 downto 800);
  -- VRegisters.vhd:31:17
  n774_o <= n773_o when n716_o = '0' else xd_i;
  n775_o <= x_reg (863 downto 832);
  -- VRegisters.vhd:31:17
  n776_o <= n775_o when n717_o = '0' else xd_i;
  n777_o <= x_reg (895 downto 864);
  -- VRegisters.vhd:31:17
  n778_o <= n777_o when n718_o = '0' else xd_i;
  n779_o <= x_reg (927 downto 896);
  -- VRegisters.vhd:31:17
  n780_o <= n779_o when n719_o = '0' else xd_i;
  n781_o <= x_reg (959 downto 928);
  -- VRegisters.vhd:31:17
  n782_o <= n781_o when n720_o = '0' else xd_i;
  n783_o <= x_reg (991 downto 960);
  -- VRegisters.vhd:31:17
  n784_o <= n783_o when n721_o = '0' else xd_i;
  n785_o <= x_reg (1023 downto 992);
  -- VRegisters.vhd:31:17
  n786_o <= n785_o when n722_o = '0' else xd_i;
  n787_o <= n786_o & n784_o & n782_o & n780_o & n778_o & n776_o & n774_o & n772_o & n770_o & n768_o & n766_o & n764_o & n762_o & n760_o & n758_o & n756_o & n754_o & n752_o & n750_o & n748_o & n746_o & n744_o & n742_o & n740_o & n738_o & n736_o & n734_o & n732_o & n730_o & n728_o & n726_o & n724_o;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vdecoder is
  port (
    instr_i : in std_logic_vector (31 downto 0);
    instr_data_o_funct3 : out std_logic_vector (2 downto 0);
    instr_data_o_imm : out std_logic_vector (31 downto 0);
    instr_data_o_rs1 : out std_logic_vector (4 downto 0);
    instr_data_o_rs2 : out std_logic_vector (4 downto 0);
    instr_data_o_rd : out std_logic_vector (4 downto 0);
    instr_data_o_use_pc : out std_logic;
    instr_data_o_use_imm : out std_logic;
    instr_data_o_alu_fn : out std_logic_vector (3 downto 0);
    instr_data_o_is_load : out std_logic;
    instr_data_o_is_store : out std_logic;
    instr_data_o_is_mret : out std_logic;
    instr_data_o_is_jump : out std_logic;
    instr_data_o_is_branch : out std_logic;
    instr_data_o_has_rd : out std_logic;
    instr_data_o_is_invalid : out std_logic);
end entity vdecoder;

architecture rtl of vdecoder is
  signal n164_o : std_logic_vector (2 downto 0);
  signal n165_o : std_logic_vector (31 downto 0);
  signal n166_o : std_logic_vector (4 downto 0);
  signal n167_o : std_logic_vector (4 downto 0);
  signal n168_o : std_logic_vector (4 downto 0);
  signal n169_o : std_logic;
  signal n170_o : std_logic;
  signal n171_o : std_logic_vector (3 downto 0);
  signal n172_o : std_logic;
  signal n173_o : std_logic;
  signal n174_o : std_logic;
  signal n175_o : std_logic;
  signal n176_o : std_logic;
  signal n177_o : std_logic;
  signal n178_o : std_logic;
  signal n179_o : std_logic_vector (6 downto 0);
  signal n180_o : std_logic_vector (4 downto 0);
  signal n181_o : std_logic_vector (4 downto 0);
  signal n182_o : std_logic_vector (2 downto 0);
  signal n183_o : std_logic_vector (4 downto 0);
  signal n184_o : std_logic_vector (6 downto 0);
  signal n185_o : std_logic_vector (11 downto 0);
  signal n186_o : std_logic_vector (6 downto 0);
  signal n187_o : std_logic_vector (4 downto 0);
  signal n188_o : std_logic;
  signal n189_o : std_logic_vector (5 downto 0);
  signal n190_o : std_logic_vector (3 downto 0);
  signal n191_o : std_logic;
  signal n192_o : std_logic_vector (19 downto 0);
  signal n193_o : std_logic;
  signal n194_o : std_logic_vector (9 downto 0);
  signal n195_o : std_logic;
  signal n196_o : std_logic_vector (7 downto 0);
  signal imm : std_logic_vector (31 downto 0);
  signal n198_o : std_logic_vector (31 downto 0);
  signal n200_o : std_logic;
  signal n202_o : std_logic;
  signal n203_o : std_logic;
  signal n205_o : std_logic_vector (8 downto 0);
  signal n206_o : std_logic_vector (9 downto 0);
  signal n207_o : std_logic_vector (19 downto 0);
  signal n209_o : std_logic_vector (20 downto 0);
  signal n214_o : std_logic_vector (31 downto 0);
  signal n216_o : std_logic;
  signal n222_o : std_logic_vector (31 downto 0);
  signal n224_o : std_logic;
  signal n226_o : std_logic;
  signal n227_o : std_logic;
  signal n229_o : std_logic;
  signal n230_o : std_logic;
  signal n232_o : std_logic;
  signal n233_o : std_logic;
  signal n235_o : std_logic_vector (1 downto 0);
  signal n236_o : std_logic_vector (7 downto 0);
  signal n237_o : std_logic_vector (11 downto 0);
  signal n239_o : std_logic_vector (12 downto 0);
  signal n244_o : std_logic_vector (31 downto 0);
  signal n246_o : std_logic;
  signal n248_o : std_logic_vector (11 downto 0);
  signal n253_o : std_logic_vector (31 downto 0);
  signal n255_o : std_logic;
  signal n256_o : std_logic_vector (4 downto 0);
  signal n257_o : std_logic_vector (31 downto 0);
  signal n278_o : std_logic;
  signal n280_o : std_logic;
  signal n281_o : std_logic;
  signal n283_o : std_logic;
  signal n284_o : std_logic;
  signal n286_o : std_logic;
  signal n288_o : std_logic;
  signal n292_o : std_logic;
  signal n294_o : std_logic;
  signal n296_o : std_logic;
  signal n297_o : std_logic;
  signal n300_o : std_logic_vector (3 downto 0);
  signal n302_o : std_logic;
  signal n305_o : std_logic;
  signal n308_o : std_logic;
  signal n311_o : std_logic;
  signal n314_o : std_logic;
  signal n317_o : std_logic;
  signal n320_o : std_logic;
  signal n322_o : std_logic;
  signal n325_o : std_logic_vector (3 downto 0);
  signal n327_o : std_logic;
  signal n329_o : std_logic_vector (7 downto 0);
  signal n330_o : std_logic_vector (3 downto 0);
  signal n332_o : std_logic;
  signal n334_o : std_logic;
  signal n335_o : std_logic;
  signal n337_o : std_logic_vector (1 downto 0);
  signal n338_o : std_logic_vector (3 downto 0);
  signal n341_o : std_logic;
  signal n343_o : std_logic;
  signal n345_o : std_logic;
  signal n347_o : std_logic;
  signal n348_o : std_logic;
  signal n350_o : std_logic;
  signal n351_o : std_logic;
  signal n353_o : std_logic;
  signal n355_o : std_logic;
  signal n356_o : std_logic;
  signal n358_o : std_logic;
  signal n360_o : std_logic;
  signal n362_o : std_logic;
  signal n363_o : std_logic;
  signal n369_o : std_logic_vector (30 downto 0);
  signal n370_o : std_logic_vector (31 downto 0);
  signal n372_o : std_logic;
  signal n373_o : std_logic;
  signal n378_o : std_logic;
  signal n380_o : std_logic;
  signal n381_o : std_logic;
  signal n383_o : std_logic;
  signal n384_o : std_logic;
  signal n386_o : std_logic;
  signal n388_o : std_logic;
  signal n390_o : std_logic;
  signal n392_o : std_logic;
  signal n393_o : std_logic;
  signal n395_o : std_logic;
  signal n396_o : std_logic;
  signal n398_o : std_logic;
  signal n399_o : std_logic;
  signal n401_o : std_logic;
  signal n402_o : std_logic;
  signal n404_o : std_logic;
  signal n405_o : std_logic;
  signal n407_o : std_logic;
  signal n409_o : std_logic;
  signal n411_o : std_logic;
  signal n413_o : std_logic;
  signal n414_o : std_logic;
  signal n416_o : std_logic;
  signal n417_o : std_logic;
  signal n419_o : std_logic;
  signal n420_o : std_logic;
  signal n422_o : std_logic;
  signal n423_o : std_logic;
  signal n425_o : std_logic;
  signal n427_o : std_logic;
  signal n429_o : std_logic;
  signal n431_o : std_logic;
  signal n432_o : std_logic;
  signal n434_o : std_logic;
  signal n435_o : std_logic;
  signal n437_o : std_logic;
  signal n439_o : std_logic;
  signal n441_o : std_logic;
  signal n443_o : std_logic;
  signal n444_o : std_logic;
  signal n446_o : std_logic;
  signal n447_o : std_logic;
  signal n449_o : std_logic;
  signal n450_o : std_logic;
  signal n452_o : std_logic;
  signal n453_o : std_logic;
  signal n455_o : std_logic;
  signal n456_o : std_logic;
  signal n458_o : std_logic;
  signal n460_o : std_logic;
  signal n462_o : std_logic;
  signal n464_o : std_logic;
  signal n465_o : std_logic;
  signal n467_o : std_logic;
  signal n469_o : std_logic_vector (2 downto 0);
  signal n470_o : std_logic;
  signal n472_o : std_logic;
  signal n474_o : std_logic;
  signal n476_o : std_logic;
  signal n477_o : std_logic;
  signal n479_o : std_logic;
  signal n481_o : std_logic;
  signal n482_o : std_logic;
  signal n484_o : std_logic;
  signal n486_o : std_logic;
  signal n488_o : std_logic;
  signal n489_o : std_logic;
  signal n491_o : std_logic;
  signal n492_o : std_logic;
  signal n494_o : std_logic;
  signal n495_o : std_logic;
  signal n497_o : std_logic;
  signal n498_o : std_logic;
  signal n500_o : std_logic;
  signal n501_o : std_logic;
  signal n503_o : std_logic_vector (1 downto 0);
  signal n504_o : std_logic;
  signal n506_o : std_logic;
  signal n508_o : std_logic;
  signal n510_o : std_logic;
  signal n511_o : std_logic;
  signal n513_o : std_logic;
  signal n515_o : std_logic_vector (7 downto 0);
  signal n516_o : std_logic;
  signal n518_o : std_logic_vector (62 downto 0);
begin
  instr_data_o_funct3 <= n164_o;
  instr_data_o_imm <= n165_o;
  instr_data_o_rs1 <= n166_o;
  instr_data_o_rs2 <= n167_o;
  instr_data_o_rd <= n168_o;
  instr_data_o_use_pc <= n169_o;
  instr_data_o_use_imm <= n170_o;
  instr_data_o_alu_fn <= n171_o;
  instr_data_o_is_load <= n172_o;
  instr_data_o_is_store <= n173_o;
  instr_data_o_is_mret <= n174_o;
  instr_data_o_is_jump <= n175_o;
  instr_data_o_is_branch <= n176_o;
  instr_data_o_has_rd <= n177_o;
  instr_data_o_is_invalid <= n178_o;
  -- VStateMachine.vhd:18:9
  n164_o <= n518_o (2 downto 0);
  -- VStateMachine.vhd:17:9
  n165_o <= n518_o (34 downto 3);
  -- VStateMachine.vhd:16:9
  n166_o <= n518_o (39 downto 35);
  -- VStateMachine.vhd:15:9
  n167_o <= n518_o (44 downto 40);
  n168_o <= n518_o (49 downto 45);
  -- VStateMachine.vhd:28:5
  n169_o <= n518_o (50);
  n170_o <= n518_o (51);
  n171_o <= n518_o (55 downto 52);
  n172_o <= n518_o (56);
  n173_o <= n518_o (57);
  n174_o <= n518_o (58);
  n175_o <= n518_o (59);
  n176_o <= n518_o (60);
  n177_o <= n518_o (61);
  n178_o <= n518_o (62);
  n179_o <= instr_i (31 downto 25);
  n180_o <= instr_i (24 downto 20);
  n181_o <= instr_i (19 downto 15);
  n182_o <= instr_i (14 downto 12);
  n183_o <= instr_i (11 downto 7);
  n184_o <= instr_i (6 downto 0);
  n185_o <= instr_i (31 downto 20);
  n186_o <= instr_i (31 downto 25);
  n187_o <= instr_i (11 downto 7);
  n188_o <= instr_i (31);
  n189_o <= instr_i (30 downto 25);
  n190_o <= instr_i (11 downto 8);
  n191_o <= instr_i (7);
  n192_o <= instr_i (31 downto 12);
  n193_o <= instr_i (31);
  n194_o <= instr_i (30 downto 21);
  n195_o <= instr_i (20);
  n196_o <= instr_i (19 downto 12);
  -- VDecoder.vhd:130:12
  imm <= n257_o; -- (signal)
  -- VDecoder.vhd:134:28
  n198_o <= n192_o & "000000000000";
  -- VDecoder.vhd:134:99
  n200_o <= '1' when n184_o = "0110111" else '0';
  -- VDecoder.vhd:134:111
  n202_o <= '1' when n184_o = "0010111" else '0';
  -- VDecoder.vhd:134:111
  n203_o <= n200_o or n202_o;
  -- VDecoder.vhd:135:45
  n205_o <= n193_o & n196_o;
  -- VDecoder.vhd:135:61
  n206_o <= n205_o & n195_o;
  -- VDecoder.vhd:135:77
  n207_o <= n206_o & n194_o;
  -- VDecoder.vhd:135:92
  n209_o <= n207_o & '0';
  -- Virgule_pkg.vhd:54:23
  n214_o <= std_logic_vector (resize (signed (n209_o), 32));  --  sext
  -- VDecoder.vhd:135:99
  n216_o <= '1' when n184_o = "1101111" else '0';
  -- Virgule_pkg.vhd:54:23
  n222_o <= std_logic_vector (resize (signed (n185_o), 32));  --  sext
  -- VDecoder.vhd:136:99
  n224_o <= '1' when n184_o = "1100111" else '0';
  -- VDecoder.vhd:136:112
  n226_o <= '1' when n184_o = "0000011" else '0';
  -- VDecoder.vhd:136:112
  n227_o <= n224_o or n226_o;
  -- VDecoder.vhd:136:122
  n229_o <= '1' when n184_o = "0010011" else '0';
  -- VDecoder.vhd:136:122
  n230_o <= n227_o or n229_o;
  -- VDecoder.vhd:136:131
  n232_o <= '1' when n184_o = "1110011" else '0';
  -- VDecoder.vhd:136:131
  n233_o <= n230_o or n232_o;
  -- VDecoder.vhd:137:45
  n235_o <= n188_o & n191_o;
  -- VDecoder.vhd:137:61
  n236_o <= n235_o & n189_o;
  -- VDecoder.vhd:137:77
  n237_o <= n236_o & n190_o;
  -- VDecoder.vhd:137:92
  n239_o <= n237_o & '0';
  -- Virgule_pkg.vhd:54:23
  n244_o <= std_logic_vector (resize (signed (n239_o), 32));  --  sext
  -- VDecoder.vhd:137:99
  n246_o <= '1' when n184_o = "1100011" else '0';
  -- VDecoder.vhd:138:45
  n248_o <= n186_o & n187_o;
  -- Virgule_pkg.vhd:54:23
  n253_o <= std_logic_vector (resize (signed (n248_o), 32));  --  sext
  -- VDecoder.vhd:138:99
  n255_o <= '1' when n184_o = "0100011" else '0';
  n256_o <= n255_o & n246_o & n233_o & n216_o & n203_o;
  -- VDecoder.vhd:133:5
  with n256_o select n257_o <=
    n253_o when "10000",
    n244_o when "01000",
    n222_o when "00100",
    n214_o when "00010",
    n198_o when "00001",
    "00000000000000000000000000000000" when others;
  -- VDecoder.vhd:150:38
  n278_o <= '1' when n184_o = "0010111" else '0';
  -- VDecoder.vhd:150:52
  n280_o <= '1' when n184_o = "1101111" else '0';
  -- VDecoder.vhd:150:52
  n281_o <= n278_o or n280_o;
  -- VDecoder.vhd:150:61
  n283_o <= '1' when n184_o = "1100011" else '0';
  -- VDecoder.vhd:150:61
  n284_o <= n281_o or n283_o;
  -- VDecoder.vhd:149:5
  with n284_o select n286_o <=
    '1' when '1',
    '0' when others;
  -- VDecoder.vhd:153:42
  n288_o <= '1' when n184_o /= "0110011" else '0';
  -- VDecoder.vhd:159:13
  n292_o <= '1' when n184_o = "0110111" else '0';
  -- VDecoder.vhd:164:41
  n294_o <= '1' when n184_o = "0110011" else '0';
  -- VDecoder.vhd:164:67
  n296_o <= '1' when n179_o = "0100000" else '0';
  -- VDecoder.vhd:164:50
  n297_o <= n294_o and n296_o;
  -- VDecoder.vhd:164:25
  n300_o <= "0001" when n297_o = '0' else "0010";
  -- VDecoder.vhd:163:21
  n302_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:169:21
  n305_o <= '1' when n182_o = "010" else '0';
  -- VDecoder.vhd:170:21
  n308_o <= '1' when n182_o = "011" else '0';
  -- VDecoder.vhd:171:21
  n311_o <= '1' when n182_o = "100" else '0';
  -- VDecoder.vhd:172:21
  n314_o <= '1' when n182_o = "110" else '0';
  -- VDecoder.vhd:173:21
  n317_o <= '1' when n182_o = "111" else '0';
  -- VDecoder.vhd:174:21
  n320_o <= '1' when n182_o = "001" else '0';
  -- VDecoder.vhd:176:41
  n322_o <= '1' when n179_o = "0100000" else '0';
  -- VDecoder.vhd:176:25
  n325_o <= "1001" when n322_o = '0' else "1010";
  -- VDecoder.vhd:175:21
  n327_o <= '1' when n182_o = "101" else '0';
  n329_o <= n327_o & n320_o & n317_o & n314_o & n311_o & n308_o & n305_o & n302_o;
  -- VDecoder.vhd:162:17
  with n329_o select n330_o <=
    n325_o when "10000000",
    "1000" when "01000000",
    "0111" when "00100000",
    "0110" when "00010000",
    "0101" when "00001000",
    "0100" when "00000100",
    "0011" when "00000010",
    n300_o when "00000001",
    "0001" when others;
  -- VDecoder.vhd:161:13
  n332_o <= '1' when n184_o = "0010011" else '0';
  -- VDecoder.vhd:161:25
  n334_o <= '1' when n184_o = "0110011" else '0';
  -- VDecoder.vhd:161:25
  n335_o <= n332_o or n334_o;
  n337_o <= n335_o & n292_o;
  -- VDecoder.vhd:158:9
  with n337_o select n338_o <=
    n330_o when "10",
    "0000" when "01",
    "0001" when others;
  -- VDecoder.vhd:188:45
  n341_o <= '1' when n184_o = "0000011" else '0';
  -- VDecoder.vhd:189:45
  n343_o <= '1' when n184_o = "0100011" else '0';
  -- VDecoder.vhd:190:45
  n345_o <= '1' when n184_o = "1110011" else '0';
  -- VDecoder.vhd:190:74
  n347_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:190:57
  n348_o <= n345_o and n347_o;
  -- VDecoder.vhd:190:100
  n350_o <= '1' when n185_o = "001100000010" else '0';
  -- VDecoder.vhd:190:84
  n351_o <= n348_o and n350_o;
  -- VDecoder.vhd:191:45
  n353_o <= '1' when n184_o = "1101111" else '0';
  -- VDecoder.vhd:191:74
  n355_o <= '1' when n184_o = "1100111" else '0';
  -- VDecoder.vhd:191:57
  n356_o <= n353_o or n355_o;
  -- VDecoder.vhd:192:45
  n358_o <= '1' when n184_o = "1100011" else '0';
  -- VDecoder.vhd:193:44
  n360_o <= '1' when n184_o /= "1100011" else '0';
  -- VDecoder.vhd:193:74
  n362_o <= '1' when n184_o /= "0100011" else '0';
  -- VDecoder.vhd:193:57
  n363_o <= n360_o and n362_o;
  -- Virgule_pkg.vhd:65:16
  n369_o <= "00000000000000000000000000" & n183_o;  --  uext
  -- VDecoder.vhd:193:111
  n370_o <= "0" & n369_o;  --  uext
  -- VDecoder.vhd:193:111
  n372_o <= '1' when n370_o /= "00000000000000000000000000000000" else '0';
  -- VDecoder.vhd:193:86
  n373_o <= n363_o and n372_o;
  -- VDecoder.vhd:205:13
  n378_o <= '1' when n184_o = "0110111" else '0';
  -- VDecoder.vhd:205:25
  n380_o <= '1' when n184_o = "0010111" else '0';
  -- VDecoder.vhd:205:25
  n381_o <= n378_o or n380_o;
  -- VDecoder.vhd:205:36
  n383_o <= '1' when n184_o = "1101111" else '0';
  -- VDecoder.vhd:205:36
  n384_o <= n381_o or n383_o;
  -- VDecoder.vhd:208:57
  n386_o <= '1' when n182_o /= "000" else '0';
  -- VDecoder.vhd:207:13
  n388_o <= '1' when n184_o = "1100111" else '0';
  -- VDecoder.vhd:212:21
  n390_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:212:33
  n392_o <= '1' when n182_o = "001" else '0';
  -- VDecoder.vhd:212:33
  n393_o <= n390_o or n392_o;
  -- VDecoder.vhd:212:42
  n395_o <= '1' when n182_o = "100" else '0';
  -- VDecoder.vhd:212:42
  n396_o <= n393_o or n395_o;
  -- VDecoder.vhd:212:51
  n398_o <= '1' when n182_o = "101" else '0';
  -- VDecoder.vhd:212:51
  n399_o <= n396_o or n398_o;
  -- VDecoder.vhd:212:60
  n401_o <= '1' when n182_o = "110" else '0';
  -- VDecoder.vhd:212:60
  n402_o <= n399_o or n401_o;
  -- VDecoder.vhd:212:70
  n404_o <= '1' when n182_o = "111" else '0';
  -- VDecoder.vhd:212:70
  n405_o <= n402_o or n404_o;
  -- VDecoder.vhd:211:17
  with n405_o select n407_o <=
    '0' when '1',
    '1' when others;
  -- VDecoder.vhd:210:13
  n409_o <= '1' when n184_o = "1100011" else '0';
  -- VDecoder.vhd:218:21
  n411_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:218:35
  n413_o <= '1' when n182_o = "001" else '0';
  -- VDecoder.vhd:218:35
  n414_o <= n411_o or n413_o;
  -- VDecoder.vhd:218:46
  n416_o <= '1' when n182_o = "010" else '0';
  -- VDecoder.vhd:218:46
  n417_o <= n414_o or n416_o;
  -- VDecoder.vhd:218:57
  n419_o <= '1' when n182_o = "100" else '0';
  -- VDecoder.vhd:218:57
  n420_o <= n417_o or n419_o;
  -- VDecoder.vhd:218:66
  n422_o <= '1' when n182_o = "101" else '0';
  -- VDecoder.vhd:218:66
  n423_o <= n420_o or n422_o;
  -- VDecoder.vhd:217:17
  with n423_o select n425_o <=
    '0' when '1',
    '1' when others;
  -- VDecoder.vhd:216:13
  n427_o <= '1' when n184_o = "0000011" else '0';
  -- VDecoder.vhd:224:21
  n429_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:224:35
  n431_o <= '1' when n182_o = "001" else '0';
  -- VDecoder.vhd:224:35
  n432_o <= n429_o or n431_o;
  -- VDecoder.vhd:224:46
  n434_o <= '1' when n182_o = "010" else '0';
  -- VDecoder.vhd:224:46
  n435_o <= n432_o or n434_o;
  -- VDecoder.vhd:223:17
  with n435_o select n437_o <=
    '0' when '1',
    '1' when others;
  -- VDecoder.vhd:222:13
  n439_o <= '1' when n184_o = "0100011" else '0';
  -- VDecoder.vhd:230:21
  n441_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:230:37
  n443_o <= '1' when n182_o = "010" else '0';
  -- VDecoder.vhd:230:37
  n444_o <= n441_o or n443_o;
  -- VDecoder.vhd:230:46
  n446_o <= '1' when n182_o = "011" else '0';
  -- VDecoder.vhd:230:46
  n447_o <= n444_o or n446_o;
  -- VDecoder.vhd:230:56
  n449_o <= '1' when n182_o = "100" else '0';
  -- VDecoder.vhd:230:56
  n450_o <= n447_o or n449_o;
  -- VDecoder.vhd:230:65
  n452_o <= '1' when n182_o = "110" else '0';
  -- VDecoder.vhd:230:65
  n453_o <= n450_o or n452_o;
  -- VDecoder.vhd:230:73
  n455_o <= '1' when n182_o = "111" else '0';
  -- VDecoder.vhd:230:73
  n456_o <= n453_o or n455_o;
  -- VDecoder.vhd:232:65
  n458_o <= '1' when n179_o /= "0000000" else '0';
  -- VDecoder.vhd:231:21
  n460_o <= '1' when n182_o = "001" else '0';
  -- VDecoder.vhd:234:65
  n462_o <= '1' when n179_o /= "0000000" else '0';
  -- VDecoder.vhd:234:96
  n464_o <= '1' when n179_o /= "0100000" else '0';
  -- VDecoder.vhd:234:79
  n465_o <= n462_o and n464_o;
  -- VDecoder.vhd:233:21
  n467_o <= '1' when n182_o = "101" else '0';
  n469_o <= n467_o & n460_o & n456_o;
  -- VDecoder.vhd:229:17
  with n469_o select n470_o <=
    n465_o when "100",
    n458_o when "010",
    '0' when "001",
    '1' when others;
  -- VDecoder.vhd:228:13
  n472_o <= '1' when n184_o = "0010011" else '0';
  -- VDecoder.vhd:241:65
  n474_o <= '1' when n179_o /= "0000000" else '0';
  -- VDecoder.vhd:241:96
  n476_o <= '1' when n179_o /= "0100000" else '0';
  -- VDecoder.vhd:241:79
  n477_o <= n474_o and n476_o;
  -- VDecoder.vhd:240:21
  n479_o <= '1' when n182_o = "000" else '0';
  -- VDecoder.vhd:240:37
  n481_o <= '1' when n182_o = "101" else '0';
  -- VDecoder.vhd:240:37
  n482_o <= n479_o or n481_o;
  -- VDecoder.vhd:243:69
  n484_o <= '1' when n179_o /= "0000000" else '0';
  -- VDecoder.vhd:242:21
  n486_o <= '1' when n182_o = "001" else '0';
  -- VDecoder.vhd:242:33
  n488_o <= '1' when n182_o = "010" else '0';
  -- VDecoder.vhd:242:33
  n489_o <= n486_o or n488_o;
  -- VDecoder.vhd:242:42
  n491_o <= '1' when n182_o = "011" else '0';
  -- VDecoder.vhd:242:42
  n492_o <= n489_o or n491_o;
  -- VDecoder.vhd:242:52
  n494_o <= '1' when n182_o = "100" else '0';
  -- VDecoder.vhd:242:52
  n495_o <= n492_o or n494_o;
  -- VDecoder.vhd:242:61
  n497_o <= '1' when n182_o = "110" else '0';
  -- VDecoder.vhd:242:61
  n498_o <= n495_o or n497_o;
  -- VDecoder.vhd:242:69
  n500_o <= '1' when n182_o = "111" else '0';
  -- VDecoder.vhd:242:69
  n501_o <= n498_o or n500_o;
  n503_o <= n501_o & n482_o;
  -- VDecoder.vhd:239:17
  with n503_o select n504_o <=
    n484_o when "10",
    n477_o when "01",
    '1' when others;
  -- VDecoder.vhd:238:13
  n506_o <= '1' when n184_o = "0110011" else '0';
  -- VDecoder.vhd:248:56
  n508_o <= '1' when n185_o /= "001100000010" else '0';
  -- VDecoder.vhd:248:84
  n510_o <= '1' when n182_o /= "000" else '0';
  -- VDecoder.vhd:248:68
  n511_o <= n508_o or n510_o;
  -- VDecoder.vhd:247:13
  n513_o <= '1' when n184_o = "1110011" else '0';
  n515_o <= n513_o & n506_o & n472_o & n439_o & n427_o & n409_o & n388_o & n384_o;
  -- VDecoder.vhd:204:9
  with n515_o select n516_o <=
    n511_o when "10000000",
    n504_o when "01000000",
    n470_o when "00100000",
    n437_o when "00010000",
    n425_o when "00001000",
    n407_o when "00000100",
    n386_o when "00000010",
    '0' when "00000001",
    '1' when others;
  n518_o <= n516_o & n373_o & n358_o & n356_o & n351_o & n343_o & n341_o & n338_o & n288_o & n286_o & n183_o & n180_o & n181_o & imm & n182_o;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vstatemachine is
  port (
    clk_i : in std_logic;
    reset_i : in std_logic;
    is_load_i : in std_logic;
    is_store_i : in std_logic;
    has_rd_i : in std_logic;
    bus_done_i : in std_logic;
    fetch_en_o : out std_logic;
    decode_en_o : out std_logic;
    execute_en_o : out std_logic;
    load_en_o : out std_logic;
    store_en_o : out std_logic;
    writeback_en_o : out std_logic);
end entity vstatemachine;

architecture rtl of vstatemachine is
  signal state_reg : std_logic_vector (2 downto 0);
  signal n117_o : std_logic_vector (2 downto 0);
  signal n119_o : std_logic;
  signal n121_o : std_logic;
  signal n124_o : std_logic_vector (2 downto 0);
  signal n126_o : std_logic_vector (2 downto 0);
  signal n128_o : std_logic_vector (2 downto 0);
  signal n130_o : std_logic;
  signal n132_o : std_logic_vector (2 downto 0);
  signal n134_o : std_logic;
  signal n136_o : std_logic_vector (2 downto 0);
  signal n138_o : std_logic;
  signal n140_o : std_logic;
  signal n141_o : std_logic_vector (5 downto 0);
  signal n145_o : std_logic_vector (2 downto 0);
  signal n147_o : std_logic_vector (2 downto 0);
  signal n150_q : std_logic_vector (2 downto 0);
  signal n152_o : std_logic;
  signal n154_o : std_logic;
  signal n156_o : std_logic;
  signal n158_o : std_logic;
  signal n160_o : std_logic;
  signal n162_o : std_logic;
begin
  fetch_en_o <= n152_o;
  decode_en_o <= n154_o;
  execute_en_o <= n156_o;
  load_en_o <= n158_o;
  store_en_o <= n160_o;
  writeback_en_o <= n162_o;
  -- VStateMachine.vhd:26:12
  state_reg <= n150_q; -- (signal)
  -- VStateMachine.vhd:36:25
  n117_o <= state_reg when bus_done_i = '0' else "001";
  -- VStateMachine.vhd:35:21
  n119_o <= '1' when state_reg = "000" else '0';
  -- VStateMachine.vhd:39:21
  n121_o <= '1' when state_reg = "001" else '0';
  -- VStateMachine.vhd:46:25
  n124_o <= "000" when has_rd_i = '0' else "101";
  -- VStateMachine.vhd:44:25
  n126_o <= n124_o when is_store_i = '0' else "100";
  -- VStateMachine.vhd:42:25
  n128_o <= n126_o when is_load_i = '0' else "011";
  -- VStateMachine.vhd:41:21
  n130_o <= '1' when state_reg = "010" else '0';
  -- VStateMachine.vhd:52:25
  n132_o <= state_reg when bus_done_i = '0' else "101";
  -- VStateMachine.vhd:51:21
  n134_o <= '1' when state_reg = "011" else '0';
  -- VStateMachine.vhd:56:25
  n136_o <= state_reg when bus_done_i = '0' else "000";
  -- VStateMachine.vhd:55:21
  n138_o <= '1' when state_reg = "100" else '0';
  -- VStateMachine.vhd:59:21
  n140_o <= '1' when state_reg = "101" else '0';
  n141_o <= n140_o & n138_o & n134_o & n130_o & n121_o & n119_o;
  -- VStateMachine.vhd:34:17
  with n141_o select n145_o <=
    "000" when "100000",
    n136_o when "010000",
    n132_o when "001000",
    n128_o when "000100",
    "010" when "000010",
    n117_o when "000001",
    "XXX" when others;
  -- VStateMachine.vhd:31:13
  n147_o <= n145_o when reset_i = '0' else "000";
  -- VStateMachine.vhd:30:9
  process (clk_i)
  begin
    if rising_edge (clk_i) then
      n150_q <= n147_o;
    end if;
  end process;
  -- VStateMachine.vhd:66:33
  n152_o <= '1' when state_reg = "000" else '0';
  -- VStateMachine.vhd:67:33
  n154_o <= '1' when state_reg = "001" else '0';
  -- VStateMachine.vhd:68:33
  n156_o <= '1' when state_reg = "010" else '0';
  -- VStateMachine.vhd:69:33
  n158_o <= '1' when state_reg = "011" else '0';
  -- VStateMachine.vhd:70:33
  n160_o <= '1' when state_reg = "100" else '0';
  -- VStateMachine.vhd:71:33
  n162_o <= '1' when state_reg = "101" else '0';
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of virgule is
  signal wrap_clk_i: std_logic;
  signal wrap_reset_i: std_logic;
  subtype typwrap_data_i is std_logic_vector (31 downto 0);
  signal wrap_data_i: typwrap_data_i;
  signal wrap_done_i: std_logic;
  signal wrap_irq_i: std_logic;
  subtype typwrap_address_o is std_logic_vector (31 downto 0);
  signal wrap_address_o: typwrap_address_o;
  subtype typwrap_data_o is std_logic_vector (31 downto 0);
  signal wrap_data_o: typwrap_data_o;
  signal wrap_write_o: std_logic;
  subtype typwrap_select_o is std_logic_vector (3 downto 0);
  signal wrap_select_o: typwrap_select_o;
  signal instr_reg : std_logic_vector (31 downto 0);
  signal instr_data : std_logic_vector (62 downto 0);
  signal instr_data_reg : std_logic_vector (62 downto 0);
  signal fetch_en : std_logic;
  signal decode_en : std_logic;
  signal execute_en : std_logic;
  signal load_en : std_logic;
  signal store_en : std_logic;
  signal writeback_en : std_logic;
  signal x1_reg : std_logic_vector (31 downto 0);
  signal x2_reg : std_logic_vector (31 downto 0);
  signal x1 : std_logic_vector (31 downto 0);
  signal x2 : std_logic_vector (31 downto 0);
  signal xd : std_logic_vector (31 downto 0);
  signal reg_write : std_logic;
  signal pc_reg : std_logic_vector (31 downto 0);
  signal pc_next_reg : std_logic_vector (31 downto 0);
  signal pc_next : std_logic_vector (31 downto 0);
  signal pc_to_fetch : std_logic_vector (31 downto 0);
  signal alu_a_reg : std_logic_vector (31 downto 0);
  signal alu_b_reg : std_logic_vector (31 downto 0);
  signal alu_r_reg : std_logic_vector (31 downto 0);
  signal alu_a : std_logic_vector (31 downto 0);
  signal alu_b : std_logic_vector (31 downto 0);
  signal alu_r : std_logic_vector (31 downto 0);
  signal taken : std_logic;
  signal load_store_en : std_logic;
  signal data_i_reg : std_logic_vector (31 downto 0);
  signal load_data : std_logic_vector (31 downto 0);
  signal load_store_select : std_logic_vector (3 downto 0);
  signal fsm_inst_fetch_en_o : std_logic;
  signal fsm_inst_decode_en_o : std_logic;
  signal fsm_inst_execute_en_o : std_logic;
  signal fsm_inst_load_en_o : std_logic;
  signal fsm_inst_store_en_o : std_logic;
  signal fsm_inst_writeback_en_o : std_logic;
  signal n5_o : std_logic;
  signal n6_o : std_logic;
  signal n7_o : std_logic;
  signal n16_o : std_logic;
  signal n20_o : std_logic_vector (31 downto 0);
  signal n21_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal decoder_inst_instr_data_o_funct3 : std_logic_vector (2 downto 0);
  signal decoder_inst_instr_data_o_imm : std_logic_vector (31 downto 0);
  signal decoder_inst_instr_data_o_rs1 : std_logic_vector (4 downto 0);
  signal decoder_inst_instr_data_o_rs2 : std_logic_vector (4 downto 0);
  signal decoder_inst_instr_data_o_rd : std_logic_vector (4 downto 0);
  signal decoder_inst_instr_data_o_use_pc : std_logic;
  signal decoder_inst_instr_data_o_use_imm : std_logic;
  signal decoder_inst_instr_data_o_alu_fn : std_logic_vector (3 downto 0);
  signal decoder_inst_instr_data_o_is_load : std_logic;
  signal decoder_inst_instr_data_o_is_store : std_logic;
  signal decoder_inst_instr_data_o_is_mret : std_logic;
  signal decoder_inst_instr_data_o_is_jump : std_logic;
  signal decoder_inst_instr_data_o_is_branch : std_logic;
  signal decoder_inst_instr_data_o_has_rd : std_logic;
  signal decoder_inst_instr_data_o_is_invalid : std_logic;
  signal n22_o : std_logic_vector (62 downto 0);
  signal reg_inst_x1_o : std_logic_vector (31 downto 0);
  signal reg_inst_x2_o : std_logic_vector (31 downto 0);
  signal n24_o : std_logic_vector (4 downto 0);
  signal n25_o : std_logic_vector (4 downto 0);
  signal n26_o : std_logic_vector (4 downto 0);
  signal n29_o : std_logic;
  signal n30_o : std_logic_vector (31 downto 0);
  signal n31_o : std_logic_vector (31 downto 0);
  signal n32_o : std_logic;
  signal n33_o : std_logic_vector (31 downto 0);
  signal n47_o : std_logic_vector (62 downto 0);
  signal n48_q : std_logic_vector (62 downto 0);
  signal n49_o : std_logic_vector (31 downto 0);
  signal n50_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n51_o : std_logic_vector (31 downto 0);
  signal n52_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n53_o : std_logic_vector (31 downto 0);
  signal n54_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n55_o : std_logic_vector (31 downto 0);
  signal n56_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal alu_inst_r_o : std_logic_vector (31 downto 0);
  signal n57_o : std_logic_vector (3 downto 0);
  signal cmp_inst_r_o : std_logic;
  signal n59_o : std_logic_vector (2 downto 0);
  signal branch_inst_pc_o : std_logic_vector (31 downto 0);
  signal branch_inst_will_jump_o : std_logic;
  signal n61_o : std_logic;
  signal n62_o : std_logic;
  signal n63_o : std_logic;
  signal n67_o : std_logic_vector (31 downto 0);
  signal n68_o : std_logic_vector (31 downto 0);
  signal n69_o : std_logic_vector (31 downto 0);
  signal n71_o : std_logic_vector (31 downto 0);
  signal n72_o : std_logic_vector (31 downto 0);
  signal n73_o : std_logic_vector (31 downto 0);
  signal n78_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n79_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n80_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n82_o : std_logic_vector (31 downto 0);
  signal n83_o : std_logic;
  signal load_store_inst_load_data_o : std_logic_vector (31 downto 0);
  signal load_store_inst_bus_data_o : std_logic_vector (31 downto 0);
  signal load_store_inst_select_o : std_logic_vector (3 downto 0);
  signal n84_o : std_logic_vector (2 downto 0);
  signal n88_o : std_logic_vector (31 downto 0);
  signal n90_o : std_logic_vector (3 downto 0);
  signal n92_o : std_logic;
  signal n96_o : std_logic;
  signal n100_o : std_logic_vector (31 downto 0);
  signal n101_q : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
  signal n102_o : std_logic;
  signal n103_o : std_logic;
  signal n104_o : std_logic;
  signal n105_o : std_logic_vector (31 downto 0);
  signal n106_o : std_logic;
  signal n107_o : std_logic_vector (31 downto 0);
begin
  wrap_clk_i <= clk_i;
  wrap_reset_i <= reset_i;
  wrap_data_i <= typwrap_data_i(data_i);
  wrap_done_i <= done_i;
  wrap_irq_i <= irq_i;
  address_o <= wrap_address_o;
  data_o <= wrap_data_o;
  write_o <= wrap_write_o;
  select_o <= wrap_select_o;
  wrap_address_o <= n88_o;
  wrap_data_o <= load_store_inst_bus_data_o;
  wrap_write_o <= n92_o;
  wrap_select_o <= n90_o;
  -- Virgule.vhd:27:12
  instr_reg <= n21_q; -- (isignal)
  -- Virgule.vhd:28:12
  instr_data <= n22_o; -- (signal)
  -- Virgule.vhd:28:24
  instr_data_reg <= n48_q; -- (signal)
  -- Virgule.vhd:29:12
  fetch_en <= fsm_inst_fetch_en_o; -- (signal)
  -- Virgule.vhd:30:12
  decode_en <= fsm_inst_decode_en_o; -- (signal)
  -- Virgule.vhd:30:23
  execute_en <= fsm_inst_execute_en_o; -- (signal)
  -- Virgule.vhd:31:12
  load_en <= fsm_inst_load_en_o; -- (signal)
  -- Virgule.vhd:31:21
  store_en <= fsm_inst_store_en_o; -- (signal)
  -- Virgule.vhd:32:12
  writeback_en <= fsm_inst_writeback_en_o; -- (signal)
  -- Virgule.vhd:33:12
  x1_reg <= n50_q; -- (isignal)
  -- Virgule.vhd:33:20
  x2_reg <= n52_q; -- (isignal)
  -- Virgule.vhd:34:12
  x1 <= reg_inst_x1_o; -- (signal)
  -- Virgule.vhd:34:16
  x2 <= reg_inst_x2_o; -- (signal)
  -- Virgule.vhd:35:12
  xd <= n105_o; -- (signal)
  -- Virgule.vhd:36:12
  reg_write <= n103_o; -- (signal)
  -- Virgule.vhd:37:12
  pc_reg <= n78_q; -- (isignal)
  -- Virgule.vhd:37:20
  pc_next_reg <= n79_q; -- (isignal)
  -- Virgule.vhd:38:12
  pc_next <= n82_o; -- (signal)
  -- Virgule.vhd:38:21
  pc_to_fetch <= branch_inst_pc_o; -- (signal)
  -- Virgule.vhd:39:12
  alu_a_reg <= n54_q; -- (isignal)
  -- Virgule.vhd:39:23
  alu_b_reg <= n56_q; -- (isignal)
  -- Virgule.vhd:39:34
  alu_r_reg <= n80_q; -- (isignal)
  -- Virgule.vhd:40:12
  alu_a <= n30_o; -- (signal)
  -- Virgule.vhd:40:19
  alu_b <= n33_o; -- (signal)
  -- Virgule.vhd:40:26
  alu_r <= alu_inst_r_o; -- (signal)
  -- Virgule.vhd:41:12
  taken <= cmp_inst_r_o; -- (signal)
  -- Virgule.vhd:42:12
  load_store_en <= n83_o; -- (signal)
  -- Virgule.vhd:43:12
  data_i_reg <= n101_q; -- (isignal)
  -- Virgule.vhd:44:12
  load_data <= load_store_inst_load_data_o; -- (signal)
  -- Virgule.vhd:45:12
  load_store_select <= load_store_inst_select_o; -- (signal)
  -- Virgule.vhd:51:5
  fsm_inst : entity work.vstatemachine port map (
    clk_i => wrap_clk_i,
    reset_i => wrap_reset_i,
    is_load_i => n5_o,
    is_store_i => n6_o,
    has_rd_i => n7_o,
    bus_done_i => wrap_done_i,
    fetch_en_o => fsm_inst_fetch_en_o,
    decode_en_o => fsm_inst_decode_en_o,
    execute_en_o => fsm_inst_execute_en_o,
    load_en_o => fsm_inst_load_en_o,
    store_en_o => fsm_inst_store_en_o,
    writeback_en_o => fsm_inst_writeback_en_o);
  -- Virgule.vhd:56:46
  n5_o <= instr_data_reg (56);
  -- Virgule.vhd:57:46
  n6_o <= instr_data_reg (57);
  -- Virgule.vhd:58:46
  n7_o <= instr_data_reg (61);
  -- Virgule.vhd:70:25
  n16_o <= fetch_en and wrap_done_i;
  -- Virgule.vhd:70:25
  n20_o <= instr_reg when n16_o = '0' else wrap_data_i;
  -- Virgule.vhd:69:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n21_q <= n20_o;
    end if;
  end process;
  -- Virgule.vhd:80:5
  decoder_inst : entity work.vdecoder port map (
    instr_i => instr_reg,
    instr_data_o_funct3 => decoder_inst_instr_data_o_funct3,
    instr_data_o_imm => decoder_inst_instr_data_o_imm,
    instr_data_o_rs1 => decoder_inst_instr_data_o_rs1,
    instr_data_o_rs2 => decoder_inst_instr_data_o_rs2,
    instr_data_o_rd => decoder_inst_instr_data_o_rd,
    instr_data_o_use_pc => decoder_inst_instr_data_o_use_pc,
    instr_data_o_use_imm => decoder_inst_instr_data_o_use_imm,
    instr_data_o_alu_fn => decoder_inst_instr_data_o_alu_fn,
    instr_data_o_is_load => decoder_inst_instr_data_o_is_load,
    instr_data_o_is_store => decoder_inst_instr_data_o_is_store,
    instr_data_o_is_mret => decoder_inst_instr_data_o_is_mret,
    instr_data_o_is_jump => decoder_inst_instr_data_o_is_jump,
    instr_data_o_is_branch => decoder_inst_instr_data_o_is_branch,
    instr_data_o_has_rd => decoder_inst_instr_data_o_has_rd,
    instr_data_o_is_invalid => decoder_inst_instr_data_o_is_invalid);
  n22_o <= decoder_inst_instr_data_o_is_invalid & decoder_inst_instr_data_o_has_rd & decoder_inst_instr_data_o_is_branch & decoder_inst_instr_data_o_is_jump & decoder_inst_instr_data_o_is_mret & decoder_inst_instr_data_o_is_store & decoder_inst_instr_data_o_is_load & decoder_inst_instr_data_o_alu_fn & decoder_inst_instr_data_o_use_imm & decoder_inst_instr_data_o_use_pc & decoder_inst_instr_data_o_rd & decoder_inst_instr_data_o_rs2 & decoder_inst_instr_data_o_rs1 & decoder_inst_instr_data_o_imm & decoder_inst_instr_data_o_funct3;
  -- Virgule.vhd:86:5
  reg_inst : entity work.vregisters port map (
    clk_i => wrap_clk_i,
    reset_i => wrap_reset_i,
    write_i => reg_write,
    rs1_i => n24_o,
    rs2_i => n25_o,
    rd_i => n26_o,
    xd_i => xd,
    x1_o => reg_inst_x1_o,
    x2_o => reg_inst_x2_o);
  -- Virgule.vhd:90:35
  n24_o <= instr_data (39 downto 35);
  -- Virgule.vhd:91:35
  n25_o <= instr_data (44 downto 40);
  -- Virgule.vhd:95:39
  n26_o <= instr_data_reg (49 downto 45);
  -- Virgule.vhd:99:45
  n29_o <= instr_data (50);
  -- Virgule.vhd:99:29
  n30_o <= x1 when n29_o = '0' else pc_reg;
  -- Virgule.vhd:100:25
  n31_o <= instr_data (34 downto 3);
  -- Virgule.vhd:100:45
  n32_o <= instr_data (51);
  -- Virgule.vhd:100:29
  n33_o <= x2 when n32_o = '0' else n31_o;
  -- Virgule.vhd:30:12
  n47_o <= instr_data_reg when decode_en = '0' else instr_data;
  -- Virgule.vhd:104:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n48_q <= n47_o;
    end if;
  end process;
  -- Virgule.vhd:30:12
  n49_o <= x1_reg when decode_en = '0' else x1;
  -- Virgule.vhd:104:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n50_q <= n49_o;
    end if;
  end process;
  -- Virgule.vhd:30:12
  n51_o <= x2_reg when decode_en = '0' else x2;
  -- Virgule.vhd:104:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n52_q <= n51_o;
    end if;
  end process;
  -- Virgule.vhd:30:12
  n53_o <= alu_a_reg when decode_en = '0' else alu_a;
  -- Virgule.vhd:104:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n54_q <= n53_o;
    end if;
  end process;
  -- Virgule.vhd:30:12
  n55_o <= alu_b_reg when decode_en = '0' else alu_b;
  -- Virgule.vhd:104:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n56_q <= n55_o;
    end if;
  end process;
  -- Virgule.vhd:119:5
  alu_inst : entity work.varithmeticandlogicunit port map (
    fn_i => n57_o,
    a_i => alu_a_reg,
    b_i => alu_b_reg,
    r_o => alu_inst_r_o);
  -- Virgule.vhd:121:36
  n57_o <= instr_data_reg (55 downto 52);
  -- Virgule.vhd:127:5
  cmp_inst : entity work.vcomparator port map (
    funct3_i => n59_o,
    a_i => x1_reg,
    b_i => x2_reg,
    r_o => cmp_inst_r_o);
  -- Virgule.vhd:129:40
  n59_o <= instr_data_reg (2 downto 0);
  -- Virgule.vhd:135:5
  branch_inst : entity work.vbranchunit port map (
    clk_i => wrap_clk_i,
    reset_i => wrap_reset_i,
    enable_i => execute_en,
    irq_i => wrap_irq_i,
    is_jump_i => n61_o,
    is_branch_i => n62_o,
    is_mret_i => n63_o,
    taken_i => taken,
    branch_address_i => alu_r,
    pc_next_i => pc_next,
    pc_o => branch_inst_pc_o,
    will_jump_o => open);
  -- Virgule.vhd:141:48
  n61_o <= instr_data_reg (59);
  -- Virgule.vhd:142:48
  n62_o <= instr_data_reg (60);
  -- Virgule.vhd:143:48
  n63_o <= instr_data_reg (58);
  -- Virgule.vhd:155:13
  n67_o <= pc_reg when execute_en = '0' else pc_to_fetch;
  -- Virgule.vhd:155:13
  n68_o <= pc_next_reg when execute_en = '0' else pc_next;
  -- Virgule.vhd:155:13
  n69_o <= alu_r_reg when execute_en = '0' else alu_r;
  -- Virgule.vhd:153:13
  n71_o <= n67_o when wrap_reset_i = '0' else "00000000000000000000000000000000";
  -- Virgule.vhd:153:13
  n72_o <= n68_o when wrap_reset_i = '0' else pc_next_reg;
  -- Virgule.vhd:153:13
  n73_o <= n69_o when wrap_reset_i = '0' else alu_r_reg;
  -- Virgule.vhd:152:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n78_q <= n71_o;
    end if;
  end process;
  -- Virgule.vhd:152:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n79_q <= n72_o;
    end if;
  end process;
  -- Virgule.vhd:152:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n80_q <= n73_o;
    end if;
  end process;
  -- Virgule.vhd:163:40
  n82_o <= std_logic_vector (unsigned (pc_reg) + unsigned'("00000000000000000000000000000100"));
  -- Virgule.vhd:169:30
  n83_o <= load_en or store_en;
  -- Virgule.vhd:171:5
  load_store_inst : entity work.vloadstoreunit port map (
    enable_i => load_store_en,
    funct3_i => n84_o,
    store_data_i => x2_reg,
    address_i => alu_r_reg,
    bus_data_i => data_i_reg,
    load_data_o => load_store_inst_load_data_o,
    bus_data_o => load_store_inst_bus_data_o,
    select_o => load_store_inst_select_o);
  -- Virgule.vhd:174:44
  n84_o <= instr_data_reg (2 downto 0);
  -- Virgule.vhd:183:25
  n88_o <= alu_r_reg when fetch_en = '0' else pc_reg;
  -- Virgule.vhd:184:25
  n90_o <= load_store_select when fetch_en = '0' else "1111";
  -- Virgule.vhd:185:25
  n92_o <= '0' when store_en = '0' else '1';
  -- Virgule.vhd:190:24
  n96_o <= load_en and wrap_done_i;
  -- Virgule.vhd:190:24
  n100_o <= data_i_reg when n96_o = '0' else wrap_data_i;
  -- Virgule.vhd:189:9
  process (wrap_clk_i)
  begin
    if rising_edge (wrap_clk_i) then
      n101_q <= n100_o;
    end if;
  end process;
  -- Virgule.vhd:200:50
  n102_o <= instr_data_reg (61);
  -- Virgule.vhd:200:31
  n103_o <= writeback_en and n102_o;
  -- Virgule.vhd:202:43
  n104_o <= instr_data_reg (56);
  -- Virgule.vhd:202:23
  n105_o <= n107_o when n104_o = '0' else load_data;
  -- Virgule.vhd:203:43
  n106_o <= instr_data_reg (59);
  -- Virgule.vhd:202:51
  n107_o <= alu_r_reg when n106_o = '0' else pc_next_reg;
end rtl;

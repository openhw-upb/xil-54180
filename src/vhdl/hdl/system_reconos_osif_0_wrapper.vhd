-------------------------------------------------------------------------------
-- system_reconos_osif_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library reconos_osif_v1_00_a;
use reconos_osif_v1_00_a.all;

entity system_reconos_osif_0_wrapper is
  port (
    OSIF_Hw2Sw_0_In_Data : in std_logic_vector(31 downto 0);
    OSIF_Hw2Sw_0_In_Empty : in std_logic;
    OSIF_Hw2Sw_0_In_RE : out std_logic;
    OSIF_Sw2Hw_0_In_Data : out std_logic_vector(31 downto 0);
    OSIF_Sw2Hw_0_In_Full : in std_logic;
    OSIF_Sw2Hw_0_In_WE : out std_logic;
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_AWREADY : out std_logic
  );
end system_reconos_osif_0_wrapper;

architecture STRUCTURE of system_reconos_osif_0_wrapper is

  component reconos_osif is
    generic (
      C_NUM_HWTS : INTEGER;
      C_OSIF_DATA_WIDTH : INTEGER;
      C_OSIF_LENGTH_WIDTH : INTEGER;
      C_OSIF_OP_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector
    );
    port (
      OSIF_Hw2Sw_0_In_Data : in std_logic_vector(C_OSIF_DATA_WIDTH - 1  downto  0);
      OSIF_Hw2Sw_0_In_Empty : in std_logic;
      OSIF_Hw2Sw_0_In_RE : out std_logic;
      OSIF_Sw2Hw_0_In_Data : out std_logic_vector(C_OSIF_DATA_WIDTH - 1  downto  0);
      OSIF_Sw2Hw_0_In_Full : in std_logic;
      OSIF_Sw2Hw_0_In_WE : out std_logic;
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_AWREADY : out std_logic
    );
  end component;

begin

  reconos_osif_0 : reconos_osif
    generic map (
      C_NUM_HWTS => 1,
      C_OSIF_DATA_WIDTH => 32,
      C_OSIF_LENGTH_WIDTH => 24,
      C_OSIF_OP_WIDTH => 8,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_DATA_WIDTH => 32,
      C_BASEADDR => X"75a00000",
      C_HIGHADDR => X"75a0ffff"
    )
    port map (
      OSIF_Hw2Sw_0_In_Data => OSIF_Hw2Sw_0_In_Data,
      OSIF_Hw2Sw_0_In_Empty => OSIF_Hw2Sw_0_In_Empty,
      OSIF_Hw2Sw_0_In_RE => OSIF_Hw2Sw_0_In_RE,
      OSIF_Sw2Hw_0_In_Data => OSIF_Sw2Hw_0_In_Data,
      OSIF_Sw2Hw_0_In_Full => OSIF_Sw2Hw_0_In_Full,
      OSIF_Sw2Hw_0_In_WE => OSIF_Sw2Hw_0_In_WE,
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY
    );

end architecture STRUCTURE;


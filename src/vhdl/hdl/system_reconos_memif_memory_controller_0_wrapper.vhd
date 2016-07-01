-------------------------------------------------------------------------------
-- system_reconos_memif_memory_controller_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library reconos_memif_memory_controller_v1_00_a;
use reconos_memif_memory_controller_v1_00_a.all;

entity system_reconos_memif_memory_controller_0_wrapper is
  port (
    MEMIF_Hwt2Mem_In_Data : in std_logic_vector(31 downto 0);
    MEMIF_Hwt2Mem_In_Empty : in std_logic;
    MEMIF_Hwt2Mem_In_RE : out std_logic;
    MEMIF_Mem2Hwt_In_Data : out std_logic_vector(31 downto 0);
    MEMIF_Mem2Hwt_In_Full : in std_logic;
    MEMIF_Mem2Hwt_In_WE : out std_logic;
    M_AXI_ACLK : in std_logic;
    M_AXI_ARESETN : in std_logic;
    M_AXI_ARREADY : in std_logic;
    M_AXI_ARVALID : out std_logic;
    M_AXI_ARADDR : out std_logic_vector(31 downto 0);
    M_AXI_ARLEN : out std_logic_vector(7 downto 0);
    M_AXI_ARSIZE : out std_logic_vector(2 downto 0);
    M_AXI_ARBURST : out std_logic_vector(1 downto 0);
    M_AXI_ARPROT : out std_logic_vector(2 downto 0);
    M_AXI_RREADY : out std_logic;
    M_AXI_RVALID : in std_logic;
    M_AXI_RDATA : in std_logic_vector(31 downto 0);
    M_AXI_RRESP : in std_logic_vector(1 downto 0);
    M_AXI_RLAST : in std_logic;
    M_AXI_AWREADY : in std_logic;
    M_AXI_AWVALID : out std_logic;
    M_AXI_AWADDR : out std_logic_vector(31 downto 0);
    M_AXI_AWLEN : out std_logic_vector(7 downto 0);
    M_AXI_AWSIZE : out std_logic_vector(2 downto 0);
    M_AXI_AWBURST : out std_logic_vector(1 downto 0);
    M_AXI_AWPROT : out std_logic_vector(2 downto 0);
    M_AXI_WREADY : in std_logic;
    M_AXI_WVALID : out std_logic;
    M_AXI_WDATA : out std_logic_vector(31 downto 0);
    M_AXI_WSTRB : out std_logic_vector(3 downto 0);
    M_AXI_WLAST : out std_logic;
    M_AXI_BREADY : out std_logic;
    M_AXI_BVALID : in std_logic;
    M_AXI_BRESP : in std_logic_vector(1 downto 0);
    M_AXI_AWCACHE : out std_logic_vector(3 downto 0);
    M_AXI_ARCACHE : out std_logic_vector(3 downto 0);
    M_AXI_AWUSER : out std_logic_vector(4 downto 0);
    M_AXI_ARUSER : out std_logic_vector(4 downto 0);
    DEBUG : out std_logic_vector(67 downto 0)
  );
end system_reconos_memif_memory_controller_0_wrapper;

architecture STRUCTURE of system_reconos_memif_memory_controller_0_wrapper is

  component reconos_memif_memory_controller is
    generic (
      C_M_AXI_ADDR_WIDTH : INTEGER;
      C_M_AXI_DATA_WIDTH : INTEGER;
      C_MAX_BURST_LEN : INTEGER;
      C_MEMIF_DATA_WIDTH : INTEGER
    );
    port (
      MEMIF_Hwt2Mem_In_Data : in std_logic_vector(C_MEMIF_DATA_WIDTH - 1  downto  0);
      MEMIF_Hwt2Mem_In_Empty : in std_logic;
      MEMIF_Hwt2Mem_In_RE : out std_logic;
      MEMIF_Mem2Hwt_In_Data : out std_logic_vector(C_MEMIF_DATA_WIDTH - 1  downto  0);
      MEMIF_Mem2Hwt_In_Full : in std_logic;
      MEMIF_Mem2Hwt_In_WE : out std_logic;
      M_AXI_ACLK : in std_logic;
      M_AXI_ARESETN : in std_logic;
      M_AXI_ARREADY : in std_logic;
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARADDR : out std_logic_vector(C_M_AXI_ADDR_WIDTH - 1  downto  0);
      M_AXI_ARLEN : out std_logic_vector(7  downto  0);
      M_AXI_ARSIZE : out std_logic_vector(2  downto  0);
      M_AXI_ARBURST : out std_logic_vector(1  downto  0);
      M_AXI_ARPROT : out std_logic_vector(2  downto  0);
      M_AXI_RREADY : out std_logic;
      M_AXI_RVALID : in std_logic;
      M_AXI_RDATA : in std_logic_vector(C_M_AXI_DATA_WIDTH - 1  downto  0);
      M_AXI_RRESP : in std_logic_vector(1  downto  0);
      M_AXI_RLAST : in std_logic;
      M_AXI_AWREADY : in std_logic;
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWADDR : out std_logic_vector(C_M_AXI_ADDR_WIDTH - 1  downto  0);
      M_AXI_AWLEN : out std_logic_vector(7  downto  0);
      M_AXI_AWSIZE : out std_logic_vector(2  downto  0);
      M_AXI_AWBURST : out std_logic_vector(1  downto  0);
      M_AXI_AWPROT : out std_logic_vector(2  downto  0);
      M_AXI_WREADY : in std_logic;
      M_AXI_WVALID : out std_logic;
      M_AXI_WDATA : out std_logic_vector(C_M_AXI_DATA_WIDTH - 1  downto  0);
      M_AXI_WSTRB : out std_logic_vector(C_M_AXI_DATA_WIDTH / 8 - 1  downto  0);
      M_AXI_WLAST : out std_logic;
      M_AXI_BREADY : out std_logic;
      M_AXI_BVALID : in std_logic;
      M_AXI_BRESP : in std_logic_vector(1  downto  0);
      M_AXI_AWCACHE : out std_logic_vector(3  downto  0);
      M_AXI_ARCACHE : out std_logic_vector(3  downto  0);
      M_AXI_AWUSER : out std_logic_vector(4  downto  0);
      M_AXI_ARUSER : out std_logic_vector(4  downto  0);
      DEBUG : out std_logic_vector(67  downto  0)
    );
  end component;

begin

  reconos_memif_memory_controller_0 : reconos_memif_memory_controller
    generic map (
      C_M_AXI_ADDR_WIDTH => 32,
      C_M_AXI_DATA_WIDTH => 32,
      C_MAX_BURST_LEN => 64,
      C_MEMIF_DATA_WIDTH => 32
    )
    port map (
      MEMIF_Hwt2Mem_In_Data => MEMIF_Hwt2Mem_In_Data,
      MEMIF_Hwt2Mem_In_Empty => MEMIF_Hwt2Mem_In_Empty,
      MEMIF_Hwt2Mem_In_RE => MEMIF_Hwt2Mem_In_RE,
      MEMIF_Mem2Hwt_In_Data => MEMIF_Mem2Hwt_In_Data,
      MEMIF_Mem2Hwt_In_Full => MEMIF_Mem2Hwt_In_Full,
      MEMIF_Mem2Hwt_In_WE => MEMIF_Mem2Hwt_In_WE,
      M_AXI_ACLK => M_AXI_ACLK,
      M_AXI_ARESETN => M_AXI_ARESETN,
      M_AXI_ARREADY => M_AXI_ARREADY,
      M_AXI_ARVALID => M_AXI_ARVALID,
      M_AXI_ARADDR => M_AXI_ARADDR,
      M_AXI_ARLEN => M_AXI_ARLEN,
      M_AXI_ARSIZE => M_AXI_ARSIZE,
      M_AXI_ARBURST => M_AXI_ARBURST,
      M_AXI_ARPROT => M_AXI_ARPROT,
      M_AXI_RREADY => M_AXI_RREADY,
      M_AXI_RVALID => M_AXI_RVALID,
      M_AXI_RDATA => M_AXI_RDATA,
      M_AXI_RRESP => M_AXI_RRESP,
      M_AXI_RLAST => M_AXI_RLAST,
      M_AXI_AWREADY => M_AXI_AWREADY,
      M_AXI_AWVALID => M_AXI_AWVALID,
      M_AXI_AWADDR => M_AXI_AWADDR,
      M_AXI_AWLEN => M_AXI_AWLEN,
      M_AXI_AWSIZE => M_AXI_AWSIZE,
      M_AXI_AWBURST => M_AXI_AWBURST,
      M_AXI_AWPROT => M_AXI_AWPROT,
      M_AXI_WREADY => M_AXI_WREADY,
      M_AXI_WVALID => M_AXI_WVALID,
      M_AXI_WDATA => M_AXI_WDATA,
      M_AXI_WSTRB => M_AXI_WSTRB,
      M_AXI_WLAST => M_AXI_WLAST,
      M_AXI_BREADY => M_AXI_BREADY,
      M_AXI_BVALID => M_AXI_BVALID,
      M_AXI_BRESP => M_AXI_BRESP,
      M_AXI_AWCACHE => M_AXI_AWCACHE,
      M_AXI_ARCACHE => M_AXI_ARCACHE,
      M_AXI_AWUSER => M_AXI_AWUSER,
      M_AXI_ARUSER => M_AXI_ARUSER,
      DEBUG => DEBUG
    );

end architecture STRUCTURE;


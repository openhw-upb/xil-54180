-------------------------------------------------------------------------------
-- system_reconos_proc_control_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library reconos_proc_control_v1_00_a;
use reconos_proc_control_v1_00_a.all;

entity system_reconos_proc_control_0_wrapper is
  port (
    PROC_Hwt_Rst_0 : out std_logic;
    PROC_Hwt_Signal_0 : out std_logic;
    PROC_Sys_Rst : out std_logic;
    PROC_Pgf_Int : out std_logic;
    MMU_Pgf : in std_logic;
    MMU_Fault_Addr : in std_logic_vector(31 downto 0);
    MMU_Retry : out std_logic;
    MMU_Pgd : out std_logic_vector(31 downto 0);
    MMU_Tlb_Hits : in std_logic_vector(31 downto 0);
    MMU_Tlb_Misses : in std_logic_vector(31 downto 0);
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
end system_reconos_proc_control_0_wrapper;

architecture STRUCTURE of system_reconos_proc_control_0_wrapper is

  component reconos_proc_control is
    generic (
      C_NUM_HWTS : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_MIN_SIZE : std_logic_vector;
      C_USE_WSTRB : INTEGER;
      C_DPHASE_TIMEOUT : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_FAMILY : STRING;
      C_NUM_REG : INTEGER;
      C_NUM_MEM : INTEGER;
      C_SLV_AWIDTH : INTEGER;
      C_SLV_DWIDTH : INTEGER
    );
    port (
      PROC_Hwt_Rst_0 : out std_logic;
      PROC_Hwt_Signal_0 : out std_logic;
      PROC_Sys_Rst : out std_logic;
      PROC_Pgf_Int : out std_logic;
      MMU_Pgf : in std_logic;
      MMU_Fault_Addr : in std_logic_vector(31 downto 0);
      MMU_Retry : out std_logic;
      MMU_Pgd : out std_logic_vector(31 downto 0);
      MMU_Tlb_Hits : in std_logic_vector(31 downto 0);
      MMU_Tlb_Misses : in std_logic_vector(31 downto 0);
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

  reconos_proc_control_0 : reconos_proc_control
    generic map (
      C_NUM_HWTS => 1,
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001ff",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"6fe00000",
      C_HIGHADDR => X"6fe0ffff",
      C_FAMILY => "zynq",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      PROC_Hwt_Rst_0 => PROC_Hwt_Rst_0,
      PROC_Hwt_Signal_0 => PROC_Hwt_Signal_0,
      PROC_Sys_Rst => PROC_Sys_Rst,
      PROC_Pgf_Int => PROC_Pgf_Int,
      MMU_Pgf => MMU_Pgf,
      MMU_Fault_Addr => MMU_Fault_Addr,
      MMU_Retry => MMU_Retry,
      MMU_Pgd => MMU_Pgd,
      MMU_Tlb_Hits => MMU_Tlb_Hits,
      MMU_Tlb_Misses => MMU_Tlb_Misses,
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


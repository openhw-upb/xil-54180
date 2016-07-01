-------------------------------------------------------------------------------
-- system_reconos_memif_mmu_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library reconos_memif_mmu_zynq_v1_00_a;
use reconos_memif_mmu_zynq_v1_00_a.all;

entity system_reconos_memif_mmu_0_wrapper is
  port (
    MEMIF_Hwt2Mem_In_Data : in std_logic_vector(31 downto 0);
    MEMIF_Hwt2Mem_In_Empty : in std_logic;
    MEMIF_Hwt2Mem_In_RE : out std_logic;
    MEMIF_Mem2Hwt_In_Data : out std_logic_vector(31 downto 0);
    MEMIF_Mem2Hwt_In_Full : in std_logic;
    MEMIF_Mem2Hwt_In_WE : out std_logic;
    MEMIF_Hwt2Mem_Out_Data : out std_logic_vector(31 downto 0);
    MEMIF_Hwt2Mem_Out_Empty : out std_logic;
    MEMIF_Hwt2Mem_Out_RE : in std_logic;
    MEMIF_Mem2Hwt_Out_Data : in std_logic_vector(31 downto 0);
    MEMIF_Mem2Hwt_Out_Full : out std_logic;
    MEMIF_Mem2Hwt_Out_WE : in std_logic;
    MMU_Pgf : out std_logic;
    MMU_Fault_Addr : out std_logic_vector(31 downto 0);
    MMU_Retry : in std_logic;
    MMU_Pgd : in std_logic_vector(31 downto 0);
    SYS_Clk : in std_logic;
    SYS_Rst : in std_logic
  );
end system_reconos_memif_mmu_0_wrapper;

architecture STRUCTURE of system_reconos_memif_mmu_0_wrapper is

  component reconos_memif_mmu_zynq is
    generic (
      C_TLB_SIZE : INTEGER;
      C_MEMIF_DATA_WIDTH : INTEGER
    );
    port (
      MEMIF_Hwt2Mem_In_Data : in std_logic_vector(C_MEMIF_DATA_WIDTH - 1  downto  0);
      MEMIF_Hwt2Mem_In_Empty : in std_logic;
      MEMIF_Hwt2Mem_In_RE : out std_logic;
      MEMIF_Mem2Hwt_In_Data : out std_logic_vector(C_MEMIF_DATA_WIDTH - 1  downto  0);
      MEMIF_Mem2Hwt_In_Full : in std_logic;
      MEMIF_Mem2Hwt_In_WE : out std_logic;
      MEMIF_Hwt2Mem_Out_Data : out std_logic_vector(C_MEMIF_DATA_WIDTH - 1  downto  0);
      MEMIF_Hwt2Mem_Out_Empty : out std_logic;
      MEMIF_Hwt2Mem_Out_RE : in std_logic;
      MEMIF_Mem2Hwt_Out_Data : in std_logic_vector(C_MEMIF_DATA_WIDTH - 1  downto  0);
      MEMIF_Mem2Hwt_Out_Full : out std_logic;
      MEMIF_Mem2Hwt_Out_WE : in std_logic;
      MMU_Pgf : out std_logic;
      MMU_Fault_Addr : out std_logic_vector(31 downto 0);
      MMU_Retry : in std_logic;
      MMU_Pgd : in std_logic_vector(31 downto 0);
      SYS_Clk : in std_logic;
      SYS_Rst : in std_logic
    );
  end component;

begin

  reconos_memif_mmu_0 : reconos_memif_mmu_zynq
    generic map (
      C_TLB_SIZE => 16,
      C_MEMIF_DATA_WIDTH => 32
    )
    port map (
      MEMIF_Hwt2Mem_In_Data => MEMIF_Hwt2Mem_In_Data,
      MEMIF_Hwt2Mem_In_Empty => MEMIF_Hwt2Mem_In_Empty,
      MEMIF_Hwt2Mem_In_RE => MEMIF_Hwt2Mem_In_RE,
      MEMIF_Mem2Hwt_In_Data => MEMIF_Mem2Hwt_In_Data,
      MEMIF_Mem2Hwt_In_Full => MEMIF_Mem2Hwt_In_Full,
      MEMIF_Mem2Hwt_In_WE => MEMIF_Mem2Hwt_In_WE,
      MEMIF_Hwt2Mem_Out_Data => MEMIF_Hwt2Mem_Out_Data,
      MEMIF_Hwt2Mem_Out_Empty => MEMIF_Hwt2Mem_Out_Empty,
      MEMIF_Hwt2Mem_Out_RE => MEMIF_Hwt2Mem_Out_RE,
      MEMIF_Mem2Hwt_Out_Data => MEMIF_Mem2Hwt_Out_Data,
      MEMIF_Mem2Hwt_Out_Full => MEMIF_Mem2Hwt_Out_Full,
      MEMIF_Mem2Hwt_Out_WE => MEMIF_Mem2Hwt_Out_WE,
      MMU_Pgf => MMU_Pgf,
      MMU_Fault_Addr => MMU_Fault_Addr,
      MMU_Retry => MMU_Retry,
      MMU_Pgd => MMU_Pgd,
      SYS_Clk => SYS_Clk,
      SYS_Rst => SYS_Rst
    );

end architecture STRUCTURE;


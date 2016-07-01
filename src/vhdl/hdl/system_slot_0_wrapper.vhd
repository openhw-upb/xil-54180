-------------------------------------------------------------------------------
-- system_slot_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library rt_feature_extraction_manager_v1_00_a;
use rt_feature_extraction_manager_v1_00_a.all;

entity system_slot_0_wrapper is
  port (
    OSIF_Sw2Hw_Data : in std_logic_vector(31 downto 0);
    OSIF_Sw2Hw_Empty : in std_logic;
    OSIF_Sw2Hw_RE : out std_logic;
    OSIF_Hw2Sw_Data : out std_logic_vector(31 downto 0);
    OSIF_Hw2Sw_Full : in std_logic;
    OSIF_Hw2Sw_WE : out std_logic;
    MEMIF_Hwt2Mem_Data : out std_logic_vector(31 downto 0);
    MEMIF_Hwt2Mem_Full : in std_logic;
    MEMIF_Hwt2Mem_WE : out std_logic;
    MEMIF_Mem2Hwt_Data : in std_logic_vector(31 downto 0);
    MEMIF_Mem2Hwt_Empty : in std_logic;
    MEMIF_Mem2Hwt_RE : out std_logic;
    HWT_Clk : in std_logic;
    HWT_Rst : in std_logic;
    HWT_Signal : in std_logic
  );
end system_slot_0_wrapper;

architecture STRUCTURE of system_slot_0_wrapper is

  component rt_feature_extraction_manager is
    port (
      OSIF_Sw2Hw_Data : in std_logic_vector(31 downto 0);
      OSIF_Sw2Hw_Empty : in std_logic;
      OSIF_Sw2Hw_RE : out std_logic;
      OSIF_Hw2Sw_Data : out std_logic_vector(31 downto 0);
      OSIF_Hw2Sw_Full : in std_logic;
      OSIF_Hw2Sw_WE : out std_logic;
      MEMIF_Hwt2Mem_Data : out std_logic_vector(31 downto 0);
      MEMIF_Hwt2Mem_Full : in std_logic;
      MEMIF_Hwt2Mem_WE : out std_logic;
      MEMIF_Mem2Hwt_Data : in std_logic_vector(31 downto 0);
      MEMIF_Mem2Hwt_Empty : in std_logic;
      MEMIF_Mem2Hwt_RE : out std_logic;
      HWT_Clk : in std_logic;
      HWT_Rst : in std_logic;
      HWT_Signal : in std_logic
    );
  end component;

begin

  slot_0 : rt_feature_extraction_manager
    port map (
      OSIF_Sw2Hw_Data => OSIF_Sw2Hw_Data,
      OSIF_Sw2Hw_Empty => OSIF_Sw2Hw_Empty,
      OSIF_Sw2Hw_RE => OSIF_Sw2Hw_RE,
      OSIF_Hw2Sw_Data => OSIF_Hw2Sw_Data,
      OSIF_Hw2Sw_Full => OSIF_Hw2Sw_Full,
      OSIF_Hw2Sw_WE => OSIF_Hw2Sw_WE,
      MEMIF_Hwt2Mem_Data => MEMIF_Hwt2Mem_Data,
      MEMIF_Hwt2Mem_Full => MEMIF_Hwt2Mem_Full,
      MEMIF_Hwt2Mem_WE => MEMIF_Hwt2Mem_WE,
      MEMIF_Mem2Hwt_Data => MEMIF_Mem2Hwt_Data,
      MEMIF_Mem2Hwt_Empty => MEMIF_Mem2Hwt_Empty,
      MEMIF_Mem2Hwt_RE => MEMIF_Mem2Hwt_RE,
      HWT_Clk => HWT_Clk,
      HWT_Rst => HWT_Rst,
      HWT_Signal => HWT_Signal
    );

end architecture STRUCTURE;


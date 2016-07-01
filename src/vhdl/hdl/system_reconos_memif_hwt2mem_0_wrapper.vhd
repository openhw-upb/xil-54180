-------------------------------------------------------------------------------
-- system_reconos_memif_hwt2mem_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library reconos_fifo_sync_v1_00_a;
use reconos_fifo_sync_v1_00_a.all;

entity system_reconos_memif_hwt2mem_0_wrapper is
  port (
    FIFO_S_Data : out std_logic_vector(31 downto 0);
    FIFO_S_Fill : out std_logic_vector(7 downto 0);
    FIFO_S_Empty : out std_logic;
    FIFO_S_AEmpty : out std_logic;
    FIFO_S_RE : in std_logic;
    FIFO_M_Data : in std_logic_vector(31 downto 0);
    FIFO_M_Remm : out std_logic_vector(7 downto 0);
    FIFO_M_Full : out std_logic;
    FIFO_M_AFull : out std_logic;
    FIFO_M_WE : in std_logic;
    FIFO_Clk : in std_logic;
    FIFO_Rst : in std_logic;
    FIFO_Has_data : out std_logic
  );
end system_reconos_memif_hwt2mem_0_wrapper;

architecture STRUCTURE of system_reconos_memif_hwt2mem_0_wrapper is

  component reconos_fifo_sync is
    generic (
      C_FIFO_DATA_WIDTH : INTEGER;
      C_FIFO_ADDR_WIDTH : INTEGER;
      C_USE_ALMOST : BOOLEAN;
      C_USE_FILLREMM : BOOLEAN;
      C_FIFO_AEMPTY : INTEGER;
      C_FIFO_AFULL : INTEGER
    );
    port (
      FIFO_S_Data : out std_logic_vector(C_FIFO_DATA_WIDTH - 1  downto  0);
      FIFO_S_Fill : out std_logic_vector(C_FIFO_ADDR_WIDTH  downto  0);
      FIFO_S_Empty : out std_logic;
      FIFO_S_AEmpty : out std_logic;
      FIFO_S_RE : in std_logic;
      FIFO_M_Data : in std_logic_vector(C_FIFO_DATA_WIDTH - 1  downto  0);
      FIFO_M_Remm : out std_logic_vector(C_FIFO_ADDR_WIDTH  downto  0);
      FIFO_M_Full : out std_logic;
      FIFO_M_AFull : out std_logic;
      FIFO_M_WE : in std_logic;
      FIFO_Clk : in std_logic;
      FIFO_Rst : in std_logic;
      FIFO_Has_data : out std_logic
    );
  end component;

begin

  reconos_memif_hwt2mem_0 : reconos_fifo_sync
    generic map (
      C_FIFO_DATA_WIDTH => 32,
      C_FIFO_ADDR_WIDTH => 7,
      C_USE_ALMOST => false,
      C_USE_FILLREMM => false,
      C_FIFO_AEMPTY => 2,
      C_FIFO_AFULL => 2
    )
    port map (
      FIFO_S_Data => FIFO_S_Data,
      FIFO_S_Fill => FIFO_S_Fill,
      FIFO_S_Empty => FIFO_S_Empty,
      FIFO_S_AEmpty => FIFO_S_AEmpty,
      FIFO_S_RE => FIFO_S_RE,
      FIFO_M_Data => FIFO_M_Data,
      FIFO_M_Remm => FIFO_M_Remm,
      FIFO_M_Full => FIFO_M_Full,
      FIFO_M_AFull => FIFO_M_AFull,
      FIFO_M_WE => FIFO_M_WE,
      FIFO_Clk => FIFO_Clk,
      FIFO_Rst => FIFO_Rst,
      FIFO_Has_data => FIFO_Has_data
    );

end architecture STRUCTURE;


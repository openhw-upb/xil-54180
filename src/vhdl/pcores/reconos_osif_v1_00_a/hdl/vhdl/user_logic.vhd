--                                                        ____  _____
--                            ________  _________  ____  / __ \/ ___/
--                           / ___/ _ \/ ___/ __ \/ __ \/ / / /\__ \
--                          / /  /  __/ /__/ /_/ / / / / /_/ /___/ /
--                         /_/   \___/\___/\____/_/ /_/\____//____/
-- 
-- ======================================================================
--
--   title:        IP-Core - OSIF - Top level entity
--
--   project:      ReconOS
--   author:       Christoph Rüthing, University of Paderborn
--   description:  A AXI slave which maps the FIFOs of the HWTs to
--                 registers accessible from the AXI-Bus.
--                   Reg0: Read data
--                   Reg1: Write data
--                   Reg2: Fill - number of elements in receive-FIFO
--                   Reg3: Rem - free space in send-FIFO
--
-- ======================================================================



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_logic is
	--
	-- Generic definitions
	--
	--   C_NUM_HWTS - number of hardware threads
	--
	--   C_OSIF_DATA_WIDTH   - width of the osif
	--   C_OSIF_LENGTH_WIDTH - width of the length in command word
	--   C_OSIF_OP_WIDTH     - width of the operation in command word
	--
	generic (
		C_NUM_HWTS : integer := 1;

		C_OSIF_DATA_WIDTH   : integer := 32;
		C_OSIF_LENGTH_WIDTH : integer := 24;
		C_OSIF_OP_WIDTH     : integer := 8
	);

	--
	-- Port defintions
	--
	--   OSIF_Hw2Sw_#i#_In_/OSIF_Sw2Hw_#i#_In_ - fifo signal inputs
	--
	--   BUS2IP_/IP2BUS_ - axi ipif signals
	--
	port (
				OSIF_Hw2Sw_0_In_Data  : in  std_logic_vector(C_OSIF_DATA_WIDTH - 1 downto 0);
		OSIF_Hw2Sw_0_In_Empty : in  std_logic;
		OSIF_Hw2Sw_0_In_RE    : out std_logic;
		


				OSIF_Sw2Hw_0_In_Data  : out std_logic_vector(C_OSIF_DATA_WIDTH - 1 downto 0);
		OSIF_Sw2Hw_0_In_Full  : in  std_logic;
		OSIF_Sw2Hw_0_In_WE    : out std_logic;
		


		BUS2IP_Clk    : in  std_logic;
		BUS2IP_Resetn : in  std_logic;
		BUS2IP_Data   : in  std_logic_vector(31 downto 0);
		BUS2IP_CS     : in  std_logic_vector(C_NUM_HWTS - 1 downto 0);
		BUS2IP_RdCE   : in  std_logic_vector(C_NUM_HWTS * 4 - 1 downto 0);
		BUS2IP_WrCE   : in  std_logic_vector(C_NUM_HWTS * 4 - 1 downto 0);
		IP2BUS_Data   : out std_logic_vector(31 downto 0);
		IP2BUS_RdAck  : out std_logic;
		IP2BUS_WrAck  : out std_logic;
		IP2BUS_Error  : out std_logic
	);
end entity user_logic;

architecture imp of user_logic is

begin

	-- == Access of fifos =================================================

		OSIF_Hw2Sw_0_In_RE <= BUS2IP_RdCE((C_NUM_HWTS - 0) * 4 - 1);
	

		OSIF_Sw2Hw_0_In_Data <= BUS2IP_Data;
	OSIF_Sw2Hw_0_In_WE   <= BUS2IP_WrCE((C_NUM_HWTS - 0) * 4 - 2);
	


	IP2BUS_Data <=
	  	  (OSIF_Hw2Sw_0_In_Data and (OSIF_Hw2SW_0_In_Data'Range => BUS2IP_RdCE((C_NUM_HWTS - 0) * 4 - 1))) or
	  (OSIF_Hw2Sw_0_In_Empty & "000" & x"0000000"  and (OSIF_Hw2SW_0_In_Data'Range => BUS2IP_RdCE((C_NUM_HWTS - 0) * 4 - 3))) or
	  (OSIF_Sw2Hw_0_In_Full & "000" & x"0000000"  and (OSIF_Hw2SW_0_In_Data'Range => BUS2IP_RdCE((C_NUM_HWTS - 0) * 4 - 4))) or
	  

	  (31 downto 0 => '0');

	IP2BUS_RdAck <= 
	  	  BUS2IP_CS(0) or
	  
	  '0';

	IP2BUS_WrAck <= 
	  	  BUS2IP_CS(0) or
	  
	  '0';

	IP2BUS_Error <= '0';
end architecture imp;
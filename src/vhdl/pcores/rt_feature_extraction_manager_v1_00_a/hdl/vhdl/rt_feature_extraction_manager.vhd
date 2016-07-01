library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use ieee.NUMERIC_STD.all;

library reconos_v3_01_a;
use reconos_v3_01_a.reconos_pkg.all;

library rt_feature_extraction_manager_v1_00_a;
use rt_feature_extraction_manager_v1_00_a.reconos_thread_pkg.all;

entity rt_feature_extraction_manager is
	
	generic (
		G_NBR_FEATURE_EXTRACTORS : integer := 4
	);

	port (
		-- OSIF FIFO ports
		OSIF_Sw2Hw_Data    : in  std_logic_vector(31 downto 0);
		OSIF_Sw2Hw_Empty   : in  std_logic;
		OSIF_Sw2Hw_RE      : out std_logic;

		OSIF_Hw2Sw_Data    : out std_logic_vector(31 downto 0);
		OSIF_Hw2Sw_Full    : in  std_logic;
		OSIF_Hw2Sw_WE      : out std_logic;

		-- MEMIF FIFO ports
		MEMIF_Hwt2Mem_Data    : out std_logic_vector(31 downto 0);
		MEMIF_Hwt2Mem_Full    : in  std_logic;
		MEMIF_Hwt2Mem_WE      : out std_logic;

		MEMIF_Mem2Hwt_Data    : in  std_logic_vector(31 downto 0);
		MEMIF_Mem2Hwt_Empty   : in  std_logic;
		MEMIF_Mem2Hwt_RE      : out std_logic;

		HWT_Clk    : in  std_logic;
		HWT_Rst    : in  std_logic;
		HWT_Signal : in  std_logic
		
		--DEBUG : out std_logic_vector(110 downto 0)
	);
end entity;

architecture implementation of rt_feature_extraction_manager is
	
	-- States for initialization, sample acquisition and handling
	type STATE_TYPE is (STATE_INIT,
						STATE_ENABLE_EXTRACTORS,
						STATE_GET_NBR_CHANNELS_NBR_FEATURES,
						STATE_GET_WIN_SIZE,
						STATE_SET_THRESHOLD_ZC,
						STATE_GET_START_ADDR_SAMPLE_WIN,
						STATE_GET_START_ADDR_FEAT_WIN,
						STATE_GET_ID_CLASS_OFFSET,
						STATE_ACQUIRE_SAMPLE_WINDOW_1,
						STATE_ACQUIRE_SAMPLE_WINDOW_2,
						STATE_ASSIGN_FIRST_ADDRESS,
						STATE_GET_AND_PASS_SAMPLE,
						STATE_CHECK_CHANNEL_COUNTER,
						STATE_WAIT_4_ACK,
						STATE_WRITE_BACK_FEATURES_2_MM,
						STATE_PASS_ID_CLASS,
						STATE_THREAD_EXIT,
						STATE_ERROR);

	-- States for feature handling
	type STATE_WRITE_BACK_TYPE is (	STATE_INIT,
									STATE_READ_FIFO_MAV,
									STATE_READ_FIFO_SSC,
									STATE_READ_FIFO_WFL,
									STATE_READ_FIFO_ZC,
									STATE_WAIT_4_FEATURES_WRITTEN_BACK_2_MM);

	-- FIFOs are used for communication between FEM and FE
	component reconos_fifo_sync is
		generic (
			C_FIFO_DATA_WIDTH : integer := 32;
			C_FIFO_ADDR_WIDTH : integer := 4;

			C_USE_ALMOST    : boolean := false;
			C_USE_FILL_REMM : boolean := false;
			C_FIFO_AEMPTY   : integer := 2;
			C_FIFO_AFULL    : integer := 2
		);

		port (
			FIFO_S_Data   : out std_logic_vector(C_FIFO_DATA_WIDTH - 1 downto 0);
			FIFO_S_Fill   : out std_logic_vector(C_FIFO_ADDR_WIDTH downto 0);
			FIFO_S_Empty  : out std_logic;
			FIFO_S_AEmpty : out std_logic;
			FIFO_S_RE     : in  std_logic;

			FIFO_M_Data   : in  std_logic_vector(C_FIFO_DATA_WIDTH - 1 downto 0);
			FIFO_M_Remm   : out std_logic_vector(C_FIFO_ADDR_WIDTH downto 0);
			FIFO_M_Full   : out std_logic;
			FIFO_M_AFull  : out std_logic;
			FIFO_M_WE     : in  std_logic;

			FIFO_Clk      : in  std_logic;
			FIFO_Rst      : in  std_logic;
			FIFO_Has_Data : out std_logic
		);
	end component;

	-- Feature-Extractor: Mean-Absolute-Value
	component fe_mav is
		port (
		    ap_clk : IN STD_LOGIC;
		    ap_rst : IN STD_LOGIC;
		    sampleFifo_V_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
		    sampleFifo_V_V_empty_n : IN STD_LOGIC;
		    sampleFifo_V_V_read : OUT STD_LOGIC;
		    featureFifo_V_V_din : OUT STD_LOGIC_VECTOR (31 downto 0);
		    featureFifo_V_V_full_n : IN STD_LOGIC;
		    featureFifo_V_V_write : OUT STD_LOGIC;
		    windowSize_V : IN STD_LOGIC_VECTOR (7 downto 0) 
	    );
	end component;
		
	-- Feature-Extractor: Slope-Sign-Changes
	component fe_ssc is
		port (
		    ap_clk : IN STD_LOGIC;
		    ap_rst : IN STD_LOGIC;
		    sampleFifo_V_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
		    sampleFifo_V_V_empty_n : IN STD_LOGIC;
		    sampleFifo_V_V_read : OUT STD_LOGIC;
		    featureFifo_V_V_din : OUT STD_LOGIC_VECTOR (31 downto 0);
		    featureFifo_V_V_full_n : IN STD_LOGIC;
		    featureFifo_V_V_write : OUT STD_LOGIC;
		    windowSize_V : IN STD_LOGIC_VECTOR (7 downto 0)
		    );
	end component;

	-- Feature-Extractor: Waveformlength
	component fe_wfl is
		port (
		    ap_clk : IN STD_LOGIC;
		    ap_rst : IN STD_LOGIC;
		    sampleFifo_V_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
		    sampleFifo_V_V_empty_n : IN STD_LOGIC;
		    sampleFifo_V_V_read : OUT STD_LOGIC;
		    featureFifo_V_V_din : OUT STD_LOGIC_VECTOR (31 downto 0);
		    featureFifo_V_V_full_n : IN STD_LOGIC;
		    featureFifo_V_V_write : OUT STD_LOGIC;
		    windowSize_V : IN STD_LOGIC_VECTOR (7 downto 0)
	   );
	end component;

	-- Feature-Extractor: Zero-Crossings
	component fe_zc is
		port (
		    ap_clk : IN STD_LOGIC;
		    ap_rst : IN STD_LOGIC;
		    sampleFifo_V_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
		    sampleFifo_V_V_empty_n : IN STD_LOGIC;
		    sampleFifo_V_V_read : OUT STD_LOGIC;
		    featureFifo_V_V_din : OUT STD_LOGIC_VECTOR (31 downto 0);
		    featureFifo_V_V_full_n : IN STD_LOGIC;
		    featureFifo_V_V_write : OUT STD_LOGIC;
		    windowSize_V : IN STD_LOGIC_VECTOR (7 downto 0);
		    threshold_V : IN STD_LOGIC_VECTOR (31 downto 0)
	   );
	end component;

	-- IMPORTANT: define size of local RAM here!!!!
	-- One RAM for one Sample-Window at a time
	-- Max. #Elements in RAM: 256 channels * 150 samples per window = 38400
	-- But one sample has 16 bit, therefore we can store 2 samples at one RAM-Address
	-- => Max. stored words = 256 channels * 150 samples per window / 2 = 19200
	-- FOR SIMULATION A RAM-SIZE MUST BE POWER OF 2
	constant C_LOCAL_RAM_SAMPLES_SIZE          : integer := 19200;
	constant C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH : integer := integer(ceil(log2(real(C_LOCAL_RAM_SAMPLES_SIZE))));
	constant C_LOCAL_RAM_SAMPLES_SIZE_IN_BYTES : integer := 4*C_LOCAL_RAM_SAMPLES_SIZE;

	constant C_LOCAL_RAM_FEATURES_SIZE          : integer := 1024;
	constant C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH : integer := integer(ceil(log2(real(C_LOCAL_RAM_FEATURES_SIZE))));
	constant C_LOCAL_RAM_FEATURES_SIZE_IN_BYTES : integer := 4*C_LOCAL_RAM_FEATURES_SIZE;

	type LOCAL_MEMORY_SAMPLES_T is array (0 to C_LOCAL_RAM_SAMPLES_SIZE-1) of std_logic_vector(31 downto 0);
	type LOCAL_MEMORY_FEATURES_T is array (0 to C_LOCAL_RAM_FEATURES_SIZE-1) of std_logic_vector(31 downto 0);

	signal i_osif   			: i_osif_t;
	signal o_osif   			: o_osif_t;
	signal i_memif  			: i_memif_t;
	signal o_memif  			: o_memif_t;
	signal i_ram_samples_memif 	: i_ram_t;
	signal o_ram_samples_memif 	: o_ram_t;
	signal i_ram_features_memif : i_ram_t;
	signal o_ram_features_memif : o_ram_t;

	signal o_RAMAddr_samples   		: std_logic_vector(0 to C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH-1)  := (others=>'0');
	signal o_RAMAddr_samples_2 		: std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMData_samples   		: std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMWE_samples     		: std_logic := '0';
	signal i_RAMData_samples   		: std_logic_vector(0 to 31) := (others=>'0');

	signal o_RAMAddr_samples_memif   : std_logic_vector(0 to C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH-1)  := (others=>'0');
	signal o_RAMAddr_samples_2_memif : std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMData_samples_memif   : std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMWE_samples_memif     : std_logic := '0';
	signal i_RAMData_samples_memif   : std_logic_vector(0 to 31) := (others=>'0');

	signal o_RAMAddr_features   : std_logic_vector(0 to C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH-1) := (others=>'0');
	signal o_RAMAddr_features_2 : std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMData_features   : std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMWE_features     : std_logic := '0';
	signal i_RAMData_features   : std_logic_vector(0 to 31) := (others=>'0');
	
	signal o_RAMAddr_features_memif   : std_logic_vector(0 to C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH-1) := (others=>'0');
	signal o_RAMAddr_features_2_memif : std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMData_features_memif   : std_logic_vector(0 to 31) := (others=>'0');
	signal o_RAMWE_features_memif     : std_logic := '0';
	signal i_RAMData_features_memif   : std_logic_vector(0 to 31) := (others=>'0');
	
	shared variable local_ram_samples : LOCAL_MEMORY_SAMPLES_T;
	shared variable local_ram_features : LOCAL_MEMORY_FEATURES_T;

	-- Constants for Feature-Extracor selection
	constant C_POS_FLAG_MAV 	: integer := 0;
	constant C_POS_FLAG_SSC 	: integer := 1;
	constant C_POS_FLAG_WFL 	: integer := 2;
	constant C_POS_FLAG_ZC 		: integer := 3;

	signal extractor_selector						: std_logic_vector(31 downto 0) := (others=>'0');
	signal nbr_channels_nbr_features				: std_logic_vector(31 downto 0) := (others=>'0');	-- [31...(#Channels)...16, 15...(#Features)...0]
	signal nbr_features 							: std_logic_vector(15 downto 0) := (others=>'0'); 	-- Is counted down for address calculation
	signal window_size								: std_logic_vector(31 downto 0) := (others=>'0');	-- Size of sample-window in samples
	signal cnt_samples								: std_logic_vector(7 downto 0) := (others=>'0');	-- Signal to count passed samples from RAM to FE per channel
	signal cnt_channels								: std_logic_vector(7 downto 0) := (others=>'0');	-- Signal to count channels. Incremented after all samples of a channel have been passed from RAM to FE
	signal threshold_4_zc							: std_logic_vector(31 downto 0) := (others=>'0');	-- Threshold for zero-crossing feature (value of sample must be above the threshold, o.t. it's noise)
	signal start_addr_feature_window				: std_logic_vector(31 downto 0) := (others=>'0');	-- Start-address of memory for features in main-memory
	signal len_feature_window						: std_logic_vector(31 downto 0) := (others=>'0');	-- length of feature-window in main-memory (calculated in bytes)
	signal start_addr_sample_window_1				: std_logic_vector(31 downto 0) := (others=>'0');	-- Start-address of first part of sample-window
	signal start_addr_sample_window_2				: std_logic_vector(31 downto 0) := (others=>'0');	-- Start-address of second part of sample-window
	signal start_addr_sample_window_ram				: std_logic_vector(31 downto 0) := (others=>'0');	-- Gives address for storing samples in RAM
	signal len_sample_window_1						: std_logic_vector(31 downto 0) := (others=>'0');	-- Length of first part of sample-window (calculated in bytes, but only half of #samples * #channels, since 2 channels are stored in one 32-bit word)
	signal elements_sample_window_1					: std_logic_vector(31 downto 0) := (others=>'0');	-- #elements in first sample-window
	signal len_sample_window_2						: std_logic_vector(31 downto 0) := (others=>'0');	-- Length of second part of sample-window (calculated in bytes, but only half of #samples * #channels, since 2 channels are stored in one 32-bit word)
	signal elements_sample_window_2					: std_logic_vector(31 downto 0) := (others=>'0');	-- #elements in second sample-window
	signal elements_sample_window					: std_logic_vector(31 downto 0) := (others=>'0');	-- #elements in complete sample-window (#samples*#channels)
	signal elements_2_next_sample_in_sample_window	: std_logic_vector(31 downto 0) := (others=>'0');	-- Signal to calculate address of next sample in RAM (imagine RAM as array: #row=#samples, #cols=#channels/2(because 2 channes per 32-bit word); this signal is basically indexing the next row)
	signal id_class_offset 							: std_logic_vector(31 downto 0) := (others=>'0');	-- [31...(dontcare)...24,23...(offset)...16,15...(class)...8,7...(id)...0]

	-- Signals for RAMs and FIFOs
	signal feature_mav						: std_logic_vector(31 downto 0) := (others=>'0');
	signal feature_ssc						: std_logic_vector(31 downto 0) := (others=>'0');
	signal feature_wfl						: std_logic_vector(31 downto 0) := (others=>'0');
	signal feature_zc						: std_logic_vector(31 downto 0) := (others=>'0');
	signal fifo_sample_full 				: std_logic_vector(31 downto 0) := (others=>'0');
	signal fifo_sample_afull 				: std_logic_vector(31 downto 0) := (others=>'0');
	signal fifo_sample_we 					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fifo_feature_empty 				: std_logic_vector(31 downto 0) := (others=>'1');
	signal fifo_feature_re 					: std_logic_vector(31 downto 0) := (others=>'0');

	-- Signals between Feature-Extractors and FIFOs
	signal fe_feature_mav					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_feature_ssc					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_feature_wfl					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_feature_zc					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_sample_mav					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_sample_ssc					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_sample_wfl					: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_sample_zc						: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_fifo_sample_empty 			: std_logic_vector(31 downto 0) := (others=>'1');
	signal fe_fifo_sample_empty_n 			: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_fifo_sample_re 				: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_fifo_feature_full 			: std_logic_vector(31 downto 0) := (others=>'0');
	signal fe_fifo_feature_full_n 			: std_logic_vector(31 downto 0) := (others=>'1');
	signal fe_fifo_feature_we				: std_logic_vector(31 downto 0) := (others=>'0');
	
	signal collect_features						: std_logic := '0';
	signal ack_fe							: std_logic := '0';
	signal rst_fe							: std_logic := '0';

	signal state    			: STATE_TYPE := STATE_INIT;					-- State for OS-FSM
	signal state_write_back 	: STATE_WRITE_BACK_TYPE := STATE_INIT;		-- State for AUX-FSM

	signal ignore   : std_logic_vector(31 downto 0);

	signal pos_mav : std_logic_vector(15 downto 0) := (others=>'0');	-- Position of mav-feature in feature-RAM; also used as counter to check whether all mavs are calculated
	signal pos_ssc : std_logic_vector(15 downto 0) := (others=>'0');	-- Position of ssc-feature in feature-RAM; also used as counter to check whether all sscs are calculated
	signal pos_wfl : std_logic_vector(15 downto 0) := (others=>'0');	-- Position of wfl-feature in feature-RAM; also used as counter to check whether all wfls are calculated
	signal pos_zc : std_logic_vector(15 downto 0) := (others=>'0');		-- Position of zc-feature in feature-RAM; also used as counter to check whether all zcs are calculated

begin

	------------------------------------------------------------------------------------------------------------------------
	-- instantiate MAV
	------------------------------------------------------------------------------------------------------------------------
	

	fe_mav_inst : fe_mav
		port map(
			ap_clk 					=> HWT_Clk,
		    ap_rst 					=> rst_fe,
		    sampleFifo_V_V_dout		=> fe_sample_mav,
		    sampleFifo_V_V_empty_n 	=> fe_fifo_sample_empty_n(C_POS_FLAG_MAV),
		    sampleFifo_V_V_read 	=> fe_fifo_sample_re(C_POS_FLAG_MAV),
		    featureFifo_V_V_din 	=> fe_feature_mav,
		    featureFifo_V_V_full_n 	=> fe_fifo_feature_full_n(C_POS_FLAG_MAV),
		    featureFifo_V_V_write 	=> fe_fifo_feature_we(C_POS_FLAG_MAV),
		    windowSize_V 			=> window_size(7 downto 0)
		);

	-- instantiate FIFO modules
	fifo_mav_samples : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 4,

			C_USE_ALMOST    => true,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 1 -- Using almost full to see if the next value can be written or not. Otherwise the signal comes one clock too late.
		)

		port map(
			FIFO_S_Data   => fe_sample_mav,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fe_fifo_sample_empty(C_POS_FLAG_MAV),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fe_fifo_sample_re(C_POS_FLAG_MAV),

			FIFO_M_Data   => i_RAMData_samples,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fifo_sample_full(C_POS_FLAG_MAV),
			FIFO_M_AFull  => fifo_sample_afull(C_POS_FLAG_MAV),
			FIFO_M_WE     => fifo_sample_we(C_POS_FLAG_MAV),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	fifo_mav_features : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 3,

			C_USE_ALMOST    => false,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 2
		)

		port map(
			FIFO_S_Data   => feature_mav,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fifo_feature_empty(C_POS_FLAG_MAV),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fifo_feature_re(C_POS_FLAG_MAV),

			FIFO_M_Data   => fe_feature_mav,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fe_fifo_feature_full(C_POS_FLAG_MAV),
			FIFO_M_AFull  => open,
			FIFO_M_WE     => fe_fifo_feature_we(C_POS_FLAG_MAV),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	------------------------------------------------------------------------------------------------------------------------
	-- instantiate SSC
	------------------------------------------------------------------------------------------------------------------------
	fe_ssc_inst : fe_ssc
		port map(
			ap_clk 					=> HWT_Clk,
		    ap_rst 					=> rst_fe,
		    sampleFifo_V_V_dout		=> fe_sample_ssc,
		    sampleFifo_V_V_empty_n 	=> fe_fifo_sample_empty_n(C_POS_FLAG_SSC),
		    sampleFifo_V_V_read 	=> fe_fifo_sample_re(C_POS_FLAG_SSC),
		    featureFifo_V_V_din 	=> fe_feature_ssc,
		    featureFifo_V_V_full_n 	=> fe_fifo_feature_full_n(C_POS_FLAG_SSC),
		    featureFifo_V_V_write 	=> fe_fifo_feature_we(C_POS_FLAG_SSC),
		    windowSize_V 			=> window_size(7 downto 0)
		);

	-- instantiate FIFO modules
	fifo_ssc_samples : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 4,

			C_USE_ALMOST    => true,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 1 -- Using almost full to see if the next value can bve written or not. Otherwise the signal comes one clock too late.
		)

		port map(
			FIFO_S_Data   => fe_sample_ssc,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fe_fifo_sample_empty(C_POS_FLAG_SSC),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fe_fifo_sample_re(C_POS_FLAG_SSC),

			FIFO_M_Data   => i_RAMData_samples,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fifo_sample_full(C_POS_FLAG_SSC),
			FIFO_M_AFull  => fifo_sample_afull(C_POS_FLAG_SSC),
			FIFO_M_WE     => fifo_sample_we(C_POS_FLAG_SSC),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	fifo_ssc_features : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 3,

			C_USE_ALMOST    => false,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 2
		)

		port map(
			FIFO_S_Data   => feature_ssc,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fifo_feature_empty(C_POS_FLAG_SSC),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fifo_feature_re(C_POS_FLAG_SSC),

			FIFO_M_Data   => fe_feature_ssc,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fe_fifo_feature_full(C_POS_FLAG_SSC),
			FIFO_M_AFull  => open,
			FIFO_M_WE     => fe_fifo_feature_we(C_POS_FLAG_SSC),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	------------------------------------------------------------------------------------------------------------------------
	-- instantiate WFL
	------------------------------------------------------------------------------------------------------------------------
	fe_wfl_inst : fe_wfl
		port map(
			ap_clk 					=> HWT_Clk,
		    ap_rst 					=> rst_fe,
		    sampleFifo_V_V_dout		=> fe_sample_wfl,
		    sampleFifo_V_V_empty_n 	=> fe_fifo_sample_empty_n(C_POS_FLAG_WFL),
		    sampleFifo_V_V_read 	=> fe_fifo_sample_re(C_POS_FLAG_WFL),
		    featureFifo_V_V_din 	=> fe_feature_wfl,
		    featureFifo_V_V_full_n 	=> fe_fifo_feature_full_n(C_POS_FLAG_WFL),
		    featureFifo_V_V_write 	=> fe_fifo_feature_we(C_POS_FLAG_WFL),
		    windowSize_V 			=> window_size(7 downto 0)
		);

	-- instantiate FIFO modules
	fifo_wfl_samples : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 4,

			C_USE_ALMOST    => true,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 1 -- Using almost full to see if the next value can bve written or not. Otherwise the signal comes one clock too late.
		)

		port map(
			FIFO_S_Data   => fe_sample_wfl,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fe_fifo_sample_empty(C_POS_FLAG_WFL),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fe_fifo_sample_re(C_POS_FLAG_WFL),

			FIFO_M_Data   => i_RAMData_samples,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fifo_sample_full(C_POS_FLAG_WFL),
			FIFO_M_AFull  => fifo_sample_afull(C_POS_FLAG_WFL),
			FIFO_M_WE     => fifo_sample_we(C_POS_FLAG_WFL),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	fifo_wfl_features : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 3,

			C_USE_ALMOST    => false,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 2
		)

		port map(
			FIFO_S_Data   => feature_wfl,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fifo_feature_empty(C_POS_FLAG_WFL),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fifo_feature_re(C_POS_FLAG_WFL),

			FIFO_M_Data   => fe_feature_wfl,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fe_fifo_feature_full(C_POS_FLAG_WFL),
			FIFO_M_AFull  => open,
			FIFO_M_WE     => fe_fifo_feature_we(C_POS_FLAG_WFL),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	------------------------------------------------------------------------------------------------------------------------
	-- instantiate ZC
	------------------------------------------------------------------------------------------------------------------------
	 fe_zc_inst : fe_zc
	 	port map(
	 		ap_clk 					=> HWT_Clk,
	 	    ap_rst 					=> rst_fe,
	 	    sampleFifo_V_V_dout		=> fe_sample_zc,
	 	    sampleFifo_V_V_empty_n 	=> fe_fifo_sample_empty_n(C_POS_FLAG_ZC),
	 	    sampleFifo_V_V_read 	=> fe_fifo_sample_re(C_POS_FLAG_ZC),
	 	    featureFifo_V_V_din 	=> fe_feature_zc,
	 	    featureFifo_V_V_full_n 	=> fe_fifo_feature_full_n(C_POS_FLAG_ZC),
	 	    featureFifo_V_V_write 	=> fe_fifo_feature_we(C_POS_FLAG_ZC),
	 	    windowSize_V 			=> window_size(7 downto 0),
	 	    threshold_V				=> threshold_4_zc
	 	);

	-- instantiate FIFO modules
	fifo_zc_samples : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 4,

			C_USE_ALMOST    => true,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 1 -- Using almost full to see if the next value can bve written or not. Otherwise the signal comes one clock too late.
		)

		port map(
			FIFO_S_Data   => fe_sample_zc,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fe_fifo_sample_empty(C_POS_FLAG_ZC),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fe_fifo_sample_re(C_POS_FLAG_ZC),

			FIFO_M_Data   => i_RAMData_samples,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fifo_sample_full(C_POS_FLAG_ZC),
			FIFO_M_AFull  => fifo_sample_afull(C_POS_FLAG_ZC),
			FIFO_M_WE     => fifo_sample_we(C_POS_FLAG_ZC),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	fifo_zc_features : reconos_fifo_sync
		generic map (
			C_FIFO_DATA_WIDTH => 32,
			C_FIFO_ADDR_WIDTH => 3,

			C_USE_ALMOST    => false,
			C_USE_FILL_REMM => false,
			C_FIFO_AEMPTY   => 2,
			C_FIFO_AFULL    => 2
		)

		port map(
			FIFO_S_Data   => feature_zc,
			FIFO_S_Fill   => open,
			FIFO_S_Empty  => fifo_feature_empty(C_POS_FLAG_ZC),
			FIFO_S_AEmpty => open,
			FIFO_S_RE     => fifo_feature_re(C_POS_FLAG_ZC),

			FIFO_M_Data   => fe_feature_zc,
			FIFO_M_Remm   => open,
			FIFO_M_Full   => fe_fifo_feature_full(C_POS_FLAG_ZC),
			FIFO_M_AFull  => open,
			FIFO_M_WE     => fe_fifo_feature_we(C_POS_FLAG_ZC),

			FIFO_Clk      => HWT_Clk,
			FIFO_Rst      => rst_fe,
			FIFO_Has_Data => open
		);

	osif_setup (
		i_osif,
		o_osif,
		OSIF_Sw2Hw_Data,
		OSIF_Sw2Hw_Empty,
		OSIF_Sw2Hw_RE,
		OSIF_Hw2Sw_Data,
		OSIF_Hw2Sw_Full,
		OSIF_Hw2Sw_WE
	);

	memif_setup (
		i_memif,
		o_memif,
		MEMIF_Mem2Hwt_Data,
		MEMIF_Mem2Hwt_Empty,
		MEMIF_Mem2Hwt_RE,
		MEMIF_Hwt2Mem_Data,
		MEMIF_Hwt2Mem_Full,
		MEMIF_Hwt2Mem_WE
	);

	ram_setup (
		i_ram_samples_memif,
		o_ram_samples_memif,
		o_RAMAddr_samples_2_memif,
		o_RAMData_samples_memif,
		i_RAMData_samples_memif,
		o_RAMWE_samples_memif
	);

	ram_setup (
		i_ram_features_memif,
		o_ram_features_memif,
		o_RAMAddr_features_2_memif,
		o_RAMData_features_memif,
		i_RAMData_features_memif,
		o_RAMWE_features_memif
	);


	-- Asynchronous assignments for Feature-FIFO and Feature-RAM communication
	-- Set write-enables
	o_RAMWE_features <= '1' when (state_write_back = STATE_READ_FIFO_MAV) and (fifo_feature_empty(C_POS_FLAG_MAV) = '0') else
						'1' when (state_write_back = STATE_READ_FIFO_SSC) and (fifo_feature_empty(C_POS_FLAG_SSC) = '0') else
						'1' when (state_write_back = STATE_READ_FIFO_WFL) and (fifo_feature_empty(C_POS_FLAG_WFL) = '0') else
						'1' when (state_write_back = STATE_READ_FIFO_ZC)  and (fifo_feature_empty(C_POS_FLAG_ZC)  = '0') else
						'0';

	-- Assign data from FIFO-Data to RAM-Data
	o_RAMData_features <= 	feature_mav when state_write_back = STATE_READ_FIFO_MAV else
							feature_ssc when state_write_back = STATE_READ_FIFO_SSC else
							feature_wfl when state_write_back = STATE_READ_FIFO_WFL else
							feature_zc  when state_write_back = STATE_READ_FIFO_ZC  else
							(others => '0');

	-- Set Feature Ram Address
	o_RAMAddr_features_2 	<= 	X"0000" & pos_mav																							 when state_write_back = STATE_READ_FIFO_MAV else
						  	std_logic_vector( unsigned(pos_ssc) + unsigned(nbr_channels_nbr_features(31 downto 16))*unsigned(nbr_features) ) when state_write_back = STATE_READ_FIFO_SSC else
						  	std_logic_vector( unsigned(pos_wfl) + unsigned(nbr_channels_nbr_features(31 downto 16))*unsigned(nbr_features) ) when state_write_back = STATE_READ_FIFO_WFL else
						  	std_logic_vector( unsigned(pos_zc)  + unsigned(nbr_channels_nbr_features(31 downto 16))*unsigned(nbr_features) ) when state_write_back = STATE_READ_FIFO_ZC else
							(others => '0');

	-- Set read-enables		
	fifo_feature_re(C_POS_FLAG_MAV) <= '1' when (state_write_back = STATE_READ_FIFO_MAV) and (fifo_feature_empty(C_POS_FLAG_MAV) = '0') else '0';
	fifo_feature_re(C_POS_FLAG_SSC) <= '1' when (state_write_back = STATE_READ_FIFO_SSC) and (fifo_feature_empty(C_POS_FLAG_SSC) = '0') else '0';
	fifo_feature_re(C_POS_FLAG_WFL) <= '1' when (state_write_back = STATE_READ_FIFO_WFL) and (fifo_feature_empty(C_POS_FLAG_WFL) = '0') else '0';
	fifo_feature_re(C_POS_FLAG_ZC)  <= '1' when (state_write_back = STATE_READ_FIFO_ZC)  and (fifo_feature_empty(C_POS_FLAG_ZC)  = '0') else '0';


	fe_fifo_feature_full_n <= not fe_fifo_feature_full;
	fe_fifo_sample_empty_n <= not fe_fifo_sample_empty;

	o_RAMAddr_samples_memif(0 to C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH-1) 	<= 	o_RAMAddr_samples_2_memif((32-C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH) to 31);
	o_RAMAddr_samples(0 to C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH-1) 	<= 	o_RAMAddr_samples_2((32-C_LOCAL_RAM_SAMPLES_ADDRESS_WIDTH) to 31);
	o_RAMAddr_features_memif(0 to C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH-1) <= o_RAMAddr_features_2_memif((32-C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH) to 31);
	o_RAMAddr_features(0 to C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH-1) 	<= 	o_RAMAddr_features_2((32-C_LOCAL_RAM_FEATURES_ADDRESS_WIDTH) to 31);

	-- local dual-port RAM for samples
	local_ram_samples_ctrl_1 : process (HWT_Clk, HWT_Rst) is
	begin
		if (rising_edge(HWT_Clk)) then
			if (o_RAMWE_samples = '1') then
				local_ram_samples(to_integer(unsigned(o_RAMAddr_samples))) := o_RAMData_samples;
			else
				i_RAMData_samples <= local_ram_samples(to_integer(unsigned(o_RAMAddr_samples)));
			end if;
		end if;
	end process;

	local_ram_samples_ctrl_2 : process (HWT_Clk, HWT_Rst, o_osif, o_memif, o_ram_samples_memif) is
	begin
		if (rising_edge(HWT_Clk)) then
			if (o_RAMWE_samples_memif = '1') then
				local_ram_samples(to_integer(unsigned(o_RAMAddr_samples_memif))) := o_RAMData_samples_memif;
			else
				i_RAMData_samples_memif <= local_ram_samples(to_integer(unsigned(o_RAMAddr_samples_memif)));
			end if;
		end if;
	end process;

	-- Dual-Port RAM for features
	local_ram_features_ctrl_1 : process (HWT_Clk, HWT_Rst) is
	begin
		if (rising_edge(HWT_Clk)) then
			if o_RAMWE_features = '1' then
				local_ram_features(to_integer(unsigned(o_RAMAddr_features))) := o_RAMData_features;
			else
				i_RAMData_features <= local_ram_features(to_integer(unsigned(o_RAMAddr_features)));
			end if;
		end if;
	end process;
	
	local_ram_features_ctrl_2 : process (HWT_Clk, HWT_Rst, o_osif, o_memif, o_ram_features_memif) is
	begin
		if (rising_edge(HWT_Clk)) then
			if o_RAMWE_features_memif='1' then
				local_ram_features(to_integer(unsigned(o_RAMAddr_features_memif))) := o_RAMData_features_memif;
			else
				i_RAMData_features_memif <= local_ram_features(to_integer(unsigned(o_RAMAddr_features_memif)));
			end if;
		end if;
	end process;

	

	-- State-machine for: Read features from FIFO and write back them to RAM
	feature_handling_fsm : process(HWT_Clk, HWT_Rst) is
	begin
		if HWT_Rst ='1' then
			nbr_features <= (others => '0');
			ack_fe <= '0';

			state_write_back <= STATE_INIT;

		elsif rising_edge(HWT_Clk) then
			case state_write_back is
				when STATE_INIT =>
					if nbr_channels_nbr_features(31 downto 16) /= X"0000" and collect_features = '1' then
						nbr_features <= X"0000";
						pos_mav <= (others=>'0');
						pos_ssc <= (others=>'0');
						pos_wfl <= (others=>'0');
						pos_zc  <= (others=>'0');

						ack_fe <= '0';

						state_write_back <= STATE_READ_FIFO_MAV;
					else
						state_write_back <= STATE_INIT;
					end if;

				when STATE_READ_FIFO_MAV =>
					if extractor_selector(C_POS_FLAG_MAV) = '1' and fifo_feature_empty(C_POS_FLAG_MAV) = '0' then
						pos_mav <= std_logic_vector(unsigned(pos_mav) + 1);
						nbr_features <= std_logic_vector(unsigned(nbr_features) + 1);
						state_write_back <= STATE_READ_FIFO_SSC;

					elsif extractor_selector(C_POS_FLAG_MAV) = '0' then
						state_write_back <= STATE_READ_FIFO_SSC;
					end if ;
					

				when STATE_READ_FIFO_SSC =>
					if extractor_selector(C_POS_FLAG_SSC) = '1' and fifo_feature_empty(C_POS_FLAG_SSC) = '0' then
						pos_ssc <= std_logic_vector(unsigned(pos_ssc) + 1);
						nbr_features <= std_logic_vector(unsigned(nbr_features) + 1);
						state_write_back <= STATE_READ_FIFO_WFL;

					elsif extractor_selector(C_POS_FLAG_SSC) = '0' then
						state_write_back <= STATE_READ_FIFO_WFL;
					end if ;
					

				when STATE_READ_FIFO_WFL =>
					if extractor_selector(C_POS_FLAG_WFL) = '1' and fifo_feature_empty(C_POS_FLAG_WFL) = '0' then
						pos_wfl <= std_logic_vector(unsigned(pos_wfl) + 1);
						nbr_features <= std_logic_vector(unsigned(nbr_features) + 1);
						state_write_back <= STATE_READ_FIFO_ZC;

					elsif extractor_selector(C_POS_FLAG_WFL) = '0' then
						state_write_back <= STATE_READ_FIFO_ZC;
					end if ;
					

				when STATE_READ_FIFO_ZC =>
					if extractor_selector(C_POS_FLAG_ZC) = '1' and fifo_feature_empty(C_POS_FLAG_ZC) = '0' then
						pos_zc <= std_logic_vector(unsigned(pos_zc) + 1);
						nbr_features <= std_logic_vector(unsigned(nbr_features) + 1);
						state_write_back <= STATE_WAIT_4_FEATURES_WRITTEN_BACK_2_MM;
							
					elsif extractor_selector(C_POS_FLAG_ZC) = '0' then
						state_write_back <= STATE_WAIT_4_FEATURES_WRITTEN_BACK_2_MM;
					end if ;


				when STATE_WAIT_4_FEATURES_WRITTEN_BACK_2_MM =>
					if 	(unsigned(pos_mav) >= (unsigned(nbr_channels_nbr_features(31 downto 16))) or extractor_selector(C_POS_FLAG_MAV) = '0' ) and 
						(unsigned(pos_ssc) >= (unsigned(nbr_channels_nbr_features(31 downto 16))) or extractor_selector(C_POS_FLAG_SSC) = '0' ) and 
						(unsigned(pos_wfl) >= (unsigned(nbr_channels_nbr_features(31 downto 16))) or extractor_selector(C_POS_FLAG_WFL) = '0' ) and 
						(unsigned(pos_zc)  >= (unsigned(nbr_channels_nbr_features(31 downto 16))) or extractor_selector(C_POS_FLAG_ZC) = '0' )  and
						(unsigned(extractor_selector) > 0)
					then
						ack_fe <= '1';

						if rst_fe = '0' then
							state_write_back <= STATE_WAIT_4_FEATURES_WRITTEN_BACK_2_MM;
						else
							state_write_back <= STATE_INIT;
						end if;
					else
						state_write_back <= STATE_READ_FIFO_MAV;
					end if ;

					nbr_features <= X"0000";
			end case;
		end if;
	end process;


	-- State-machine for: main process. Handling of the samples and memory communication
	sample_handling_fsm : process(HWT_Clk, HWT_Rst, o_osif, o_memif, o_ram_samples_memif, o_ram_features_memif) is
		variable done : boolean;
	begin
		if HWT_Rst ='1' then
			osif_reset(o_osif);
			memif_reset(o_memif);
			ram_reset(o_ram_samples_memif);
			ram_reset(o_ram_features_memif);

			done := False;

			rst_fe <= '1';

			state <= STATE_INIT;

		elsif rising_edge(HWT_Clk) then
			-- Reset signals
			rst_fe <= '0';
			collect_features <= '0';

			case state is
				when STATE_INIT =>
					osif_read(i_osif, o_osif, ignore, done);
					if done then
						rst_fe <= '1';
						state <= STATE_ENABLE_EXTRACTORS;
					end if;

				-- Enable/disable Feature-Extractors by flags
				when STATE_ENABLE_EXTRACTORS =>
					osif_mbox_get(i_osif, o_osif, RESOURCES_INITFEATUREEXTRACTIONMANAGERHW, extractor_selector, done);
					
					if done then
						if (extractor_selector = X"00000000") then
							state <= STATE_THREAD_EXIT;
						else
							state <= STATE_GET_NBR_CHANNELS_NBR_FEATURES;
						end if;
					end if;

				-- Get number of channels
				when STATE_GET_NBR_CHANNELS_NBR_FEATURES =>
					osif_mbox_get(i_osif, o_osif, RESOURCES_INITFEATUREEXTRACTIONMANAGERHW, nbr_channels_nbr_features, done);
					
					if done then
						if (nbr_channels_nbr_features(31 downto 16) = X"0000") or (nbr_channels_nbr_features(15 downto 0) = X"0000") then
							state <= STATE_THREAD_EXIT;
						else
							-- Length of Feature-Window: 1 feature in one 32 bit word => #Features * 4 byte
							len_feature_window <= std_logic_vector( (unsigned(nbr_channels_nbr_features(31 downto 16)) * unsigned(nbr_channels_nbr_features(15 downto 0))) sll 2 );
							state <= STATE_GET_WIN_SIZE;
						end if;
					end if;

				-- Get Window-Size
				when STATE_GET_WIN_SIZE =>
					osif_mbox_get(i_osif, o_osif, RESOURCES_INITFEATUREEXTRACTIONMANAGERHW, window_size, done);
					
					if done then
						if (window_size = X"00000000") then
							state <= STATE_THREAD_EXIT;
						else
							if(extractor_selector(C_POS_FLAG_ZC) = '1') then
								state <= STATE_SET_THRESHOLD_ZC;
							elsif (extractor_selector(C_POS_FLAG_ZC) = '0') then
								state <= STATE_GET_START_ADDR_SAMPLE_WIN;
							end if;
						end if;
					end if;

				-- Get ZC threshold value and put it into FIFO
				when STATE_SET_THRESHOLD_ZC =>
					osif_mbox_get(i_osif, o_osif, RESOURCES_INITFEATUREEXTRACTIONMANAGERHW, threshold_4_zc, done);
					
					if done then
						-- Put threshold into FIFO of Zero-Crossing Feature-Extracors
						state <= STATE_GET_START_ADDR_SAMPLE_WIN;
					end if;

				-- Get address of sample window
				when STATE_GET_START_ADDR_SAMPLE_WIN =>
					osif_mbox_get(i_osif, o_osif, RESOURCES_INITFEATUREEXTRACTIONMANAGERHW, start_addr_sample_window_2, done);
					
					if done then
						state <= STATE_GET_START_ADDR_FEAT_WIN;
					end if;

				-- Get address to Feature-Window
				when STATE_GET_START_ADDR_FEAT_WIN =>
					osif_mbox_get(i_osif, o_osif, RESOURCES_INITFEATUREEXTRACTIONMANAGERHW, start_addr_feature_window, done);
					
					if done then
						state <= STATE_GET_ID_CLASS_OFFSET;
					end if;

				-- Get id, class and offset (all in one mbox message)
				when STATE_GET_ID_CLASS_OFFSET =>
					-- id_class_offset [31...(dontcare)...24,23...(offset)...16,15...(class)...8,7...(id)...0]
					osif_mbox_get(i_osif, o_osif, RESOURCES_SAMPLEWINDOWHW, id_class_offset, done);
					
					if done then
						rst_fe <= '1';

						-- Calculate length of Sample-Window in bytes
						-- Res. samples: 16 bit = 2 bytes
						-- length = 2 bytes * #Channels * #SamplesPerWindow
						-- Length of Sample-Window: 2 samples in one 32 bit word => Only read half the number of channels * Window-Size
						len_sample_window_1 <= X"00" & std_logic_vector( ( (unsigned(window_size(7 downto 0)) - unsigned(id_class_offset(23 downto 16)))*unsigned(nbr_channels_nbr_features(31 downto 16)) ) sll 1 );
						elements_sample_window_1 <= X"00" & std_logic_vector( (unsigned(window_size(7 downto 0)) - unsigned(id_class_offset(23 downto 16)))*unsigned(nbr_channels_nbr_features(31 downto 16)) srl 1 );
						
						len_sample_window_2 <= X"00" & std_logic_vector( (unsigned(nbr_channels_nbr_features(31 downto 16)) * unsigned(id_class_offset(23 downto 16))) sll 1 );
						elements_sample_window_2 <= X"00" & std_logic_vector( (unsigned(nbr_channels_nbr_features(31 downto 16)) * unsigned(id_class_offset(23 downto 16))) srl 1 );
						
						start_addr_sample_window_ram <= X"00000000";
						start_addr_sample_window_1 <= std_logic_vector( unsigned(start_addr_sample_window_2) + ((unsigned(nbr_channels_nbr_features(31 downto 16)) * unsigned(id_class_offset(23 downto 16))) sll 1));

						-- Since 2 channels (16 bit) are at one memory location (32 bit), #Channels/2 tell us the distance to the next sample of the same channel
						--
						--
						-- TODO: If #Channels is odd, increment #Channels by 1. Otherwise we loose one Channel!!!
						--
						--
						elements_2_next_sample_in_sample_window <= X"0000" & std_logic_vector( unsigned(nbr_channels_nbr_features(31 downto 16)) srl 1 );
						
						o_RAMAddr_samples_2 <=  X"00000000";

						state <= STATE_ACQUIRE_SAMPLE_WINDOW_1;
					end if;

				-- Aqucire a new sample from the Sample-Window and give it to the right Feature-Extractor
				when STATE_ACQUIRE_SAMPLE_WINDOW_1 =>
					-- Read sample from RAM until the entire Sample-Window was processed
					memif_read(i_ram_samples_memif,o_ram_samples_memif,i_memif,o_memif,start_addr_sample_window_1(31 downto 2) & "00",start_addr_sample_window_ram,len_sample_window_1,done);

					if done then
						start_addr_sample_window_ram <= elements_sample_window_1;
						-- All elements in Sample-Window: #Channels/2 * Window-Size
						elements_sample_window <= std_logic_vector( unsigned(elements_sample_window_1) + unsigned(elements_sample_window_2) );


						state <= STATE_ACQUIRE_SAMPLE_WINDOW_2;
					end if;

				-- Aqucire a new sample from the Sample-Window and give it to the right Feature-Extractor
				when STATE_ACQUIRE_SAMPLE_WINDOW_2 =>
					if id_class_offset(23 downto 16) /= X"00000000" then
						-- Read sample from RAM until the entire Sample-Window was processed
						memif_read(i_ram_samples_memif,o_ram_samples_memif,i_memif,o_memif,start_addr_sample_window_2(31 downto 2) & "00",start_addr_sample_window_ram,len_sample_window_2,done);

						if done then
							collect_features <= '1';
							state <= STATE_ASSIGN_FIRST_ADDRESS;
						end if;
					else
						collect_features <= '1';
						state <= STATE_ASSIGN_FIRST_ADDRESS;
					end if;
 				
 				when STATE_ASSIGN_FIRST_ADDRESS =>
 					cnt_samples <= X"01";
		            cnt_channels <= X"00";
					o_RAMAddr_samples_2 <=  std_logic_vector( unsigned(o_RAMAddr_samples_2) + unsigned(elements_2_next_sample_in_sample_window) );
					fifo_sample_we <= extractor_selector;

					state <= STATE_GET_AND_PASS_SAMPLE;

				-- Set Address and increment sample counter
				when STATE_GET_AND_PASS_SAMPLE =>
					if fifo_sample_afull = X"00000000" then
						if unsigned(cnt_samples) < unsigned(window_size) then
							-- Calculate new address
							o_RAMAddr_samples_2 <=  std_logic_vector( unsigned(o_RAMAddr_samples_2) + unsigned(elements_2_next_sample_in_sample_window) );
							cnt_samples <= std_logic_vector( unsigned(cnt_samples) + 1 );
							fifo_sample_we <= extractor_selector;

						elsif unsigned(cnt_samples) = unsigned(window_size) then
							cnt_channels <= std_logic_vector( unsigned(cnt_channels) + 1 );
							cnt_samples <= std_logic_vector( unsigned(cnt_samples) + 1 );
							o_RAMAddr_samples_2 <=  X"000000" & std_logic_vector( unsigned(cnt_channels) + 1 );
							fifo_sample_we <= (others=>'0');

							state <= STATE_CHECK_CHANNEL_COUNTER;
						end if ;
					else
						fifo_sample_we <= (others=>'0');
					end if;

				-- Increment channel counter if necessary
				when STATE_CHECK_CHANNEL_COUNTER =>
					-- All channels have been processed
					if unsigned(cnt_channels) = unsigned(elements_2_next_sample_in_sample_window) then
						state <= STATE_WAIT_4_ACK;

					-- Not all channels have been processed
					else
						cnt_samples <= X"01";
						o_RAMAddr_samples_2 <=  std_logic_vector( unsigned(o_RAMAddr_samples_2) + unsigned(elements_2_next_sample_in_sample_window) );
						fifo_sample_we <= extractor_selector;

						state <= STATE_GET_AND_PASS_SAMPLE;
					end if;

				-- Wait for Feature-Extractors to finish
				when STATE_WAIT_4_ACK =>
					if ack_fe = '0' then
						state <= STATE_WAIT_4_ACK;
					else
						state <= STATE_WRITE_BACK_FEATURES_2_MM;
					end if;

				-- Write back features from RAM to main-memory
				when STATE_WRITE_BACK_FEATURES_2_MM =>
					memif_write(i_ram_features_memif,o_ram_features_memif,i_memif,o_memif,X"00000000",start_addr_feature_window,len_feature_window,done);

					if done then
						state <= STATE_PASS_ID_CLASS;
					end if;

				-- Put ID and class as acknowledgement into mbox for projected features
				when STATE_PASS_ID_CLASS =>
					osif_mbox_put(i_osif, o_osif, RESOURCES_FEATUREWINDOW, id_class_offset, ignore, done);

					if done then 
						state <= STATE_GET_ID_CLASS_OFFSET;
					end if;

				-- Thread exit
				when STATE_THREAD_EXIT =>
					osif_thread_exit(i_osif,o_osif);

				when STATE_ERROR =>
				 	state <= STATE_ERROR;

				-- Other-case
				when others =>
					osif_mbox_put(i_osif, o_osif, RESOURCES_FEATUREWINDOW, X"00000000", ignore, done);
					
					if done then 
						state <= STATE_ERROR;
					end if;
			end case;
		end if;
	end process;

end architecture;

--                                                        ____  _____
--                            ________  _________  ____  / __ \/ ___/
--                           / ___/ _ \/ ___/ __ \/ __ \/ / / /\__ \
--                          / /  /  __/ /__/ /_/ / / / / /_/ /___/ /
--                         /_/   \___/\___/\____/_/ /_/\____//____/
-- 
-- ======================================================================
--
--   title:        VHDL Thread Package - ReconOS
--
--   project:      ReconOS
--   author:       Enno Lübbers, University of Paderborn
--                 Andreas Agne, University of Paderborn
--                 Christoph Rüthing, University of Paderborn
--   description:  Auto-generated thread specific package.
--
-- ======================================================================



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package reconos_thread_pkg is
		constant RESOURCES_INITTCPIPSERVER : std_logic_vector(31 downto 0) := x"00000000";
		constant RESOURCES_INITFEATUREEXTRACTIONMANAGERSW : std_logic_vector(31 downto 0) := x"00000001";
		constant RESOURCES_INITFEATUREEXTRACTIONMANAGERHW : std_logic_vector(31 downto 0) := x"00000002";
		constant RESOURCES_INITFEATUREPROJECTION : std_logic_vector(31 downto 0) := x"00000003";
		constant RESOURCES_INITLDA : std_logic_vector(31 downto 0) := x"00000004";
		constant RESOURCES_INITCLASSIFICATION : std_logic_vector(31 downto 0) := x"00000005";
		constant RESOURCES_SAMPLEWINDOWSW : std_logic_vector(31 downto 0) := x"00000006";
		constant RESOURCES_SAMPLEWINDOWHW : std_logic_vector(31 downto 0) := x"00000007";
		constant RESOURCES_FEATUREWINDOW : std_logic_vector(31 downto 0) := x"00000008";
		constant RESOURCES_MAVMAV : std_logic_vector(31 downto 0) := x"00000009";
		constant RESOURCES_PROJECTEDFEATURES : std_logic_vector(31 downto 0) := x"0000000a";
		constant RESOURCES_ACKNOWLEDGEMENTCLASSIFICATION : std_logic_vector(31 downto 0) := x"0000000b";
		constant RESOURCES_LDATRAININGDATASET : std_logic_vector(31 downto 0) := x"0000000c";
		constant RESOURCES_LDAPROJECTIONMATRIX : std_logic_vector(31 downto 0) := x"0000000d";
		constant RESOURCES_LDACLASSMEANS : std_logic_vector(31 downto 0) := x"0000000e";
	
end package reconos_thread_pkg;
-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2016.1
-- Copyright (C) 1986-2016 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fe_ssc is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    sampleFifo_V_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
    sampleFifo_V_V_empty_n : IN STD_LOGIC;
    sampleFifo_V_V_read : OUT STD_LOGIC;
    featureFifo_V_V_din : OUT STD_LOGIC_VECTOR (31 downto 0);
    featureFifo_V_V_full_n : IN STD_LOGIC;
    featureFifo_V_V_write : OUT STD_LOGIC;
    windowSize_V : IN STD_LOGIC_VECTOR (7 downto 0) );
end;


architecture behav of fe_ssc is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "fe_ssc,hls_ip_2016_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xc7z020clg484-1,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=8.340000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=2,HLS_SYN_FF=281,HLS_SYN_LUT=368}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_st1_fsm_0 : STD_LOGIC_VECTOR (6 downto 0) := "0000001";
    constant ap_ST_st2_fsm_1 : STD_LOGIC_VECTOR (6 downto 0) := "0000010";
    constant ap_ST_st3_fsm_2 : STD_LOGIC_VECTOR (6 downto 0) := "0000100";
    constant ap_ST_st4_fsm_3 : STD_LOGIC_VECTOR (6 downto 0) := "0001000";
    constant ap_ST_st5_fsm_4 : STD_LOGIC_VECTOR (6 downto 0) := "0010000";
    constant ap_ST_st6_fsm_5 : STD_LOGIC_VECTOR (6 downto 0) := "0100000";
    constant ap_ST_st7_fsm_6 : STD_LOGIC_VECTOR (6 downto 0) := "1000000";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_6 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000110";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv32_4 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000100";
    constant ap_const_lv32_5 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000101";
    constant ap_const_lv8_2 : STD_LOGIC_VECTOR (7 downto 0) := "00000010";
    constant ap_const_lv32_10 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000010000";
    constant ap_const_lv32_1F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011111";
    constant ap_const_lv8_1 : STD_LOGIC_VECTOR (7 downto 0) := "00000001";
    constant ap_const_lv33_0 : STD_LOGIC_VECTOR (32 downto 0) := "000000000000000000000000000000000";

    signal sampleFifo_V_V_blk_n : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (6 downto 0) := "0000001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_sig_cseq_ST_st2_fsm_1 : STD_LOGIC;
    signal ap_sig_31 : BOOLEAN;
    signal ap_sig_cseq_ST_st3_fsm_2 : STD_LOGIC;
    signal ap_sig_38 : BOOLEAN;
    signal ap_sig_cseq_ST_st4_fsm_3 : STD_LOGIC;
    signal ap_sig_46 : BOOLEAN;
    signal tmp_7_fu_160_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal featureFifo_V_V_blk_n : STD_LOGIC;
    signal ap_sig_cseq_ST_st7_fsm_6 : STD_LOGIC;
    signal ap_sig_61 : BOOLEAN;
    signal tmp_fu_152_p1 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_reg_276 : STD_LOGIC_VECTOR (15 downto 0);
    signal p_Result_1_reg_281 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_2_fu_156_p1 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_8_fu_165_p1 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_8_reg_299 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_sig_90 : BOOLEAN;
    signal p_Result_5_reg_305 : STD_LOGIC_VECTOR (15 downto 0);
    signal cntSamples_V_fu_169_p2 : STD_LOGIC_VECTOR (7 downto 0);
    signal cntSamples_V_reg_311 : STD_LOGIC_VECTOR (7 downto 0);
    signal grp_fu_255_p3 : STD_LOGIC_VECTOR (32 downto 0);
    signal r_V_2_reg_316 : STD_LOGIC_VECTOR (32 downto 0);
    signal ap_sig_cseq_ST_st5_fsm_4 : STD_LOGIC;
    signal ap_sig_104 : BOOLEAN;
    signal grp_fu_263_p3 : STD_LOGIC_VECTOR (32 downto 0);
    signal r_V_5_reg_321 : STD_LOGIC_VECTOR (32 downto 0);
    signal p_s_fu_228_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_sig_cseq_ST_st6_fsm_5 : STD_LOGIC;
    signal ap_sig_115 : BOOLEAN;
    signal sscChannel2_V_1_fu_247_p3 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_3_reg_63 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_4_reg_73 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_5_reg_84 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_6_reg_94 : STD_LOGIC_VECTOR (15 downto 0);
    signal t_V_reg_105 : STD_LOGIC_VECTOR (31 downto 0);
    signal t_V_3_reg_118 : STD_LOGIC_VECTOR (31 downto 0);
    signal t_V_2_reg_131 : STD_LOGIC_VECTOR (7 downto 0);
    signal lhs_V_fu_175_p1 : STD_LOGIC_VECTOR (16 downto 0);
    signal rhs_V_fu_179_p1 : STD_LOGIC_VECTOR (16 downto 0);
    signal r_V_fu_182_p2 : STD_LOGIC_VECTOR (16 downto 0);
    signal lhs_V_2_fu_196_p1 : STD_LOGIC_VECTOR (16 downto 0);
    signal rhs_V_3_fu_200_p1 : STD_LOGIC_VECTOR (16 downto 0);
    signal r_V_3_fu_203_p2 : STD_LOGIC_VECTOR (16 downto 0);
    signal tmp_s_fu_217_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sscChannel1_V_fu_222_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_1_fu_236_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sscChannel2_V_fu_241_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal grp_fu_255_p0 : STD_LOGIC_VECTOR (15 downto 0);
    signal grp_fu_263_p0 : STD_LOGIC_VECTOR (15 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (6 downto 0);

    component fe_ssc_am_submul_16s_16s_17s_33_1 IS
    generic (
        ID : INTEGER;
        NUM_STAGE : INTEGER;
        din0_WIDTH : INTEGER;
        din1_WIDTH : INTEGER;
        din2_WIDTH : INTEGER;
        dout_WIDTH : INTEGER );
    port (
        din0 : IN STD_LOGIC_VECTOR (15 downto 0);
        din1 : IN STD_LOGIC_VECTOR (15 downto 0);
        din2 : IN STD_LOGIC_VECTOR (16 downto 0);
        dout : OUT STD_LOGIC_VECTOR (32 downto 0) );
    end component;



begin
    fe_ssc_am_submul_16s_16s_17s_33_1_U1 : component fe_ssc_am_submul_16s_16s_17s_33_1
    generic map (
        ID => 1,
        NUM_STAGE => 1,
        din0_WIDTH => 16,
        din1_WIDTH => 16,
        din2_WIDTH => 17,
        dout_WIDTH => 33)
    port map (
        din0 => grp_fu_255_p0,
        din1 => tmp_5_reg_84,
        din2 => r_V_fu_182_p2,
        dout => grp_fu_255_p3);

    fe_ssc_am_submul_16s_16s_17s_33_1_U2 : component fe_ssc_am_submul_16s_16s_17s_33_1
    generic map (
        ID => 1,
        NUM_STAGE => 1,
        din0_WIDTH => 16,
        din1_WIDTH => 16,
        din2_WIDTH => 17,
        dout_WIDTH => 33)
    port map (
        din0 => grp_fu_263_p0,
        din1 => tmp_3_reg_63,
        din2 => r_V_3_fu_203_p2,
        dout => grp_fu_263_p3);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_st1_fsm_0;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    t_V_2_reg_131_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                t_V_2_reg_131 <= cntSamples_V_reg_311;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                t_V_2_reg_131 <= ap_const_lv8_2;
            end if; 
        end if;
    end process;

    t_V_3_reg_118_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                t_V_3_reg_118 <= sscChannel2_V_1_fu_247_p3;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                t_V_3_reg_118 <= ap_const_lv32_0;
            end if; 
        end if;
    end process;

    t_V_reg_105_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                t_V_reg_105 <= p_s_fu_228_p3;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                t_V_reg_105 <= ap_const_lv32_0;
            end if; 
        end if;
    end process;

    tmp_3_reg_63_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                tmp_3_reg_63 <= tmp_4_reg_73;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                tmp_3_reg_63 <= p_Result_1_reg_281;
            end if; 
        end if;
    end process;

    tmp_4_reg_73_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                tmp_4_reg_73 <= p_Result_5_reg_305;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                tmp_4_reg_73 <= sampleFifo_V_V_dout(31 downto 16);
            end if; 
        end if;
    end process;

    tmp_5_reg_84_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                tmp_5_reg_84 <= tmp_6_reg_94;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                tmp_5_reg_84 <= tmp_reg_276;
            end if; 
        end if;
    end process;

    tmp_6_reg_94_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st6_fsm_5)) then 
                tmp_6_reg_94 <= tmp_8_reg_299;
            elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then 
                tmp_6_reg_94 <= tmp_2_fu_156_p1;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_st4_fsm_3) and not((tmp_7_fu_160_p2 = ap_const_lv1_0)) and not(ap_sig_90))) then
                cntSamples_V_reg_311 <= cntSamples_V_fu_169_p2;
                p_Result_5_reg_305 <= sampleFifo_V_V_dout(31 downto 16);
                tmp_8_reg_299 <= tmp_8_fu_165_p1;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((sampleFifo_V_V_empty_n = ap_const_logic_0)))) then
                p_Result_1_reg_281 <= sampleFifo_V_V_dout(31 downto 16);
                tmp_reg_276 <= tmp_fu_152_p1;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st5_fsm_4)) then
                r_V_2_reg_316 <= grp_fu_255_p3;
                r_V_5_reg_321 <= grp_fu_263_p3;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (sampleFifo_V_V_empty_n, featureFifo_V_V_full_n, ap_CS_fsm, tmp_7_fu_160_p2, ap_sig_90)
    begin
        case ap_CS_fsm is
            when ap_ST_st1_fsm_0 => 
                ap_NS_fsm <= ap_ST_st2_fsm_1;
            when ap_ST_st2_fsm_1 => 
                if (not((sampleFifo_V_V_empty_n = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st3_fsm_2;
                else
                    ap_NS_fsm <= ap_ST_st2_fsm_1;
                end if;
            when ap_ST_st3_fsm_2 => 
                if (not((sampleFifo_V_V_empty_n = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st4_fsm_3;
                else
                    ap_NS_fsm <= ap_ST_st3_fsm_2;
                end if;
            when ap_ST_st4_fsm_3 => 
                if (((tmp_7_fu_160_p2 = ap_const_lv1_0) and not(ap_sig_90))) then
                    ap_NS_fsm <= ap_ST_st7_fsm_6;
                elsif ((not((tmp_7_fu_160_p2 = ap_const_lv1_0)) and not(ap_sig_90))) then
                    ap_NS_fsm <= ap_ST_st5_fsm_4;
                else
                    ap_NS_fsm <= ap_ST_st4_fsm_3;
                end if;
            when ap_ST_st5_fsm_4 => 
                ap_NS_fsm <= ap_ST_st6_fsm_5;
            when ap_ST_st6_fsm_5 => 
                ap_NS_fsm <= ap_ST_st4_fsm_3;
            when ap_ST_st7_fsm_6 => 
                if (not((featureFifo_V_V_full_n = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st2_fsm_1;
                else
                    ap_NS_fsm <= ap_ST_st7_fsm_6;
                end if;
            when others =>  
                ap_NS_fsm <= "XXXXXXX";
        end case;
    end process;

    ap_sig_104_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_104 <= (ap_const_lv1_1 = ap_CS_fsm(4 downto 4));
    end process;


    ap_sig_115_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_115 <= (ap_const_lv1_1 = ap_CS_fsm(5 downto 5));
    end process;


    ap_sig_31_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_31 <= (ap_CS_fsm(1 downto 1) = ap_const_lv1_1);
    end process;


    ap_sig_38_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_38 <= (ap_const_lv1_1 = ap_CS_fsm(2 downto 2));
    end process;


    ap_sig_46_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_46 <= (ap_const_lv1_1 = ap_CS_fsm(3 downto 3));
    end process;


    ap_sig_61_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_61 <= (ap_const_lv1_1 = ap_CS_fsm(6 downto 6));
    end process;


    ap_sig_90_assign_proc : process(sampleFifo_V_V_empty_n, featureFifo_V_V_full_n, tmp_7_fu_160_p2)
    begin
                ap_sig_90 <= ((not((tmp_7_fu_160_p2 = ap_const_lv1_0)) and (sampleFifo_V_V_empty_n = ap_const_logic_0)) or ((tmp_7_fu_160_p2 = ap_const_lv1_0) and (featureFifo_V_V_full_n = ap_const_logic_0)));
    end process;


    ap_sig_cseq_ST_st2_fsm_1_assign_proc : process(ap_sig_31)
    begin
        if (ap_sig_31) then 
            ap_sig_cseq_ST_st2_fsm_1 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st2_fsm_1 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st3_fsm_2_assign_proc : process(ap_sig_38)
    begin
        if (ap_sig_38) then 
            ap_sig_cseq_ST_st3_fsm_2 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st3_fsm_2 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st4_fsm_3_assign_proc : process(ap_sig_46)
    begin
        if (ap_sig_46) then 
            ap_sig_cseq_ST_st4_fsm_3 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st4_fsm_3 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st5_fsm_4_assign_proc : process(ap_sig_104)
    begin
        if (ap_sig_104) then 
            ap_sig_cseq_ST_st5_fsm_4 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st5_fsm_4 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st6_fsm_5_assign_proc : process(ap_sig_115)
    begin
        if (ap_sig_115) then 
            ap_sig_cseq_ST_st6_fsm_5 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st6_fsm_5 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st7_fsm_6_assign_proc : process(ap_sig_61)
    begin
        if (ap_sig_61) then 
            ap_sig_cseq_ST_st7_fsm_6 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st7_fsm_6 <= ap_const_logic_0;
        end if; 
    end process;

    cntSamples_V_fu_169_p2 <= std_logic_vector(unsigned(ap_const_lv8_1) + unsigned(t_V_2_reg_131));

    featureFifo_V_V_blk_n_assign_proc : process(featureFifo_V_V_full_n, ap_sig_cseq_ST_st4_fsm_3, tmp_7_fu_160_p2, ap_sig_cseq_ST_st7_fsm_6)
    begin
        if ((((ap_const_logic_1 = ap_sig_cseq_ST_st4_fsm_3) and (tmp_7_fu_160_p2 = ap_const_lv1_0)) or (ap_const_logic_1 = ap_sig_cseq_ST_st7_fsm_6))) then 
            featureFifo_V_V_blk_n <= featureFifo_V_V_full_n;
        else 
            featureFifo_V_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    featureFifo_V_V_din_assign_proc : process(featureFifo_V_V_full_n, ap_sig_cseq_ST_st4_fsm_3, tmp_7_fu_160_p2, ap_sig_cseq_ST_st7_fsm_6, ap_sig_90, t_V_reg_105, t_V_3_reg_118)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_st7_fsm_6) and not((featureFifo_V_V_full_n = ap_const_logic_0)))) then 
            featureFifo_V_V_din <= t_V_3_reg_118;
        elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st4_fsm_3) and (tmp_7_fu_160_p2 = ap_const_lv1_0) and not(ap_sig_90))) then 
            featureFifo_V_V_din <= t_V_reg_105;
        else 
            featureFifo_V_V_din <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;


    featureFifo_V_V_write_assign_proc : process(featureFifo_V_V_full_n, ap_sig_cseq_ST_st4_fsm_3, tmp_7_fu_160_p2, ap_sig_cseq_ST_st7_fsm_6, ap_sig_90)
    begin
        if ((((ap_const_logic_1 = ap_sig_cseq_ST_st4_fsm_3) and (tmp_7_fu_160_p2 = ap_const_lv1_0) and not(ap_sig_90)) or ((ap_const_logic_1 = ap_sig_cseq_ST_st7_fsm_6) and not((featureFifo_V_V_full_n = ap_const_logic_0))))) then 
            featureFifo_V_V_write <= ap_const_logic_1;
        else 
            featureFifo_V_V_write <= ap_const_logic_0;
        end if; 
    end process;

    grp_fu_255_p0 <= lhs_V_fu_175_p1(16 - 1 downto 0);
    grp_fu_263_p0 <= lhs_V_2_fu_196_p1(16 - 1 downto 0);
        lhs_V_2_fu_196_p1 <= std_logic_vector(resize(signed(tmp_4_reg_73),17));

        lhs_V_fu_175_p1 <= std_logic_vector(resize(signed(tmp_6_reg_94),17));

    p_s_fu_228_p3 <= 
        sscChannel1_V_fu_222_p2 when (tmp_s_fu_217_p2(0) = '1') else 
        t_V_reg_105;
    r_V_3_fu_203_p2 <= std_logic_vector(signed(lhs_V_2_fu_196_p1) - signed(rhs_V_3_fu_200_p1));
    r_V_fu_182_p2 <= std_logic_vector(signed(lhs_V_fu_175_p1) - signed(rhs_V_fu_179_p1));
        rhs_V_3_fu_200_p1 <= std_logic_vector(resize(signed(p_Result_5_reg_305),17));

        rhs_V_fu_179_p1 <= std_logic_vector(resize(signed(tmp_8_reg_299),17));


    sampleFifo_V_V_blk_n_assign_proc : process(sampleFifo_V_V_empty_n, ap_sig_cseq_ST_st2_fsm_1, ap_sig_cseq_ST_st3_fsm_2, ap_sig_cseq_ST_st4_fsm_3, tmp_7_fu_160_p2)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) or (ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) or ((ap_const_logic_1 = ap_sig_cseq_ST_st4_fsm_3) and not((tmp_7_fu_160_p2 = ap_const_lv1_0))))) then 
            sampleFifo_V_V_blk_n <= sampleFifo_V_V_empty_n;
        else 
            sampleFifo_V_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    sampleFifo_V_V_read_assign_proc : process(sampleFifo_V_V_empty_n, ap_sig_cseq_ST_st2_fsm_1, ap_sig_cseq_ST_st3_fsm_2, ap_sig_cseq_ST_st4_fsm_3, tmp_7_fu_160_p2, ap_sig_90)
    begin
        if ((((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1) and not((sampleFifo_V_V_empty_n = ap_const_logic_0))) or ((ap_const_logic_1 = ap_sig_cseq_ST_st3_fsm_2) and not((sampleFifo_V_V_empty_n = ap_const_logic_0))) or ((ap_const_logic_1 = ap_sig_cseq_ST_st4_fsm_3) and not((tmp_7_fu_160_p2 = ap_const_lv1_0)) and not(ap_sig_90)))) then 
            sampleFifo_V_V_read <= ap_const_logic_1;
        else 
            sampleFifo_V_V_read <= ap_const_logic_0;
        end if; 
    end process;

    sscChannel1_V_fu_222_p2 <= std_logic_vector(unsigned(ap_const_lv32_1) + unsigned(t_V_reg_105));
    sscChannel2_V_1_fu_247_p3 <= 
        sscChannel2_V_fu_241_p2 when (tmp_1_fu_236_p2(0) = '1') else 
        t_V_3_reg_118;
    sscChannel2_V_fu_241_p2 <= std_logic_vector(unsigned(ap_const_lv32_1) + unsigned(t_V_3_reg_118));
    tmp_1_fu_236_p2 <= "1" when (signed(r_V_5_reg_321) > signed(ap_const_lv33_0)) else "0";
    tmp_2_fu_156_p1 <= sampleFifo_V_V_dout(16 - 1 downto 0);
    tmp_7_fu_160_p2 <= "1" when (unsigned(t_V_2_reg_131) < unsigned(windowSize_V)) else "0";
    tmp_8_fu_165_p1 <= sampleFifo_V_V_dout(16 - 1 downto 0);
    tmp_fu_152_p1 <= sampleFifo_V_V_dout(16 - 1 downto 0);
    tmp_s_fu_217_p2 <= "1" when (signed(r_V_2_reg_316) > signed(ap_const_lv33_0)) else "0";
end behav;

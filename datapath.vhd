    -- Datapath, fazendo a conexao entre cada componente

    library ieee;
    use ieee.std_logic_1164.all;
    use IEEE.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    use IEEE.NUMERIC_STD.ALL;
    
    entity datapath is
    port (
    -- Entradas de dados
    SW: in std_logic_vector(9 downto 0);
    CLOCK_50, CLK_1Hz: in std_logic;
    -- Sinais de controle
    R1, R2, E1, E2, E3, E4, E5: in std_logic;
    -- Sinais de status
    sw_erro, end_game, end_time, end_round: out std_logic;
    -- Saidas de dados
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0);
    LEDR: out std_logic_vector(9 downto 0)
    );
    end datapath;
    
    architecture arc of datapath is
    --============================================================--
    --                      COMPONENTS                            --
    --============================================================--
    -------------------DIVISOR DE FREQUENCIA------------------------
    
    component Div_Freq is
        port (	    clk: in std_logic;
                    reset: in std_logic;
                    CLK_1Hz: out std_logic
                );
    end component;
    
    ------------------------CONTADORES------------------------------
    
    component counter_time is
    port(Enable, Reset, CLOCK: in std_logic;
            load: in std_logic_vector(3 downto 0);
            end_time: out std_logic;
            tempo: out std_logic_vector(3 downto 0)
            );
    end component;
    
    component counter0to10 is
    port(
        Enable, Reset, CLOCK: in std_logic;
        round: out std_logic_vector(3 downto 0);
        end_round: out std_logic
        );
                
    end component;
    
    -------------------ELEMENTOS DE MEMORIA-------------------------
    
    component reg4bits is 
    port(
        CLK, RST, enable: in std_logic;
        D: in std_logic_vector(3 downto 0);
        Q: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component reg8bits is 
    port (
        CLK, RST, enable: in std_logic;
        D: in std_logic_vector(7 downto 0);
        Q: out std_logic_vector(7 downto 0)
    );
    end component;
    
    component reg10bits is 
    port(
        CLK, RST, enable: in std_logic;
        D: in std_logic_vector(9 downto 0);
        Q: out std_logic_vector(9 downto 0)
        );
    end component;
    
    component ROM is
    port(
        address : in std_logic_vector(3 downto 0);
        data : out std_logic_vector(9 downto 0) 
        );
    end component;
    
    ---------------------MULTIPLEXADORES----------------------------
    
    
    component mux2pra1_4bits is
    port(
        sel: in std_logic;
        x, y: in std_logic_vector(3 downto 0);
        saida: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component mux2pra1_7bits is
    port (sel: in std_logic;
            x, y: in std_logic_vector(6 downto 0);
            saida: out std_logic_vector(6 downto 0)
    );
    end component;
    
    component mux2pra1_8bits is
    port(
        sel: in std_logic;
        x, y: in std_logic_vector(7 downto 0);
        saida: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component mux2pra1_10bits is
    port(
        sel: in std_logic;
        x, y: in std_logic_vector(9 downto 0);
        saida: out std_logic_vector(9 downto 0)
        );
    end component;
    
    ----------------------DECODIFICADOR-----------------------------
    
    component decod7seg is
    port(
        X: in std_logic_vector(3 downto 0);
        Y: out std_logic_vector(6 downto 0)
        );
    end component;
    
    -------------------COMPARADORES E SOMA--------------------------
    
    component comp is
    port (
        seq_user: in std_logic_vector(9 downto 0);
        seq_reg: in std_logic_vector(9 downto 0);
        seq_mask: out std_logic_vector(9 downto 0)
        );
    end component;
    
    component comp_igual4 is
    port(
        soma: in std_logic_vector(3 downto 0);
        status: out std_logic
        );
    end component;
    
    component sum_with_for is
    port(
        seq: in std_logic_vector(9 downto 0);
        soma_out: out std_logic_vector(3 downto 0)
        );
    end component;
    
    --============================================================--
    --                      SIGNALS                               --
    --============================================================--
    
    signal selMux23, selMux45, end_game_interno, end_round_interno, clk_1, enableRegFinal, naoerro, swerro, R1_xor_R2, E1_or_E2 : std_logic; --1 bit
    signal round, Level_time, Level_code, SaidaCountT, SomaDigitada, SomaSelDig, CounterTMux,mux_hex4_out: std_logic_vector(3 downto 0) ; -- 4 bits
    signal decMuxCode, decMuxRound, muxMux2, muxMux3, decMux4, Tempo, t, r, n: std_logic_vector(6 downto 0); -- 7 bits
    signal SomaSelDig_estendido,SeqLevel, RegFinal, Reg_final, valorfin_vector, MuxSelDig,e_engame_e_round, e_somaseldig, switch_7: std_logic_vector(7 downto 0); -- 8 bits
    -- signal N_unsigned: unsigned(3 downto 0);
    signal SeqDigitada, ComparaSelDig, SelecionadaROM, EntradaLEDS, switch_9: std_logic_vector(9 downto 0); -- 10 bits
    signal n3, n2, n1, n0: std_logic;

    
    begin
    
    --DIV: Div_Freq port map (CLOCK_50, R2, clk_1); -- Para teste no emulador, comentar essa linha e usar o CLK_1Hz
    
    ------------------------CONTADORES------------------------------
    
    COUNT_TIME: counter_time port map (E2, R1, CLK_1Hz, Level_time, end_time, SaidaCountT); --ok
    COUNTER_ROUND: counter0to10 port map (E3, R2, CLOCK_50, round, end_round_interno); --ok
    
    -------------------ELEMENTOS DE MEMORIA-------------------------
    REG1_LEVEL: reg8bits port map (CLOCK_50, R2, E1, switch_7, valorfin_vector); --Setup info
    REG2_USER: reg10bits port map (CLOCK_50, R2, E2, switch_9, SeqDigitada); --Play info
    REG3_HEX: reg8bits port map (CLOCK_50, R2, enableRegFinal, MuxSelDig, RegFinal); --Display HEX0 HEX1
    
    ROM1: rom port map(Level_code, SelecionadaROM);
    ---------------------MULTIPLEXADORES----------------------------
    
    -- sel, in, out
    MUX_HEX5: mux2pra1_7bits port map (E1_or_E2 ,"1111111", "0000111", HEX5); --ok

    MUX_TIME_HEX4: mux2pra1_4bits port map (E2, Level_Time, SaidaCountT, mux_hex4_out); -- counterTmux - msm saida do counter time (VERIFICAR) 

    MUX_HEX4: mux2pra1_7bits port map (E1_or_E2, "1111111", decMux4, HEX4);

    MUX_N: mux2pra1_7bits port map (E1,"1111111" ,"0101011", muxMux3); --ok

    MUX_HEX3: mux2pra1_7bits port map (R1_xor_R2, muxMux3,"0101111", HEX3); --ok DUPLICATE

    MUX_LCODE: mux2pra1_7bits port map (E1, "1111111", decMuxCode, muxMux2); --ok
    
    MUX_HEX2: mux2pra1_7bits port map (R1_xor_R2, muxMux2, decMuxRound, HEX2); --ok
    
    MUX_END_GAME: mux2pra1_8bits port map (E5, e_somaseldig, e_engame_e_round, MuxSelDig); --acho que ok

    MUX_LEDR: mux2pra1_10bits port map (E5,"0000000000", SelecionadaROM, EntradaLEDS); --ok
    
    -------------------COMPARADORES E SOMA--------------------------
    
    COMP10: comp PORT MAP (SelecionadaROM, SeqDigitada, ComparaSelDig); -- ok
    
    SOMA10_COMP10: sum_with_for port map (ComparaSelDig, SomaSelDig); --ok

    COMP_4_ENDGAME: comp_igual4 port map (SomaSelDig, end_game_interno);

    SOMA_SW_ERRO: sum_with_for port map(SeqDigitada, SomaDigitada);

    Soma10_COMP4: comp_igual4 port map(SomaDigitada, swerro); --ok
    
    
    ---------------------DECODIFICADORES----------------------------
    --decod7seg   (in, out)
    
    DEC_HEX4: decod7seg port map (mux_hex4_out, decMux4); --entrada? 
    DEC_ROUND: decod7seg port map (round, decMuxRound); --ok
    DEC_LCODE: decod7seg port map (Level_code, decMuxCode); --ok
    DEC_HEX1: decod7seg port map (RegFinal(7 downto 4), HEX1); --ok
    DEC_HEX0: decod7seg port map (RegFinal(3 downto 0), HEX0); --ok
    
    ---------------------ATRIBUICOES DIRETAS---------------------
    n3 <= valorfin_vector(7);
    n2 <= not(valorfin_vector(7));
    n1 <= (valorfin_vector(7) and valorfin_vector(6)) or (valorfin_vector(7) and valorfin_vector(5)) or (valorfin_vector(6) and valorfin_vector(5));
    n0 <= (not(valorfin_vector(7)) and not(valorfin_vector(6))) or (not(valorfin_vector(7)) and not(valorfin_vector(5))) or (not(valorfin_vector(7)) and valorfin_vector(4)) or (not(valorfin_vector(6)) and not(valorfin_vector(5)) and valorfin_vector(4));

    Level_time <= n3 & n2 & n1 & n0;
    Level_code <= valorfin_vector(3 downto 0);

    EnableRegFinal <= E5 or E4;
    e_engame_e_round <= "000" & end_game_interno & not(round);
    e_somaseldig <= "1010" & SomaSelDig;
    naoerro <= not swerro ;
    switch_9 <= SW(9 downto 0);
    switch_7 <= SW(7 downto 0);
    LEDR(9 downto 0) <= EntradaLEDS;
    
    end_game <= end_game_interno;
    sw_erro <= naoerro;
    end_round <= end_round_interno;

    E1_or_E2 <= E1 or E2;
    R1_xor_R2 <= R1 XOR R2;


    end arc;
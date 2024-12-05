library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controle is
port
(
BTN1, BTN0, clock_50: in std_logic;
sw_erro, end_game, end_time, end_round: in std_logic;
R1, R2, E1, E2, E3, E4, E5: out std_logic
);
end entity;

architecture Behavioral of controle is
    type state is (Start, Setup, Play, Count_Round, Check, Waits, Result);
    signal EA, PE : state := start;
begin
    process(clock_50, BTN0)
    begin
        if BTN0 = '0' then
            EA <= start;
        elsif clock_50'event and clock_50='1'  then
            EA <= PE;
        end if;
    end process;

    process(EA, BTN1, end_time, end_game, end_round, sw_erro)
    begin
        case EA is
            when start =>
				R1 <= '1';
				R2 <= '1';
				E1 <= '0';
				E2 <= '0';
				E3 <= '0';
				E4 <= '0';
				E5 <= '0';
				
                if BTN1 = '0' then
                    PE <= Setup;
                else
                    PE <= start;
                end if;
            when Setup =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '1';
				
                if BTN1 = '0' then
                PE <= Play;
                else
                    PE <= setup;
                end if;
            when Play =>
				R1 <= '0';
				R2 <= '0';
				E1 <= '0';
				E2 <= '1';
				E4 <= '0';
				
                if end_time = '1' then
                PE <= Result;
                elsif (end_time = '0') and (BTN1 = '0') then
                    PE <= Count_Round;
                else
                    PE <= Play;
                end if;
            when Count_Round =>
				E3 <= '1';
				PE <= Check;

                PE <= Check;
            when Check =>
                R1 <= '0'; 
                R2 <= '0';
                E1 <= '0';
                E2 <= '0';
                E3 <= '0';
                E4 <= '1';
                E5 <= '0';
                
                if (end_round or sw_erro or end_game) = '1' then
                
                PE <= Result;
                else
                    PE <= Waits;
                end if;
            when Waits =>
				E2 <= '0';
				R1 <= '1';
				E4 <= '1';
				
                if BTN1 = '0' then
               
                PE <= Play;
                else 
                    PE <= Waits;
                end if;
            when Result =>
				E5 <= '1';
				E4 <= '1';
				E2 <= '0';
				E3 <= '0';
                E1 <= '0';
				
                if BTN1 = '0' then
                PE <= start;
                else 
                    PE <= Result;
                end if;
        end case;
    end process;
end Behavioral;
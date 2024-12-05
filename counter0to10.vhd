library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity counter0to10 is
port(
    Enable, Reset, CLOCK: in std_logic;
    Round: out std_logic_vector(3 downto 0);
    end_round: out std_logic
);
end counter0to10;

architecture bhv of counter0to10 is
    signal count: std_logic_vector(3 downto 0) := "0000"; 

begin
    P1: process(clock, reset)
    begin
        if reset = '1' then
            count <= "0000";
            end_round <= '0'; 
            elsif clock'event and clock = '1' and enable = '1' then
            if count = "1001" then
                count <= "0000"; 
                end_round <= '1'; 
            else
                count <= count + 1;
                end_round <= '0'; 
            end if;
        end if;
    end process;

    Round <= count; 
end bhv;
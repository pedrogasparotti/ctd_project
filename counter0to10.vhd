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
    P1: process(CLOCK, Reset, Enable)
    begin
        if Reset = '1' then
            count <= "0000";

        elsif CLOCK'event and CLOCK = '1' and Enable = '1' then
            count <= count + 1;
            Round <= count;

            if count = "1010" then
                end_round <= '1';
            end if;
        end if;
    end process;
end bhv;
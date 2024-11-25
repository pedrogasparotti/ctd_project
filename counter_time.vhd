library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity counter_time is 
port(
    Enable, Reset, CLOCK: in std_logic;
    load: in std_logic_vector(3 downto 0);
    end_time: out std_logic;
    tempo: out std_logic_vector(3 downto 0)
);
end counter_time;

architecture bhv of counter_time is
    signal count: std_logic_vector(3 downto 0) := "0000";
    signal count_done: std_logic := '0';

begin
    P1: process(CLOCK, reset, enable)
    begin
        if reset = '1' then
            count_done <= '0';
            count <= "0000";

        elsif CLOCK'event and CLOCK = '1' and enable = '1' then
            if count_done = '0' then
                if count = load - 1 then 
                    count_done <= '1';
                    count <= count + 1; 
                elsif count < load - 1 then
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    tempo <= count;
    end_time <= count_done;
            
end bhv;
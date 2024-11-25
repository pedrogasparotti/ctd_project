library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg8bits is
    Port ( CLK, RST, enable : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR(7 downto 0);
           Q : out STD_LOGIC_VECTOR(7 downto 0));
end reg8bits;

architecture behv of reg8bits is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            Q <= "00000000";
        elsif rising_edge(CLK) then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end behv;

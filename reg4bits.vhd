library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg4bits is
    Port ( CLK, RST, enable : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR(3 downto 0);
           Q : out STD_LOGIC_VECTOR(3 downto 0));
end reg4bits;

architecture behv of reg4bits is
begin
    process(CLK, RST)
    begin
        if RST = '0' then
            Q <= "0000";
        elsif rising_edge(CLK) then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end behv;

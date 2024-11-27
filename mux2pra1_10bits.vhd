library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg10bits is
    Port ( CLK, RST, enable : in STD_LOGIC;
           D : in STD_LOGIC_VECTOR(9 downto 0);
           Q : out STD_LOGIC_VECTOR(9 downto 0));
end reg10bits;

architecture behv of reg10bits is
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            Q <= "0000000000";
        elsif rising_edge(CLK) then
            if enable = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end behv;

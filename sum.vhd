library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sum is
    Port ( seq : in STD_LOGIC_VECTOR(9 downto 0);
           soma_out : out STD_LOGIC_VECTOR(3 downto 0));
end sum;

architecture circuito of sum is
begin
    soma_out <= "000" & seq(0) + "000" & seq(1) + "000" & seq(2) + "000" & seq(3) + 
                "000" & seq(4) + "000" & seq(5) + "000" & seq(6) + "000" & seq(7) + 
                "000" & seq(8) + "000" & seq(9);
end circuito;
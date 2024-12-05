library ieee;
use ieee.std_logic_1164.all;

entity comp_igual4 is
port(
    soma: in std_logic_vector(3 downto 0);
    status: out std_logic
    );
end comp_igual4;

architecture arch of comp_igual4 is
begin
status <= '1' when soma = "0100"
else '0';
end arch;
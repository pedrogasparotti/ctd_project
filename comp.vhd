library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comp is
    Port ( seq_user : in STD_LOGIC_VECTOR(9 downto 0);
           seq_reg : in STD_LOGIC_VECTOR(9 downto 0);
           seq_mask : out STD_LOGIC_VECTOR(9 downto 0));
end comp;

architecture circuito of comp is
begin
   seq_mask <= seq_user and seq_reg;
end circuito;
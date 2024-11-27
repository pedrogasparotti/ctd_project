-- Armazena as opções das sequências, dependendo no valor que for escolhido, será escolhida uma sequência aleatória, que deve ser preenchida pelo aluno

-----------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------
entity ROM is
  port ( address : in std_logic_vector(3 downto 0);
         data : out std_logic_vector(9 downto 0) );
end entity;

architecture Rom_Arch of ROM is
  type memory is array (00 to 15) of std_logic_vector(9 downto 0);
  constant my_Rom : memory := (
	00 => "0001010101",
	01 => "1111000000",
  02 => "1001000101",
	03 => "0001010110",
	04 => "1010100001",
	05 => "1000100011",
	06 => "1010001100",
	07 => "1001100001",
	08 => "1100000101",
	09 => "0010101100",
	10 => "0110100010",
	11 => "0101010001",
	12 => "1000010011",
	13 => "0111001000",
	14 => "0010100101",
	15 => "0011110000");
begin
   process (address)
   begin
     case address is
        when "0000" => data <= my_rom(00);
        when "0001" => data <= my_rom(01);
        when "0010" => data <= my_rom(02);
        when "0011" => data <= my_rom(03);
        when "0100" => data <= my_rom(04);
        when "0101" => data <= my_rom(05);
        when "0110" => data <= my_rom(06);
        when "0111" => data <= my_rom(07);
        when "1000" => data <= my_rom(08);
        when "1001" => data <= my_rom(09);
        when "1010" => data <= my_rom(10);
        when "1011" => data <= my_rom(11);
	when "1100" => data <= my_rom(12);
	when "1101" => data <= my_rom(13);
	when "1110" => data <= my_rom(14);
	when "1111" => data <= my_rom(15);
        when others => data <= "0001010101";
       end case;
  end process;
end architecture Rom_Arch;
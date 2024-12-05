library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- For numeric operations

entity sum_with_for is
    port (
        seq : in std_logic_vector(9 downto 0); -- 10-bit input
        soma_out      : out std_logic_vector(3 downto 0) -- 4-bit output
    );
end sum_with_for;

architecture arch of sum_with_for is
begin
    process(seq)
        variable sum : integer := 0; -- Variable to accumulate the sum
    begin
        sum := 0; -- Initialize sum
        for i in seq'range loop
            if seq(i) = '1' then
                sum := sum + 1;
            end if;
        end loop;
        soma_out <= std_logic_vector(to_unsigned(sum, soma_out'length)); -- Convert to std_logic_vector
    end process;
end arch;
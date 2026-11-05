-- Demi-additionneur 1 bit
library ieee;
use ieee.std_logic_1164.all;

entity ADD1 is
  port (
    E1, E2   : in  std_logic;
    Ret, Sum : out std_logic   -- retenue et somme
  );
end ADD1;

architecture additionneur of ADD1 is
begin
  Ret <= E1 and E2;
  Sum <= E1 xor E2;
end additionneur;

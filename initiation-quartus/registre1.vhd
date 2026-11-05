-- Bascule D avec remise à zéro asynchrone active à l'état bas
library ieee;
use ieee.std_logic_1164.all;

entity registre1 is
  port (
    clk, R, D : in  std_logic;
    Q         : out std_logic
  );
end registre1;

architecture reg_rst of registre1 is
begin
  process (clk, R)
  begin
    if R = '0' then
      Q <= '0';
    elsif rising_edge(clk) then
      Q <= D;
    end if;
  end process;
end reg_rst;

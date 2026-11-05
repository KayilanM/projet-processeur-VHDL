-- Montage d'initiation : multiplexeur 2 vers 1, demi-additionneur
-- et mémorisation de la somme et de la retenue dans deux bascules D
library ieee;
use ieee.std_logic_1164.all;

entity MIC1 is
  port (
    H, sel, A1, A2, B, rst : in  std_logic;
    Q1, Q2                 : out std_logic   -- somme et retenue mémorisées
  );
end MIC1;

architecture MIC of MIC1 is

  component ADD1 is
    port (
      E1, E2   : in  std_logic;
      Ret, Sum : out std_logic
    );
  end component;

  component registre1 is
    port (
      clk, R, D : in  std_logic;
      Q         : out std_logic
    );
  end component;

  signal A, s_sum, s_ret : std_logic;

begin

  -- Multiplexeur : sel choisit l'entrée A1 ou A2
  A <= A1 when sel = '1' else A2;

  comp1 : ADD1      port map (E1 => A, E2 => B, Sum => s_sum, Ret => s_ret);
  comp2 : registre1 port map (clk => H, R => rst, D => s_sum, Q => Q1);
  comp3 : registre1 port map (clk => H, R => rst, D => s_ret, Q => Q2);

end MIC;

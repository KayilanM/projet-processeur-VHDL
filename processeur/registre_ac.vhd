-- Registre accumulateur (AC) 16 bits
--  * RAZ    : remise à zéro asynchrone, active à l'état bas
--  * ld_AC  : chargement de D sur front montant de l'horloge
--  * store  : présente le contenu sur le bus mémoire, sinon haute impédance
library ieee;
use ieee.std_logic_1164.all;

entity registre_AC is
  port (
    D                      : in  std_logic_vector(15 downto 0);
    RAZ, ld_AC, store, clk : in  std_logic;
    Q, Q_mem               : out std_logic_vector(15 downto 0)
  );
end registre_AC;

architecture AC of registre_AC is
  signal AC_interne : std_logic_vector(15 downto 0);
begin
  process (clk, RAZ)
  begin
    if RAZ = '0' then
      AC_interne <= (others => '0');
    elsif rising_edge(clk) then
      if ld_AC = '1' then
        AC_interne <= D;
      end if;
    end if;
  end process;

  Q     <= AC_interne;
  Q_mem <= AC_interne when store = '1' else (others => 'Z');  -- sortie trois états
end AC;

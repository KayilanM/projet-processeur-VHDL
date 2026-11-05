-- Banc de test du registre accumulateur
-- Vérifie le chargement, le maintien de la valeur, la sortie trois états
-- vers la mémoire et la remise à zéro asynchrone.
-- Simulé avec GHDL (entité de plus haut niveau : tb_registre_AC).
library ieee;
use ieee.std_logic_1164.all;

entity tb_registre_AC is
end tb_registre_AC;

architecture sim of tb_registre_AC is
  signal D, Q, Q_mem : std_logic_vector(15 downto 0);
  signal RAZ, ld_AC, store : std_logic := '0';
  signal clk : std_logic := '0';
  signal fin : boolean := false;
begin
  dut : entity work.registre_AC
    port map (D => D, RAZ => RAZ, ld_AC => ld_AC, store => store,
              clk => clk, Q => Q, Q_mem => Q_mem);

  -- Horloge de période 20 ns
  clk <= not clk after 10 ns when not fin else '0';

  stimuli : process
  begin
    D <= x"0000";
    wait for 25 ns;
    RAZ <= '1';                               -- fin de la remise à zéro

    D <= x"1234"; ld_AC <= '1';               -- chargement de 1234
    wait for 20 ns;
    ld_AC <= '0'; D <= x"ABCD";               -- D change, sans chargement
    wait for 40 ns;
    assert Q = x"1234" report "Erreur : Q aurait du garder 1234" severity error;

    store <= '1';                             -- écriture vers la mémoire
    wait for 40 ns;
    assert Q_mem = x"1234" report "Erreur : Q_mem aurait du valoir 1234" severity error;
    store <= '0';                             -- Q_mem repasse en haute impédance

    D <= x"00FF"; ld_AC <= '1';               -- nouveau chargement
    wait for 20 ns;
    ld_AC <= '0';
    wait for 20 ns;

    RAZ <= '0';                               -- remise à zéro asynchrone
    wait for 15 ns;
    assert Q = x"0000" report "Erreur : la remise a zero n'a pas fonctionne" severity error;
    RAZ <= '1';

    store <= '1';
    wait for 30 ns;
    store <= '0';
    wait for 20 ns;

    report "Simulation terminee sans erreur";
    fin <= true;
    wait;
  end process;
end sim;

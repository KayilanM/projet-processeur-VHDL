-- Unité arithmétique et logique 16 bits
-- 8 opérations choisies par fc_ctrl. Les comparaisons sont non signées
-- et renvoient x"0001" si la condition est vraie, x"0000" sinon.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port (
    A, B    : in  std_logic_vector(15 downto 0);  -- 2 opérandes 16 bits
    fc_ctrl : in  std_logic_vector(2 downto 0);   -- code de l'opération
    ALU_out : out std_logic_vector(15 downto 0)   -- résultat 16 bits
  );
end ALU;

architecture Behavioral of ALU is
begin
  -- Logique combinatoire : le résultat dépend des opérandes et du code d'opération
  process (A, B, fc_ctrl)
  begin
    case fc_ctrl is
      when "000" => ALU_out <= std_logic_vector(unsigned(A) + unsigned(B));  -- addition
      when "001" => ALU_out <= std_logic_vector(unsigned(A) - unsigned(B));  -- soustraction
      when "010" => ALU_out <= A and B;                                      -- ET logique
      when "011" => ALU_out <= A or B;                                       -- OU logique
      when "100" =>                                                          -- A = B ?
        if A = B then
          ALU_out <= x"0001";
        else
          ALU_out <= x"0000";
        end if;
      when "101" =>                                                          -- A > B ?
        if unsigned(A) > unsigned(B) then
          ALU_out <= x"0001";
        else
          ALU_out <= x"0000";
        end if;
      when "110" =>                                                          -- A < B ?
        if unsigned(A) < unsigned(B) then
          ALU_out <= x"0001";
        else
          ALU_out <= x"0000";
        end if;
      when "111" => ALU_out <= A xor B;                                      -- OU exclusif
      when others => ALU_out <= (others => '0');
    end case;
  end process;
end Behavioral;

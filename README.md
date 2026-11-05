# Conception d'un processeur simple en VHDL

TP de conception numérique (BUT GEII, 2023–2024) réalisés sous **Quartus II 13.0**, pour un FPGA
**Altera Cyclone II** (EP2C20F484C7). Ils décrivent en VHDL les briques d'un processeur simple,
validées en simulation.

## Contenu

| Fichier | Description |
|---|---|
| `processeur/alu.vhd` | Unité arithmétique et logique 16 bits à 8 opérations |
| `processeur/registre_ac.vhd` | Registre accumulateur 16 bits avec remise à zéro et sortie trois états |
| `initiation-quartus/` | Premier projet Quartus : multiplexeur, demi-additionneur et bascules D |

## Unité arithmétique et logique (ALU)

L'opération est choisie par l'entrée `fc_ctrl` sur 3 bits :

| `fc_ctrl` | Opération |
|---|---|
| `000` | A + B |
| `001` | A − B |
| `010` | A ET B |
| `011` | A OU B |
| `100` | A = B (résultat 1 ou 0) |
| `101` | A > B (résultat 1 ou 0) |
| `110` | A < B (résultat 1 ou 0) |
| `111` | A OU exclusif B |

Les comparaisons traitent A et B comme des nombres **non signés**. Les indicateurs d'état
(zéro, retenue, négatif, dépassement) ne sont pas encore implémentés dans cette version.

## Registre accumulateur

- `RAZ` remet le registre à zéro immédiatement (asynchrone, actif à l'état bas).
- `ld_AC` charge la donnée `D` au front montant de l'horloge.
- `Q` donne en permanence le contenu du registre.
- `Q_mem` présente ce contenu sur le bus mémoire quand `store = '1'`, et passe en haute
  impédance (`Z`) sinon, pour ne pas perturber les autres composants reliés au bus.

## Projet d'initiation

`MIC1` sélectionne une entrée parmi deux (`sel`), l'additionne à `B` avec un demi-additionneur,
puis mémorise la somme et la retenue dans deux bascules D. Le projet s'ouvre directement avec
`MIC1.qpf`, et `Waveform1.vwf` contient les stimuli de simulation.

## Corrections apportées par rapport au compte rendu

- **ALU, opération `110` (A < B)** : les deux branches renvoyaient `x"0000"`. Sur la simulation
  d'origine, à 880 ns, la sortie valait 0 alors que A (14 914) était inférieur à B (43 523 en
  non signé, affiché −22 013 en signé).
- **ALU, liste de sensibilité** : le processus ne réagissait qu'à `fc_ctrl`. Quartus l'ignore à
  la synthèse, mais un simulateur VHDL comme ModelSim ne recalcule alors pas le résultat quand
  seuls A ou B changent. Elle contient maintenant `A, B, fc_ctrl`.
- **ALU, bibliothèques** : `std_logic_arith`/`std_logic_unsigned` (non standard) et
  `numeric_std` étaient mélangées, ce qui crée des conflits. Seule `numeric_std` est conservée.
  Le port `ZCNV`, déclaré mais jamais affecté, est retiré en attendant les indicateurs.
- **Registre accumulateur** : la donnée `D` était copiée dans le registre interne à chaque
  exécution du processus, hors front d'horloge. La sortie mémoire recopiait donc l'entrée `D`
  au lieu du contenu mémorisé (visible sur la simulation d'origine à partir de 520 ns).
  Le registre ne se charge plus qu'au front montant, quand `ld_AC = '1'`.
- **Projet Quartus** : les fichiers `add1.vhd` et `registre1.vhd` sont déclarés dans le projet,
  et le chemin absolu `D:/` vers les stimuli de simulation est remplacé par un chemin relatif.

## Auteur

Kayilan Mmadi Moilime

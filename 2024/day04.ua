Input     ← &fras "input/day04.txt"
Parse     ← ⊜∘≠@\n.
Match     ← /+♭∈⊙⧈∘
Straight₁ ← "SAMX"_"XMAS"
Diag₁     ← [∩(≡⇌.)⇌."X\W\W\W"_"\WM\W\W"_"\W\WA\W"_"\W\W\WS"]
Diag₂     ← [⍥⊸(⍉⇌)3["M\WM""\WA\W""S\WS"]]
Part₁     ← +⊃(+∩(Match Straight₁ 1_4) ⍉.|Match Diag₁ 4_4)
Part₂     ← Match Diag₂ 3_3
⊃($Part₁ Part₁|$Part₂ Part₂) Parse Input

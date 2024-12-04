Input     ← &fras "input/day04.txt"
Parse     ← ⊜∘≠@\n.
Compare   ← ↥⊃(≍|≍⇌)
Match₁    ← Compare "XMAS"
Match₂    ← Compare "MAS"
Straight  ← +∩(/+ ≡Match₁ ♭₂≡(⧈∘ 4))⊃(∘|⍉)
Diagonals ← ⊟∩(⌝⤸ 0_0)⊃(∘|⇌⍉)
Diagonal  ← /+ ≡Match₁ ♭₂≡Diagonals ♭₃⧈∘4_4
Part₁     ← +⊃(Straight|Diagonal)
Part₂     ← /+≡(/×≡Match₂ Diagonals) ♭₃⧈∘3_3
⊃(Part₁|Part₂) Parse Input

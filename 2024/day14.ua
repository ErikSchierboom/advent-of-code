Input        ← &fras "input/day14.txt"
Dim          ← 101_103
Step         ← ◿ Dim + ×
Map          ← ⍜(⍉|⬚0↯Dim°⊚)
Parse        ← ⊃↘↙2⍉ ⊜(⊟₄∩₄⋕°$"p=_,_ v=_,_") ≠@\n.
SafetyFactor ← /×♭⧈(/+♭) ⊟⊃(⌊|⌈)÷2△.
Part₁        ← SafetyFactor Map Step 100
Part₂        ← ⊗/↧.≡(SafetyFactor Map Step)⇡×°⊟Dim ∩¤
⊃($Part₁ Part₁|$Part₂ Part₂) Parse Input

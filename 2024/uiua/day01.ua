Input ← &fras "input/day01.txt"
Parse ← ⍉⊜(⊜⋕⊸≠@\s)⊸≠@\n
Part₁ ← /+⌵/-≡⍆
Part₂ ← /+≡(×/+):⟜⊞=°⊟
⊃($Part₁ Part₁|$Part₂ Part₂) Parse Input

Input    ← &fras "day3.txt"
Sample   ← $ xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
Toggles  ← ⊃(⌕"do()"|⌕"don't()")
Sanitize ← ▽⊏\↥×+1°⊏⊃(↥|⊂1) ⊸Toggles

Part₁ ← /+/×⋕↘₁⍉regex$ mul\((\d{1,3}),(\d{1,3})\)
Part₂ ← Part₁ Sanitize
Solve ← [⊃(Part₁|Part₂)]

⍤⤙≍ [161 48] Solve Sample
⍤⤙≍ [173529487 99532691] Solve Input

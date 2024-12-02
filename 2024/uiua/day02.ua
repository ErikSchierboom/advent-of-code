Input    ← &fras "input/day02.txt"
Parse    ← ⊜(□⊜⋕⊸≠@\s)⊸≠@\n
Sorted   ← ≠⊃(≍⍆.|≍⇌⍆.)
Adjacent ← ×∩(/×)≡(⊃(≥1|≤3)/-)◫2⍆
Safe     ← ◇(×⊃(Sorted|Adjacent))
Correct  ← ◇(≡⍜↻↘₁⊙¤°⊏)
Part₁    ← ⧻▽⊸≡Safe
Part₂    ← ⧻▽⊸≡(±Part₁ Correct)
⊃(Part₁|Part₂) Parse Input

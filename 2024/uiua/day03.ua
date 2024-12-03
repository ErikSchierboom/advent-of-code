Input ← &fras "input/day03.txt"
Parse ← ⬚"0"regex $ mul\((\d{1,3}),(\d{1,3})\)|do(n't)?\(\)
Part₁ ← /◇+⍚(×∩⋕⊃(⊡1|⊡2))
Part₂ ← Part₁ ▽\(↧₁↥₀+)⊂1+≡(⊃(◇≍"do()"⊡0|¯◇≍"don't()"⊡0)) .
⊃(Part₁|Part₂) Parse Input

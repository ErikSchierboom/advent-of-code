# Experimental!
Input       ← &fras "input/day05.txt"
ParseRule   ← ⋕≡[°$"_|_"]
ParseUpdate ← ⍚(⊜⋕≠@,.)
Parse       ← :⊓(¤ParseRule|ParseUpdate) ∩(⊜□≠@\n.) °$"_\n\n_"
Ordered     ← /×∈:⧈₂∘
Swap        ← ⍣(⍜(↙2↘)⇌|◌)
Reorder     ← ⍥(Swap ⊗0 ◡(∈:⧈₂∘))∞
Middle      ← ⊡⌊÷2⧻.
MiddleSum   ← /+≡◇Middle
Part₁       ← MiddleSum ▽⤚≡◇Ordered
Part₂       ← MiddleSum ⊙◌⍚Reorder ▽◡≡◇(¬Ordered)
⊃($Part₁ Part₁|$Part₂ Part₂) Parse Input

Input  ← &fras "day1.txt"
Sample ← $ 3   4
         $ 4   3
         $ 2   5
         $ 1   3
         $ 3   9
         $ 3   3

Parse ← °⊟⍉↯∞_2⊜⋕⊸≥@0
Part₁ ← /+⌵-∩⍆
Part₂ ← /+×⟜(/⊂⊞(/+=))⊙¤
Solve ← [⊃(Part₁|Part₂)] Parse

⍤⤙≍ [11 31] Solve Sample
⍤⤙≍ [2196996 23655822] Solve Input

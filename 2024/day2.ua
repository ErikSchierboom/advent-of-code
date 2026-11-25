Input  ← &fras "day2.txt"
Sample ← $ 7 6 4 2 1
         $ 1 2 7 8 9
         $ 9 7 6 2 1
         $ 1 3 2 4 5
         $ 8 6 4 4 1
         $ 1 3 6 7 9

Parse ← ⊜(□⊜⋕⊸≠@\s) ⊸≠@\n

InRange       ← /××⊃≥₁≤₃⌵
SameSign      ← /×⧈∘=±
Safe          ← ×⊃(InRange|SameSign) ⧈∘-
RemoveOne     ← ≡⍜↻↘₁⊙¤°⊏
SafeV₂        ← /↥≡Safe RemoveOne
NumberOfSafe! ← /+≡◇^0

Part₁ ← NumberOfSafe!Safe
Part₂ ← NumberOfSafe!SafeV₂

Solve ← [⊃(Part₁|Part₂)] Parse

⍤⤙≍ [2 4] Solve Sample
⍤⤙≍ [490 536] Solve Input

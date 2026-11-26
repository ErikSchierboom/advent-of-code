Input  ← &fras "day4.txt"
Sample ← $ MMMSXXMASM
         $ MSAMXMSMSA
         $ AMXSXMAAMM
         $ MSAMASMSMX
         $ XMASAMXAMM
         $ XXAMMXXAMA
         $ SMSMSASXSS
         $ SAXAMASAAA
         $ MAMMMXMMMM
         $ MXMXAXMASX

Parse         ← ⊜∘⊸≠@\n
ToDiagnonal   ← ≡(↻¯⊙(⬚@\W↯))⊸⇡⊸⧻
PatternsPart₁ ← {⊃(⇌⍉¤|⍉¤|∘|⇌|◡∩≡⇌⟜⇌ToDiagnonal)} "XMAS"
PatternsPart₂ ← {⊃(∘|≡⇌|⍉|⇌⍉)} ["M\WS"
                                "\WA\W"
                                "M\WS"]
Count ← /+≡(/+/+⌕°□)

Part₁ ← Count PatternsPart₁
Part₂ ← Count PatternsPart₂
Solve ← [⊃(Part₁|Part₂)] ¤Parse

⍤⤙≍ [18 9] Solve Sample
⍤⤙≍ [2549 2003] Solve Input

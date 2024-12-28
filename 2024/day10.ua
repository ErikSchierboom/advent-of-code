Input      ← &fras "input/day10.txt"
Trailheads ← ⊚=0
Parse      ← ⊃Trailheads¤ ⊜∵⋕≠@\n.
Neighbors  ← +A₂¤
Steps      ← ▽=-1 ⤚∩⬚∞⊡ ⊸⤚Neighbors
Top        ← =9⊡
Paths      ← path(Steps|Top)
Score      ← ⧻◴≡⊣ Paths
Rating     ← ⧻Paths
Part₁      ← /+≡Score
Part₂      ← /+≡Rating
⊃($Part₁ Part₁|$Part₂ Part₂) Parse Input

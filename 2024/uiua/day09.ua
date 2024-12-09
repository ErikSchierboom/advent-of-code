Input    ← &fras "input/day09.txt"
File     ← +1▽:⌊÷2
Empty    ← ▽⊃⋅∘0
Checksum ← /+×°⊏
Layout   ← /◇⊂≡(□⨬(Empty|File)=0◿2.)°⊏-@0
Defrag   ← ⍥(⨬(◌|⍜⊏⇌)≤°⊟. ⊸(⊂⊃(⊣▽|⊢▽¬):°⊏))∞
Part₁    ← Checksum -1▽±. Defrag
Part₂    ← 1◌
⊃($Part₁ Part₁|$Part₂ Part₂) Layout Input

(module
  (memory (export "mem") 1)

  (global $actualRedCubes i32 (i32.const 12))
  (global $actualGreenCubes i32 (i32.const 13))
  (global $actualBlueCubes i32 (i32.const 14))

  (global $red i32 (i32.const 114))   ;; ASCII 'r'
  (global $green i32 (i32.const 103)) ;; ASCII 'g'
  (global $blue i32 (i32.const 98))   ;; ASCII 'b'

  (global $i (mut i32) (i32.const 0))

  (func $parseNumber (result i32)
    (local $c i32)
    (local $number i32)

    (loop $loop
      (local.set $c (i32.load8_u (global.get $i)))

      (if
        (i32.or
          (i32.lt_u (local.get $c) (i32.const 48))  ;; < ASCII '0'
          (i32.gt_u (local.get $c) (i32.const 57))) ;; > ASCII '9'
        (then
          (return (local.get $number))))
      
      (local.set $number
        (i32.add 
          (i32.mul (local.get $number) (i32.const 10))
          (i32.sub (local.get $c) (i32.const 48))))

      (global.set $i (i32.add (global.get $i) (i32.const 1)))
      (br $loop))

    (return (i32.const -1)) ;; We should not get here
  )

  (func $parseId (result i32)
    (global.set $i (i32.add (global.get $i) (i32.const 5))) ;; skip over "Game "
    (return (call $parseNumber)))

  (func $parseColor (result i32)
    (local $c i32)
    (local.set $c (i32.load8_u (global.get $i)))

    (if (i32.eq (local.get $c) (global.get $blue))
      (then 
        (global.set $i (i32.add (global.get $i) (i32.const 4))) ;; skip over "lue"
        (return (global.get $blue))))

    (if (i32.eq (local.get $c) (global.get $red))
      (then 
        (global.set $i (i32.add (global.get $i) (i32.const 3))) ;; skip over "ed"
        (return (global.get $red))))
    
    (if (i32.eq (local.get $c) (global.get $green))
      (then 
        (global.set $i (i32.add (global.get $i) (i32.const 5))) ;; skip over "reen"
        (return (global.get $green))))

    (return (i32.const -1)) ;; We should not get here
  )

  (func (export "solve") (param $length i32) (result i32 i32)
    (local $partA i32)
    (local $partB i32)
    (local $id i32)
    (local $redCubes i32)
    (local $greenCubes i32)
    (local $blueCubes i32)
    (local $maxRedCubes i32)
    (local $maxGreenCubes i32)
    (local $maxBlueCubes i32)
    (local $cubes i32)
    (local $color i32)
    (local $c i32)

    (loop $gameLoop
      (local.set $id (call $parseId))
      (global.set $i (i32.add (global.get $i) (i32.const 2))) ;; skip over ": "
      (local.set $maxRedCubes (i32.const 0))
      (local.set $maxBlueCubes (i32.const 0))
      (local.set $maxGreenCubes (i32.const 0))

      (loop $revealsLoop
        (local.set $redCubes (i32.const 0))
        (local.set $blueCubes (i32.const 0))
        (local.set $greenCubes (i32.const 0))

        (loop $revealLoop
          (local.set $cubes (call $parseNumber))
          (global.set $i (i32.add (global.get $i) (i32.const 1))) ;; skip over " "
          (local.set $color (call $parseColor))

          (if (i32.eq (local.get $color) (global.get $red))
            (then
              (local.set $redCubes (local.get $cubes))
              (if (i32.gt_u (local.get $redCubes) (local.get $maxRedCubes))
                (then (local.set $maxRedCubes (local.get $redCubes))))))
          (if (i32.eq (local.get $color) (global.get $blue))
            (then
              (local.set $blueCubes (local.get $cubes))
              (if (i32.gt_u (local.get $blueCubes) (local.get $maxBlueCubes))
                (then (local.set $maxBlueCubes (local.get $blueCubes))))))
          (if (i32.eq (local.get $color) (global.get $green))
            (then
              (local.set $greenCubes (local.get $cubes))
              (if (i32.gt_u (local.get $greenCubes) (local.get $maxGreenCubes))
                (then (local.set $maxGreenCubes (local.get $greenCubes))))))

          (local.set $c (i32.load8_u (global.get $i)))
          (if (i32.eq (local.get $c) (i32.const 44)) ;; equal to ','
            (then
              (global.set $i (i32.add (global.get $i) (i32.const 2))) ;; skip over " "
              (br $revealLoop)))
          
          (if (i32.gt_u (local.get $blueCubes) (global.get $actualBlueCubes))
            (then (local.set $id (i32.const 0))))

          (if (i32.gt_u (local.get $redCubes) (global.get $actualRedCubes))
            (then (local.set $id (i32.const 0))))

          (if (i32.gt_u (local.get $greenCubes) (global.get $actualGreenCubes))
            (then (local.set $id (i32.const 0))))

          (if (i32.eq (local.get $c) (i32.const 59)) ;; equal to ';'
            (then
              (global.set $i (i32.add (global.get $i) (i32.const 2))) ;; skip over " "
              (br $revealsLoop)))

          (if (i32.eq (local.get $c) (i32.const 10)) ;; equal to newline
            (then
              (global.set $i (i32.add (global.get $i) (i32.const 1))) ;; skip over newline 
            ))))

      (local.set $partA (i32.add (local.get $partA) (local.get $id)))
      (local.set $partB (i32.add (local.get $partB) (i32.mul (local.get $maxBlueCubes) (i32.mul (local.get $maxGreenCubes) (local.get $maxRedCubes)))))
      (br_if $gameLoop (i32.ne (i32.load8_u (global.get $i)) (i32.const 0))))

    (return (local.get $partA) (local.get $partB))))

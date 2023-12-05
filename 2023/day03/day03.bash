part_a=0

readarray -t lines < input.txt

rows=${#lines[@]}
cols=${#lines[0]}

part_a=0
part_b=0

declare -A star_numbers

for y in $(seq 0 $((rows - 1))); do
    line=${lines[$y]}

    x=0
    num=0
    part=0
    starred_pos=""

    while (( x < cols )); do
        c=${line:$x:1}

        [[ $c =~ ^[0-9]$ ]]
        is_digit=$?

        if (( is_digit == 0 )); then
            num=$((num * 10 + $c))

            for dy in {-1..1}; do
                for dx in {-1..1}; do
                    if [[ $dx -eq 0 && $dy -eq 0 ]]; then
                        continue
                    fi

                    check_x=$((x + dx))
                    check_y=$((y + dy))

                    if (( check_x < 0 || check_x >= cols || check_y < 0 || check_y >= rows )); then
                        continue
                    fi

                    check_line=${lines[$check_y]}
                    check_char=${check_line:$check_x:1}
                    if [[ $check_char =~ ^[^0-9\.]$ ]]; then
                        part=1

                        if [[ $check_char == '*' ]]; then
                            starred_pos="$check_x,$check_y"
                        fi
                    fi
                done
            done
        fi

        if (( is_digit != 0 || x == cols - 1 )); then
            if (( num != 0 && part == 1 )); then
                part_a=$((part_a + num))

                if [[ $starred_pos != "" ]]; then
                    star_numbers[$starred_pos]="${star_numbers[$starred_pos]} $num"
                fi
            fi

            num=0
            part=0
            starred_pos=""
        fi
        x=$((x + 1))
    done
done

for i in "${!star_numbers[@]}"; do
    values=(${star_numbers[$i]})
    if [[ ${#values[@]} -eq 2 ]]; then
        part_b=$((part_b + values[0] * values[1]))
    fi
done

echo "part a: ${part_a}"
echo "part b: ${part_b}"

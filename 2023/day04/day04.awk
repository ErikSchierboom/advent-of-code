BEGIN {
    part_a = 0
    part_b = 0
}

{
    delete winning
    num_matching = 0    

    for (i = 3; i <= 12; i++)
        winning[$i] = true

    for (i = 14; i <= NF; i++)
        if ($i in winning) num_matching++

    card_id = substr($2, 1, length($2) - 1)
    instances[card_id]++

    part_a += num_matching > 0 ? lshift(1, num_matching - 1) : 0
    part_b += instances[card_id]

    for (j = card_id + 1; j <= card_id + num_matching; j++)
        instances[j] += instances[card_id]
}

END {
    print "part a: " part_a
    print "part b: " part_b
}

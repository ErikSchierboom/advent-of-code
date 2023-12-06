frame <- read.table("input.txt", header = FALSE)

num_wins <- function(time, distance) sum(seq_len(time - 1) * (time - seq_len(time - 1)) > distance)
part_a <- prod(apply(frame[,-1], 2, function (pair) num_wins(pair[1], pair[2])))
part_b <- num_wins(as.double(paste0(frame[1, -1], collapse = "")), as.double(paste0(frame[2, -1], collapse = "")))

cat("part a: ", part_a)
cat("part b: ", part_b)

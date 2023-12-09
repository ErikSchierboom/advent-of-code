:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

card(Ordering, Value) --> [Card], { nth0(Value, Ordering, Card) }.
player(Ordering, Cards-Amount) --> sequence(card(Ordering), Cards), { length(Cards, 5 ) }, white, integer(Amount).
players(Ordering, Players) --> sequence(player(Ordering), "\n", Players), !.

counts(Cards, Counts) :-
    sort(0, @=<, Cards, SortedCards),
    clumped(SortedCards, CardCounts),
    transpose_pairs(CardCounts, Counts).

% Five of a kind
wildcard_score(10, [C,C,C,C,C]) :- !.
wildcard_score(10, Cards) :- counts(Cards, [1-A, 4-B]), (A = 0; B = 0), !.
wildcard_score(10, Cards) :- counts(Cards, [2-A, 3-B]), (A = 0; B = 0), !.

% Four of a kind
wildcard_score(9, Cards) :- counts(Cards, [1-_, 4-_]), !.
wildcard_score(9, Cards) :- counts(Cards, [1-A, 1-B, 3-C]), (A = 0; B = 0; C = 0), !.
wildcard_score(9, Cards) :- counts(Cards, [1-_, 2-A, 2-B]), (A = 0; B = 0), !.

% Full house
wildcard_score(8, Cards) :- counts(Cards, [2-_, 3-_]), !.
wildcard_score(8, Cards) :- counts(Cards, [1-0, 2-_, 2-_]), !.

% Three of a kind
wildcard_score(7, Cards) :- counts(Cards, [1-_, 1-_, 3-_]), !.
wildcard_score(7, Cards) :- counts(Cards, [1-A, 1-B, 1-C, 2-D]), (A = 0; B = 0; C = 0; D = 0), !.

% Two pair
wildcard_score(6, Cards) :- counts(Cards, [1-_, 2-_, 2-_]), !. 

% One pair
wildcard_score(5, Cards) :- counts(Cards, [1-0, 1-_, 1-_, 1-_, 1-_]), !.
wildcard_score(5, Cards) :- counts(Cards, [1-_, 1-_, 1-_, 2-_]), !.

% High card
wildcard_score(4, _) :- !.

regular_score(10, [C,C,C,C,C]) :- !. % Five of a kind
regular_score(9, Cards) :- counts(Cards, [1-_, 4-_]), !. % Four of a kind
regular_score(8, Cards) :- counts(Cards, [2-_, 3-_]), !. % Full house
regular_score(7, Cards) :- counts(Cards, [1-_, 1-_, 3-_]), !. % Three of a kind
regular_score(6, Cards) :- counts(Cards, [1-_, 2-_, 2-_]), !. % Two pair
regular_score(5, Cards) :- counts(Cards, [1-_, 1-_, 1-_, 2-_]), !. % One pair
regular_score(4, _) :- !. % High card

prepend_score(_, [], []).
prepend_score(ScoreFunc, [Cards-Amount|Hands], [Score-Cards-Amount|ScoredHands]) :-
    call(ScoreFunc, Score, Cards),
    prepend_score(ScoreFunc, Hands, ScoredHands), !.

parse(Ordering, Players) :-
    string_chars(RelativeFileName, "input.txt"),
    absolute_file_name(RelativeFileName, AbsoluteFilename, [mode(read)]),
    read_file_to_string(AbsoluteFilename, Content, []),
    string_chars(Content, Chars),
    phrase(players(Ordering, Players), Chars).

bid_sum([], 0, _).
bid_sum([_-_-Bid|Players], Sum, Rank) :-
    bid_sum(Players, PlayersSum, Rank + 1),
    Sum is PlayersSum + Rank * Bid.

solve(ScoreFunc, Ordering, Solution) :-
    parse(Ordering, Players),
    prepend_score(ScoreFunc, Players, ScoredPlayers),
    sort(0, @=<, ScoredPlayers, SortedPlayers),
    bid_sum(SortedPlayers, Solution, 1).

solution(PartA, PartB) :-
    solve(regular_score, "23456789TJQKA", PartA),
    solve(wildcard_score, "J23456789TQKA", PartB).

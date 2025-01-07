(ns day04-test
  (:require [clojure.test :refer :all]
            [day04 :as sut]
            input))

(def live (input/for-day 4))

(deftest part1
  (testing "Sample"
    (is (= 1 (sut/part1 (sut/parse "111111-111111"))))
    (is (= 0 (sut/part1 (sut/parse "223450-223450"))))
    (is (= 0 (sut/part1 (sut/parse "123789-123789")))))

  (testing "Live"
    (is (= 1178 (sut/part1 (sut/parse live))))))

(deftest part2
  (testing "Sample"
    (is (= 1 (sut/part2 (sut/parse "112233-112233"))))
    (is (= 1 (sut/part2 (sut/parse "111122-111122"))))
    (is (= 0 (sut/part2 (sut/parse "123444-123444"))))
    (is (= 0 (sut/part2 (sut/parse "223450-223450")))))

  (testing "Live"
    (is (= 763 (sut/part2 (sut/parse live))))))

(ns day01-test
  (:require [clojure.test :refer :all]
            [day01 :as sut]
            input))

(def sample
  "12
14
1969
100756")

(def live (input/for-day 1))

(deftest part1
  (testing "Sample"
    (is (= 34241 (sut/part1 (sut/parse sample)))))

  (testing "Live"
    (is (= 3365459 (sut/part1 (sut/parse live))))))

(deftest part2
  (testing "Sample"
    (is (= 51316 (sut/part2 (sut/parse sample)))))

  (testing "Live"
    (is (= 5045301 (sut/part2 (sut/parse live))))))

(ns day01
  (:require convert))

(def parse convert/str->ints)

(defn- fuel-requirement [mass]
  (- (quot mass 3) 2))

(defn- compound-fuel-requirement [mass]
  (->> mass
       (iterate fuel-requirement)
       (take-while pos?)
       (rest)
       (reduce +)))

(defn- total-fuel [f parsed] (reduce + (map f parsed)))

(defn part1 [parsed] (total-fuel fuel-requirement parsed))
(defn part2 [parsed] (total-fuel compound-fuel-requirement parsed))

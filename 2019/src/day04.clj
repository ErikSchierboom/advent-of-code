(ns day04
  (:require convert
            [clojure.string :as str]))

(defn parse [input] (map Integer/parseInt (str/split input #"-")))

(defn valid? [cmp number]
  (let [digits (convert/int->digits number)]
    (boolean
     (and
      (apply <= digits)
      (some #(cmp (count %) 2) (partition-by identity digits))))))

(defn digits [parsed]
  (let [[low high] parsed]
    (range low (inc high))))

(defn count-valid [cmp parsed]
  (->> parsed
       (digits)
       (filter (partial valid? cmp))
       (count)))

(defn part1 [parsed] (count-valid >= parsed))
(defn part2 [parsed] (count-valid = parsed))

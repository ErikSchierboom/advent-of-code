(require '[clojure.string :as str])

(defn transpose [m] (apply mapv vector m))
(defn zip [left right] (map vector left right))
(defn hamming-distance [pair] (count (filter #(apply not= %1) (apply zip pair))))

(defn perfect-reflection? [pattern-pairs]
  (every? #(apply = %1) pattern-pairs))

(defn imperfect-reflection? [pattern-pairs]
  (= (reduce + (map hamming-distance pattern-pairs)) 1))

(defn reflection? [pred pattern idx]
  (->> (zip (reverse (take idx pattern)) (drop idx pattern))
       (pred)))

(defn reflection-indexes [pred pattern]
  (->> (range 1 (count pattern))
       (filter #(reflection? pred pattern %1))))

(defn reflection-pattern-sum [pred pattern]
  (+
   (reduce + (map #(* 100 %1) (reflection-indexes pred pattern)))
   (reduce + (reflection-indexes pred (transpose pattern)))))

(defn reflection-sum [pred patterns]
  (reduce + (map #(reflection-pattern-sum pred %1) patterns)))

(def patterns
  (-> "input.txt"
      (slurp)
      (str/split #"\n\n")
      (#(map (comp seq str/split-lines) %1))))

(printf "part a: %d" (reflection-sum perfect-reflection? patterns))
(printf "part b: %d" (reflection-sum imperfect-reflection? patterns))

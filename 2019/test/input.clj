(ns input
  (:require [clojure.java.io :as io]))

(defn file-path [n]
  (clojure.java.io/resource
   (format "day%02d.txt" n)))

(defn for-day [n] (slurp (file-path n)))

(ns convert
  (:require [clojure.string :as str]))

(defn str->lines [str] (str/split-lines str))

(defn str->ints [str] (map Integer/parseInt (str->lines str)))

(defn int->digits [n] (map #(- (byte %) 48) (str n)))

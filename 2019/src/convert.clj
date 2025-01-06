(ns convert
  (:require [clojure.string :as str]))

(defn ->strings [str] (str/split-lines str))

(defn ->ints [str] (map Integer/parseInt (->strings str)))

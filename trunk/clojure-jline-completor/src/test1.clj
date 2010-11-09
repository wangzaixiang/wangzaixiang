(ns test1)

(defn blank? [s] 
  (every? #(Character/isWhitespace %) s))

(defstruct book :author :title)

(defn buybook [{author :author}]
  (print author)
)
(ns wangzx.test-xml
	(:use [clojure.zip :only [xml-zip] ])
)


(use 'clojure.xml)

(def -xml "<performs_respones xmlns =\"http://cp.pony.cn/1.0\"> 
  <perform> 
    <PerformName>2008年12月-2009年12月31日</PerformName> 
    <ProjectName>郁金香摩锐水世界</ProjectName> 
    <SeatType>无座位</SeatType> 
    <FieldName>国家京剧院实验剧场•畅和园</FieldName> 
    <Address>１</Address> 
    <PerformTime>2009-12-31 0:00:00</PerformTime> 
    <PerformID>169681</PerformID> 
    <AreaID>852</AreaID> 
  </perform> 
  <perform> 
    <PerformName>场次一（）</PerformName> 
    <ProjectName>纵贯线（电子票）</ProjectName> 
    <SeatType>有座位</SeatType> 
    <FieldName>工人体育场</FieldName> 
    <Address>工人体育场</Address> 
    <PerformTime>2009-11-18 19:30:00</PerformTime> 
    <PerformID>238888</PerformID> 
    <AreaID>852</AreaID> 
  </perform> 
 </performs_respones>")
 
(defn- text-for-node [node]
	(let [ [content] (:content node) ]
		(if (map? content) nil content))
)
 
 ;; (xml tree ["perform"]) -> [ elem1, elem2 ]
 ;; (xml tree ["perform" "PerformName"] -> [ text1, text2 ]
(defn- xpath-1
	"Return the nodes for next level elements" 
	[Node path]
	(if (= path :text!)
			(text-for-node Node) 
			(filter #(= path (:tag %)) (:content Node))
	)
)
(defn- xpath-2 [Nodes path]
	(if (map? Nodes)
			(xpath-1 Nodes path)	
			(apply concat (map #(xpath-1 % path) Nodes))	;; [node1 node2]
	)
)


(defn xpath [Nodes Pathes]
	(if (empty? Pathes) Nodes
			(recur (xpath-2 Nodes (first Pathes)) (rest Pathes)) 
	)
)

(defn md5-sum
  "Compute the hex MD5 sum of a string."
  [#^String str]
  (let [alg (doto (java.security.MessageDigest/getInstance "MD5")
              (.reset)
              (.update (.getBytes str)))]
    (try
      (.toString (new java.math.BigInteger 1 (.digest alg)) 16)
      (catch java.security.NoSuchAlgorithmException e
        (throw (new RuntimeException e))))))

(def -tree 
 	(parse (-> -xml java.io.StringReader. org.xml.sax.InputSource.)))
 	
(defn -main [] (xpath -tree [:perform :PerformName]))
(defn -main2 [] (xpath -tree [:peform :PerformName :text!]))

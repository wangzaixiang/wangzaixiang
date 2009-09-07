(ns wangzx.test)

(use 'clojure.http.client)

(def -msg "http://219.136.240.94:13013//cgi-bin/sendsms?username=hyjk&password=hotye&to=13808846365&text=%E6%B5%8B%E8%AF%95")

(def -data {
		:url	"http://219.136.240.94:13013//cgi-bin/sendsms"
		:message "尊敬的好易会员，您于08月25日在好易站投注的彩票〔彩票编号：000154454943〕共中得奖金￥5元。奖金将在10个工作日内自动返还至您的投注银行卡中，敬请留意。热线85566300"
		:fields {	:username "hyjk" :password "unknown"
					 		:to "13808846365" }
	})

(defn sendsms1 [arg]
	(let [	forms (assoc (:fields -data) :text arg)
					res 
					(request (str (:url -data) "?" (url-encode forms)))]
		(println "send sms to " (:to forms) "message:" arg)
		(:body-seq res)
	)
)

(defn sendsms [arg]
	(loop [ msg arg ]
		(if (< (.length msg) 62) (sendsms1 msg)
			(do (sendsms1 (.substring msg 0 62)) (recur (.substring msg 62) ) )
		)
	)
)

					 

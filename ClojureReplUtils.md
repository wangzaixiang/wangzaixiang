# Target Tab Complete Features #

  * **(re-s TAB**  will show hint for all matched vars in current namespace **(complete)**
  * **(Class/for TAB** will show java hint for members such as forName
  * **(.. instance TAB** will show java hint for instance method
  * **(doto instance TAB** will show java hint for instance method

> with Tab Complete ASAP, the REPL will be much interesting.

# Other features #

# TODO #
  * rewrite the JLine ClojureCompletor with clojure, override the clojur/main.clj to automate dect the availabilty of JLine libraray, and enable JLine Tab Complete if possible. so we can still using java -jar clojure.jar to startup the REPL
  * add .repl.clj support, automated load the module for user defined initialize
  * add classpath operation such as (load-jar) to load a jar into classpath. so we no need to add it the launch script but in clojure script such as ".repl.clj"
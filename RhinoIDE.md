#design a JavaScript IDE based on rhino

# Introduction #

Impressed by Squeak and Morph, I would like a similar thing in the java world, maybe javascript is chooice.


# Details #

javascript Browser: like the squeak "class browser"
  * browse classes(class like the prototype)
  * edit classes. when saved, the class is hot

Object Inspector：
  * inspect a script object
  * modify it
  * script it
  * serialized the object into file system with json format

Workspace Management
  * script management.
  * object management.
  * once startup, can reuse the objects on last snapshot
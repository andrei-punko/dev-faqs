# Java

## Java profiling
https://www.youtube.com/watch?v=4TTgrRPnvno

## Java 8: Stream Style
http://w.on24.com/r.htm?e=807818&s=1&k=467E0D659F4695078A17A3F17A73C441

## JSR (Java Specification Request)
Documents describing proposed additions to the Java platform

## Start application and make thread dump
```sh
java -agentlib:hprof=cpu=samples,depth=100,interval=20,lineno=y,thread=y,file=your_dump_name.hprof -jar your-jar-name.jar
```

## Get java process ids
```sh
jps
```

## Get thread pool
```sh
jstack
```

## Heap dump in case of OOM error
```sh
java -XX:+HeapDumpOnOutOfMemoryError MainClass
```

## Switch on debug of SSL in Java
http://itech-notes.blogspot.com/2013/02/javaxnetdebug-ssl-java.html
```sh
java -Djavax.net.debug=SSL,handshake,data,keymanager,trustmanager -jar ...
```

## Include one XML into another
```xml

<include resource="by/andd3dfx/mdclogging/mdc-pattern.xml"/>
```

## JVisualVM error: "jvisualvm can not locate Java installation"
https://stackoverflow.com/questions/59538974/jvisualvm-can-not-locate-java-installation

You have 2 options:
- Launch `bin/visualvm.exe` at the command line with the `--jdkhome` parameter and your JDK location
  ```sh
  visualvm.exe --jdkhome "c:\\Program Files\\Java\\jdk-11.0.13"
  ```
- Update the `visualvm_jdkhome` variable in the file `etc/visualvm.conf` of your JVisualVM directory

## JVisualVM error: redefinition failed with error 62 while trying to profile an application
https://stackoverflow.com/questions/26834651/redefinition-failed-with-error-62-while-trying-to-profile-an-application

In VM arguments, add `-Xverify:none`

## To add breakpoint for exception by condition - put next text into Condition field:
```
this instanceof java.lang.ClassCastException
```

## OpenJDK General-Availability Releases
https://jdk.java.net/archive/

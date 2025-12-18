# Maven

## Clean results of previous build
```
mvn clean
mvn clean :module-name
```

## Clean & build
```
mvn clean install
mvn clean install :module-name
```

## Clean & test
```
mvn clean test
mvn clean test :module-name
```

## Build module with all modules it depends on
```
mvn [clean] install -am -pl :module-name
```

## Build all modules dependent of current module
```
mvn [clean] install -amd -pl :module-name
```

## Skip tests (save time, but not good way)
```
mvn [clean] install -am -pl :module-name -Dmaven.test.skip=true
mvn [clean] install -am -pl :module-name -DskipTests
```

## Build several modules (Reactor pattern)
```
mvn [clean] install -pl :module-name-1,...,:module-name-n
```

## Run one test-class
```
mvn clean test -pl :module-name -Dtest=TestClassName
```

## Run one test-method (for `maven-surefire-plugin` 2.7.3+)
```
mvn clean test -pl :module-name -Dtest=TestClassName#methodName
```

## Run several test-methods (for `maven-surefire-plugin` 2.12.1+)
```
mvn clean test -pl :module-name -Dtest=TestClassName#methodName1+methodName2
```

## Debug some test
```
mvn clean test -pl :<module-name> -Dmaven.surefire.debug
mvn clean test -pl :<module-name> -Dtest=<TestClassName> -Dmaven.surefire.debug=”-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005 -Xnoagent -Djava.compiler=NONE”
```
In IDE use remote debug with port 5005

## Show dependencies list
```
mvn dependency:list
mvn -pl :<module-name> dependency:list
```

## Guide dependencies list output to selected file
```
mvn dependency:list > deps-list.txt
mvn -pl :<module-name> dependency:list > deps-list.txt
```

## Analyze maven dependencies
Use `dependency:analyze` to show you whether there are dependencies in your pom that you don’t need 
(it may also identify some that you have missed, add -DoutputXML=true to show the missing entries):
```
mvn -pl :<module-name> dependency:analyze -DoutputXML=true
```

## Show dependency tree
```
mvn dependency:tree
mvn -pl :<module-name> dependency:tree
```

## Dependency tree: you can guide output to selected file
```
mvn dependency:tree > deps-tree.txt
mvn -pl :<module-name> dependency:tree > deps-tree.txt
```

## Dependency tree: add -Dverbose=true to show all the duplicates and conflicts
```
mvn dependency:tree -Dverbose=true
mvn -pl :<module-name> dependency:tree -Dverbose=true
```

## Maven `compile` vs `provided` scope:
- `compile` - default scope, available in runtime, propagated to dependent project
- `provided` - like compile, but isn't available on runtime, and don’t propagated to dependent project

## Some notes
- For artifact versions it’s better to use constants
- Use Ctrl+C to stop maven build
- Try to avoid cyclic dependencies

## To remove Maven warning about `platform-dependent build` - add to root pom of the project:
```xml
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
  </properties>
```

## Make release with maven-release-plugin
```
mvn clean release:clean release:prepare release:perform --batch-mode
```

## Init Maven wrapper
https://www.baeldung.com/maven-wrapper
```
mvn -N wrapper:wrapper
```

## Upgrade Maven wrapper version
```
./mvnw wrapper:wrapper -Dmaven=3.9.6
mvn wrapper:wrapper -Dmaven=3.9.6
```

## Чтобы использовать при сборке Maven-ом ту же версию Java, что и команда java в консоли
Добавить в `pom.xml`:
```xml
<properties>
  <maven.compiler.executable>java</maven.compiler.executable>
</properties>
```
Это должно решить проблему с конфликтом между OpenJDK и Oracle JDK, т.к. теперь Maven будет использовать системную версию Java

## Скачать заново артефакты при сборке и обновить те, что сохранены в локальном Maven репозитории:
```
mvn clean compile -U
```

## Fix case when mvnw doesn't have +x permission ("mvnw: Permission denied")
https://github.com/actions/starter-workflows/issues/171
```
git update-index --chmod=+x mvnw
```

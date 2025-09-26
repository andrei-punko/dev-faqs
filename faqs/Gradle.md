# Gradle

## Stop run of all Gradle agents
```
./gradlew --stop
```

## Build Gradle dependencies tree
```
./gradlew -q dependencies > deps.txt
```

## Run particular test in Gradle
```
gradle test --tests HealthCheckSpecTest
```

## Publishing artifact
```
plugins {
    `maven-publish`
}

publishing {
    publications {
        create<MavenPublication>("maven") {
            groupId = groupId
            artifactId = artifactId
            version = version

            from(components["java"])
        }
    }
}
```

## Set JVM memory params for Gradle project:
Add into the project root file `gradle.properties` with next content:
```
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m
```

## Switch off incremental build and re-run tasks
```
./gradlew clean build --rerun-tasks
```

## Run tests in parallel using Gradle
https://stackoverflow.com/questions/23805915/run-parallel-test-task-using-gradle
```
test {
    maxParallelForks = Runtime.runtime.availableProcessors().intdiv(2) ?: 1
}
```

## Upgrade gradle wrapper version
```
./gradlew wrapper --gradle-version 8.5
gradle wrapper --gradle-version 8.5
```

## Gradle compatibility matrix
https://docs.gradle.org/8.8/userguide/compatibility.html

## Fix case when gradlew doesn't have +x permission ("Gradlew: Permission denied")
https://github.com/actions/starter-workflows/issues/171
```
git update-index --chmod=+x gradlew
```

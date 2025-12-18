# JUnit 4 / 5 for Spring Boot

According to next [video](https://www.udemy.com/course/spring-framework-5-beginner-to-guru/learn/lecture/11592692) by
John Thompson

Useful Baeldung [article](https://www.baeldung.com/junit-5-migration)

## JUnit 4
```java
import org.junit.Test;

@RunWith(SpringRunner.class)
@SpringBootTest
public class AppTest {
    @Test
    public void contextLoads() {
    }
}
```

```xml

<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-test</artifactId>
  <scope>test</scope>
</dependency>
```

## JUnit 5
```java
import org.junit.jupiter.api.Test;

@ExtendWith(SpringExtension.class)
@SpringBootTest
public class AppTest {
    @Test
    public void contextLoads() {
    }
}
```

```xml

<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
    <exclusions>
      <exclusion>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
      </exclusion>
    </exclusions>
  </dependency>
  <dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <scope>test</scope>
  </dependency>
  <dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

```xml

<build>
  <plugins>
    <plugin>
      <artifactId>maven-surefire-provider</artifactId>
      <version>2.22.0</version>
      <dependencies>
        <groupId>org.junit.platform</groupId>
        <artifactId>junit-platform-surefire-provider</artifactId>
        <version>${junit-platform.version}</version>
      </dependencies>
    </plugin>
  </plugins>
</build>
```

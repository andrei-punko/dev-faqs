# Spring — заметки

Конспект по основам контейнера + практические сниппеты. XML оставлен сжато — для сопровождения легаси; в новых проектах предпочтительны Java-конфиг и auto-configuration (Spring Boot).

## Component scan

В XML:

```xml
<context:component-scan base-package="soundsystem" />
```

В Java-конфиге:

```java
@Configuration
@ComponentScan  // пакет — пакет класса с @Configuration
public class AppConfig { }
```

Явный базовый пакет:

```java
@ComponentScan("soundsystem")
@ComponentScan(basePackages = "soundsystem")
@ComponentScan(basePackages = {"soundsystem", "video"})
@ComponentScan(basePackageClasses = {CDPlayer.class, DVDPlayer.class})
```

## Имя бина

```java
@Component("lonelyHeartsClub")
@Named("lonelyHeartsClub") // JSR-330
```

```java
@Bean(name = "lonelyHeartsClubBand")
public CompactDisc sgtPeppers() { return new SgtPeppers(); }
```

## Внедрение зависимостей

Конструктор, сеттер или произвольный метод — через `@Autowired`; альтернатива — `@Inject` (JSR-330).

```java
@Autowired
public CDPlayer(CompactDisc cd) { ... }
```

```java
@Inject
public CDPlayer(CompactDisc cd) { ... }
```

В Java-конфиге зависимости часто передают параметром метода `@Bean`:

```java
@Bean
public CDPlayer cdPlayer(CompactDisc compactDisc) {
    return new CDPlayer(compactDisc);
}
```

**Конструктор vs поле:** для обязательных зависимостей предпочтительнее конструктор; опциональные — через сеттер/поле при необходимости.

## Тесты с контекстом Spring

JUnit 4 (легаси, всё ещё встречается в старых проектах):

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = CDPlayerConfig.class)
public class CDPlayerTest {
    // ...
}
```

Захват stdout в тестах (библиотека [System Rules](https://stefanbirkner.github.io/system-rules/) + JUnit 4 `@Rule`) — по сути устарело, но полезно знать при чтении старых тестов:

```java
@Rule
public final StandardOutputStreamLog log = new StandardOutputStreamLog(); // system-rules / аналоги
```

В новых тестах предпочтительнее JUnit 5 и `OutputCaptureExtension` (Spring Boot) или проверка логгера.

JUnit 5:

```java
@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = CDPlayerConfig.class)
class CDPlayerTest {
    // ...
}
```

В Spring Boot чаще `@SpringBootTest` (или срезы `@WebMvcTest`, `@DataJpaTest` и т.д.).

## Импорт конфигурации

```java
@Configuration
@Import(CDConfig.class)
public class CDPlayerConfig { }

@Configuration
@Import({CDPlayerConfig.class, CDConfig.class})
public class SoundSystemConfig { }
```

Java-конфиг + XML:

```java
@Configuration
@Import(CDPlayerConfig.class)
@ImportResource("classpath:cd-config.xml")
public class SoundSystemConfig { }
```

В XML:

```xml
<import resource="cd-config.xml" />
```

Регистрация `@Configuration` из XML:

```xml
<bean class="soundsystem.CDConfig" />
```

Один «корневой» конфиг собирает модули и обычно включает component scan (`@ComponentScan` или `<context:component-scan>`).

**Рекомендация (из конспекта):** по возможности auto-configuration; явная конфигурация — в Java, а не в XML (типобезопасность, рефакторинг).

---

## Legacy XML (кратко)

Объявление бина: `<bean id="..." class="...">`. Конструктор + `ref`:

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer">
    <constructor-arg ref="compactDisc" />
</bean>
```

c-namespace (нужны объявления `xmlns:c` в `<beans>`):

```xml
<bean id="cdPlayer" class="soundsystem.CDPlayer" c:cd-ref="compactDisc" />
<bean id="cdPlayer" class="soundsystem.CDPlayer" c:_0-ref="compactDisc" />
<!-- один параметр: c:_-ref="..." -->
```

Литералы и коллекции — через `<constructor-arg value="..."/>`, `<list>` / `<set>` с `<value>` или `<ref bean="..."/>`, `<null/>`.

p-namespace и вложенный `<property>` — для setter injection; вынесенный список — `<util:list id="trackList">...</util:list>` и `p:tracks-ref="trackList"`.

Элементы `util:`: `constant`, `list`, `map`, `properties`, `property-path`, `set` — см. [документацию Spring](https://docs.spring.io/spring-framework/reference/core/beans.html).

Плейсхолдеры в XML: `<context:property-placeholder />` (разрешение через `Environment`).

---

## DataSource

### Встроенная БД со скриптами (тесты / dev)

```java
@Bean(destroyMethod = "shutdown")
public DataSource dataSource() {
    return new EmbeddedDatabaseBuilder()
        .addScript("classpath:schema.sql")
        .addScript("classpath:test-data.sql")
        .build();
}
```

Обычно под капотом H2 (раньше в книгах часто упоминали Hypersonic).

### JNDI (application server)

```java
@Bean
public DataSource dataSource() throws Exception {
    JndiObjectFactoryBean factory = new JndiObjectFactoryBean();
    factory.setJndiName("jdbc/myDS");
    factory.setResourceRef(true);
    factory.setProxyInterface(javax.sql.DataSource.class);
    factory.afterPropertiesSet();
    return (DataSource) factory.getObject();
}
```

### Пул вручную

В Spring Boot по умолчанию — HikariCP и настройки `spring.datasource.*`. Пример явного бина:

```java
@Bean(destroyMethod = "close")
public DataSource dataSource() {
    HikariDataSource ds = new HikariDataSource();
    ds.setJdbcUrl("jdbc:h2:tcp://dbserver/~/test");
    ds.setDriverClassName("org.h2.Driver");
    ds.setUsername("sa");
    ds.setPassword("password");
    ds.setMaximumPoolSize(30);
    ds.setMinimumIdle(5);
    return ds;
}
```

Старый `BasicDataSource` (Commons DBCP) с `setMaxActive` / `setInitialSize` для новых проектов не рекомендуется — API и зависимости другие; предпочтительны Boot + Hikari.

---

## Профили

```java
@Configuration
@Profile("dev")
public class DevelopmentProfileConfig { ... }

@Bean(destroyMethod = "shutdown")
@Profile("dev")
public DataSource embeddedDataSource() { ... }
```

В XML: корневой `<beans profile="dev">` или атрибут `profile` (см. схему beans).

Активация: `spring.profiles.active` (env, JVM, `application.properties`), параметры веб-приложения, JNDI; в тестах — `@ActiveProfiles`.

Если задан `spring.profiles.active`, `spring.profiles.default` не перекрывает его. Несколько профилей — через запятую.

JUnit 4 + профиль:

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = PersistenceTestConfig.class)
@ActiveProfiles("dev")
public class PersistenceTest {
    // ...
}
```

JUnit 5 + профиль:

```java
@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = PersistenceTestConfig.class)
@ActiveProfiles("dev")
class PersistenceTest { ... }
```

---

## Условные бины (`@Conditional`)

```java
@Bean
@Conditional(MagicExistsCondition.class)
public MagicBean magicBean() { ... }

public class MagicExistsCondition implements Condition {
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return context.getEnvironment().containsProperty("magic");
    }
}
```

`ConditionContext`: `getRegistry()`, `getBeanFactory()`, `getEnvironment()`, `getResourceLoader()`, `getClassLoader()`.

---

## Несколько бинов одного типа: `@Primary` и `@Qualifier`

```java
@Component
@Primary
public class IceCream implements Dessert { ... }

@Bean
@Primary
public Dessert iceCream() { ... }
```

```xml
<bean id="iceCream" class="com.desserteater.IceCream" primary="true" />
```

```java
@Autowired
@Qualifier("iceCream")
public void setDessert(Dessert dessert) { ... }
```

Кастомные стерео-аннотации с `@Qualifier` на типе; на точке внедрения — несколько таких аннотаций для сужения выбора.

---

## Области жизни (scopes)

- **singleton** — один на контекст (по умолчанию).
- **prototype** — новый экземпляр при каждом запросе из контекста.
- **session** / **request** — в веб-приложении на сессию / на запрос.

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class Notepad { ... }

@Bean
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public Notepad notepad() { return new Notepad(); }
```

Сессионный бин в синглтон нужно внедрять через **scoped proxy** (иначе один экземпляр «прилипнет» к синглтону):

```java
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ShoppingCart {
    // ...
}
```

Для интерфейса можно `ScopedProxyMode.INTERFACES`. В XML: `<aop:scoped-proxy />` (при необходимости `proxy-target-class="false"` для JDK-прокси).

---

## Свойства и SpEL

`@PropertySource` + `Environment`:

```java
@Configuration
@PropertySource("classpath:/com/soundsystem/app.properties")
public class ExpressiveConfig {
    @Autowired
    Environment env;
    // env.getProperty("disc.title")
    // env.getProperty("db.connection.count", Integer.class, 30)
    // env.getRequiredProperty("disc.title")
    // env.containsProperty("disc.title")
}
```

Плейсхолдеры `${...}` в XML/Java. Для явной регистрации (без Boot) иногда нужен:

```java
@Bean
public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
    return new PropertySourcesPlaceholderConfigurer();
}
```

В Boot это обычно не требуется.

```java
public BlankDisc(
    @Value("${disc.title}") String title,
    @Value("${disc.artist}") String artist) { ... }
```

**SpEL** (`#{...}`): литералы, `T(System).currentTimeMillis()`, свойства бинов, `systemProperties[...]`, безопасная навигация `?.`, `T(java.lang.Math).PI`, тернарный оператор, Elvis `?:`, `matches`, индексы и отборы `.?[]`, `.^[]`, `.$[]`, проекция `.![]`, комбинации.

---

## Валидация в Spring Boot

Обзор: [Spring validation (blog.upagge.ru)](https://blog.upagge.ru/posts/guide/2020/spring/validation/)

**Контроллер**

- Тело запроса (`@RequestBody`): аннотации Bean Validation на DTO + `@Valid` на параметре → типично `MethodArgumentNotValidException` и ответ 400 (при настроенной обработке).
- Путь и query (`@PathVariable`, `@RequestParam`): аннотации на параметрах + `@Validated` на классе контроллера → нарушения через `ConstraintViolationException` (часто настраивают маппинг в 400).

**Сервис**

- `@Validated` на классе + `@Valid` на параметре метода → `ConstraintViolationException`.

Точные коды ответа зависят от `@ControllerAdvice` и версии; при необходимости сверяйте с текущей документацией Boot.

---

## MockMvc: тело ответа строкой

[Stack Overflow: check string in response body](https://stackoverflow.com/questions/18336277/how-to-check-string-in-response-body-with-mockmvc)

```java
MvcResult result = mockMvc.perform(post("/api/users")
        .header("Authorization", base64ForTestUser)
        .contentType(MediaType.APPLICATION_JSON)
        .content("{\"userName\":\"testUserDetails\",...}"))
    .andDo(MockMvcResultHandlers.print())
    .andExpect(status().isBadRequest())
    .andReturn();
String content = result.getResponse().getContentAsString();
```

Альтернатива без `MvcResult`: `andExpect(content().string(containsString("...")))` и статические импорты из `MockMvcResultMatchers`.

---

## Файл из `classpath` (`resources`)

```java
new ClassPathResource("ccp-" + name.toLowerCase() + ".yaml").getFile();
```

`getFile()` работает только для ресурса на **реальном диске**; в упакованном JAR используйте `getInputStream()` или `Resource.getFile()` только если уверены в раскладке (например, тесты из IDE).

---

## Свойства JVM / окружения в коде

```java
@Autowired
private Environment env;

@PostConstruct
void init() {
    String name = env.getProperty("fabric.org.name");
}
```

В Boot те же ключи задаются через `application.properties`, переменные окружения и т.д.

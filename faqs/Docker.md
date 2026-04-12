# Docker — заметки

Ориентир: **Docker Engine / Docker CE** на Linux и **Docker Desktop** на Windows. Устаревшие шаги из старых заметок (`apt.dockerproject.org`, пакет `docker-engine`, `apt-key` со SKS) заменены ссылками на актуальную установку; легаси-сценарии сохранены помеченными.

Сценарии **только для Windows** (Desktop, `DockerCli.exe`, группа `docker-users`, `wincred`) — в [Windows.md](Windows.md).

## Установка на Ubuntu / Debian

Актуально: [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) (официальный скрипт или пошагово с `keyring` и репозиторием `download.docker.com`).

Кратко после установки:

```bash
sudo systemctl enable --now docker
docker run hello-world
```

**Устарело (из старых заметок, не повторять на новых системах):** репозиторий `apt.dockerproject.org`, пакет `docker-engine`, `apt-key adv` и ключи с SKS, отдельный пакет `linux-image-extra-*` под AUFS — это эпоха Ubuntu 14.04–16.04 и старого демона.

## Подготовка на Windows

Виртуализация в BIOS, версия Windows, WSL2 / Hyper-V — см. [Windows.md](Windows.md) (Docker Desktop и WSL2).

## Первые команды

```bash
docker run hello-world
docker run -d hello-world          # detached; не путать с «hello-world -d» в конце
docker ps
docker ps -a
docker images
docker logs <container>
```

Порты:

```bash
docker run -d -p <host_port>:<container_port> <image>[:tag]
```

Пример PostgreSQL:

```bash
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
docker run -it --rm --link some-postgres:postgres postgres psql -h postgres -U postgres
```

`--link` устарел; в новых сетях удобнее общая user-defined network и имя сервиса как hostname в Compose.

Обновление пакета движка на Linux: `sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io` (имена пакетов см. в документации вашего года выпуска).

## Образы: commit, tag, push, registry

```bash
docker commit <container_id> my-image:tag
docker stop <container_id>
docker run -d my-image:tag
```

Вход в приватный реестр (пароль лучше через stdin, не в командной строке):

```bash
echo "$PASSWORD" | docker login <host>:<port> -u <user> --password-stdin
docker login <host>:<port>
```

```bash
docker images
docker tag <image_id> <registry>/<name>:<tag>
docker push <registry>/<name>:<tag>
docker pull <image>
```

Пример цепочки (подставьте свой Nexus / Artifactory):

```bash
docker pull tarantool/tarantool:2.7.2
docker tag tarantool/tarantool:2.7.2 <your-registry>/tarantool/tarantool:2.7.2
docker push <your-registry>/tarantool/tarantool:2.7.2
```

### `daemon.json`: зеркала и insecure registry

Формат — JSON, пути к реестрам **`host:port`** (без тройных двоеточий из опечатки в старых заметках):

```json
{
  "registry-mirrors": [],
  "insecure-registries": ["registry.example.com:18443"]
}
```

После правок — перезапуск демона: `sudo systemctl restart docker`.

### Maven и Docker

В `settings.xml` для публикации в реестр через Maven (пароль — через CI-секреты, не в открытом виде):

```xml
<servers>
  <server>
    <id>docker-hub</id>
    <username>admin</username>
    <password>...</password>
    <configuration>
      <email>you@example.com</email>
    </configuration>
  </server>
</servers>
```

`DOCKER_HOST` для **docker-maven-plugin** (если демон слушает TCP), например `tcp://127.0.0.1:2375` — только в доверенной сети; предпочтительно Unix-socket и проброс для CI.

## Демон на TCP (Jenkins / легаси)

Старые заметки: правка `/etc/default/docker`, `DOCKER_OPTS="-H tcp://192.168.x.x:2375"`, правка `docker.service`. Сейчас предпочтительны **systemd drop-in** или официальная документация «Configure remote access»; открытый TCP без TLS — риск.

## Очистка

```bash
docker system prune
docker container prune
docker image prune
docker network prune
docker volume prune
```

```bash
docker kill $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker rmi $(docker images -q -f dangling=true)
docker volume rm $(docker volume ls -f dangling=true -q)
```

## Вход в контейнер и сеть

```bash
docker exec -it <name_or_id> /bin/bash
docker exec -it <name_or_id> sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container>
```

**Доступ к хосту из контейнера (Windows / Desktop):** `host.docker.internal`. На Linux часто `172.17.0.1` или extra_hosts — см. [SO](https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach).

Проверка: `nslookup host.docker.internal` (см. [ab57](https://ab57.ru/cmdlist/nslookup.html)).

## Dockerfile (сжато)

Подробнее: [Habr / RUVDS](https://habr.com/ru/company/ruvds/blog/439980/), [Kapeli cheat sheet](https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index).

| Инструкция | Назначение |
|------------|------------|
| `FROM` | Базовый образ (можно несколько стадий multi-stage) |
| `LABEL` | Метаданные; **`MAINTAINER` устарел** — заменить на `LABEL maintainer="..."` |
| `ENV` | Переменные среды |
| `RUN` | Shell-форма или exec JSON; объединять `&&` и чистить кэш пакетов — меньше слоёв |
| `COPY` / `ADD` | Копирование; `ADD` умеет tar и URL (URL для загрузки **не рекомендуется**, лучше `RUN wget` + удалить артефакт) |
| `CMD` / `ENTRYPOINT` | Запуск; см. ниже |
| `WORKDIR` | Рабочая директория |
| `ARG` | Build-time переменные |
| `EXPOSE` | Документация портов (не публикует на хост само по себе) |
| `VOLUME` | Тома |
| `HEALTHCHECK` | Проверка живости (`interval`, `timeout`, `retries`) |

**CMD vs ENTRYPOINT:** см. [документацию](https://docs.docker.com/reference/dockerfile/) и блок в старых заметках: фиксированная команда — чаще `ENTRYPOINT`; переопределяемые аргументы — `CMD` в связке с `ENTRYPOINT`. Exec-форма предпочтительнее shell-формы (лишний `sh -c`).

`Dockerfile` и **`Containerfile`** (Podman) — по сути одно и то же соглашение.

Пример заготовки под Spring Boot / Java (проверьте путь к JAR и базовый образ):

```dockerfile
FROM eclipse-temurin:21-jre-alpine
VOLUME /tmp
EXPOSE 8080
COPY target/articles-backend-app-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=container","-jar","/app.jar"]
```

Актуальный лёгкий JRE: например `eclipse-temurin:21-jre-alpine`.

## Docker Compose

Спецификация: [Compose file reference](https://docs.docker.com/compose/compose-file/) (актуальная версия схемы — смотрите поле `version` и доки для вашей установки).

Плагин CLI: **`docker compose`** (v2). Старая отдельная утилита `docker-compose` (v1) устаревает.

Ссылки из заметок: [getting started](https://docs.docker.com/compose/gettingstarted/), [dker.ru](https://dker.ru/docs/docker-compose/getting-started/), [Habr](https://habr.com/ru/company/ruvds/blog/450312/).

Пример (выравнивание пробелами, без табов в YAML):

```yaml
services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/code
    depends_on:
      - redis
  redis:
    image: redis
```

```bash
docker compose up -d
docker compose stop
docker compose down --volumes
docker compose ps
docker compose exec <service> <command>
docker compose logs -f
docker compose logs -f <service>
```

**Ожидание готовности сервиса:** `depends_on` не ждёт «готовности» процесса; используйте **`healthcheck`** и при необходимости обёртки в entrypoint. Пример с RabbitMQ и `healthcheck`: [SO](https://stackoverflow.com/questions/31746182/docker-compose-wait-for-container-x-before-starting-y), [доки](https://docs.docker.com/compose/compose-file/#healthcheck).

## Тома

```bash
docker volume create myvol
docker volume ls
docker volume inspect myvol
docker run -it --rm --mount source=myvol,target=/data nginx:latest sh
docker history <image>
```

## Копирование файлов

```bash
docker cp <container>:/path/in/container /path/on/host
```

Пример: `docker cp django:/usr/local/lib/python3.9/site-packages D:/Work/temp` (пути под Windows — в своём стиле).

## Сборка Java через Maven в контейнере

`Dockerfile`:

```dockerfile
FROM maven:3-eclipse-temurin-17-alpine AS builder
WORKDIR /usr/local
ENTRYPOINT ["mvn", "install"]
```

`docker-compose.yml`:

```yaml
services:
  builder:
    build: .
    volumes:
      - ./:/usr/local
```

Запуск: `docker compose run --rm builder` или `docker compose up` в зависимости от цели.

## RabbitMQ

```bash
docker run -d --hostname guru-rabbit --name some-rabbit \
  -p 8080:15672 -p 5671:5671 -p 5672:5672 \
  rabbitmq:3-management
```

Логин/пароль по умолчанию: `guest` / `guest`.

## PostgreSQL: больше соединений

[SO: max_connections](https://stackoverflow.com/questions/47252026/how-to-increase-max-connection-in-the-official-postgresql-docker-image)

В `docker-compose.yml`:

```yaml
command: postgres -c 'max_connections=200'
```

Или SQL в `docker-entrypoint-initdb.d/` через volume.

## Testcontainers / Docker Hub `unauthorized`

Сообщение вида `Head "https://registry-1.docker.io/.../ryuk/...": unauthorized` — выполнить логин:

```bash
docker login index.docker.io
```

См. [SO](https://stackoverflow.com/questions/72205231/test-ignored-and-failing-when-running-it-test-in-spring-boot-mongodb-test-conta).

## Лимит параллельных загрузок/отдачи

В `daemon.json`: [SO](https://stackoverflow.com/questions/43479614/docker-parallel-operations-limit)

```json
{
  "max-concurrent-uploads": 1,
  "max-concurrent-downloads": 1
}
```

## Локаль UTF-8 в контейнере

```bash
-e LANG=C.UTF-8 -e LC_ALL=C.UTF-8
```

## Дублирование тега образа

[SO: duplicate tag](https://stackoverflow.com/questions/64350015/how-to-duplicate-docker-image-with-a-new-tag)

```bash
docker tag myapp:1.0.0 myapp:old
docker tag registry/myapp:1.0.0 registry/myapp:old
```

## Остановка всех контейнеров (аккуратно)

Подставьте **ASCII-дефис** в опциях (в старых заметках иногда был похожий Unicode-символ):

```bash
docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)
```

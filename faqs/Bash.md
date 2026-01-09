# Bash

## Получение home директории bash

```bash
which bash
```

## Потом этот путь должен быть прописан вначале скриптов

```bash
#!/bin/bash
```

## Сделать файл исполняемым (gives everyone execute permission)

```bash
chmod +x script-name
```

## Сделать файл исполняемым (gives everyone read/execute permission)

```bash
chmod +rx script-name
```

## Рекомендация

Don't use all-uppercase, use at least one lowercase character in your names

## Чтение значений пользователя в переменные `$a`, `$b`

```bash
read a b
```

## Вывод информации без перевода строки (по умолчанию `-e`)

```bash
echo -ne <string>
```

## Архивирование директории, расположенной по адресу `<path>` в файл `<archive_name>`

```bash
tar -czf <archive_name>.taz.gz /<path>
```

## Параметры командной строки

- `$1, $2, $3` - параметры
- `$@` - все, в массиве
- `$#` - их кол-во

## Файловые операции

| Операция                                              | Команда            |
|-------------------------------------------------------|--------------------|
| Указание на наличие спецсимволов в файле              | `-c filename`      |
| Проверка существования директории                     | `-d directoryname` |
| Проверка существования объекта (файла или директории) | `-e filename`      |
| Проверка существования конкретно файла                | `-f filename`      |
| Существует ли файл и относится ли к текущему GID      | `-G filename`      |
| Установлен ли для файла GID                           | `-g filename`      |
| Является ли файл символьной ссылкой                   | `-L filename`      |
| Существует ли файл и относится ли к текущему UID      | `-O filename`      |
| Доступен ли для чтения                                | `-r filename`      |
| Является ли сокетом                                   | `-S filename`      |
| Имеет ли ненулевую длину                              | `-s filename`      |
| Установлен ли для файла UID                           | `-u filename`      |
| Доступен ли для записи                                | `-w filename`      |
| Является ли исполняемым файлом                        | `-x filename`      |

## Условное выражение

```bash
if [ <expression> ]; then
	<if case>
else
	<else case>
fi
```

## Arithmetic Comparisons

| Оператор | Значение |
|----------|----------|
| `-lt`    | <        |
| `-gt`    | >        |
| `-le`    | <=       |
| `-ge`    | >=       |
| `-eq`    | ==       |
| `-ne`    | !=       |

## String Comparisons

| Оператор | Значение               |
|----------|------------------------|
| `=`      | equal                  |
| `!=`     | not equal              |
| `<`      | less then              |
| `>`      | greater then           |
| `-n s1`  | string s1 is not empty |
| `-z s1`  | string s1 is empty     |

## Цикл for

```bash
for I in $( <any_array> ); do <actions> done
for I in {start..stop}; do <actions> done
for I in 1 2 3 4 5; do <actions> done
for ((I=1; I <= 10 ; I++)); do <actions> done
```

## Цикл while

```bash
while [ <условное выражение> ]; do <actions> done
```

## Цикл until

```bash
until [ <условное выражение> ]; do <actions> done
```

## Математические вычисления

```bash
$((<expression>))
let VARIABLE_NAME=$a+$b
```

## Вывод вещественных чисел с помощью printf

```bash
echo $(printf %2.3f $VARIABLE_NAME)
```

## Переназначение потока вывода/потока ошибок

```bash
1>DESTINATION / 2>DESTINATION
```

Варианты DESTINATION:
- имя файла
- `1`
- `2`
- `/dev/null`

## Case statement

```bash
case $A in
 2)<action1>
 5)<action2>
esac
```

## Просмотр содержимого файла, в том числе изменяющегося (например: трассировка лога)

```bash
less <filename>
```

- `q` - выход из режима редактирования

## Просмотр лога в zip-файле

```bash
zless <filename>
```

## Рекурсивный поиск и обход указанных каталогов/файлов, проверка для них условий и выполнение указанных действий

```bash
find файл [ ... ] ключи/условия/действия
```

### Examples

```bash
# просто печатает все имена файлов (эквивалентно find ./ -type f -print)
find

# находим рекурсивно все файлы с именем, соотв. маске "*1*1*" и для каждого выполняем grep -l "depl.*y" <имя_файла> (выводим имя файла, если он содержит строку "depl.*y", где .* - любое кол-во любых символов)
find /d/testdir/ -name "*1*1*" -type f -exec grep -l "depl.*y" {} \;
```

## Рекурсивный поиск вхождения строки по паттерну

```bash
grep [OPTION]... PATTERN [FILE]...
```

### Examples

```bash
grep -i 'hello world' menu.h main.c
grep -r -l 'depl.*y' /d/testdir/subdir1/*1*1*
```

Вывод grep-ом строк с контекстом (около найденных):
добавить ключ «-A» (после контекста), «-B» (перед контекстом) и «-C» (контекст), например: `grep -C 2 pattern files`

### `grep` usage examples

```bash
grep -r '<bean ' /d/Magic/dev/domains/stay/stay-service/src/ > /c/stay-service-beans.txt
grep -A 5 -r '<bean ' /d/Magic/dev/domains/stay/stay-service/src/ > /c/stay-service-beans-with-context.txt
grep -h -n "package " /c/_search_results/*.java | sort -n | uniq
```

## Наиболее часто используемые команды

```bash
cat
less
grep
```

## uniq

```bash
uniq -c success2.txt > /c/1.txt
uniq -c /c/_log_backup2/3.txt > /c/3log.txt
```

## sort

```bash
sort result.txt
sort result.txt | uniq -c
sort result.txt | uniq -c > parse_result.txt
sort parse_result.txt
sort parse_result.txt > sorted_parse_result.txt
```

## Показать разницу между файлами

```bash
diff --report-identical-files <filename-1> <filename-2> > <diff-log-fname>
```

### Пример

```bash
diff --report-identical-files c:/stay-batch-deps.txt c:/stay-batch-runtime-deps.txt > c:/diff.txt
```

## Пример grep-а лога: (показываем из данного файла много строк (20 тыс) начиная с строки с указанным куском)

```bash
grep "2013.04.19 10:31" -A 20000 *soap.log
```

## Поиск файла

```bash
find -name "application-runner.args"
```

## Замена строки в файлах

```bash
oldstring='1.0.2-SNAPSHOT'
newstring='1.0.3-SNAPSHOT'
find . -name "pom.xml" -print | xargs sed -i s@$oldstring@$newstring@g
```

## suid, sgid, sticky bit

- **suid** - означает, что при запуске данного файла он будет запущен с правами автора файла
- **sgid** - означает, что при запуске данного файла он будет запущен с правами группы, к которой файл принадлежит
- **sticky bit** - раньше означал, что файл часто используется ОС; сейчас - применяется только к каталогам, означает,
  что удалять и переименовывать файлы в каталоге может только его владелец

Данные признаки могут использоваться в 4-значной версии параметра для chmod, в самом левом разряде (suid=4, sgid=2,
sticky bit=1)

## сжатие, архивация

- **сжатие**:
  - `zip` - совместим с Windows
  - `gzip` - с Unix
  - `bzip2` - с Unix, новая, лучше сжатие
- **tar** - производит архивирование (из нескольких файлов делает один)

## Подсчет кол-ва слов в pdf-файлах

```bash
( for pdf in *.pdf ; do echo -n "$pdf,"; qpdf --show-npages "$pdf"; done ) > temp.txt
```

## Replace one host with another during `curl` call

https://curl.se/docs/manpage.html#--connect-to

```bash
curl -v --connect-to articles-service:9082:localhost:9082 https://articles-service:9082/api/v1/articles
```

## Group file renaming (.txt->.md)

https://superuser.com/questions/8716/rename-a-group-of-files-with-one-command

```bash
for file in *.txt; do mv "$file" "${file%.txt}.md"; done
```

## Show info about alias

https://askubuntu.com/questions/102093/how-to-see-the-command-attached-to-a-bash-alias

```bash
$ type -a <alias>
```

### Example

```bash
$ type -a gf
gf is aliased to `git fetch'
```

Или:

```bash
$ alias | grep gf
```

Или:
just type your alias and press `Ctrl+Alt+E` to show info (and press again if this alias used another alias)

## Run definite command from history

```bash
$ history		# to show commands history
$ !340			# run command with number 340
```

## Interactive search in history

- `Ctrl+R` - Search for commands in your bash history
- `Ctrl+O` - Run a command you found using a `Ctrl+R` search
- `Ctrl+G` - Exit a `Ctrl+R` search

# DB

## Увеличение кол-ва сессий и подключений БД:
```
alter system set PROCESSES=200 scope=SPFILE;
alter system set SESSIONS=115 scope=SPFILE;
```

## Для хранения значения суммы денег оптимальный выбор:
`DECIMAL(19, 4)`, т.е. 15 цифр в целой части и 4 - в дробной

## Запись в файл лога выполнения скрипта в sqlplus:
```
sqlplus -s system/root@XE --зашел в sqlplus, -s включает silent logging
--set linesize 100        --устанавливаем длину строки результата
--set heading off         --отключаем заголовки столбцов в результате
spool <имя файла>
--@имя_скрипта            --или
--<скрипт>
spool off
```

## Если видим, что не хватает ресурсов БД:
```
select resource_name, current_utilization, max_utilization, limit_value 
    from v$resource_limit 
    where resource_name in ('sessions', 'processes');
```

## Open psql command line:
```
psql -h localhost database_name [postgres by default] username [postgres by default]
```

## Apply a script to DB:
```
psql -U username -d myDataBase -a -f myInsertFile
```

## How to ping Redis:
https://stackoverflow.com/questions/33243121/abuse-curl-to-communicate-with-redis
```
exec 3<>/dev/tcp/127.0.0.1/6379 && echo -e "PING\r\n" >&3 && head -c 7 <&3
```

## Show info about existing tables in DB (for MySQL DB):
https://stackoverflow.com/questions/1498777/how-do-i-show-the-schema-of-a-table-in-a-mysql-database
```
select TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ROW_COUNT_ESTIMATE from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA='PUBLIC';
```

## Fix the issue when liquibase checksum validation failed while migration file was not modified
https://forum.liquibase.org/t/how-to-fix-validationfailedexception-in-liquibase-checksum/6780/5

Update the `databasechangelog` table, setting the md5sum to NULL for the particular row
```
update databasechangelog set md5sum=null where filename='<put your file name here>';
```

## H2 error "h2 database: Unsupported database file version or invalid file header in file":
https://stackoverflow.com/questions/40729216/h2-database-unsupported-database-file-version-or-invalid-file-header-in-file
To check H2 version use query:
```
SELECT H2VERSION() FROM DUAL
```

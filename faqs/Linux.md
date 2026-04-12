# Linux — заметки

Ориентир: современные **Debian/Ubuntu** (и частично RHEL/CentOS через `yum`/`dnf`). Ниже — сжатые актуальные команды и **приложение в конце**: туда перенесены по возможности полные ручные сценарии из старого `Linux.txt` (без реальных паролей и PSK из Wi‑Fi; где было неверно — помечено). Внутренние URL и хосты при необходимости подставьте свои.

## Книги и материалы

- Д. Колисниченко — *Linux. Полное руководство*
- М. Уэлш — *Запускаем Linux*
- William Shotts — *[The Linux Command Line](https://linuxcommand.org/tlcl.php)*
- Федорчук — [ruslinux.net](http://ruslinux.net)
- База по CLI: [Ubuntu tutorial — command line](https://ubuntu.com/tutorials/command-line-for-beginners)

## Пакеты (APT)

Поиск пакета:

```bash
apt-cache search <имя>
```

Установка / удаление:

```bash
sudo apt update
sudo apt install <пакет>
sudo apt remove <пакет>
```

Локальный `.deb`:

```bash
sudo dpkg -i package_name.deb
sudo dpkg -r <краткое_имя_пакета>
```

Если зависимости «сломались»: `sudo apt -f install`.

**Зависший `dpkg` / «Unable to lock…»:** дождаться окончания другого `apt`, при необходимости снять блокировку и восстановить — см. [Ask Ubuntu](https://askubuntu.com/questions/15433/unable-to-lock-the-administration-directory-var-lib-dpkg-is-another-process) (в заметках не смешивать с посторонними командами вроде `deluser`).

### Maven

```bash
sudo apt install maven
mvn -version
```

Дополнительно: [Installing Maven](https://www.mkyong.com/maven/how-to-install-maven-in-ubuntu/) (статья; версии в репозитории могут отставать). В старых Ubuntu пакет мог называться `maven2`.

### Git

```bash
sudo apt install git
git --version
```

Раньше метапакет часто назывался `git-core` — сейчас обычно достаточно `git`.

### Jenkins

Официальная установка меняется; актуальные шаги: [Jenkins — Linux](https://www.jenkins.io/doc/book/installing/linux/).

**Как было в ручных заметках (старый репозиторий `pkg.jenkins-ci.org`)** — сейчас URL и ключи могут не работать, оставлено для воспроизведения легаси-окружения:

```text
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update && sudo apt-get install jenkins
```

В заметках были свои URL веб-UI Jenkins и APEX — подставьте актуальные хосты.

Обновление после подключения репозитория:

```bash
sudo apt update
sudo apt install jenkins
```

```bash
sudo systemctl restart jenkins
# раньше: service jenkins restart
```

Порт и параметры (в т.ч. свой порт вроде 8180): `/etc/default/jenkins` или unit-файл systemd — сверяйте с версией пакета.

### Диски (udisks, сведения)

```bash
sudo apt install udisks2   # имя пакета в современных дистрибутивах часто udisks2
udisksctl status
# или классика:
sudo fdisk -l
lsblk
blkid
df -h
```

На очень старых системах встречалось `sudo apt-get install udisks` и сведения так: `udisks --show-info /dev/sda1` (udisks1; в udisks2 — другой CLI).

### Samba-клиент для монтирования SMB/CIFS

Пакет **`smbfs` устарел**; используйте **CIFS**:

```bash
sudo apt install cifs-utils
```

### Прочее

```bash
sudo apt install sysinfo    # по желанию
sudo apt install memtester  # тест ОЗУ: memtester <МБ> <прогоны>
```

## Монтирование

Список смонтированного:

```bash
mount
df -h
```

Примеры:

```bash
sudo mount /dev/sdb1 /mnt/video
sudo mount -t ext4 /dev/sdb1 /mnt/video
```

Из ручных заметок (пути и `ext3` могли быть именно такими):

```bash
sudo mount /dev/sdb1 /home/user/Видео
sudo mount -t ext3 /dev/sdb1 /home/user/Видео
sudo mount -t ext3 -o rw,iocharset=utf8,codepage=866 /dev/sdb1 /home/user/Видео
```

Типы ФС: `ntfs`, `ntfs-3g`, `vfat`, `iso9660` и т.д. Права: `-o rw` / `-o ro`. Для проблем иногда `-o force`.

Кодировки (старые сценарии с FAT/NTFS):

```bash
sudo mount -t ntfs-3g -o rw,iocharset=utf8,codepage=866 /dev/sdb1 /mnt/video
```

Отмонтировать:

```bash
sudo umount /dev/sdb1
# или по точке монтирования
```

CD-ROM и ISO:

```bash
sudo mount -t iso9660 -o ro /dev/cdrom /mnt/cd
sudo mount -t iso9660 -o loop /path/file.iso /mnt/iso
```

Сетевая шара **CIFS** (не использовать устаревший тип `smbfs`):

```bash
sudo mount -t cifs -o username=USER,password=PASS //server/share /mnt/mountpoint
```

Раньше в заметках был тип `smbfs` и шара вида `//pupkin_v/oracle10g-binary` → точка монтирования `/home/user/oracle-binaries` — **сейчас только CIFS** (`cifs-utils`), команда та же по смыслу с `-t cifs`.

Безопаснее — учётные данные в файле с правами `600` и опция `credentials=`.

## Файлы и каталоги

```bash
mkdir -p /home/user/dev
cd /home/user/dev
git init
ls
ls -l
ls -R
ls -lR
pwd
file <filename>
mv источник назначение
```

Поиск каталога:

```bash
find / -name '<dir_name>' -type d 2>/dev/null
```

Обзор `find`: [losst.ru — find](https://losst.ru/komanda-find-v-linux).

Удаление по маске (сначала без `-delete` — проверка):

```bash
find . -name "*.versionsBackup" -type f
find . -name "*.versionsBackup" -type f -delete
find . -name 'build.gradle' -delete
```

Замена строки в `.txt` рекурсивно:

```bash
find . -type f -name "*.txt" -exec sed -i 's/string1/string2/g' {} +
```

## Права, пользователи, группы

```bash
sudo -s
# или
sudo bash

su -
# ввод пароля root (если настроен)

chown -R user:group /path
chown -R pi /home/pi
sudo usermod -a -G pi root
id -a
id username
who
w
last
```

Добавить пользователя в группу:

```bash
sudo usermod -aG groupname username
```

Пример: пользователь в группе `docker` (после — перелогиниться или `newgrp docker`):

```bash
sudo usermod -aG docker "$USER"
grep docker /etc/group   # в заметках: проверить, что пользователь в строке группы
sudo systemctl restart docker
# или: sudo service docker restart
```

После добавления в группу — выход/вход в сессию или `newgrp docker` (иногда нужна перезагрузка).

Установка Docker Engine, `daemon.json`, Compose и прочая настройка демона — в [Docker.md](Docker.md).

`/etc/passwd`, `/etc/shadow`, `/etc/group` — учётные записи (пароли в `shadow`).

## Сеть и SSH

```bash
hostname -I
ip addr
ip route
ping 8.8.8.8
nc -zv host port
```

Статический адрес (пример классики `ifupdown`; на современных системах часто **Netplan** или NetworkManager — сверяйте дистрибутив):

`/etc/network/interfaces` — пример:

```text
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
```

**Raspberry Pi / Netplan:** используйте актуальную документацию вашего образа.

SSH-ключ:

```bash
ssh-keygen -t rsa -b 4096   # или ed25519: ssh-keygen -t ed25519
ssh-keygen -t rsa -C "your_email@example.com"
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
```

Копирование с удалённого хоста:

```bash
scp user@host:/path/to/file .
scp -r user@host:/remote/dir ./local-dir
```

Туннель через промежуточный хост:

```bash
ssh -L local_port:target_host:target_port user@gateway_host
```

С Windows: PuTTY / **plink** — в [Windows.md](Windows.md) (раздел про PuTTY и plink).

Проверка SOAP/WSDL:

```bash
wget 'http://host:port/Service?wsdl' -q -O -
```

Пример из заметок (подставьте свой хост):

```bash
wget 'http://adcosgiq3:9009/BookerDomainService?wsdl' --quiet -O -
```

## Wi‑Fi (ручная настройка)

На десктопе чаще **NetworkManager** (`nmcli`, GUI). Ниже — **полная последовательность из ручных заметок** (адаптер `wlx…`, SSID в примере замените на свой; **реальные пароли и hex PSK не воспроизводятся** — заново сгенерируйте через `wpa_passphrase`). См. также [linuxcommando — WPA/WPA2](https://linuxcommando.blogspot.com/2013/10/how-to-connect-to-wpawpa2-wifi-network.html).

```bash
iw dev
ip link show wlxXXXXXXXXXXXX
# при необходимости: sudo ip link set wlxXXXXXXXXXXXX up
iw wlxXXXXXXXXXXXX link
sudo iw wlxXXXXXXXXXXXX scan | less
sudo -s
wpa_passphrase "YOUR_SSID" >> /etc/wpa_supplicant.conf
# ввести пароль; в файле останутся ssid и psk=...
exit
sudo wpa_supplicant -B -i wlxXXXXXXXXXXXX -c /etc/wpa_supplicant.conf
iw wlxXXXXXXXXXXXX link
sudo dhclient wlxXXXXXXXXXXXX
ip addr show wlxXXXXXXXXXXXX
```

Маршрут по умолчанию — **через шлюз сети** (часто `192.168.1.1`), а не через IP, выданный интерфейсу. В черновике заметок ошибочно фигурировал `via` на адрес самого клиента — используйте:

```bash
sudo ip route add default via 192.168.1.1 dev wlxXXXXXXXXXXXX
ping 8.8.8.8
```

Проверка SMB соседа: `smbclient -L 192.168.0.100 -U%`.

Драйверы USB (пример **TP‑Link T2U Plus** / rtl8814au): [Ask Ubuntu](https://askubuntu.com/questions/1185952/need-rtl8814au-driver-for-kernel-5-3-on-ubuntu-19-10), [форум TP‑Link](https://community.tp-link.com/en/home/forum/topic/184118).

Диагностика:

```bash
dmesg
journalctl -b
lspci
lsusb
```

Старые логи: `/var/log/dmesg`; про udev на старых системах смотрели `/var/log/udev`.

## Oracle XE 10g (исторически)

Репозиторий и пакеты **могут быть мёртвы**; шаги ниже — **как в ваших ручных заметках**, для архива / легаси.

1. В `/etc/apt/sources.list` (осторожно): `deb http://oss.oracle.com/debian unstable main non-free`
2. Ключ: `wget http://oss.oracle.com/el4/RPM-GPG-KEY-oracle -O- | sudo apt-key add -`
3. `sudo apt-get update`
4. `sudo aptitude install oracle-xe oracle-xe-client` или `sudo apt-get install oracle-xe`
5. `sudo /etc/init.d/oracle-xe configure` (пароли sys/system)
6. Веб: `http://127.0.0.1:8080/apex`

Установка из скачанного `.deb` (как в заметках: расшарили каталог, смонтировали сеть):

```bash
cd <каталог_с_deb>
sudo dpkg -i oracle-xe_10.2.0.1-1.1_i386.deb
sudo /etc/init.d/oracle-xe configure
```

**PATH для Oracle в `~/.profile` (в заметках была опечатка):**

```bash
export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server/
export PATH="$PATH:$ORACLE_HOME/bin"
```

Было неверно: `export $PATH=$PATH:...`.

## Файл подкачки (swap)

Вариант из заметок (файл `/swpfs1`, ~1 ГиБ):

```bash
sudo dd if=/dev/zero of=/swpfs1 bs=1M count=1000
sudo mkswap /swpfs1
sudo swapon /swpfs1
```

Современный вариант — отдельный `/swapfile` с `chmod 600` и запись в `/etc/fstab` по документации дистрибутива.

## Печать (CUPS + Samba)

Как в ручных заметках (Raspberry / `pi`):

```bash
sudo apt-get update
sudo apt-get install vim mc cups samba samba-common-bin
sudo usermod -aG lpadmin pi
sudo /etc/init.d/cups start
sudo /etc/init.d/samba restart
# сейчас чаще: sudo systemctl enable --now cups smbd
```

Фрагменты, которые правили в **`/etc/cups/cupsd.conf`** (проверьте актуальность для вашей версии CUPS):

```apache
<Location />
  Order allow,deny
  Allow @LOCAL
</Location>
<Location /admin>
  Order allow,deny
  Allow @local
</Location>
<Location /admin/conf>
  AuthType Default
  Require user @SYSTEM
  Order allow,deny
  Allow @local
</Location>
```

В **`/etc/samba/smb.conf`** в секции `[printers]`: `browseable = yes`.

Дальше по заметкам: веб CUPS `http://<IP_малины>:631`, добавили принтер **Samsung ML-2010**. Подключение с **Windows** к такому принтеру — в [Windows.md](Windows.md) (IPP / клиент интернет-печати).

Общая шпаргалка по шаре: [Ubuntu community — Samba CLI](https://help.ubuntu.com/community/How%20to%20Create%20a%20Network%20Share%20Via%20Samba%20Via%20CLI%20%28Command-line%20interface/Linux%20Terminal%29%20-%20Uncomplicated%2C%20Simple%20and%20Brief%20Way%21).

```bash
sudo systemctl restart smbd
testparm
```

## Snap: зависшая установка

```bash
snap changes
sudo snap abort <ID>
sudo snap install <имя>
```

Подробнее: [Ask Ubuntu (RU)](https://ask-ubuntu.ru/questions/103349/ubuntu-ne-mozhet-zavershit-ustanovku-spotify-s-pomoschyu-snap).

## Процессы и порты

```bash
ps aux | grep java
ps -ef | grep java
pgrep -a java
pidof <имя>
kill -9 "$(pgrep -f pattern)"   # осторожно с шаблоном
```

Убить процесс по имени, не зацепив `grep` (трюк с квадратными скобками в шаблоне):

```bash
kill -9 $(ps -ef | grep '[t]arantool' | awk '{print $2}')
```

Время работы процесса:

```bash
ps -o etime= -p PID
ps -o etime= -p "$(pidof tarantool)"
```

Порты:

```bash
ss -lntu
ss -tulpn
netstat -tulpn   # пакет net-tools
netstat -a -n
```

**Какой процесс слушает порт (Linux):**

```bash
sudo ss -tulpn | grep ':PORT'
# или
sudo lsof -i :PORT
```

На **Windows** проверка порта через CMD: [Windows.md](Windows.md).

## Java

```bash
sudo apt install openjdk-17-jdk   # или 11, 21 — по задаче
sudo apt install openjdk-8-jdk    # если нужен именно 8
sudo update-alternatives --config java
sudo update-alternatives --config javac
whereis java
readlink -f "$(which java)"
```

Несколько JDK: [Ask Ubuntu — switch Java versions](https://askubuntu.com/questions/740757/switch-between-multiple-java-versions).

## Сертификат TLS (OpenSSL)

Проверка срока / цепочки (подставьте **имя хоста** в `-servername`, не URL):

```bash
echo | openssl s_client -servername www.google.com -connect www.google.com:443 2>/dev/null | openssl x509 -noout -dates
```

Кастомный хост и порт (пример из заметок — подставьте свой SNI и порт):

```bash
echo | openssl s_client -servername int-paymentauthapi-qvc-de-v1.qvcdev.qvc.net -connect localhost:8989 2>/dev/null
```

Обзоры: [ShellHacks (RU)](https://www.shellhacks.com/ru/openssl-check-ssl-certificate-expiration-date/), [Habr](https://habr.com/ru/post/481398/).

Проверка срока сертификата из вывода `s_client`: можно добавить `| openssl x509 -noout -dates`.

## Кодирование Base64

```bash
echo -n "your_secret" | base64
base64 -w 0 client.keystore.jks
base64 -w 0 client.truststore.jks
echo '<строка_base64>' | base64 -d
```

## Ansible Vault (ссылка)

[ansible-vault-tool.com](https://ansible-vault-tool.com)

## SSH-ключи: просмотр / шифрование

Просмотр/анализ ключей: [KeyStore Explorer](https://keystore-explorer.org/downloads.html).

**Как в ручных заметках** (`rsautl`; в OpenSSL 3 может понадобиться `pkeyutl`):

```bash
ssh-keygen -f ~/.ssh/id_rsa.pub -e -m PKCS8 > ~/.ssh/id_rsa.pub.pem
echo "String to Encrypt" \
  | openssl rsautl -pubin -inkey ~/.ssh/id_rsa.pub.pem -encrypt -pkcs \
  | openssl enc -base64 \
  > string.txt
openssl enc -base64 -d -in string.txt \
  | openssl rsautl -inkey ~/.ssh/id_rsa -decrypt
```

Современный вариант:

```bash
echo "String" | openssl pkeyutl -encrypt -pubin -inkey ~/.ssh/id_rsa.pub.pem | openssl base64 -A
openssl base64 -d -in string.b64 | openssl pkeyutl -decrypt -inkey ~/.ssh/id_rsa
```

## Shell (bash), cron, автозагрузка

Интерактивная история (`history`, `!n`), **`export` / `unset`**, **`nohup`**, **`crontab`**, heredoc, **nano**, стартовый `cd` в `~/.bashrc` — в [Bash.md](Bash.md).

Системное время в консоли:

```bash
date
```

Автозапуск при загрузке ОС: **systemd** (unit-файлы) или `@reboot` в crontab пользователя/рута.

Из заметок — правка **`/etc/rc.local`** (команды **до** строки `exit 0`). На многих дистрибутивах сервис **`rc-local`** нужно включить явно; иначе файл не выполняется.

## Сжатые логи, почта, звук

```bash
zless file.log.gz
zless rules.2.log.zip
mail -s "Script for web server" user@example.com < ~/app.py   # подставьте свой адрес; логи exim4: /var/log/exim4/mainlog
speaker-test
```

## Версия ОС и ядра

```bash
cat /proc/version
cat /etc/os-release
cat /etc/issue
```

## Тесты: сеть, GPU, gitk

```bash
iperf3
speedtest-cli   # пакет отдельно; см. [addictivetips](https://www.addictivetips.com/ubuntu-linux-tips/run-speedtest-from-linux-terminal/)
sudo dmidecode -t 2
glxgears      # пакет mesa-utils
glmark2
```

Ошибка gitk с emoji / X11: [Unix.SE](https://unix.stackexchange.com/questions/629281/gitk-crashes-when-viewing-commit-containing-emoji-x-error-of-failed-request-ba). Из заметок: снять цветные emoji-шрифты Noto, если мешают X11:

```bash
sudo apt remove --purge fonts-noto-color-emoji
```

## Восстановление разделов (TestDisk)

1. Загрузка с live CD/USB (например Ubuntu).
2. `sudo apt-get install testdisk`; если пакета нет — `sudo add-apt-repository universe`, `sudo apt update`.
3. `sudo testdisk` → создать log → выбрать диск → Proceed.
4. Тип таблицы (часто Intel, если раздел был под Windows).
5. Analyze → Quick Search → выделить удалённый раздел (стрелки, тип `T` при необходимости).
6. Enter → **Write** → перезагрузка.

## PM2

[Документация PM2](https://pm2.keymetrics.io/docs/usage/quick-start/)

```bash
pm2 start "serve -s ./" --name my-app
pm2 ls
pm2 logs
```

## Netdata

[netdata/netdata](https://github.com/netdata/netdata)

## JMX (консоль к JMX)

Историческая страница: [jmxsh (Google Code, архив)](https://code.google.com/archive/p/jmxsh/). Ищите живой форк на GitHub или используйте `jconsole` / `jmxterm`.

Пример из заметок:

```bash
java -jar jmxsh.jar br_fix_quartz_jobs.jmxsh
```

## Разное

| Задача | Команда |
|--------|---------|
| алиас / тип команды | `type ls` |
| очистить экран | `Ctrl+L` или `clear` |
| терминал (GUI) | `Ctrl+Alt+T` |
| дисплей / масштаб | `xrandr`, `gnome-tweaks` |
| резолвер DNS | `/etc/resolv.conf` (часто управляется systemd-resolved) |
| просмотр / редактор / heredoc | **less**, **nano**, heredoc — в [Bash.md](Bash.md); кратко: в `less` выход `q`, `v` → `$EDITOR` |
| сокращение для `ls -l` | `ll` (если задан алиас в shell) |
| локальные бинарники для пользователя | `~/bin` или `/usr/local/bin` |

**EC2 / Ubuntu и PuTTYgen с машины Windows:** [Windows.md](Windows.md).

**Samba:** см. ссылку Ubuntu community выше; после правок `sudo systemctl restart smbd`.

**Форматирование флешки:** [losst.ru](https://losst.ru/formatirovanie-fleshki-v-linux), GParted.

**NVIDIA:** гайды сильно зависят от дистрибутива и ядра, например [gist с шагами](https://gist.github.com/wangruohui/df039f0dc434d6486f5d4d098aa52d07) — сверяйте дату и версию ОС.

**Клавиатура в GNOME:** `sudo apt install gnome-tweaks`.

**UNIX basics (Stanford):** [mally.stanford.edu](http://mally.stanford.edu/~sr/computing/basic-unix.html)

**Глобальный PATH для всех пользователей (из заметок):**

```bash
echo 'export PATH=$PATH:/folder_name/' | sudo tee -a /etc/bash.bashrc
```

**`scp` (синтаксис и пример с losst.ru):** [losst.ru — scp](https://losst.ru/kopirovanie-fajlov-scp); пример: `scp -r /home/user/photos root@host:/root/`.

**Группы пользователя (из заметок):** [pingvinus — добавление в группу](https://pingvinus.ru/note/user-groups-add) — `sudo usermod -a -G editorsgroup pingvinus`.

Переименование расширений файлов в **Windows** (в т.ч. `.bat` с циклом): [Windows.md](Windows.md).

## RPM-семейство (кратко)

```bash
sudo yum install <пакет>
sudo yum remove <пакет>
sudo rpm -i package.rpm
sudo rpm -e <имя>
# современнее на Fedora/RHEL: dnf вместо yum
```

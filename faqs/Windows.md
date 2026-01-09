# Windows

## Решение проблемы с русским шрифтом в путях к папкам после установки Windows
Изменить кодировку для несистемной локали на русскую

## Чтобы включить клавишу NUM LOCK до входа в систему
- В редакторе реестра перейдите к разделу `HKEY_USERS\.Default\Control Panel\Keyboard`
- Измените значение параметра `InitialKeyboardIndicators` с 0 на 2

## To find which version of Windows you are running
```
wmic os get caption
wmic os get osarchitecture
ver     (выводит в консоль)
winver  (показывает попап с версией)
```

## Show installed Java versions
```
for %I in (java.exe) do @echo %~$PATH:I
```

## Set Java version from console
```
SETX JAVA_HOME "c:\Program Files\Java\jdk-21.0.8"
```

## Local drives for CygWin
```
cd /cygdrive/d
```

## Перезагрузка/выключение компа через RDC
Ctrl + Alt + End

## Upgrading from WSL1 to WSL2 (to speed up Docker on Windows)
https://docs.docker.com/docker-for-windows/wsl  
https://dev.to/adityakanekar/upgrading-from-wsl1-to-wsl2-1fl9

List existing distros:
```
wsl -l -v
```

Set wsl version:
```
wsl --set-version Ubuntu-18.04 2
```

Start Ubuntu shell:
```
wsl -d Ubuntu-18.04
```

## Fix issue when VSCode doesn't see system `$PATH`
https://stackoverflow.com/questions/43983718/set-global-path-environment-variable-in-vs-code

Press Ctrl + Shift + P, open `Preferences: Open Settings (JSON)`, add next block:
```
"terminal.integrated.env.windows": {
  "PATH": "..."
}
```
Replace `"..."` with output of `echo "$PATH"` command

## How to use Unicode characters in Windows command line?
https://stackoverflow.com/questions/388490/how-to-use-unicode-characters-in-windows-command-line

```
chcp 65001 (was 866, change codepage)
```
(Использовал, чтобы обеспечить поддержку русских символов в ответах от `curl` в Windows cmd)

## Как переименовать папку пользователя в Windows 10
https://remontka.pro/rename-user-folder-windows-10/

## Hosts file location
`C:\Windows\system32\drivers\etc\hosts`

## How to delete disk partition on Win 10
Run `cmd` with admin permissions
```
diskpart
list disk
select disk N
list partition
select partition M
delete partition override
```

## Fix an issue when Ubuntu in Windows could not get update: "Temporary failure resolving `security.ubuntu.com`"
https://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error
```
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
```

## Import Nexus cert into JDK store
```
keytool -importcert -file nexus-cert.cer -keystore cacerts -alias "nexus-cert-alias"
```
- use password `changeit` (default jdk store password)
- reply `yes` on question about trusting to new certificate

## Remove association between a file extension and program which should open these files
- In Registry Editor find node:
  `Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts`
- Under `FileExts` key, find the file extension you want to remove file association for it. Right-click and choose
  `Delete`

## Add certificates to make call of secured service endpoint
- from Swagger page - export certificate to .cer file (choose Base64 encoding)
- run from folder: `C:\Users\<USERNAME>\Documents\JDK\jdk-11.0.9\bin`
```
keytool -list -keystore ..\lib\security\cacerts
keytool -alias MY_CERT_FOR_BLA -import -keystore ..\lib\security\cacerts -file "C:\Users\<USERNAME>\Documents\certs\1.cer"
```

## Show BIOS version in Win 11
Win + R, msinfo32

## PrintScreen of selected screen area
Win + Shift + S
you could change mode: `Rectangle/Windows/Full Screen/Freedom`

## Avoid closing `.bat` file after end of run
https://stackoverflow.com/questions/988403/how-to-prevent-auto-closing-of-console-after-the-execution-of-batch-file
- add `call` before your command in .bat-file
- put `pause` at the end of .bat-file

## Recovery file in Win 11
`Windows File Recovery` works on Windows 11, but it doesn't come preinstalled. You can download it for free from the
Microsoft Store and install it
```
$ winfr C: D:\RecoveryDestination /regular /n "Users\<username>\My pictures\"
```

## Change extension for group of files
https://stackoverflow.com/questions/9885241/changing-all-files-extensions-in-a-folder-with-one-command-on-windows
```
ren *.txt *.md
```

## Инструменты для отображения клавиш при нажатии
- KeyPose
- Carnac

## Fix issue with Battle.net in Belarus (2025)
https://vk.com/wall-103726238_161615
```
Пуск
  Панель управления
    Сеть и Интернет
      Центр управления сетями и общим доступом
        Изменить настройки адаптера
```
Заменить DNS на следующие:
```
IPv4:
8.8.8.8
8.8.4.4

IPv6:
2001:4860:4860::8888
2001:4860:4860::8844
```

## Автодополнение при печати в Win 11
```
Time & language
  Typing
    Show text suggestions when typing on the physical keyboard
```

## Активация Windows 8+ и MS Office
https://habr.com/en/news/884288/

Активатор MAS работает через Powershell по команде `irm https://get.activated.win | iex`

## Проверка прохождения пакетов
### ping
```
ping google.com
```
Проанализируйте результат: если процент потерь пакетов (Loss) очень высок, это указывает на проблемы с соединением

### tracert
```
tracert google.com
```
Покажет весь путь, который проходят пакеты до выбранного сервера, и выявит узлы, где могут возникать задержки или потери

### pathping
```
pathping google.com
```
Сочетает функционал ping и tracert, предоставляя более детальную информацию о потерях и задержках на каждом узле
маршрута

## Посмотреть naming полей в PDF-е
PDF-XChange Editor

## Активация speech-to-text
Win + H
(только язык надо переключить на нужный заранее)

## Добавить папку в исключения Windows Defender-а
```
Windows Security
  Virus & threat protection settings
    Manage settings
	    Exclusions
	      Add or remove exclusions
и добавить нужные папки
```

## Terminate tasks by process id (PID) or image name
```
taskkill /f /im java.exe
	/F                  Specifies to forcefully terminate the process(es).
	/IM   imagename     Specifies the image name of the process to be terminated. 
	                    Wildcard '*' can be used to specify all tasks or image names.
```

## Быстрый перенос окна на другой монитор
Win + Shift + `стрелка вправо/влево`

## Быстрое изменение громкости
Навести на динамик в трее и крутить колесо мыши

## Смена DNS, используя PowerShell

### Определить имя сетевого адаптера
```
Get-NetAdapter | Format-Table -Property Name, InterfaceDescription

Output:
Name                         InterfaceDescription
----                         --------------------
Ethernet 3                   Realtek PCIe GbE Family Controller
Wi-Fi 6                      MediaTek Wi-Fi 6 MT7921 Wireless LAN Card #4
vEthernet (Default Switch)   Hyper-V Virtual Ethernet Adapter
Bluetooth Network Connection Bluetooth Device (Personal Area Network)
```

### Установка DNS ipv4
```
$AdapterName = "Ethernet 3" 	# Замените на имя вашего адаптера
$DNS = "8.8.8.8", "8.8.4.4" 	# Google DNS-серверы

Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses $DNS
```

### Установка DNS ipv6
```
$AdapterName = "Ethernet 3" 		# Замените на имя вашего адаптера
$ipv6Dns1 = "2001:4860:4860::8888"	# Google DNS 1
$ipv6Dns2 = "2001:4860:4860::8844"	# Google DNS 2

Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses @($ipv6Dns1, $ipv6Dns2)
```

### Перезапуск сетевого адаптера (опционально, но рекомендуется)
```
$AdapterName = "Ethernet 3" 		# Замените на имя вашего адаптера

Restart-NetAdapter -Name $AdapterName -Confirm:$false
```

## Add emoji
- Win+`;`
- Choose emoji. For example: 😊

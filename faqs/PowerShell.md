# PowerShell

## Set execution policy for PowerShell
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies
```
Set-ExecutionPolicy -ExecutionPolicy PolicyName
```
где `PolicyName` - одно из:
- Unrestricted
- RemoteSigned
- AllSigned

## Запуск tail консоли с логом выбранного контейнера, чтобы не писать каждый раз команду в консоли
```
Get-Content order.log -Wait -Tail 5
```
Нужен 3й PowerShell (просмотр версии PowerShell: `PSVersionTable`)

## PowerShell commands history path
https://stackoverflow.com/questions/44104043/how-can-i-see-the-command-history-across-all-powershell-sessions-in-windows-serv

Use next command in PowerShell console:
```
(Get-PSReadlineOption).HistorySavePath
```

For example for user `Andrei` I got:
```
C:\Users\Andrei\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
```

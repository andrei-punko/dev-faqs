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

# Cheatsheet of curl : cmd vs PowerShell vs bash

## Quick rules

- `cmd`: `^` and escaped quotes (`\"`)
- `PowerShell`: backtick and often `'{"k":"v"}'`
- `bash`: `\` and often `'{"k":"v"}'`

## 1) Windows Command Prompt (`cmd.exe`)

- Use code block type: `bat` (or `cmd`)
- Line continuation: `^`
- Escape JSON quotes in `--data-raw` as `\"`

```bat
curl -X POST "http://localhost:3001/api/auth/login" ^
  -H "Content-Type: application/json" ^
  -H "User-Agent: Mozilla/5.0" ^
  --data-raw "{\"email\":\"admin\",\"password\":\"admin123\"}"
```

## 2) PowerShell

- Use code block type: `powershell`
- Line continuation: `` ` `` (backtick)
- Prefer JSON in single quotes `'...'`
- Prefer `curl.exe` to avoid PowerShell alias behavior

```powershell
curl.exe -X POST "http://localhost:3001/api/auth/login" `
  -H "Content-Type: application/json" `
  -H "User-Agent: Mozilla/5.0" `
  --data-raw '{"email":"admin","password":"admin123"}'
```

## 3) bash (Linux/macOS/Git Bash)

- Use code block type: `bash`
- Line continuation: `\`
- JSON usually in single quotes `'...'`

```bash
curl -X POST "http://localhost:3001/api/auth/login" \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0" \
  --data-raw '{"email":"admin","password":"admin123"}'
```

# Multiple SSH keys

## Use multiple SSH keys with GitHub
Based on [article](https://gist.github.com/oanhnn/80a89405ab9023894df7)

### 1. Generate SSH keys
```sh
ssh-keygen -t ed25519 -C "andd3dfx@gmail.com"             # use default key name `id_ed25519`
ssh-keygen -t ed25519 -C "Andrei.Punko@another-group.com" # use key name `id_ed25519_another`
```

### 2. Create `~/.ssh/config` with next content:
```
# Default GitHub account: andrei-punko
Host github.com
   HostName github.com
   IdentityFile ~/.ssh/id_ed25519
   IdentitiesOnly yes

# Another GitHub account: another
Host github-another
   HostName github.com
   IdentityFile ~/.ssh/id_ed25519_another
   IdentitiesOnly yes
```

### 3.Add SSH private keys to your agent
```sh
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519_another
```

According
to [article](https://stackoverflow.com/questions/17846529/could-not-open-a-connection-to-your-authentication-agent)
to make `ssh-add` work you may need to run next command before that:
```sh
eval `ssh-agent -s`
```

### 4. Test connection
```sh
ssh -T git@github.com
ssh -T git@github-another
```

In case of success you will get messages:
```
Hi andrei-punko! You've successfully authenticated, but GitHub does not provide shell access.
Hi apunko-another! You've successfully authenticated, but GitHub does not provide shell access.
```

### 5. Clone your repo
But in clone link you need to use `github-another` instead of `github.com`:
- Got from GitHub: `git@github.com:another/sf-original.git`
- Right link to make clone: `git@github-another:another/sf-original.git`

### 6. Adjust default name & email
```
git config user.name "Andrei Punko"
git config user.email "Andrei.Punko@another-group.com"
```

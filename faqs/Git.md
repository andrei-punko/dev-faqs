# Git & Git Bash commands

Амперсанд `&` в конце команды не блокирует консоль на время выполнения команды

## Запуск GUI для просмотра и коммита последних изменений
```
git gui &
```

## Запуск GUI для просмотра истории коммитов
```
gitk &
```

## Просмотр списка существующих веток:
```
git branch --list
```

## Переключение на другую ветку:
```
git checkout branch_name
```

## Создание новой ветки с переключением на нее:
```
git checkout -b branch_name master
```

## Просмотр текущего состояния ветки (имя ветки, незакоммитанные изменения):
```
git status
```

## Переименование текущей ветки:
```
git branch -m new_branch_name
```

## Предварительное сохранение изменений без коммита:
```
git stash
```

## Применить последнее изменение (без удаления его из стека):
```
git stash apply
```

## Удалить последнее изменение из стека:
```
git stash drop
```

## Применить последнее изменение и удалить его из стека:
```
git stash pop
```

## Показать историю двух веток в одном окне:
```
gitk branch_name1 branch_name2 &
```

## Сброс состояния ветки на состояние, соответствующее выбранному коммиту:
В `gitk` выбрать `reset <branch> to here` на данном коммите, `Hard`

## Чтобы объединить несколько коммитов вместе:
```
git rebase -i sha1
```
где `sha1` - id предыдущего коммита (стоящего перед коммитом, в который планируем "складывать" изменения)

В новом окне VIM-a переставляем коммиты в нужном нам порядке, в строке с коммитом (куда складываем) - ничего не меняем
в следующих за ней строках (коммиты, которые в этот коммит складываем) меняем `pick` на `s` (это, в отличие от `f`,
позволит потом отредактировать название итогового коммита)

Выходим в режим консоли: ":"
```
wq
ENTER
(или ZZ (Shift+zz))
```

## Разбить один коммит на несколько:
```
git rebase -i sha1
```
где `sha1` - id предыдущего коммита (стоящего перед коммитом, который собрались редактировать)
```
git gui&
```
Запускаем GUI, откуда делаем несколько нужных коммитов (здесь можно вносить правки в IDE)
```
git rebase --continue
```
В окне gitk жмем `Ctrl+F5`

## Пушнуть ветки branch_name в origin:
```
git push origin branch_name
```
Для форспуша уже существующей ветки надо добавить ключ `-f`

## Push multiple branches at once
```
git push origin branch1 branch2 branch3
```

## Push multiple branches at once atomically (all or nothing)
```
git push --atomic origin branch1 branch2 branch3
```

## В VIM:
```
переход в режим текстового редактора/консоли: "i"/":"
dd - удалить строку в буфер
p - вставить строку после курсора
:m 12       move current line to after line 12
:m 0        move current line to before first line
:m $        move current line to after last line
:5,7m 21    move lines 5, 6 and 7 to after line 21
:5,7m 0     move lines 5, 6 and 7 to before first line
:5,7m $     move lines 5, 6 and 7 to after last line
:.,.+4m 21 	move 5 lines starting at current line to after line 21
:,+4m14     same (. for current line is assumed)
:m .+1 (which can be abbreviated to :m+) moves the current line to after line number .+1 (current line number + 1). In short - current line moved down one line
:m .-2 (which can be abbreviated to :m-2) moves the current line to after line number .-2 (current line number − 2). In short - current line moved up one line
```

## Накатить коммиты (со следующего за sha1 до последнего) на master:
```
git rebase -i sha1 --onto origin/master
```
При возникновении проблем устраняем их и выполняем:
```
git rebase --continue
```

## Варианты rebase:
```
git rebase -i origin/last_branch_name
git rebase -i TAG_NAME
```

## Создание тага:
```
git tag -a -F path_to_file_with_tag_info TAG_NAME_IN_UPPERCASE
```
После создания своего тага, он самому себе не виден (глюк Git-а), надо выполнить:
```
git gc (крайняя форма: `git gc --aggressive`)
```

## Пересадка коммита с заданным sha1 на верхушку текущей ветки:
```
git cherry-pick sha1
```

## Смена репозитория:
```
git remote set-url origin git@git.another-company.com:dev
```

## Работа без git gui, gitk, из консоли
### Создание нового хранилища в текущей директории
```
git init
```

### Просмотр изменений, можно скопировать имя файла
```
git status
```

### Добавление имени файла в индекс
```
git add  <filename>
```

### Создание коммита из индекса
```
git commit -m commit_message
```

## Посмотреть автора строк указанного файла:
```
git gui blame <path/filename> &
```

## Link для запуска git-а:
`C:\WINDOWS\system32\cmd.exe /c ""C:\Program Files (x86)\Git\bin\sh.exe" --login -i"`

## Забрать ветки с сервера по умолчанию
```
git fetch
```

## Забрать ветки с сервера <name>
```
git fetch <name>
```

------------------------------------------------------------------------------------
* Конфиг Git-а расположен в трех местах
------------------------------------------------------------------------------------
Git ищет параметры в таком порядке:
1. /etc/gitconfig - папка с установленным Git-ом
   git config --system <param.name> <param.value>

2. ~/.gitconfig - папка текущего юзера
   git config --global <param.name> <param.value>

3. .git/config - репозиторий текущего проекта
   git config <param.name> <param.value>
------------------------------------------------------------------------------------

## Rebase с фиксом пробельных символов по текущим правилам:
```
git rebase --whitespace=fix ..
```

## Добавление в индекс измененных файлов, начиная с указанного пути:
```
git add <путь>
git add domains/stay
```

## Добавление в индекс удаленных файлов:
```
git add -u <путь>
```

## Просмотр истории заданной ветки без переключения на нее:
```
gitk <branch_name>
```

## Удаление ненужных изменений при merge конфликте:
```
git rm <path[/file]>
```
В пути и имени поддерживается regexp

## Запрет перезаписывания line-ending-ов:
```
git config --global core.safecrlf true
```

## Удаление ветки:
```
git branch -d <branch_name>
```

## Удаление ветки из удаленного репозитория origin:
```
git push origin :<branch_name>
```

## Удаление тега MAMA_3:
```
git tag -d MAMA_3
```

## Удаление тега из удаленного репозитория origin:
```
git push origin :refs/tags/MAMA_3
```

## Перезапись истории:
http://git-scm.com/book/ru/%D0%98%D0%BD%D1%81%D1%82%D1%80%D1%83%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-Git-%D0%9F%D0%B5%D1%80%D0%B5%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C-%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D0%B8
```
git filter-branch
```

## Делаем невозможным push без параметров:
```
git config --global push.default nothing
```

## Вытягиваем изменения перепушаных тегов:
```
git fetch --tags
```

## Перенос ветки в другой репозиторий (команды запускаем из директории с исходным репо /d/Magic/dev):
```
git checkout -b dco_generator
mkdir /d/Magic/generator
pushd /d/Magic/generator
git init
git pull /d/Magic/dev dco_generator
popd
```

## Поиск ветки с известным куском названия:
```
git branch -r | grep part_of_name
```

## Пуш всех веток и тегов:
```
git push -u origin --all
git push -u origin --tags
```

## Добавление удаленного репозитория:
```
git remote add <name> <url>
git remote add origin git@bitbucket.org:andrei_punko/timesheet-plugin.git
```

## Список веток в удаленных репозиториях:
```
git branch -r
```

## Список тегов в репозитории:
```
git ls-remote --tags <repository>
```

## Push all tags to remote repo
```
git push --tags <remote>
git push <remote> --tags
```

## Генерация нового SSH-ключа
```
ssh-keygen -t rsa
```

## List your existing remotes
```
git remote -v
```

## Set new origin url
```
git remote set-url origin <new_url>
```

## Found commits that don't belong to any branch
```
git fsck --lost-found
```

## Change author of last commit
```
git commit --amend --author "Andrei Punko <andd3dfx@gmail.com>"
```

## Rebase using first commit
```
git rebase -i --root
```

## Group replacement text1 -> text2 in vim
```
:%s/text1/text2/
```

## Change author of commit
```
git filter-branch --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "Andrei_Punko@another-company.com" ]; then
GIT_AUTHOR_EMAIL=andd3dfx@gmail.com;
GIT_AUTHOR_NAME="Andrei Punko";
GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL;
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; fi' -- --all
```

## Восстановление данных Git в случае hard reset или удаления ветки:
```
git reflog
```
Позволяет посмотреть последние коммиты,
для последних - открыть `gitk`, и найти нужное, после чего создать ветку для этого `sha1`.

## Install Git tools on Linux
```
sudo yum install -y gitk
sudo yum install -y git-gui
```

## Key generation
```
ssh-keygen -t ed25519 -C "Andrei.Punko@company-name.com"
```

## Show history in terminal
```
git log
```

## Check current state (branch, changes etc.)
```
git status
```

## Exit from VIM
- without saving: `:q!`
- with saving: `:wq`

## Add files to commit and create commit
```
git add file_path_and_name
git commit -m "Add code coverage check into pipeline"
```

## Set commiter name/email for particular repo (not globally):
```
git config user.name "Andrei Punko"
git config user.email "andd3dfx@gmail.com"
cat .git/config
```

## How to resolve problem with self-signed certificate
https://stackoverflow.com/questions/11621768/how-can-i-make-git-accept-a-self-signed-certificate
```
GIT_SSL_NO_VERIFY=true git clone <url>
```

## Add the ability to run GitHub actions job manually
https://build5nines.com/configuring-manual-triggers-in-github-actions-with-workflow_dispatch/

Add next code to `.yml` config:
```
# configure manual trigger
on:
  workflow_dispatch:
```

## Add condition in GitHub actions to avoid some step in case of pull request:
```
  - name: Commit the badge (if it changed)
    if: ${{ github.event_name != 'pull_request' }}
    run: |
    ...
```

## How to use Linux utils in Git-Bash console
Download and put utils into `./Git/mingw64/bin/`

## Change author of last commit
https://stackoverflow.com/questions/3042437/how-can-i-change-the-commit-author-for-a-single-commit
```
git commit --amend --author="Andrei Punko <andd3dfx@gmail.com>" --no-edit
```

## Squash commits during interactive rebase using `fixup!`
You have next commits:
```
...
111ff SOME-RELEASE
03e4f Some changes
04123 Bla-bla
9efe0 fixup! 03e4f
```

To squash `9efe0` with `03e4f` during interactive rebase:
1. Use for `9efe0` commit next commit message: `fixup! 03e4f`
2. Run `git rebase -i --autosquash branch-name`

## Dark theme for gitk
https://draculatheme.com/gitk

Download https://github.com/dracula/gitk/archive/master.zip and copy:
```
cp gitk/gitk ~/.config/git/
```

## Dark theme for git gui
https://stackoverflow.com/questions/49935684/dark-theme-for-git-gui
1. Find file `git-gui.tcl` in your Git installation

   For Windows it could be in one of places:

- `%userprofile%\AppData\Local\Programs\Git\mingw64\libexec\git-core`
- `C:\Program Files\Git\mingw64\libexec\git-core`

2. insert next lines after line `pave_toplevel .`:
```
ttk::style theme use default
ttk::style configure TFrame -background #333
ttk::style configure TLabelframe -background #333
ttk::style configure TLabelframe.Label -background #333 -foreground #fff
ttk::style configure TPanedwindow  -background #333
ttk::style configure EntryFrame -background #333
ttk::style configure TScrollbar -background #666 -troughcolor #444 -arrowcolor #fff -arrowsize 15
ttk::style map TScrollbar -background [list active #333 disabled #000]
ttk::style configure TLabel -background #333 -foreground #fff
ttk::style configure TButton -background #333 -foreground #fff -borderwidth 2 -bordercolor #fff
ttk::style map TButton -background [list active #555 disabled #111 readonly #000]
ttk::style configure TCheckbutton -background #333 -foreground #fff -indicatorbackground #666 -indicatorcolor #fff
ttk::style map TCheckbutton -background [list active #555 disabled #111 readonly #000]
ttk::style configure TEntry -fieldbackground #333 -background #333 -foreground #fff -insertcolor #fff
ttk::style configure TRadiobutton -background #333 -foreground #fff
ttk::style map TRadiobutton -background [list active #555 disabled #111 readonly #000]
option add *TCombobox*Listbox.background #333 interactive
option add *TCombobox*Listbox.foreground #fff interactive
option add *TCombobox*Listbox.selectBackground blue interactive
option add *TCombobox*Listbox.selectForeground #fff interactive
option add *Listbox.Background #333 interactive
option add *Listbox.Foreground #fff interactive
option add *Text.Background #333 interactive
option add *Text.Foreground #fff interactive
ttk::style configure TSpinbox -fieldbackground #333 -background #333 -foreground #fff -insertcolor #fff -arrowcolor #fff \
    .vpane.lower.commarea.buffer.frame.t \
    configure -background #0d1117 -foreground #fff -insertbackground #fff \
    .vpane.lower.diff.body.t configure -background #0d1117 -foreground #fff \
    .vpane.files.workdir.list configure -background #0d1117 -foreground #fff \
    .vpane.files.index.list configure -background #0d1117 -foreground #fff \
    .about_dialog.git_logo configure -background #333
```

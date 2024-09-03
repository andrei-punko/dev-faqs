
# java
alias jver="java -version"

# maven
alias mver="mvn --version"

alias mc="mvn clean"
alias mci="mc install"
alias mcist="mci -DskipTests"
alias mciap="mci -am -pl"
alias mcip="mci -pl"
alias mct="mc test"
alias mctp="mct -pl"
alias mi="mvn install"
alias mip="mi -pl"
alias mt="mvn test"
alias mtp="mt -pl"
alias qb="mci -DskipTests -Dnomodel"

# git
alias gf="git fetch"
alias gfo="gf origin"

alias gk="gitk &"
alias пл="gk"
alias gkom="gitk origin/master &"
alias gg="git gui &"
alias пп="gg"

alias gr="git rebase"
alias grc="gr --continue"
alias gra="gr --abort"
alias gri="gr -i"
alias grom="gri origin/master"

alias gbd="git branch -D"
alias gbm="git branch -m"
alias gbl="git branch --list"

alias gch="git checkout"
alias gcom="gch origin/master"
alias gcm="gch master"
alias nb="git checkout -b"

alias gpo="git push origin"
alias gpom="gpo master"

alias gplo="git pull origin"
alias gplom="git pull origin master"

update_buildSrc() {
	cd buildSrc
	gcm
	gplom
	cd ..
}
alias gsplom=update_buildSrc
alias gaplom="gplom && gsplom"

# gradle
alias gver="gradle --version"
alias gt="gradle test"
alias gb="gradle build"
alias gct="gradle clean test"
alias gcb="gradle clean build"

alias gw="./gradlew"
alias gwver="gw --version"
alias gwc="gw clean"
alias gwb="gw build"
alias gwcb="gwc build"
alias gwt="gw test"
alias gwct="gwc test"
alias gws="gw --stop"
alias gwup="gw wrapper --gradle-version"

# SSH
alias ntop="ssh andd3dfx@192.168.1.215"

jver

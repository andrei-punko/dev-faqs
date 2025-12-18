
# Java
alias jver="java -version"

# Maven
alias mver="mvn --version"

alias mc="mvn clean"
alias mcc="mc compile"
alias mci="mc install"
alias mciap="mci -am -pl"
alias mcip="mci -pl"
alias mcist="mci -DskipTests"
alias mct="mc test"
alias mctc="mc test-compile"
alias mctp="mct -pl"
alias mi="mvn install"
alias mip="mi -pl"
alias mt="mvn test"
alias mtp="mt -pl"
alias qb="mci -DskipTests -Dnomodel"
alias mdeps="mvn dependency:tree > deps.txt"

# Git
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
alias gblg="gbl | grep"

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

# Gradle
alias gver="gradle --version"
alias gt="gradle test"
alias gb="gradle build"
alias gct="gradle clean test"
alias gcb="gradle clean build"
alias gdeps="gradle dependencies > deps.txt"

alias gw="./gradlew"
alias gwver="gw --version"
alias gwc="gw clean"
alias gwb="gw build"
alias gwcb="gwc build"
alias gwt="gw test"
alias gwct="gwc test"
alias gws="gw --stop"
alias gwup="gw wrapper --gradle-version"


# k8s
alias k="minikube kubectl --"

# CleverDev
alias mctft="mct -Dfix.tests=true"
alias mtft="mt -Dfix.tests=true"
alias groq="gri origin/release/qa"
alias gkoq="gitk origin/release/qa &"
alias gkorq="gkoq"
alias gkop="gitk origin/release/preprod &"
alias grop="gri origin/release/preprod"
alias gcoq="git checkout origin/release/qa"

jver

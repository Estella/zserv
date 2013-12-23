#!/usr/bin/zsh
echo 'Welcome to U Services. This will not work if the IRCd is not local and not connected with II.'
echo "/n U" >$HOME/irc/127.0.0.1/in
echo "/OPER $operUser $operPass" >$HOME/irc/127.0.0.1/in
mkdir -p ~/.Uchan/nicks 2>/dev/null
mkdir -p ~/.Uhost 2>/dev/null
chanOps(){
while read user discard1 hostAuth ; do
	echo "/WHO $user" >>$HOME/irc/127.0.0.1/in
	hostname="$(cut -d ' ' -f 5 <$HOME/irc/127.0.0.1/out)"
	if test "$hostname" = "$hostAuth" ; then
		echo "/SAMODE $chan +o $user" >$HOME/irc/127.0.0.1/in
		echo "/SAMODE $chan +o $user"
	fi
done < "${1:-/dev/stdin}"
}

vHostUser(){
IFS=' '
while read discard1 vHost ; do
	echo "/CHGHOST $i $vHost" >$HOME/irc/127.0.0.1/in
	echo "/NOTICE $i You're now authenticated to your U account, $vHost." >$HOME/irc/127.0.0.1/in
done < "$HOME/.Uhost/$(tr '[A-Z]' '[a-z]' <<<${1:-/dev/stdin})"
}

createDB(){
printf '%s\n' $(shift ; echo "$@") | grep -v '^:' >> "$HOME/.Uchan/$1.db"
echo "$HOME/.Uchan/${1}.db"
}

chanServ(){
for chan in ${1:-$(cat "$HOME/.Uchandb")}
do
	#echo "/SAMODE $chan +o U" > $HOME/irc/127.0.0.1/in
	echo "/SATOPIC $chan :$(cat $HOME/.Uchan/$chan.tp)" > $HOME/irc/127.0.0.1/in
done
}

chanPM(){
        while sleep 5 ; do
	cd $HOME/irc/127.0.0.1/ ; ls -1 -p ./ | egrep '/$' | egrep -v '^#' | sed -e 's/\///g' |
	while read i ; do
	tail -n 1 $HOME/irc/127.0.0.1/${i}/out |
	read discard1 discard2 discard3 comName comArgV1 comArgV2 comArgV3 comArgV4
	if egrep '^[aA][uU][tT][hH]' <<<$comName && test "$comArgV2:$(echo $comArgV2:$comArgV3 | shasum -a 512 | sed -e 's/  -//g')" = "$(grep -i $comArgV2 $HOME/.Uchan/${comArgV1}.db)" ; then
		echo "/SAMODE $comArgV1 +o $(echo $i | sed -e 's/\///g')" > tee $HOME/irc/127.0.0.1/in
		echo "You are now a chanop in $comArgV1" > $HOME/irc/127.0.0.1/${i}/in
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
		echo "$comArgV1" > ~/.Uchan/nicks/$(echo $i | sed -e 's/\///g')
	elif egrep '^[aA][uU][tT][hH]' <<<$comName && [ ! "$comArgV2:$(echo $comArgV2:$comArgV3 | shasum -a 512 | sed -e 's/  -//g')" = "$(grep -i $comArgV2 $HOME/.Uchan/${comArgV1}.db )" ] ; then
		echo "You did not enter your password correctly for $comArgV1." > "$HOME/irc/127.0.0.1/${i}/in"
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[fF][aA][uU][tT][hH]' <<<$comName && test "$comArgV2:$(echo $comArgV2:$comArgV3 | shasum -a 512 | sed -e 's/  -//g')" = "$(grep -i $comArgV2 $HOME/.Uchan/${comArgV1}.db)" ; then
		echo "/SAMODE $comArgV1 +q $(echo $i | sed -e 's/\///g')" > $HOME/irc/127.0.0.1/in
		echo "/SAMODE $comArgV1 +o $(echo $i | sed -e 's/\///g')" > $HOME/irc/127.0.0.1/in
		echo "/NOTICE $i You are now a founder in $comArgV1" > $HOME/irc/127.0.0.1/in
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
		echo "$comArgV1" > ~/.Uchan/nicks/$(echo $i | sed -e 's/\///g')
	elif egrep '^[fF][aA][uU][tT][hH]' <<<$comName && [ ! "$comArgV2:$(echo $comArgV2:$comArgV3 | shasum -a 512 | sed -e 's/  -//g')" = "$(grep -i $comArgV2 $HOME/.Uchan/${comArgV1}.db )" ] ; then
		echo "You did not enter your password correctly for $comArgV1." > "$HOME/irc/127.0.0.1/${i}/in"
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[aA][aA][uU][tT][hH]' <<<$comName && test "$comArgV2:$(echo $comArgV2:$comArgV3 | shasum -a 512 | sed -e 's/  -//g')" = "$(grep -i $comArgV2 $HOME/.Uchan/${comArgV1}.db)" ; then
		echo "/SAMODE $comArgV1 +a $(echo $i | sed -e 's/\///g')" > $HOME/irc/127.0.0.1/in
		echo "/SAMODE $comArgV1 +o $(echo $i | sed -e 's/\///g')" > $HOME/irc/127.0.0.1/in
		echo "/NOTICE $i You are now an administrator" > $HOME/irc/127.0.0.1/in
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
		echo "$comArgV1" > ~/.Uchan/nicks/$(echo $i | sed -e 's/\///g')
	elif egrep '^[aA][aA][uU][tT][hH]' <<<$comName && [ ! "$comArgV2:$(echo $comArgV2:$comArgV3 | shasum -a 512 | sed -e 's/  -//g')" = "$(grep -i $comArgV2 $HOME/.Uchan/${comArgV1}.db )" ] ; then
		echo "You did not enter your password correctly for $comArgV1." > "$HOME/irc/127.0.0.1/${i}/in"
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[rR][gG][sS][tT]' <<<$comName ; then
		echo "/NOTICE $i This is your last chance to check the configuration of your" > ~/irc/127.0.0.1/in
		echo "/NOTICE $i channel." > ~/irc/127.0.0.1/in
		echo /NOTICE $i -\`\~\`-\`\~\`-\`\~\`-\`\~\`-\,\_\,\-\,\_\,\-\,\_\,\-\,\_\,\-\`\~\`\-\`\~\`\-\`\~\`\-\`\~\`\-\,\_\,\-\,\_\,\-\,\_\,\-\,\_\,\- > ~/irc/127.0.0.1/in
		echo "/NOTICE $i If you are certain your nickname appears in the first nick:pass" > ~/irc/127.0.0.1/in
		echo "/NOTICE $i combo, use RGSR instead of RGST." > ~/irc/127.0.0.1/in
		echo "/NOTICE $i THIS IS YOUR LAST CHANCE - USE IT WISELY." > ~/irc/127.0.0.1/in
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[vV][cC][hH][nN]' <<<$comName ; then
		echo "/NOTICE $i Joining to #!$comArgV1@$i." > ~/irc/127.0.0.1/in
		echo "/SAJOIN $i #!$comArgV1@$i" > ~/irc/127.0.0.1/in
		if test -e "~/.Uchan/\#!$comArgV1@$i.db" ; then
			: ; else
			echo "/NOTICE $i #!$comArgV1@$i is unregistered." > ~/irc/127.0.0.1/in
			echo "/NOTICE $i You may register it at any time." > ~/irc/127.0.0.1/in
		fi
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[rR][gG][sS][rR]' <<<$comName ; then
		echo "/WHO $comArgV1" > ~/irc/127.0.0.1/in
		grep "$comArgV1" ~/.Uchan/nicks/$(echo "$i" | sed -e 's/\///g') 2>/dev/null ; grepolev=$?
		if test "$(grep $comArgV1 ~/.Uchandb >/dev/null ; echo $?)" = "1" ; then
			createDB "$comArgV1" "$(echo $comArgV2 | sed -e 's/:.*//g'):$(echo $comArgV2 | shasum -a 512 | sed -e 's/  -//g')" "$(echo $comArgV3 | sed -e 's/:.*//g'):$(echo $comArgV3 | shasum -a 512 | sed -e 's/  -//g')" "$(echo $comArgV4 | sed -e 's/:.*//g'):$(echo $comArgV4 | shasum -a 512 | sed -e 's/  -//g')"
			echo "$comArgV1" >> ~/.Uchandb
		elif [ "$grepolev" = "0" ] ; then
			test "$(grep $comArgV1 $HOME/.Uchan/nicks/$(echo $PMs | sed -e 's/\///g'))" = ""
			echo "$comArgV1 already exists. So now, since you're authed in that channel, we're giving the ops to the people:passwords in the args to $comName." >"$HOME/irc/127.0.0.1/${i}/in"
			createDB "$comArgV1" "$(echo $comArgV2 | sed -e 's/:.*//g'):$(echo $comArgV2 | shasum -a 512 | sed -e 's/  -//g')" "$(echo $comArgV3 | sed -e 's/:.*//g'):$(echo $comArgV3 | shasum -a 512 | sed -e 's/  -//g')" "$(echo $comArgV4 | sed -e 's/:.*//g'):$(echo $comArgV4 | shasum -a 512 | sed -e 's/  -//g')"
		fi
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[uU][sS][rR][aA][dD][dD]' <<<$comName ; then
		echo "Creating channel $comArgV1" > "$HOME/irc/127.0.0.1/${i}/in"
		grep "$comArgV1" ~/.Uchan/nicks/$(echo $i | sed -e 's/\///g') 2>/dev/null ; grepolev=$?
		if [ "$grepolev" = "0" ] ; then
			test "$(grep $comArgV1 $HOME/.Uchan/nicks/$(echo $i | sed -e 's/\///g'))" = ""
			echo "$comArgV1 already exists. So now, since you're authed in that channel, we're giving the ops to the people:passwords in the args to $comName." >"$HOME/irc/127.0.0.1/${i}/in"
			createDB "$comArgV1" "$(echo $comArgV2 | sed -e 's/:.*//g'):$(echo $comArgV2 | shasum -a 512 | sed -e 's/  -//g')" "$(echo $comArgV3 | sed -e 's/:.*//g'):$(echo $comArgV3 | shasum -a 512 | sed -e 's/  -//g')" "$(echo $comArgV4 | sed -e 's/:.*//g'):$(echo $comArgV4 | shasum -a 512 | sed -e 's/  -//g')"
		fi
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[tT][pP][iI][cC]' <<<$comName ; then
		echo "Setting topic in $comArgV1" > "$HOME/irc/127.0.0.1/${i}/in"
		echo "/SATOPIC $comArgV1 :$comArgV2 $comArgV3 $comArgV4" > $HOME/irc/127.0.0.1/in
		echo "$comArgV2 $comArgV3 $comArgV4" > "$HOME/.Uchan/$comArgV1.tp"
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[vV][hH][sS][rR]' <<<$comName ; then
		test -e "$HOME/.Uhost/$comArgV1" && echo 'Either you already have a vHost or my bot sucks :)' > $HOME/irc/127.0.0.1/${i}/in || \
		echo "You now have vHost visitor/$comArgV2/$comArgV1 with the password given as the second argument." > "$HOME/irc/127.0.0.1/${i}/in"
		echo "$(echo $(tr '[A-Z' '[a-z]' <<<$comArgV1):$comArgV3 | shasum -a 512 | sed -e 's/ -//g') visitor/$comArgV2/$comArgV1" > ~/.Uhost/$comArgV1
		vHostUser $comArgV1 #"$(echo $i | sed -e 's/\///g')"
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[vV][hH][sS][iI]' <<<$comName ; then
		test "$(echo $(tr '[A-Z]' '[a-z]' <<<$comArgV1):$comArgV2 | shasum -a 512 | sed -e 's/  -//g')" = "$(cut -d ' ' -f 1 $HOME/.Uhost/$comArgV1)" && \
		vHostUser $comArgV1 #"$(ls -1 $HOME/.Uhost/ | grep -i $comArgV1)"
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	elif egrep '^[nN][sS][aA][tT]' <<<$comName ; then
		echo "/WHO $(echo $i | sed -e 's/\///g')" > ~/irc/127.0.0.1/in
		tail -n 2 ~/irc/127.0.0.1/out | IFS=' ' read discard discard1 discard2 discard3 hostname discard4
		grep "/" <<<$hostname && for j in ~/.Uchan/*.db ; do
			grep -i "$(sed -e 's/.*\///g' <<<$hostname)" $j >/dev/null && \
			echo "/MODE $(echo $j | sed -e 's/.*\///g' -e 's/\.db//g') +o $(echo $i | sed -e 's/\///g')" > $HOME/irc/127.0.0.1/in
		done
		rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	fi
	comName=''
	comArgV1=''
	comArgV2=''
	comArgV3=''
	comArgV4=''
	i=''
	rm -r $HOME/irc/127.0.0.1/${i} 2> /dev/null ; continue
	done
	done
}

chanServ
chanPM
rm ~/.Uchan/nicks/*
kill $$

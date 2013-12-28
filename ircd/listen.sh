#!/usr/bin/env zsh
myport="$1"
./configparse.sh ircd.conf
. ./ircd.conf.sh
# This bit listens for connections on the client port 6667
zmodload zsh/net/tcp zsh/zselect
ztcp -l $listen0001
listenfd="$REPLY"

###
# this is the rub. I need to implement a full ircd in just one file. madness!
createChannel(){
	channelname="$1"
	if grep '[;()$,]' <<<"$channelname" ; then
		noSuchCu "Illegal characters in username" ; return
	else
		creator="$2"
		ts="$(date +%s)"
		sqlite ./channel.db "create table ${channelname}(text, timestamp INTEGER, oplevel INTEGER); insert into ${channelname} values('$creator', $ts, 9000);"
	fi
}
leaveChannel(){
	channelname="$1"
	if grep '[;()$,]' <<<"$channelname" ; then
		noSuchCu "Illegal characters in username" ; return
	else
		creator="$2"
		sqlite ./channel.db "delete from ${channelname} where text = \"$creator\";" || noSuchCu "No such channel"
	fi
}
###

while ztcp -a $listenfd ; do
	ipaddr="$(ztcp -L | grep \"^$REPLY\" | cut -f 5 -d' ')"
	theirport="$(ztcp -L | grep \"^$REPLY\" | cut -f 6 -d' ')"
	theirident="$(echo $theirport, $myport | nc $ipaddr 113)"
	grep -i '^$' <<<"$theirident" && theirident="noident"
	if test "$theirident" \!= "noident" ; then
		theirid="$(perl -p -e 's/.*://g' <<<\"$theirident\")"
	fi
	accept $REPLY "$theirid" $ipaddr &
done

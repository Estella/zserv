#!/usr/bin/env zsh
# Zserv initialisation script

. ./server.conf
#****************************************
#This sets up the connect-out.
ztcp -d 4 $irc-server $irc-server-port
. ./s2s/$proto.sh
for i in $mods; do
	. ./pclients/$i.sh
done


#We have a pseudo object oriented system.
#Whenever this server sees a message directed at ]]AAA, it should direct it to client number
#AAA. This server ALWAYS links as ]] in the P10 protocol as shipped.
# Clients use numbers configured in their $modulename.conf files.
# If they conflict, an error should be raised and the program should quit.
# Feck. We don't do that. :P

#!/usr/bin/env zsh
# Zserv initialisation script

. ./server.conf
#****************************************
#This sets up the connect-out.
#MUST USE CAMELCASE LOL
ztcp -d 4 $ircServer $ircServerPort
. ./s2s/$proto.sh

# here we set up the communication between the server and the pseudoclients.
# A client is supposed to ignore messages not addressed to it.
for i in $mods; do
	. ./pclients/$i.sh
done


#We have a pseudo object oriented system.
#Whenever this server sees a message directed at ]]AAA, it should direct it to client number
#AAA. This server ALWAYS links as ]] in the P10 protocol as shipped.
# Clients use numbers configured in their $modulename.conf files.
# If they conflict, an error should be raised and the program should quit.
# Feck. We don't do that. :P

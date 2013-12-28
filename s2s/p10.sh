#!/usr/bin/env zsh
# This module attempts to implement the P10 protocol.

. ./s2s/p10.conf
#This bit sets the program to read/write to the irc file descriptor
exec <>&4

#This bit sends the correct commands to the server.
echo "PASS $srvpassword"
echo "SERVER $ircServerName 1 $(date +%s) $(date +%s) J10 ]]AA] +0 :$ircServerDescription"
while read burst ; do
	if test "$burst" = "EB" ; then
		echo "EA"
		break
	fi
	echo "$burst" >> ./burst.log
done
echo "]] N ${ircP10operServNickname} 1 $(date +%s) ${ircP10operServIdent} $ircServerName +io AAAAAA ]]AAB :Some stupid homemade oper service"

#!/usr/bin/env zsh
. ./rednek.conf
echo Welcome to the Red Neck Bot program.
echo This is an IRC bot programmed in Zsh script.
if grep zsh <<<$SHELL ; then
	echo "Continuing."
else
	echo "!!! YOUR SHELL IS NOT ZSH !!!"
	echo "This script depends on certain Zsh specific functions."
	exit 1
fi
zmodload zsh/net/tcp zsh/zselect && echo "Ztcp loaded."
ztcp -d 6 $ircServer $ircServerPort
exec <>&6
while read line; do
	fromnick=""
done

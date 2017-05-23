This file is horrifically out of date. I'm no longer j4jackj, I'm no longer a he, and 'm0n'
doesn't bloody know me.

I must have been high on something. - Ellenor Malik




The ZIRC Services Program
=====

j4jackj and m0n are developing a program called zserv, or for long, ZIRC services.
This services package is designed from the ground up to be extensible at runtime.
But the thing you need to know is that it's written in Zsh script, portions may be
Bourne compliant minus our use of ztcp.

Why is brell.sh here?
====

Brell.sh was the old umbrellixserv, used before Umbrellix became known as Aster IRC.
It is a client, and only, ONLY suitable for InspIRCD.
*PLEASE DO NOT USE IT.*

WTF with the directory 'ircd'?
====

j4jackj thought he would develop an ircd to go with his services package.
His ircd is called IRCD-Citrus. It is, like zserv, written in Zsh.
It uses a custom s2s protocol called P90, which is a variant
on P10 designed to negate the need for a complicated state machine.

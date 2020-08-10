#!/bin/bash

# 3syua game robot
# Copyright (C) 2020 Michael

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This script aims to do some daily missions to acquire golds automatically
# for game 3syua. It will benefit people who would like to "raise" some
# replacement accounts for your main characters. The replacement accounts are
# created manually at the moment.

# Prerequisite Software
# - Linux OS (Mac OS does not work as xdotool is not supported properly.)
# - Google Chrome
# - xdotool

# To define how many accounts that will run the scripts to request golds.
# This definition can be overwritten depends on your demands.
#
NUM_ACCOUNT=10

# "ACCOUNT_PREFIX" defines what the forms of accounts and passwords.
# For instance, if ACCOUNT_PREFIX is mtest, the accounts will mtest_000,
# mtest_001 and so on. So bear in mind the forms when you're creating
# replacement accounts.
#
ACCOUNT_PREFIX='mtest' 

#/*************************************************************************/ /*!
#@Function       getScreenWidth
#@Description    Get the width of screen
#*/ /**************************************************************************/
#
getScreenWidth()
{
	xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'| \
		cut -d'x' -f1
}

#/*************************************************************************/ /*!
#@Function       getScreenHeight
#@Description    Get the height of screen
#*/ /**************************************************************************/
#
getScreenHeight()
{
	xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'| \
		cut -d'x' -f2
}

#/*************************************************************************/ /*!
#@Function       doMouseMove
#@Description    Simulating mouse moving
#@Input          $1 The ratio of offests on horizontal axis.
#                $2 The ratio of offests on vertical axis.
#*/ /**************************************************************************/
#
doMouseMove()
{
	width=$(getScreenWidth)
	height=$(getScreenHeight)
	x=$1
	y=$2

	# Since people have a variety of different screens, using ratio to
	# calculate coordinate should be more consistent.
	x=$(expr $width*$x/100 |bc -l)
	y=$(expr $height*$y/100 |bc -l)

	xdotool mousemove $x $y
}

#/*************************************************************************/ /*!
#@Function       doMouseMoveAndClick
#@Description    Simulating mouse moving and click
#@Input          $1 The ratio of offests on horizontal axis.
#                $2 The ratio of offests on vertical axis.
#*/ /**************************************************************************/
#
doMouseMoveAndClick()
{
	width=$(getScreenWidth)
	height=$(getScreenHeight)
	x=$1
	y=$2

	# Since people have a variety of different screens, using ratio to
	# calculate coordinate should be more consistent.
	x=$(expr $width*$x/100 |bc -l)
	y=$(expr $height*$y/100 |bc -l)

	xdotool mousemove $x $y click 1
}

#/*************************************************************************/ /*!
#@Function       doMouseDrag
#@Description    Simulating mouse dragging
#@Input          $1 The ratio of offests on horizontal axis.
#                $2 The ratio of offests on vertical axis.
#*/ /**************************************************************************/
#
doMouseDrag()
{
	width=$(getScreenWidth)
	height=$(getScreenHeight)
	x=$1
	y=$2

	# Since people have a variety of different screens, using ratio to
	# calculate coordinate should be more consistent.
	x=$(expr $width*$x/100 |bc -l)
	y=$(expr $height*$y/100 |bc -l)

	xdotool mousedown 1
	sleep 0.5
	xdotool mousemove_relative --sync $x $y
	sleep 0.5
	xdotool mouseup 1
}

#/*************************************************************************/ /*!
#@Function       doKeyBoardInput
#@Description    Simulating keyboard typing
#@Input          $1 Stings as inputs
#*/ /**************************************************************************/
#
doKeyBoardInput()
{
	xdotool type "$1"
}

# Main functionality
#
# Launch Chrome browser with the game URL.
#
/opt/google/chrome/chrome --user-data-dir --start-fullscreen \
	--app=https://h5.3syua.com/tw/syua?cid=48&scid=3syua_button \

# Waiting on the game.
#
sleep 3

# The simple steps are implemented here and described them inline.
#
i=0
while [ $i != $NUM_ACCOUNT ]
do
	# Format ids to three digits.
	ACCOUNT_POSTFIX=_$(printf "%03d" $i)

	# ---- Starting to login the game ---
	# The username and password are sharing the same strings which
	# is mtest_00{0->$NUM_ACCOUNT} if ACCOUNT_PREFIX is default.
	username="$ACCOUNT_PREFIX""$ACCOUNT_POSTFIX"

	# Typing username.
	# width: 40%, height: 33%
	doMouseMoveAndClick 40 33
	doKeyBoardInput $username

	# Typing password.
	# width: 40%, height: 43%
	doMouseMoveAndClick 40 43
	doKeyBoardInput $username

	# Clicking login button.
	# width: 50%, height: 60%
	doMouseMoveAndClick 50 60

	# Waiting on login
	sleep 2
	# ----------------End----------------

	# Another login button with animation.
	# width: 50%, height: 85%
	doMouseMoveAndClick 50 85
	sleep 5

	# At the stages, we should already in game and be able to do missions.
	# ---- Starting to do tasks ---
	# Skip any notification
	xdotool click 1
	sleep 0.5

	# Go to world map
	# width: 40%, height: 95%
	doMouseMoveAndClick 40 95
	sleep 0.5

	# Visiting palace
	# width: 50%, height: 35%
	doMouseMoveAndClick 50 35
	sleep 0.5

	# Visiting 逍遙王 and get golds
	# width: 50%, height: 70%
	doMouseMoveAndClick 50 70
	sleep 0.5
	# To get golds
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 0.5
	# Back to world map
	# width: 60%, height: 20%
	doMouseMoveAndClick 60 20
	sleep 0.5
	# width: 60%, height: 20%
	doMouseMoveAndClick 60 20
	sleep 0.5

	# Moving cursor to central for dragging frame in order to see the
	# ranking label.
	doMouseMove 50 50
	sleep 0.5
	doMouseDrag 90 0
	sleep 0.5

	# Visiting the lists
	# width: 40%, height: 70%
	doMouseMoveAndClick 40 70
	sleep 0.5

	# Choosing our own server
	# width: 40%, height: 50%
	doMouseMoveAndClick 40 50
	sleep 0.5

	# Golds for power ranking
	# width: 60%, height: 95%
	doMouseMoveAndClick 40 95
	sleep 0.5

	# Golds for class ranking
	# width: 47%, height: 27%
	doMouseMoveAndClick 47 27
	sleep 0.5
	# width: 60%, height: 95%
	doMouseMoveAndClick 40 95
	sleep 0.5

	# Golds for love ranking
	# width: 47%, height: 27%
	doMouseMoveAndClick 47 27
	sleep 0.5
	# width: 60%, height: 95%
	doMouseMoveAndClick 40 95
	sleep 0.5
	# ----------------End----------------

	# Logout and change to the next account
	# width: 74%, height: 65%
	doMouseMoveAndClick 74 65
	sleep 5

	i=$(($i+1))
done

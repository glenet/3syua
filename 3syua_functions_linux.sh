# The following functions are used in most cases thus packaged here to be
# sourced. Hence future alterations can be implemented only by changing the
# parameters here.


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
#@Function       doMouseClick
#@Description    Simulating mouse clicking
#*/ /**************************************************************************/
#
doMouseClick()
{
	xdotool click 1
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
#@Input          $1 The degree of movement, 270 for mouse to go left, 90 right
#                $2 The pixels to move
#*/ /**************************************************************************/
#
doMouseDrag()
{
    xdotool click 1
	xdotool mousedown 1
	sleep 0.5
	xdotool mousemove_relative --sync --polar $1 $2
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
	xdotool type --delay 200 "$1"
}

#/*************************************************************************/ /*!
#@Function       doSoftBack
#@Description    This can be used to exit most of pages without affecting other
#                functions. 
#*/ /**************************************************************************/
#
doSoftBack()
{
	# It's the small spot under "攻略"
	doMouseMoveAndClick 62.4 20.59
	sleep 1.5
	doMouseClick
	sleep 1.3
}

doMultipleClick()
{
	r=1
	while [ $r -le $1 ]
	do
		doMouseClick
		sleep 0.5
		r=$(($r+1))
	done
}

#/*************************************************************************/ /*!
#@Function       doHardBack
#@Description    This can be used to exit pages but may click '攻略' if clicked
#                multiple times.
#*/ /**************************************************************************/
#
doHardBack()
{
	doMouseMoveAndClick 60 18
	sleep 1
}

#/*************************************************************************/ /*!
#@Function       doLogin
#@Description    Login with username 
#@Input          $1 The username and $2 the password. $3 may be used to change 
#			     server.
#*/ /**************************************************************************/
#
doLogin()
{
    # Typing username.
	# width: 40%, height: 30%
	doMouseMoveAndClick 40 30
	doKeyBoardInput $1

	# Typing password.
	# width: 40%, height: 43%
	doMouseMoveAndClick 40 43
	doKeyBoardInput $2
	sleep 2

	# Clicking login button.
	# width: 50%, height: 60%
	doMouseMoveAndClick 50 60

	# Waiting on login
	sleep 4

	# Change server if needed
	if [ -n "$3" ]
	then
		# Click to select server 
		doMouseMoveAndClick 50 79.4
		sleep 1
		if [ $1 = masonfocus ] 
		then
			if [ $3 = 125 ]
			then
				# Chosse mason 125
				doMouseMoveAndClick 50 83.1
				sleep 1
			elif [ $3 = 141 ]
			then
				# Chosse mason 141
				doMouseMoveAndClick 50 62.7
				sleep 1
			elif [ $3 = 127 ]
			then
				# Chosse mason 127
				doMouseMoveAndClick 50 75.3
				sleep 1
			fi
		elif [ $1 = kylet2 ]
		then
			# scroll down
			doMouseMove 50 60.8
			sleep 0.5
			doMouseDrag 0 80
			sleep 1

			# Chosse fengyue 125
			doMouseMoveAndClick 50 77.1
			sleep 1
			# choose 125
		elif [ $1 = qq9966633@gmail.com ]
		then
			# Choose 125
			doMouseMoveAndClick 50 63.3
		fi
	fi

    # Enter Game
    doMouseMoveAndClick 50 87.7
    sleep 4

	# Dismiss the common welcome notification by softbacking
	doSoftBack
	doSoftBack
}

#/*************************************************************************/ /*!
#@Function       doDismissTaige
#@Description    Dissmiss event notifications of Taige ecents
#*/ /**************************************************************************/
#
doDismissTaige()
{
    # Dismiss notification of Taige Ecents
    doMouseMoveAndClick 62 28.68
    sleep 1.5
}

#/*************************************************************************/ /*!
#@Function       doDismissBE
#@Description    Dissmiss event notifications of Big Events like new skins
#*/ /**************************************************************************/
#
doDismissBE()
{
    # Dismiss notification of Ecents
    doMouseMoveAndClick 62 21.68
    sleep 1.5
}


dodismissBEALL()
{
	# Choose do not show again
	doMouseMoveAndClick 47.14 92.95

	sleep 1

	# Dismiss notification of Ecents
    doMouseMoveAndClick 60.83 19.55
    sleep 1.5

	# Quit account
	doQuitGame
}

#/*************************************************************************/ /*!
#@Function       doDismissNewMonth
#@Description    Dissmiss event notifications of NewMonth event.
#*/ /**************************************************************************/
#
doDismissNewMonth()
{
    # Dismiss notification of Ecents
    doMouseMoveAndClick 62 20
    sleep 1.5
}

#/*************************************************************************/ /*!
#@Function       doWorldHome
#@Description    The button to go to world or go back to home
#*/ /**************************************************************************/
#
doWorldHome()
{
	# Go to world map or back home
	# width: 40%, height: 95%
	doMouseMoveAndClick 40 95
	sleep 1
}

#/*************************************************************************/ /*!
#@Function       doWorship
#@Description    Go worship to get golds and credits from the world map
#*/ /**************************************************************************/
#
doWorship()
{
	# Visiting palace
	# width: 50%, height: 35%
	doMouseMoveAndClick 50 35
	sleep 1

	# Visiting 逍遙王 and get golds
	# width: 50%, height: 70%
	doMouseMoveAndClick 50 70
	sleep 1
	# To get golds
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1
	# Back to world map
	doSoftBack

	# Visiting the lists
	# width: 40%, height: 70%
	doMouseMoveAndClick 40 70
	sleep 1

	# Choosing our own server
	# width: 50%, height: 50%
	doMouseMoveAndClick 50 50
	sleep 1

	# Golds for power ranking
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1

	doMouseClick
	sleep 1

	# Golds for class ranking
	# width: 45%, height: 27%
	doMouseMoveAndClick 45 27
	sleep 1
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1
	doMouseClick
	sleep 1

	# Golds for love ranking
	# width: 50%, height: 27%
	doMouseMoveAndClick 50 27
	sleep 1
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1
	doMouseClick
	sleep 1

	# back
	doHardBack

	# choos cross server 
	doMouseMoveAndClick 49.7 83.5
	sleep 2

	# Achievment for power ranking
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1
	doMouseClick
	sleep 1

	# Achievment for families
	# width: 45%, height: 27%
	doMouseMoveAndClick 45 27
	sleep 1
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1
	doMouseClick
	sleep 1

	# Achievment for soldiers
	# width: 50%, height: 27%
	doMouseMoveAndClick 50 27
	sleep 1
	# width: 60%, height: 95%
	doMouseMoveAndClick 60 95
	sleep 1
	doMouseClick
	sleep 1

	# Quit list and go back to world map
	doHardBack
	doSoftBack
}



#/*************************************************************************/ /*!
#@Function       doClanConstruction
#@Description    Go to clan and construct accordingly
#@Input          $1 The degree of construction, either high, medium or low
#*/ /**************************************************************************/
#
doClanConstruction()
{
	# Moving cursor to central for dragging frame in order to see the
	# clan.
	doMouseMove 50 50
	sleep 0.8
	doMouseDrag 270 120
	sleep 1

    # Visiting the clan
	doMouseMoveAndClick 60.6 51
	sleep 1

	# Click construct
	doMouseMoveAndClick 51.2 49.8
	sleep 1

	# Choose which kind of construction to make
	if [ $1 = high ]
	then
		# Choose high construction
		doMouseMoveAndClick 56.8 58.1
		sleep 1
	elif [ $1 = medium ]
	then
		# Choose medium construction
		doMouseMoveAndClick 56.8 47
		sleep 1
	elif [ $1 = low ]
	then
		# Choose low construction
		doMouseMoveAndClick 56.8 37.2
		skeep 1
	fi

	# Quit clan
	doSoftBack
}

doVisit()
{
	# Drag twice to see visit
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 270 140
	sleep 1
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 270 140
	sleep 1

	# Click Visit
	doMouseMoveAndClick 62.5 63.2
	sleep 1

	# Click batch visit
	doMouseMoveAndClick 56.7 98.7
	sleep 1

	# Click visit
	doMouseMoveAndClick 58 94.2
	sleep 5

	doHardBack

	# Quit Any hongyan request
	doMouseMoveAndClick 45.9 95
	sleep 1
	doMouseClick
	sleep 1
	doMouseClick
	sleep 1
	doMouseClick
	sleep 1
	doMouseClick
	sleep 1

	# Quit visit
	doSoftBack
}

doSchool()
{
    # Click School
	doMouseMoveAndClick 60.8 71.8
	sleep 1.5

	# Finish study
	doMouseMoveAndClick 57.4 93.6
	sleep 8

	# Deploy study again
	doMouseMoveAndClick 57.4 93.6
	sleep 0.5
	doMouseMoveAndClick 57.3 76.5 # totest
	sleep 1

	doSoftBack
}

doClaim()
{
    # Click treasure
    doMouseMoveAndClick 50 70
    sleep 1.5

    # Claim treasure
    doMouseMoveAndClick 50 95
    sleep 1
    doMouseMoveAndClick 50 81.3
    sleep 1

    doSoftBack
}

doWife()
{
    # Choose wife
    doMouseMoveAndClick 60 60
    sleep 1

    # Click batch selection 
    doMouseMoveAndClick 54.1 96.3
    sleep 1

    # Papapa
    doMouseMoveAndClick 60.4 93
    sleep 5

    doSoftBack
}

doChildren()
{
    # Drag and see children
    doMouseMove 61.5 80
	sleep 1
	doMouseDrag 270 120
	sleep 1

    # Click children
    doMouseMoveAndClick 56 66
    sleep 1
    
    # Click raise
    doMouseMoveAndClick 60 53
	sleep 1.5

    doSoftBack
}

doFuben()
{
	# Drag twice to see fuben
	# Drag twice to see visit
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 270 150
	sleep 0.5
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 270 150
	sleep 1

	# Click fuben
	doMouseMoveAndClick 63 35.6
	sleep 0.5

	# Enter battle
	doMouseMoveAndClick 50 50
	sleep 1

	# Auto battle
	doMouseMoveAndClick 62.3 70

	# Move mouse elsewhere
	doMouseMove	60.51 62.84

	if [ $1 = noon ]
	then
		doMultipleClick 140
	elif [ $1 = night ]
	then
		doMultipleClick 76
	fi

	# Go back to world map(special)
	doMouseMoveAndClick 797 309
    sleep 1
}

doQinjiaSchool()
{
	doMouseMove 42.24 68.44

	# Drag to see yuelao
	doMouseDrag 90 200 
	sleep 1

	# Choose yuelao
	doMouseMoveAndClick 41.28 64.79
	sleep 1
	# Click to omit any notifications
	doMouseMoveAndClick 50 50
	sleep 1 
	doMouseClick
	sleep 0.5
	doMouseClick
	sleep 0.5
	# Choose 1st qinjia
	doMouseMoveAndClick 49.63 75.09
	sleep 1
	# Click school
	doMouseMoveAndClick 58.56 54.36
	sleep 1
	# Choose first child
	doMouseMoveAndClick 55.85 39.37
	sleep 1
	# Click sure 
	doMouseMoveAndClick 54.39 62.32
	sleep 1
}

ddd()
{
	# Choose yuelao
	doMouseMoveAndClick 41.28 64.79
	sleep 1
	# Click to omit any notifications
	doMouseMoveAndClick 50 50
	sleep 1 
	doMouseClick
	sleep 0.5
	doMouseClick
	sleep 0.5
	# Choose 1st qinjia
	doMouseMoveAndClick 49.63 75.09
	sleep 1
	# Click school
	doMouseMoveAndClick 58.56 54.36
	sleep 1
	# Choose first child
	doMouseMoveAndClick 55.85 39.37
	sleep 1
	# Click sure 
	doMouseMoveAndClick 54.39 62.32
	sleep 1
}



doQuitGame()
{
	# Logout and change to the next account
	# width: 72%, height: 3%
	doMouseMoveAndClick 72 3
	sleep 1
}

doQuitChrome()
{
	# Quit Chrome
	killall chrome
}

doOpenWebsite()
{
	# Launch Chrome browser with the game URL.
	/opt/google/chrome/chrome --user-data-dir --start-fullscreen \
	--app=https://h5.3syua.com/tw/syua?cid=48&scid=3syua_button \

	# Waiting on the game.
	#
	sleep 5
	WID=`xdotool search --name "Chrome" | tail -1`
	xdotool windowfocus $WID
	sleep 2
}

Richang()
{
	doClaim

	doWorldHome

	doSchool

	doWorldHome

	doWife

	doChildren

	doWorldHome

	doVisit

	doQuitGame
}

doLaba()
{
	# Click Chat
    doMouseMoveAndClick 57.5 88.26
    sleep 1.5

	# Choose server chatroom
	doMouseMoveAndClick 38.7 88.6
	sleep 1.5

	# Send message
	for ms
	do
		# Enter chatbox
		doMouseMoveAndClick 47.2 96.2
		sleep 1

		# Send message
		doKeyBoardInput $ms
		sleep 1
		

		# Press send
		doMouseMoveAndClick 61 96
		sleep 11
	done
}


doSihai()
{
	# Click sihai
	doMouseMoveAndClick 56.3 30
	sleep 1

	# Click Enter
	doMouseMoveAndClick 50 57
	sleep 1.5

	# Assemble a ship of 3
	doMouseMoveAndClick 50 87
	sleep 1
	doMouseMoveAndClick 55.3 45.1
	sleep 0.6
	doMouseMoveAndClick 55.3 55.8
	sleep 0.6
	doMouseMoveAndClick 55.3 67.1
	sleep 0.6
	# Click assemble
	doMouseMoveAndClick 50 8
	sleep 1 

	# drag to see target
	doMouseMove 50 50
	doMouseDrag $1 $2

	# Go to target
	doMouseMoveAndClick $3 $4
	sleep 1
	# Challenge
	doMouseMoveAndClick 50 68
	sleep 1


	# attack
	doMouseMoveAndClick 50 53
	sleep 1

}

doSihaiCollect()
{
	# Click sihai
	doMouseMoveAndClick 56.3 30
	sleep 1

	# Click Enter
	doMouseMoveAndClick 50 57
	sleep 1.5

	# drag to see target
	doMouseMove 50 50
	doMouseDrag $1 $2

	# Click target
	doMouseMoveAndClick $3 $4
	sleep 1

	# Collect
	doMouseMoveAndClick 50 68
	sleep 1

	doSoftBack
}



alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
getPosition()
{
	width=$(getScreenWidth)
	height=$(getScreenHeight)
	x=$(xdotool getmouselocation | awk '{ print $1 }' | cut -c 3- )
	x=$(echo "scale=4; ($x/$width) * 100" | bc)
	y=$(xdotool getmouselocation | awk '{ print $2 }' | cut -c 3- )
	y=$(echo "scale=4; ($y/$height) * 100" | bc)

	# Put (x, y) to clipboard
	echo ${x::len-2} ${y::len-2} | setclip
	# Display on the screen
	echo ${x::len-2} ${y::len-2}
}

doAutoBattle()
{
	# Drag to see battle
	doMouseMoveAndClick 50 46
	sleep 0.5
	doMouseDrag 90 120
	sleep 0.5
	# Visit 
	doMouseMoveAndClick 37.62 55.67
	sleep 0.8

	# Click attack
	doMouseMoveAndClick 56.95 64.27
	sleep 0.8

	# Click Yijian, twice to avoid blood choice first
	doMouseMoveAndClick 62.00 45.89
	sleep 0.8
	doMouseClick

	# Click Sure
	doMouseMoveAndClick 54.61 69.88
	sleep 1
 }

 doUpgrade()
 {
	 # Click Profile
	 doMouseMoveAndClick 39.01 19.03
	 sleep 1
	 # Choose upgrade
	 doMouseMoveAndClick 60.90 52.54
	 sleep 1
	 # Click upgrade
	 doMouseMoveAndClick 50.21 94.00
	 sleep 1 
	 doMouseClick
	 sleep 1 
	 doMouseClick
	 sleep 1

	 # Quit upgrading
	 doSoftBack
	 sleep 1
	 doSoftBack
 }

 doClaimMail()
 {
	 # Click arrow to show the mail
	 doMouseMoveAndClick 37.40 67.14
	 sleep 0.5

	 # Choose mail
	 doMouseMoveAndClick 38.21 57.88
	 sleep 1
	 
	 # Claimall 
	 doMouseMoveAndClick 58.12 95.95
	 sleep 1

	 # Quit
	 doSoftBack
 }

 donate()
{
	if [ $1 = sweets ]
	then
		# sweets
		doMouseMoveAndClick 50 57.5
		sleep 1
	elif [ $1 = fan ]
	then
		#fan
		doMouseMoveAndClick 45 75
		sleep 1
	elif [ $1 = silk ]
	then
		# silk
		doMouseMoveAndClick 51 72.3
		sleep 1
	elif [ $1 = banzhi ]
	then
		# banzhi
		doMouseMoveAndClick 41.5 60
		sleep 1
	fi
}

doLaofoye()
{
	doMouseMoveAndClick $1 $2

    sleep 1

    # Choose today's donation, either banzhi, sweets, fan, or silk
    donate $3

    # Press Donate
    doMouseMoveAndClick 50 84
    sleep 1

    # Press Thankyou
    doMouseClick
    sleep 2

	# Collect the presents at the last day
	if [ $4 = collect ]
	then
		# Click the 5 boxes
		doMouseMoveAndClick 45 27.5
		sleep 0.6
		doMouseClick
		sleep 0.8
		doMouseClick
		sleep 0.8
		doMouseMoveAndClick 50 27.5
		sleep 0.6
		doMouseClick
		sleep 0.8
		doMouseClick
		sleep 0.8
		doMouseMoveAndClick 54 27.5
		sleep 0.6
		doMouseClick
		sleep 0.8
		doMouseClick
		sleep 0.8
		doMouseMoveAndClick 58 27.5
		sleep 0.6
		doMouseClick
		sleep 0.8
		doMouseClick
		sleep 0.8
		doMouseMoveAndClick 62 27.5
		sleep 0.6
		doMouseClick
		sleep 0.8
		doMouseClick
		sleep 0.8
	fi
}


lazyroutine()
{
    doWorldHome

    doWorship

	doTaofa

	doWorldHome

	doWorldHome

	doSilkroad

	doWorldHome

	doWorldHome

    doClanConstruction high

    # Choose mission
    doMouseMoveAndClick 55.5 94.7
    sleep 1

    # Finish three missions
    doMouseMoveAndClick 58 39.2
    sleep 1 
    doMouseMoveAndClick 58 49.4
    sleep 1 
    doMouseMoveAndClick 58 60.3
    sleep 1 

    # Claim the rewards
    doMouseMoveAndClick 43.8 26.5
    sleep 1
    doMouseMoveAndClick 48 26.5
    sleep 1

    # QuitGame
    doQuitGame
}

lazyroutinenotaofa()
{
    doWorldHome

    doWorship

	doSilkroad

	doWorldHome

	doWorldHome

    doClanConstruction high

    # Choose mission
    doMouseMoveAndClick 55.5 94.7
    sleep 1

    # Finish three missions
    doMouseMoveAndClick 58 39.2
    sleep 1 
    doMouseMoveAndClick 58 49.4
    sleep 1 
    doMouseMoveAndClick 58 60.3
    sleep 1 

    # Claim the rewards
    doMouseMoveAndClick 43.8 26.5
    sleep 1
    doMouseMoveAndClick 48 26.5
    sleep 1

    # QuitGame
    doQuitGame
}

minilazyRoutine()
{
    doClaim

	doQinjiaSchool
}

doTaofa()
{
	# Drag to see the taofa
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 90 140
	sleep 1
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 90 140
	sleep 1

	round=1
	while [ $round -le 10 ]
	do
		# Click taofa
		doMouseMoveAndClick 37.55 62.71
		sleep 1

		# Taofa
		doMouseMoveAndClick 55.27 46.54
		sleep 1

		# Skip 
		doMouseMoveAndClick	61.63 70.66
		sleep 1

		# Back to the taofa page
		doMouseMoveAndClick	50.07 78.48
		sleep 1
		round=$(($round+1))
	done

	# Quit
	doSoftBack
}

doSilkroad()
{
	# Drag to see the silk road
	doMouseMove 50 46
	sleep 0.5
	doMouseDrag 270 140
	sleep 1

	# Click silkroad
	doMouseMoveAndClick 57.54 44.06
	sleep 1

	# Click iran
	doMouseMoveAndClick 42.60 77.57
	sleep 1

	# Click goahead
	doMouseMoveAndClick	50.21 70.14
	sleep 4
	doMouseClick
	sleep 1

	# Quit
	doSoftBack
}
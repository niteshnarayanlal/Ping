	#! /bin/env tclsh
	package require Tk

	# Set window title
	wm title . TrafficGenerator 

	# Create a frame for buttons and entry.
	frame .maintop -borderwidth 30 -bg grey70
	pack .maintop -side top -fill x 

	# Create the command buttons.
	button .subtop.quit -text Quit -command exit -bg red
	set but [button .subtop.run -text "Ping"  -bg red -command Run] 
	pack .subtop.quit .subtop.run -side right

	# Create a labeled entry for the command
	label .subtop.l1 -text DestinationIP: -padx 0 -relief raised -bg red
	entry .subtop.cmd1 -width 20  -textvariable input

	label .subtop.l2 -text NumberOfPackets: -padx 0 -relief raised -bg red
	entry .subtop.cmd2 -width 20  -textvariable nop

	label .subtop.l3 -text PacketSize: -padx 0 -relief raised -bg red
	entry .subtop.cmd3 -width 20  -textvariable packetsize

	pack .subtop.l1 -side left
	pack .subtop.cmd1 -side left -fill x -expand true 

	pack .subtop.l2 -side left
	pack .subtop.cmd2 -side left -fill x -expand true

	pack .subtop.l3 -side left
	pack .subtop.cmd3 -side left -fill x -expand true

	# Set up key binding equivalents to the buttons
	bind .subtop.cmd1 <Return> Run
	bind .subtop.cmd1 <Control-c> Stop
	focus .subtop.cmd1
	# Create a text widget to log the output
	frame .subt
	set log [text .subt.log -width 80 -height 10 \
	-borderwidth 2 -relief raised -setgrid true \
	-yscrollcommand {.subt.scroll set}]
	scrollbar .subt.scroll -command {.subt.log yview}
	pack .subt.scroll -side right -fill y
	pack .subt.log -side left -fill both -expand true
	pack .subt -side top -fill both -expand true
	# Run the program and arrange to read its input
	proc Run {} {
	global input log but Data nop packetsize
	set Data [exec ping -c $nop -s $packetsize $input]
	$log insert end $Data\n
	$but config -text Stop -command Stop
	}
	# Read and log output from the program
	proc Log {} {
	global input log
	if [eof $input] {
	Stop
	} else {
	gets $input line
	$log insert end $line\n $Data \n
	$log see end
	}
	}
	# Stop the program and fix up the button
	proc Stop {} {
	global input but
	catch {close $input}
	$but config -text "Ping" -command Run
	}

#!/usr/bin/env bash
xrdb -merge ~/.Xresources

xset +fp ~/.local/share/fonts
xset fp rehash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
	echo "Invalid monitor $monitor"
	exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=$(expr ${geometry[2]} - 140 + 140 \* $monitor)
panel_height=16
export font='-*-profont-*-*-*-*-11-*-*-*-*-*-*-*'
bgcolor=$(hc get frame_border_normal_color)
selbg=$(hc get window_border_active_color)
selfg='#101010'

####
# Try to find textwidth binary.
# In e.g. Ubuntu, this is named dzen2-textwidth.
if which textwidth &> /dev/null ; then
	textwidth="textwidth";
	#fc-list
elif which dzen2-textwidth &> /dev/null ; then
	textwidth="dzen2-textwidth";
else
	echo "This script requires the textwidth tool of the dzen2 project."
	exit 1
fi
####
# true if we are using the svn version of dzen2
# depending on version/distribution, this seems to have version strings like
# "dzen-" or "dzen-x.x.x-svn"
if dzen2 -v 2>&1 | head -n 1 | grep -q '^dzen-\([^,]*-svn\|\),'; then
	dzen2_svn="true"
else
	dzen2_svn=""
fi

if awk -Wv 2>/dev/null | head -1 | grep -q '^mawk'; then
	# mawk needs "-W interactive" to line-buffer stdout correctly
	# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593504
	uniq_linebuffered() {
		awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
	}
else
	# other awk versions (e.g. gawk) issue a warning with "-W interactive", so
	# we don't want to use it there.
	uniq_linebuffered() {
		awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
	}
fi

hc pad $monitor $panel_height

{
	### Event generator ###
	# based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
	#   <eventname>\t<data> [...]
	# e.g.
	#   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29
	mpc idleloop player &
	while true ; do
		# "date" output is checked once a second, but an event is only
		# generated if the output changed compared to the previous run.
		date +$'date\t^fg(#efefef)%H:%M^fg(#909090), %Y-%m-^fg(#efefef)%d'
		sleep 1 || break
	done > >(uniq_linebuffered) &
	childpid1=$!
	childpid2=$!
	hc --idle
	kill $childpid1
	kill $childpid2
} 2> /dev/null | {
IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
visible=true
date=""
windowtitle=""
while true ; do
	echo $SONG >&2
	### Output ###
	# This part prints dzen data based on the _previous_ data handling run,
	# and then waits for the next event to happen.

	bordercolor="#26221C"
	separator="^bg()^fg($selbg)|"
	# draw tags
	for i in "${tags[@]}" ; do
		case ${i:0:1} in
			'#')
				echo -n "^bg($selbg)^fg($selfg)"
				;;
			'+')
				echo -n "^bg(#aaaaaa)^fg(#141414)"
				;;
			':')
				echo -n "^bg()^fg(#ffffff)"
				;;
			'!')
				echo -n "^bg(#FF0675)^fg(#141414)"
				;;
			*)
				echo -n "^bg()^fg(#ababab)"
				;;
		esac
		if [ ! -z "$dzen2_svn" ] ; then
			# clickable tags if using SVN dzen
			echo -n "^ca(1,\"${herbstclient_command[@]:-herbstclient}\" "
			echo -n "focus_monitor \"$monitor\" && "
			echo -n "\"${herbstclient_command[@]:-herbstclient}\" "
			echo -n "use \"${i:1}\")[${i:1}]^ca()"
		else
			# non-clickable tags if using older dzen
			echo -n "${i:1}"
		fi
	done
	echo -n "$separator"
	echo -n "^bg()^fg() ${windowtitle//^/^^}"
	# small adjustments
	right="$SONG $separator^bg() $date $separator"
	right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
	# get width of right aligned text.. and add some space..
	width=$($textwidth "$font" "$right_text_only")
	echo -n "^pa($(($panel_width - $width)))$right"
	echo

	### Data handling ###
	# This part handles the events generated in the event loop, and sets
	# internal variables based on them. The event and its arguments are
	# read into the array cmd, then action is taken depending on the event
	# name.
	# "Special" events (quit_panel/togglehidepanel/reload) are also handled
	# here.

	# wait for next event
	IFS=$'\t' read -ra cmd || break
	# find out event origin
	case "${cmd[0]}" in
		tag*)
			IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
			;;
		date)
			date="${cmd[@]:1}"
			;;
		player)
			export SONG=$(mpc current | tr -d "\n")
			;;
		quit_panel)
			exit
			;;
		togglehidepanel)
			currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
			if [ "${cmd[1]}" -ne "$monitor" ] ; then
				continue
			fi
			if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
				continue
			fi
			echo "^togglehide()"
			if $visible ; then
				visible=false
				~/.config/herbstluftwm/killtray.sh
				hc pad $monitor 0
			else
				visible=true
				~/.config/herbstluftwm/tray.sh
				hc pad $monitor $panel_height
			fi
			;;
		reload)
			exit
			;;
		focus_changed|window_title_changed)
			windowtitle="${cmd[@]:2}"
			;;
		#player)
			#    ;;
		esac
	done

	### dzen2 ###
	# After the data is gathered and processed, the output of the previous block
	# gets piped to dzen2.

} | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height -ta l -bg "$bgcolor" -fg '#efefef'

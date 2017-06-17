#!/bin/bash
herbstclient spawn nm-applet
herbstclient spawn cbatticon -n
herbstclient spawn pasystray
herbstclient spawn trayer --edge top --height 16 --align right --widthtype pixel --width 140 --heighttype pixel --tint "0xFF333333" --transparent true

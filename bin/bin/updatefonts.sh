#!/bin/bash
sudo -- sh -c 'cd /usr/share/fonts/; mkfontscale; mkfontdir'
xset +fp /usr/share/fonts/

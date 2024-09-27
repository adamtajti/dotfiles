#!/usr/bin/env bash

# Make sure that your portals launch after this gets executed. For some people, they might launch before that has happened.

sleep 4
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-wlr &
sleep 4
/usr/lib/xdg-desktop-portal &


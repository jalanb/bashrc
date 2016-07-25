#! /usr/bin/osascript
tell application "System Events"
   tell current location of network preferences
       set VPNservice to service "WWTS VPN" -- name of the VPN service
       if exists VPNservice then connect VPNservice
   end tell
end tell

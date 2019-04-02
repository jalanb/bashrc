#! /bin/bash

# Add back the 192.168.111 toute that Cisco AnyConnect destroys

add_route () {
    /usr/bin/sudo /sbin/route -n add -cloning -nostatic -net 192.168.111 -interface vboxnet0
}

route_exists () {
    /usr/sbin/netstat -rn | /usr/bin/grep 192.168.111
}

main () {
    route_exists && return 0
    add_route
    route_exists 
}

main

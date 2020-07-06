#!/bin/sh
#  Description:     To ban ip on continents
#  Author:          Anton Isakov <ping115115@gmail.com>
#  Date:            21.08.2017
#  Script usage:    ban_continent.sh

# AFRINIC - Africa
# APNIC - Asia, Oceania and Australia
# ARIN - North America
# LACNIC - Central and South America
# RIPE - Europe and the Middle East

# Substitute the continents to be banned with a separator |
BAN_CONT='APNIC|AFRNIC|LACNIC'

# Get the list of Ipv4 addresses from the official site of iana.org and bring it to the canonical form
list=`curl -s  http://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv | egrep $BAN_CONT  | cut -d "," -f 1  | sed s/^00//g | sed s/^0//g | sed 's!/8!.0.0.0/8!g' `

# To ban
for ip in $list; do
	iptables -I INPUT -s $ip  -j DROP
	echo $ip
done

echo
echo "Ready for $BAN_CONT"
echo

exit

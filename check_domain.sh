#!/bin/bash
#  Description:     Check the domain dns info
#  Author:          Anton Isakov <anton@isakov54.ru>
#  Date:            01.08.2014
#  Script usage:    check_domain.sh example.com

delimiter () {
    echo "****************************************************************************************************************"
}

delimiter

echo "# whois $1"
echo
whois $1

delimiter

echo "# dig +trace $1"
echo
dig +trace $1

delimiter

# 20 times because after changing dns settings this information may vary
echo "# host -t a $1"
echo
for ((i=01;i<=20;i++))
do
    echo -n "$i) "
    host -t a $1
done

delimiter

echo "# host -t ns $1"
echo
for ((i=1;i<=20;i++))
do
    echo "$i) "
    host -t ns $1
done

delimiter

echo "# host -t mx $1"
echo
host -t mx $1 > /tmp/mx.txt
cat /tmp/mx.txt
aa=`cat /tmp/mx.txt | awk '{print $7}'`
for i in $aa
do
    host $i
done

delimiter

echo "# host -t txt $1"
echo 
host -t txt $1

delimiter

myline=$(dig -t NS +short $1)
for ns in ${myline[@]}
do
    echo "# dig @${ns} $1"
    dig @${ns} $1
    delimiter
done

delimiter

echo
echo
echo


exit 0

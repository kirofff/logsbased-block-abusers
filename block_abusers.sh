#!/bin/bash

egrep -a Failed /var/log/location/application.log|cut -d = -f3|sort |uniq -c|sed 's/^[ \t]*//;s/[ \t]*$//'|while read i; do
        count=$(echo $i|cut -d " " -f1)
        ip=$(echo $i|cut -d " " -f2)
        if [ $count -gt 3 ];then
                if [[ $(iptables -L -n|egrep -a $ip) ]]; then
                        echo "skipping $ip";
                else
                        echo "Blocking $ip for $count failed attemtps... ";
                        iptables -I INPUT -s $ip -j DROP
                fi
        fi
done

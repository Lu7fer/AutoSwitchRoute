echo start
verbose=""
rou=`route | grep default`
i=0
day_ip="0.0.0.0"
night_ip="0.0.0.0"
night=""
day=""
night_metric=""
day_metric=""
for var in $rou
do
    #Detect Gateway
    if [ `expr $i % 8` == "1" ]
    then
        `$verbose echo "find gateway $var"`
        #if wifi
        if [ "$var" == "$night_ip" ]
        then
            night=True
        fi
        #if Ethernet
        if [ "$var" == "$day_ip" ]
        then 
            day=True
        fi
        j=`expr $i + 3`
        #get metric
        k=0
        for var2 in $rou
        do
            if [ "$j" == "$k" ]
            then
                `$verbose echo "find metric $var2 of $var"`
                if [ "$night" == "True" ]
                then
                    night_metric=$var2
                    night=""
                    break
                else
                    day_metric=$var2
                    day=""
                    break
                fi
            fi
            k=`expr $k + 1`    
        done
    fi
    i=`expr $i + 1` 
done
`$verbose echo "night_metric $night_metric"`
`$verbose echo "day_metric $day_metric"`
if [ "$night_metric" == "" ]
then
    no_night="1"
    echo "no_night"
fi
if [ "$day_metric" == "" ]
then 
    no_day="1"
    echo "no day"
fi

if [ $1 == "day" ]
then
    if [ $night_metric == "" ]
    then
        `$verbose echo "no $night_ip route detect"`
    elif [ `expr $night_metric \<= 5` == "1" ]
    then
        `$verbose echo "del and add metric of $night_ip"`
        route del default netmask 0.0.0.0 gw $night_ip
        route add default netmask 0.0.0.0 gw $night_ip metric 10
    else
        `$verbose echo "$night_ip metric greater than 5"`
    fi
    if [ "$no_day" == "1" ]
    then
        `$verbose echo "add $day_ip metric 5"`
        route add default netmask 0.0.0.0 gw $day_ip metric 5
    else
        if [ `expr $day_metric \> 5` == "1" ]
        then    
            `$verbose echo "$day_ip metric greater than 5"`
            route del default netmask 0.0.0.0 gw $day_ip
            route add default netmask 0.0.0.0 gw $day_ip metric 5
        fi
        `$verbose echo "$day_ip metric less than or equalse 5 no operate"`
    fi
    
    ping www.baidu.com -c 2 > /dev/null

    if [ $? == "0" ]
    then
        `$verbose echo "Internet Connect"`
    else
        #登录命令
    fi
fi

if [ $1 == "night" ]
then
    if [ $day_metric == "" ]
    then
        `$verbose echo "no $day_ip route detect"`
    elif [ `expr $day_metric \<= 5` == "1" ]
    then
        `$verbose echo "del and add metric of $day_ip"`
        route del default netmask 0.0.0.0 gw $day_ip
        route add default netmask 0.0.0.0 gw $day_ip metric 10
    else
        `$verbose echo "$day_ip metric greater than 5"`
    fi
    if [ "$no_night" == "1" ]
    then
        `$verbose echo "add $night_ip metric 5"`
        route add default netmask 0.0.0.0 gw $night_ip metric 5
    else
        if [ `expr $night_metric \> 5` == "1" ]
        then    
            `$verbose echo "$night_ip metric greater than 5"`
            route del default netmask 0.0.0.0 gw $night_ip
            route add default netmask 0.0.0.0 gw $night_ip metric 5
        fi
        `$verbose echo "$night_ip metric less than or equalse 5 no operate"`
    fi
    
fi

`$verbose echo end `

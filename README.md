# AutoSwitchRoute
自动切换路由, 可用于OpenWrt.
用于学校断网后的自动切换网络.
 ## 使用方法:
    ./chroute.sh time
    将命令添加到crontab中,每分钟运行一次. 由于路由器连接问题, 每当连接到网络时都需要修改一下路由, 所以需要每分钟运行一次, 解决可能的新网络连接路由.

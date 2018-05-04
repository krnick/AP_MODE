#!/bin/bash
# NUKIM krnick
echo "
1. update and upgrade ,and then install hostapd,dnsmasq,isc-dhcp-server
2. 乙太網路接網路wan,由無線網卡發網路
3. wifi 接網路wan ,由乙太網卡發網路
4. 還原設定
5. 離開.

";



PS3='請輸入選項:'
options=("Option 1" "Option 2" "Option 3" "Option 4" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
          	apt-get update && apt-get upgrade -y
          	apt-get install dnsmasq hostapd -y
          	apt-get install isc-dhcp-server -y
          	;;
        "Option 2")
            echo "---------乙太網路接網路wan,由無線網卡發網路--------"
            cp mode_give_NetworkFromEth/dhcpcd.conf /etc/dhcpcd.conf
            cp mode_give_NetworkFromEth/interfaces /etc/network/interfaces
            cp mode_give_NetworkFromEth/hostapd.conf /etc/hostapd/hostapd.conf
            cp mode_give_NetworkFromEth/hostapd /etc/default/hostapd
            cp mode_give_NetworkFromEth/dnsmasq.conf /etc/dnsmasq.conf
	    cp mode_give_NetworkFromEth/sysctl.conf /etc/sysctl.conf
            sysctl -p


	    echo "firewall nat"
            sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
            sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
            sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
	    echo "firewall done"
            iptables-save
            sudo sh -c "iptables-save" > /etc/iptables.ipv4.nat
            cp mode_give_NetworkFromEth/rc.local /etc/rc.local

            /etc/init.d/dhcpcd restart
            /etc/init.d/dnsmasq restart
            /etc/init.d/hostapd restart

            echo "請確認wlan0 網路是否有IP ,dnsmasq 是否有啟動 才能有dhcp  IP"
            ;;
        "Option 3")
            echo "----wifi 接網路wan ,由乙太網卡發網路------"
            cp mode_give_NetworkFromWifi/dhcpcd.conf_settingok /etc/dhcpcd.conf
            cp mode_give_NetworkFromWifi/isc-dhcp-server_settingok /etc/default/isc-dhcp-server
            cp mode_give_NetworkFromWifi/dhcpd.conf_settingok /etc/dhcp/dhcpd.conf


	    ifconfig  eth0 192.168.4.1 netmask 255.255.255.0 broadcast 192.168.4.255

            /etc/init.d/isc-dhcp-server restart
	    cp mode_give_NetworkFromWifi/sysctl.conf /etc/sysctl.conf
            sysctl -p

            iptables -F
            iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
            iptables -A FORWARD -i wlan0 -o eth0 -m state --state ESTABLISHED,RELATED  -j ACCEPT
            iptables -t  nat  -A POSTROUTING -o wlan0 -j MASQUERADE

            iptables-save
            sudo sh -c "iptables-save" > /etc/iptables.ipv4.nat
 	    cp daemon_detect_service.exe /root
            cp mode_give_NetworkFromWifi/rc.local /etc/rc.local
	    exec /root/daemon_detect_service.exe



            ;;
	"Option 4")
	    echo "------還原設定------"
          	cp origin_file_setting/dhcpcd.conf /etc/dhcpcd.conf
          	cp origin_file_setting/interfaces /etc/network/interfaces
          	cp origin_file_setting/isc-dhcp-server /etc/default/isc-dhcp-server
          	cp origin_file_setting/rc.local /etc/rc.local
          	cp origin_file_setting/sysctl.conf /etc/sysctl.conf
          	cp origin_file_setting/hostapd /etc/default/hostapd
          	cp origin_file_setting/dnsmasq.conf /etc/dnsmasq.conf
          	cp origin_file_setting/hostapd.conf /etc/hostapd/hostapd.conf

          	iptables -F
          	iptables-save

          	/etc/init.d/dnsmasq stop
          	/etc/init.d/isc-dhcp-server stop
          	/etc/init.d/hostapd stop
          	    ;;

        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

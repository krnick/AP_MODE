
#!/bin/bash
# NUKIM krnick
echo "
1. update and upgrade ,and then install hostapd,dnsmasq,isc-dhcp-server
2. wifi 接網路wan ,由乙太網卡發網路
3. 乙太網路接網路wan,由無線網卡發網路
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
            echo "---------wifi 接網路wan ,由乙太網卡發網路--------"
            cp mode_give_NetworkFromEth/dhcpcd.conf /etc/dhcpcd.conf
            cp mode_give_NetworkFromEth/interfaces /etc/network/interfaces
            cp mode_give_NetworkFromEth/hostapd.conf /etc/hostapd/hostapd.conf
            cp mode_give_NetworkFromEth/hostapd /etc/default/hostapd
            cp mode_give_NetworkFromEth/dnsmasq.conf /etc/dnsmasq.conf
            sudo sh -c "echo 1 >/proc/sys/net/ipv4/ip_forward "

            sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
            sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT 
            sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

            iptables-save
            sudo sh -c "iptables-save" > /etc/iptables.ipv4.nat
            cp rc.local /etc/rc.local



            ;;
        "Option 3")
            echo "you chose choice 3"
            ;;
	"Option 4")
	    echo "------還原設定------"
	cp origin_file_setting/dhcpcd.conf
	cp origin_file_setting/interfaces
	cp origin_file_setting/isc-dhcp-server
	cp origin_file_setting/rc.local
	cp origin_file_setting/sysctl.conf
	cp origin_file_setting/hostapd
	cp origin_file_setting/dnsmasq.conf
	cp origin_file_setting/hostapd.conf

	iptables -F
	iptables-save

	/etc/init.d/dnsmasq stop
	/etc/init.d/isc-dhcp-server stop
	/etc/init.d/hostapd stop
	chkconfig isc-dhcp-server off
	chkconfig dnsmasq off
	chkconfig hostapd off
	    ;;

        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

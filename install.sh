#sudo apt-get update && apt-get upgrade -y
#sudo apt-get install dnsmasq hostapd -y
#sudo apt-get install isc-dhcp-server -y


#!/bin/bash
# Bash Menu Script Example
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
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice 3"
            ;;
	"Option 4")
	    echo "you chose choice 4"
	cp origin_file_setting/dhcpcd.conf
	cp origin_file_setting/interfaces 
	cp origin_file_setting/isc-dhcp-server
	cp origin_file_setting/rc.local 
	cp origin_file_setting/sysctl.conf
	    ;;

        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

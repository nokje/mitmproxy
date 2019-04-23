#vars
dt=$(date '+%d/%m/%Y %H:%M:%S');
ban=$dt' [mitm.sh]'
con=$dt' [mitm.sh] :'

#functionlist
ctrl_c() {
	echo "$con ctrl +c pressed. Quiting mitm script."
	exit 1
}
trap ctrl_c INT

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
echo "$con Checking OS type"
sleep 1
if [[ $(uname -a) != *"kali"* ]]; then
   echo "$con ERROR OS type: Not running on Kali, script is not build for this. Go run Kali!"
   exit 1
else
   echo "$con No problems found, continuing"
fi

#Functie om je internet facing interface te bepalen
inetint=$(route get 8.8.8.8 | awk '/interface/ {print $2}')

#vraag de user om de internet facing interface in te vullen.
echo -n "$con Op welke interface zit de internet verbinding?[$inetint]:"
read input
if [[ -z "$input" ]]; then
  #user input is empty
  echo "$con Using interface >$inetint< for internet facing interface"
  
else
  # If userInput is not empty show what the user typed in and run ls l
  echo "$con Using interface >$input< for internet facing interface"
  int=$input
fi

#bouw de hostapd configuratie op
echo -n "$con Vul het SSID in welke je wil hosten :"
read ssid
echo "
interface=wlan0
driver=nl80211
ssid=$ssid
channel=6
"> ./hostapd.conf
nmcli radio wifi off
rfkill unblock wlan
ifconfig wlan0 10.0.0.1/24 up
sysctl -w net.ipv4.ip_forward=1 >/dev/null
sysctl -w net.ipv4.ip_forward=1 >/dev/null
iptables -t nat -A PREROUTING -i $int -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i $int -p tcp --dport 443 -j REDIRECT --to-port 8080
hostapd ./hostapd.conf

#mitmproxy -m transparent
#dnsmasq --conf-file=dnsmasq.conf 

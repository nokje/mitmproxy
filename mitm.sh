
#vars
dt=$(date '+%d/%m/%Y %H:%M:%S');
con=$dt' [mitm.sh] :'

#Functie om je internet facing interface te bepalen
inetint=$(route get 8.8.8.8 | awk '/interface/ {print $2}')

#vraag de user om de internet facing interface in te vullen.
echo -n "$con op welke interface zit de internet verbinding?[$inetint]:"
read input
if [[ -z "$input" ]]; then
  #user input is empty
  echo "$con using interface >$inetint< for internet facing interface"
else
  # If userInput is not empty show what the user typed in and run ls l
  echo "$con using interface >$input< for internet facing interface"
  ls -l
fi

echo "$int"
exit 0

#bouw de hostapd configuratie op
echo -n "Vul het SSID in welke je wil hosten :"
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

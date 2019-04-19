#Kies internet uplink
echo -n "Op welke interface zit de internet verbinding?[wlan0/eth0]:"
read int
echo "$int"
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

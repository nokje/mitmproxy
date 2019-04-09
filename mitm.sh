apt-get install hostapd
ifconfig wlan0 10.0.0.1/24 up
ifconfig wlan0
nmcli radio wifi off
rfkill unblock wlan
ifconfig wlan0 10.0.0.1/24 up
hostapd ./hostapd.conf
sysctl -w net.ipv4.ip_forward=1 >/dev/null
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 443 -j REDIRECT --to-port 8080
#dnsmasq --conf-file=/root/dnsmasq.conf -d
#mitmproxy -m transparent

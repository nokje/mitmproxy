# Man-in-the-Middel met mitmproxy

Een scipt om vanuit een Kali linux systeem een Man-in-the-Middel proxy op te zetten op basis van WiFi. Het script is userfriendly gemaakt door feedback op het console en userinput te vragen met uitleg tijdens het runnen. Ook worden er een aantal controles uitgevoerd op basis van if/then/else waarin foutmeldingen worden weergegeven. Alle messages die uit applicaties worden gebruikt zijn verwijderd (@1>/dev/null), de error messages van de applicaties worden wel naar console geprint (@2).

LET OP! Als je gebruik wilt maken van HTTPS interceptie is het noodzakelijk dat de target-client jouw CA's SSL certificaat vertrouwd. Deze procedure heb ik handmatig uitgevoerd en gedocumenteerd in deze README.
LET OP! Bij gebruik van de mitmproxy applicatie is het noodzakelijk om deze eerst een run te geven om zijn self signed CA certificaat te genereren.

Index
Chapter 1 - Hardware
Chapter 2 - Procedure
Chapter 3 - Certificaat installeren

================================================================================================

Chapter 1 - Hardware
Deze MITM attack is gebasseerd op het gebruiken van een USB WiFi dongel waarmee je een netwerk opzet waarop de target-client zal verbinden. Daarnaast gebruik je buildin WiFi adapter om verbinding te maken met een WiFi netwerk waarover internet beschikbaar is.
De hardware die ik gebruik is:
- Cisco Linksys AE1000;
- Werkplek waarop ik Kali als VM draai;
- iPhone SE (target-client).

================================================================================================

Chapter 2 - Procedure
Hier wordt uitgelegd welke stappen je moet doorlopen om de MITM proxy in productie te nemen.

- 1 Deze git repository moet gekopieerd worden naar een locale plek. Omdat dit een private github repo is, zal je hiervoor moet authenticeren. Om de git repo te kopieren gebruik je het commando:
#git copy https://github.com/nokje/mitmproxy
- 2 Vervolgens kan je het script runnen. In het script zitten verschillende checks die hij doorloopt bij elke stap. Hij zal vragen om de interface waarachter het rogue WiFi netwerk hangt en is intiligent genoeg om jou input te controleren. Hij controleert of jouw ingegevens interface NIET de internet uplink is. Vervolgens kan je een WiFi netwerk naam opgeven en zal hij het netwerk voor je hosten.
Navigeer naar de directory waar de copy van de GitHub repo staat en run het script met:
#chmod +x mitm.sh
#./mitm.sh
- 3 Als laatste stap moet je een TRANSPARENT proxy server draaien welke lokaal op *:8080 luisterd om zowel het HTTP en HTTPS verkeer af te vangen. Dit kan met mitmporxy door het volgende commando:
#mitmproxy -m transparent

================================================================================================

Chapter 3 - Certificaat installeren
Met IOS 12.0.x is het niet meer mogelijk om via je browser certificaten te installeren. Dit kan uitsluitend met de mail app of de mappen (iCloud drive). Er zijn wel andere methoden welke te vinden zijn op openstack et cetera. In deze instructie maak ik gebruik van de iOS mail app om het certificaat te downloaden en te installeren.
- 1 Op de Kali VM ga ik vanuit de browser naar mijn outlook mail en mail het 'mitmproxy-ca-cert.cer' certificaat aan mijzelf (deze staat in ~/.mitmproxy/ folder) ;
- 2 Installeer je mail account op de native iOS mail app;
- 3 Open de e-mail met het certificaat en installeer het certificaat;
- 4 Het certificaat is geinstalleerd maar wordt nog niet vertrouwd door je toestel als CA. Hiervoor moet het certificaat vertrouwd worden. Dit doe je door: Instellingen > Algemeen > Info > Vertrouwen van certificaten > mitmproxy vertrouwen.

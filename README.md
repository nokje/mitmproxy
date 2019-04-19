# mitmproxy

Een scipt om vanuit een Kali linux systeem een Man-in-the-Middel proxy op te zetten op basis van WiFi.

Index
Chapter 1 - Hardware
Chapter 2 - Procedure
Chapter 3 - Certificate installation

Chapter 1 - Hardware
Deze MITM attack is gebasseerd op het gebruiken van een USB WiFi dongel waarmee je een netwerk opzet waarmee de client zal verbinden. Daarnaast gebruik je buildin WiFi adapter om verbinding te maken met een WiFi netwerk waarover internet beschikbaar is.
De hardware die ik gebruik is:
- Cisco Linksys AE1000;
- Macbook waarop ik Kali als VM draai.
- iPhone SE met IOS12.0.x

Chapter 2 - Procedure
Hier wordt uitgelegd welke stappen je moet doorlopen om de MITM proxy in productie te nemen.

Deze git repository moet gecloned worden naar een locale plek. Omdat dit een private github repo is, zal je hiervoor moet authenticeren. Om de git repo te clonen gebruik je het commando:
#git clone https://github.com/nokje/mitmproxy

Chapter 3 - Certiciaat installeren
Met IOS 12.0.x is het niet meer mogelijk om via je browser certificaten te installeren. Dit kan uitsluitend met de mail app of de mappen (iCloud drive). Er zijn wel andere methoden welke te vinden zijn op openstack et cetera. In deze instructie maak ik gebruik van de mail app.
1. Op de Kali VM ga ik vanuit de browser naar mijn outlook mail en mail het 'mitmproxy-ca-cert.cer' certificaat aan mijzelf (deze staat in ~/.mitmproxy);
2. Vervolgens installeer ik mijn mail aders op mijn iPhone en installeer het certificaat;
3. Het certificaat is geinstalleerd maar wordt nog niet vertrouwd door je toestel als CA. Hiervoor moet het certificaat vertrouwd worden. Dit doe je door: Instellingen > Algemeen > Info > Vertrouwen van certificaten > mitmproxy vertrouwen.

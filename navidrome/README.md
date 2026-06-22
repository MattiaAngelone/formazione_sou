# Navidrome Music Server — Lab Vagrant

Progetto Vagrant che configura, tramite un provisioner **shell**, una macchina
**Ubuntu 22.04** con Navidrome: un server di
streaming musicale self-hosted con interfaccia web.

Basta eseguire vagrant up: al termine del provisioning il server è raggiungibile
dal browser dell'host su **http://localhost:4533**, con la libreria già popolata
dai brani presenti nella cartella music/.

## Avvio

Dalla cartella del progetto:


-vagrant up


Al primo avvio Vagrant scarica la box Ubuntu ed esegue il provisioning
(installazione dipendenze, download di Navidrome, configurazione del servizio).
L'operazione richiede qualche minuto.

Quando termina, apri il browser su:

http://localhost:4533

---

## Primo accesso

Navidrome **non ha credenziali predefinite**. Al primo accesso viene mostrata
una schermata di **creazione dell'account amministratore**: scegli username e
password a piacere. Quelle diventeranno le credenziali di login.

La schermata di creazione admin compare solo la prima volta, quando il database è vuoto. Dagli accessi successivi viene chiesto il normale login.

---

## Aggiungere altra musica

I brani vanno inseriti nella cartella music/ del progetto. Vagrant la rende
disponibile dentro la VM (in /vagrant/music) e lo script di provisioning la
copia nella libreria di Navidrome.

Per caricare nuovi brani dopo il primo avvio, basta rilanciare il provisioning:


-vagrant provision

---

## Come funziona `provision.sh`

Lo script di provisioning viene eseguito automaticamente da Vagrant (come utente
`root`) al primo `vagrant up`. È organizzato in quattro fasi:

1. **Installazione delle dipendenze** — aggiorna l'elenco dei pacchetti e
   installa `ffmpeg` (l'unica dipendenza di Navidrome) e `curl` (usato per il
   download). La variabile `DEBIAN_FRONTEND=noninteractive` evita che `apt` si
   blocchi chiedendo conferme durante il provisioning automatico.

2. **Download del binario** — crea le cartelle di lavoro
   (`/opt/navidrome` per l'eseguibile, `/var/lib/navidrome/music` per la
   libreria), recupera l'ultima release di Navidrome da GitHub, la scarica
   in `/tmp` ed estrae il solo binario in `/opt/navidrome`.

3. **Copia della musica** — copia i brani dalla cartella condivisa
   `/vagrant/music/` (cioè la cartella `music/` del progetto) alla libreria di
   Navidrome. Se la cartella è vuota, lo script prosegue comunque: il server
   parte solo senza brani.

4. **Configurazione del servizio** — genera l'unit file
   `navidrome.service` e lo registra in **systemd**, impostando l'avvio
   automatico al boot e il riavvio in caso di crash. Il servizio viene poi
   avviato subito con `systemctl enable --now`.

Le impostazioni di Navidrome (cartella musica e indirizzo di ascolto) sono
passate tramite **variabili d'ambiente** `ND_*` direttamente nell'unit file,
senza bisogno di un file di configurazione separato.


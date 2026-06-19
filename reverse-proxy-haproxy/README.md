# Lab Reverse Proxy con Vagrant, HAProxy e SSL


In questo lab il reverse proxy fa due cose:

1. Terminazione TLS: riceve traffico cifrato in HTTPS, lo decifra e lo
   inoltra ai backend in HTTP semplice. Fuori cifrato, dentro in chiaro.
2. Bilanciamento e routing: distribuisce o smista le richieste fra i due
   backend secondo regole precise.

---

## Architettura

| VM        | IP              | Ruolo                          |
|-----------|-----------------|--------------------------------|
| proxy     | 192.168.56.10   | Reverse proxy HAProxy + SSL    |
| backend1  | 192.168.56.11   | Web server nginx (Sito UNO)    |
| backend2  | 192.168.56.12   | Web server nginx (Sito DUE)    |

```
                  HTTPS (443)            HTTP (80)
   browser  ────────────────►  PROXY  ──────────►  backend1
                            (HAProxy +  ──────────►  backend2
                          cert OpenSSL)
                          192.168.56.10
```

Le tre VM stanno su una rete privata (192.168.56.x) creata da Vagrant.
Questa rete è ricostruita identica su qualsiasi computer esegua vagrant up,
quindi gli IP funzionano ovunque, non solo sulla macchina originale.

---

## Come funziona lo smistamento

Il proxy decide dove mandare ogni richiesta in base all'URL:

| Richiesta                          | Destinazione                         |
|------------------------------------|--------------------------------------|
| https://192.168.56.10              | Bilanciamento casuale fra i due backend |
| https://192.168.56.10/backend1     | Sempre backend1 (Sito UNO)           |
| https://192.168.56.10/backend2     | Sempre backend2 (Sito DUE)           |
| http://...` (porta 80)            | Redirect automatico verso HTTPS      |

---

## Avvio

Dalla cartella del progetto:

-vagrant up

Vagrant crea le tre VM, copia i file necessari dentro ciascuna ed esegue gli
script di provisioning che installano e configurano tutto automaticamente.

---

## Accesso ai siti

https://192.168.56.10
https://192.168.56.10/backend1
https://192.168.56.10/backend2

---

## Spiegazione dei file

provisioning_proxy

─ Vagrantfile: definizione delle VM e del provisioning

─ provision_proxy.sh: configurazione del reverse proxy

─ provision_backend.sh: configurazione dei due web server

─ haproxy.cfg: configurazione di HAProxy

─ sito1.html: pagina servita da backend1

─ sito2.html: pagina servita da backend2

### Vagrantfile

È il file principale: descrive le tre VM e come configurarle. Per ogni
macchina definisce:

- box: l'immagine di partenza;
- hostname: il nome interno della macchina;
- private_network con ip: l'indirizzo sulla rete privata condivisa;
- i provisioner, cioè le azioni da eseguire dopo la creazione.

Ogni VM usa due provisioner in sequenza:

1. file — copia un file dal computer host a /tmp dentro la VM.
   Esempio: source: "haproxy.cfg", destination: "/tmp/haproxy.cfg".

2. shell — esegue lo script di provisioning corrispondente.

I backend ricevono in più un argomento (args: "sito1" / "sito2"):
per usare un unico script (provision_backend.sh) su entrambe le
macchine, dicendogli di volta in volta quale pagina installare.

### provision_backend.sh

Configura un web server nginx. Passi:

1. dnf install -y nginx — installa nginx.
2. Copia la pagina in /usr/share/nginx/html/index.html
3. Crea le sottocartelle backend1 e backend2 e vi copia la stessa pagina:
   servono al routing per percorso (/backend1, /backend2).
4. restorecon -Rv — ripristina le etichette SELinux sui file copiati.
   Senza questo passaggio nginx non può leggerli e risponde 403 fporbidden.
5. Apre la porta HTTP (80) sul firewall e ricarica le regole.
6. systemctl enable --now nginx — avvia nginx subito e lo abilita al boot.

L'argomento $1 (il nome del sito) viene salvato nella variabile PAGINA e
usato per costruire il nome del file da copiare (/tmp/$PAGINA.html).

### provision_proxy.sh

Configura il reverse proxy. Passi:

1. dnf install -y haproxy — installa haproxy.
2. dnf update -y openssl openssl-libs openssh openssh-server — aggiorna
   OpenSSL e OpenSSH insieme: se OpenSSL viene
   aggiornato da solo, il demone SSH resta legato alla versione vecchia e al
   riavvio smette di funzionare ("version mismatch"). Aggiornandoli insieme
   il problema non si presenta.
3. Genera il certificato autofirmato con openssl req -x509:
      -x509: produce un certificato già firmato;
      -nodes: non protegge la chiave con password;
      -days 365: valido un anno;
      -newkey rsa:2048`: genera al volo una chiave RSA da 2048 bit;
4. Unisce certificato e chiave in un unico file .pem con cat:
   HAProxy, a differenza di nginx, vuole i due elementi in un solo file.
   chmod 600 ne restringe i permessi (contiene la chiave privata).
5. Copia haproxy.cfg (da /tmp) nella posizione di sistema.
6. setsebool -P haproxy_connect_any 1 — abilita il booleano SELinux che
   permette ad HAProxy di aprire connessioni verso i backend. Senza, ogni
   richiesta fallirebbe con un errore 502.
7. Apre le porte HTTP e HTTPS sul firewall.
8. haproxy -c -f — verifica la sintassi della config prima di avviare.
9. Riavvia sshd (per ripartire pulito sulle librerie aggiornate) e avvia HAProxy.

### haproxy.cfg

La configurazione di HAProxy, divisa in sezioni:

- global / defaults: impostazioni generali e valori predefiniti. I tre
  timeout sono obbligatori: senza, HAProxy si rifiuta di partire.
- frontend http_in: ascolta sulla porta 80 e con redirect scheme https
  rimanda ogni richiesta in chiaro verso HTTPS (codice 301).
- frontend https_in: ascolta sulla porta 443, presenta il certificato
  (ssl crt) e termina l'SSL. Le righe use_backend ... if { path_beg ... }
  smistano i percorsi /backend1 e /backend2 ai rispettivi backend; tutto
  il resto va al default_backend.
- backend_sito1 / backend_sito2: un solo server ciascuno, per il routing
  per percorso.
- backend_pool: contiene entrambi i server con balance roundrobin, cioè
  il bilanciamento usato per la radice (alterna fra i due backend).

La direttiva check su ogni server attiva il controllo di salute: se un
backend smette di rispondere, HAProxy lo esclude automaticamente.

### sito1.html / sito2.html

Le due pagine web statiche servite dai backend, distinte per colore e testo
così da riconoscere a colpo d'occhio quale backend ha risposto durante il
bilanciamento.

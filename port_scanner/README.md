# Portscanner

Port scanner TCP scritto in Bash. Verifica quali porte sono in ascolto su un
host target in un range di porte e tentando una connessione con `nc`
(NetCat) una porta alla volta.

Lo scopo dell'esercizio è implementare a mano la logica di scansione tramite
un ciclo, senza usare la modalità di scan integrata di NetCat (l'opzione
`-z`).

## Utilizzo

```bash
./portscanner.sh <indirizzo_target> <porta_iniziale> <porta_finale>
```

### Esempio

```bash
./portscanner.sh 192.168.50.10 20 30
```

Output tipico (se sull'host è attivo SSH):

```
porta 22 APERTA
```

## Funzionamento

- Gli argomenti vengono passati allo script nelle variabili `$1, $2, $3`.
- Controlla che gli argomenti siano esattamente 3.
- Controlla che start ed end siano numerici.
- Controlla che rientrino nel range TCP valido 1-65535 e che la porta iniziale non superi quella finale.
- controllo di raggiungibilità `con ping -c 1`: se l'host non risponde
viene stampato un avviso, ma lo script prosegue comunque.
- Ciclo for:
Per ogni porta lancia
`nc -w 1 "$target" "$port" < /dev/null 2>/dev/null`: `-w 1` impone un timeout di
1 secondo, `< /dev/null` chiude subito la connessione invece di restare
interattivo, `2>/dev/null` silenzia i messaggi di errore sulle porte chiuse.
L'if valuta l'exit code di `nc: 0` se la connessione riesce (porta aperta),
diverso da 0 se fallisce. Vengono stampate solo le porte aperte.


## Differenza tra scansione TCP e UDP

Questo script scansiona porte **TCP**. La scansione UDP è un problema diverso, e
la differenza nasce dalla natura dei due protocolli.

### TCP — orientato alla connessione

TCP stabilisce una connessione con il **three-way handshake**
(SYN -> SYN/ACK -> ACK). Questo rende lo scan affidabile, perché ogni tentativo
produce una risposta che ne indica chiaramente l'esito:

**Handshake completato** --> **Porta aperta** — un servizio è in ascolto e accetta la connessione.

**Pacchetto RST** (connection refused) --> **Porta chiusa** — nessun servizio in ascolto.

**Nessuna risposta** (timeout) --> **Porta filtrata** — tipicamente un firewall che ignora il pacchetto.


### UDP — senza connessione

UDP è *connectionless*: si invia un pacchetto senza nessuna stretta di mano e
senza conferma di ricezione. Questo ribalta la logica della scansione:


**Nessuna risposta** --> **Aperta o filtrata** (`open\|filtered`) — molti servizi UDP rispondono solo a pacchetti con un contenuto che riconoscono, quindi restano in silenzio.

**ICMP port unreachable** --> **Porta chiusa** — il sistema operativo segnala che nessuno è in ascolto.

Il problema fondamentale: **porta aperta e porta filtrata danno lo stesso
risultato** (silenzio), quindi non sono distinguibili con certezza.

Inoltre, con `nc -u` l'**exit code non è affidabile** come in TCP: non esistendo
una connessione da confermare, nc esce spesso con `0` semplicemente perché è
riuscito a spedire il pacchetto, non perché qualcuno abbia risposto. Di
conseguenza la stessa logica segnalerebbe quasi
tutte le porte come aperte. Una scansione UDP fatta a mano in Bash con nc è
quindi poco affidabile.
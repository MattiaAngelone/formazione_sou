# Classificatore di indirizzi IPv4

Script Bash che, dato un indirizzo IPv4 in *decimal dotted notation*, ne verifica la validità tramite espressioni regolari estese (ERE) e ne determina le proprietà.

## Utilizzo

Passando l'indirizzo come argomento:

```bash
./regex.sh 8.8.8.8
```

Oppure in modalità interattiva: lanciando lo script senza argomenti, verrà richiesto di inserire l'indirizzo.

```bash
./regex.sh
```

Ricordarsi di rendere lo script eseguibile la prima volta:

```bash
chmod +x regex.sh
```

## Esempi di output

```
8.8.8.8        -> è un indirizzo PUBBLICO di Classe A
192.168.1.10   -> è un indirizzo PRIVATO di Classe C
127.0.0.1      -> è un indirizzo di LOOPBACK
255.255.255.255-> è un indirizzo di BROADCAST
300.1.1.1      -> non è un indirizzo ip valido
```

## Come funziona la validazione

La regex valida un singolo ottetto. Non è sufficiente accettare "da una a tre cifre" (`[0-9]{1,3}`), perché una regex ragiona sul *numero di caratteri*, non sul *valore numerico*: in questo modo verrebbero accettati anche valori come `300` o `999`, che hanno tre cifre ma non sono ottetti validi.

Ad esempio per descrivere l'intervallo bisogna spezzarlo in questo modo:
```
25[0-5]          # 250-255
2[0-4][0-9]      # 200-249
1[0-9][0-9]      # 100-199
[0-9]?[0-9]      # 0-99 (prima cifra opzionale)
```

L'indirizzo completo è dato da quattro di questi gruppi separati da punti letterali (`\.`), il tutto racchiuso tra le ancore `^` e `$` per garantire che la riga contenga esattamente un indirizzo, senza testo prima o dopo.

## Classificazione

La classe viene determinata in base al valore del primo ottetto:

| Classe | Primo ottetto |
|--------|---------------|
| A      | 1 – 126       |
| B      | 128 – 191     |
| C      | 192 – 223     |
| D      | 224 – 239     |
| E      | 240 – 255     |


#! /bin/bash
# progress-bar2.sh
# Author: Graham Ewart (with reformatting by ABS Guide author).
# Used in ABS Guide with permission (thanks!).

# Invoke this script with bash. It doesn't work with sh.

interval=1									#Impostiamo intervallo di un secondo tra un punto e l'altro.
long_interval=10								#Impostiamo intervallo di 10 secondi tra un punto e l'altro.

{
     trap "exit" SIGUSR1							#Se il programma riceve il comando "SIGUSR1" esce immediatamente.
     sleep $interval; sleep $interval						#Attende due volte "interval" ovvero 2 secondi.
     while true									
     do
       echo -n '.'     # Use dots.						#Stampa un punto senza andare a capo.
       sleep $interval								#Attende un secondo e poi ripete il ciclo all'infinito.
     done; } &         # Start a progress bar as a background process.

pid=$!										#Salva il PID dell'ultimo processo lanciato .
trap "echo !; kill -USR1 $pid; wait $pid"  EXIT        # To handle ^C.		#Se lo script termina viene stampato "!", viene inviato SIGUSR1 per 
										#farlo uscire e aspetta che il processo figlio sia terminato completamente
echo -n 'Long-running process '							#Stampa "Long-running process".
sleep $long_interval								#Attende 10 secondi
echo ' Finished!'								#Stampa messaggio di completamento.

kill -USR1 $pid									#Invia segnale di stop al processo che stampa i puntini.
wait $pid              # Stop the progress bar.					#Attende la sua terminazione.
trap EXIT									#Rimuove trap associat ad EXIT (non verrà più usato).

exit $?										#Esce dallo script restituendo il codice d'uscita dell'ultimo comando eseguito

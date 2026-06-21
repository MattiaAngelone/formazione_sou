#!/bin/bash
# am-i-root.sh:   Am I root or not?	
ROOT_UID=0   # Root has $UID 0. 						#Definiamo una variabile contenente l'UID di Root (in Linux è sempre 0).
										#Utilizziamo un ciclo if per dire che:
if [ "$UID" -eq "$ROOT_UID" ]  # Will the real "root" please stand up?		#Se la condizione è vera, quindi l'UID dell'utente corrente equivale a zero, 
then										#Allora,
  echo "You are root."								#Stampa che sei l'utente Root,
else										#Altrimenti, se la condizione è falsa,
  echo "You are just an ordinary user (but mom loves you just the same)."	#Stampa che sei un altro utente.
fi

exit 0										#Termina lo script restituendo codice di ritorno 0 (successo).

# ============================================================= #
# Code below will not execute, because the script already exited.

# An alternate method of getting to the root of matters:

ROOTUSER_NAME=root								#Definiamo la variabile per indicare che l'username di Root equivale a "root"
										
username=`id -nu`              # Or...   username=`whoami`			#Definiamo la variabile che indica il nome dell'utente corrente.
if [ "$username" = "$ROOTUSER_NAME" ]						#Se la condizione è vera, quindi l'username utente corrisponde all'username
then										#di root, allora
  echo "Rooty, toot, toot. You are root."					#Stampa che sei l'utente root.
else										#Altrimenti, se la condizione è falsa,
  echo "You are just a regular fella."						#Stampa che sei un altro utente.
fi

#!/bin/bash4
# fetch_address.sh

declare -A address							#Dichiara un array associativo (di stringhe con l'opzione -A) chiamato "address".
#       -A option declares associative array.

address[Charles]="414 W. 10th Ave., Baltimore, MD 21236"		#Aggiunge un elemento con chiave "Charles" e indirizzo come valore.
address[John]="202 E. 3rd St., New York, NY 10009"			#Aggiunge un elemento con chiave "John" e indirizzo come valore.
address[Wilma]="1854 Vermont Ave, Los Angeles, CA 90023"		#Aggiunge un elemento con chiave "Wilma" e indirizzo come valore.


echo "Charles's address is ${address[Charles]}."			#Stampa il valore associato alla chiave "Charles".
# Charles's address is 414 W. 10th Ave., Baltimore, MD 21236.		
echo "Wilma's address is ${address[Wilma]}."				#Stampa il valore associato alla chiave "Wilma".
# Wilma's address is 1854 Vermont Ave, Los Angeles, CA 90023.
echo "John's address is ${address[John]}."				#Stampa il valore associato alla chiave "John".
# John's address is 202 E. 3rd St., New York, NY 10009.

echo

echo "${!address[*]}"   # The array indices ...				°Stampa tutte le chiavi presenti con "*".
# Charles John Wilma

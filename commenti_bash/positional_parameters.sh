#!/bin/bash

# Call this script with at least 10 parameters, for example
# ./scriptname 1 2 3 4 5 6 7 8 9 10
MINPARAMS=10							#Variabile che contiene il numero minimo dei parametri.

echo

echo "The name of this script is \"$0\"."			#Stampa il nome del file di script.
# Adds ./ for current directory					
echo "The name of this script is \"`basename $0`\"."		#Stampa il nome del file di script eliminando il percorso "./" grazie a basename.
# Strips out path name info (see 'basename')

echo

if [ -n "$1" ]              # Tested variable is quoted.	#Se viene passato il primo parametro.
then
 echo "Parameter #1 is $1"  # Need quotes to escape #		#Stampa il valore del primo parametro.
fi 
                                  				
if [ -n "$2" ]							#Se viene passato il secondo paramentro. 
then
 echo "Parameter #2 is $2"					#Stampa il valore del scondo parametro.
fi 

if [ -n "$3" ]							#Se viene passato il terzo paramentro	
then
 echo "Parameter #3 is $3"					#Stampa il valore del terzo parametro.
fi 

# ...


if [ -n "${10}" ]  # Parameters > $9 must be enclosed in {brackets}.		#Se viene passato il decimo paramentro.
then
 echo "Parameter #10 is ${10}"							#Stampa il valore del decimo parametro.
fi 

echo "-----------------------------------"
echo "All the command-line parameters are: "$*""				#Stampa i valori di tutti i parametri passati allo script.

if [ $# -lt "$MINPARAMS" ]							#Se il numero totale dei parametri è inferiore a 10,
then										#Allora
  echo
  echo "This script needs at least $MINPARAMS command-line arguments!"		#Stampa che lo script ha bisogno di almeno 1o parametri.
fi  

echo

exit 0										#Termina script con codice di ritorno di successo.


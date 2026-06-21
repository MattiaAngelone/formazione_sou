#!/bin/bash
# Naked variables

echo

# When is a variable "naked", i.e., lacking the '$' in front?
# When it is being assigned, rather than referenced.

# Assignment
a=879								#Assegniamo un valore alla variabile "a".
echo "The value of \"a\" is $a."				#Stampa il valore della variabile "a".

# Assignment using 'let'
let a=16+5							#assegniamo con let un valore che viene calcolato da una somma aritmetica.
echo "The value of \"a\" is now $a."				#Stampa il nuovo valore di "a" (21).

echo

# In a 'for' loop (really, a type of disguised assignment):
echo -n "Values of \"a\" in the loop are: "			#Stampa senza andare a capo che i valori di "a" nel loop sono:
for a in 7 8 9 11						#Viene assegnato ad "a" un valore diverso per ogni iterazione. 
do
  echo -n "$a "							#Stampa valore corrente di "a".
done								

echo
echo

# In a 'read' statement (also a type of assignment):
echo -n "Enter \"a\" "						#Viene chiesto di inserire un valore all'utente.
read a								#Viene letto il valore.
echo "The value of \"a\" is now $a."				#Viene stampato il nuovo valore di "a".

echo

exit 0 								#Lo script termina restituendo codice di ritorno di successo.

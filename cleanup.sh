# Cleanup
# Run as root, of course.

cd /var/log  			#Entriamo nella direcotory /var/log
cat /dev/null > messages	#Reinderizziamo outuput nullo di /dev/null dentro il file messages per svuotarlo
cat /dev/null > wtmp		#Facciamo la stessa cosa per il file wtmp	
echo "Log files cleaned up." 	#Stampa che i nostri file sono stati puliti!

#!/usr/bin/env bash


cleanup() {
  echo
  echo "Interruzione... Spengo il container..."
  vagrant ssh node1 -c "docker rm -f echo >/dev/null 2>&1 || true"
  vagrant ssh node2 -c "docker rm -f echo >/dev/null 2>&1 || true"
  exit 0
}
trap cleanup INT

while true; do

  read -p "Vuoi avviare il ping pong? (s/n)" risposta 
  case "$risposta" in 
    s|S) break ;;
    n|N) echo "Ok, non avvio"; exit 0 ;;
    *) echo "inserisci 's' oppure 'S'" ;;
  esac
done

round=1
while true; do
  echo "<round ${round}>"
  echo "========== PING =========="
  vagrant ssh node1 -c "docker rm -f echo >/dev/null 2>&1 || true; docker run -d --rm --name echo -p 8080:80 ealen/echo-server >/dev/null"
  sleep 60
  echo "<<<<<<<< PING OFF >>>>>>>>"
  vagrant ssh node1 -c "docker stop echo >/dev/null"

  echo "========== PONG =========="
  vagrant ssh node2 -c "docker rm -f echo >/dev/null 2>&1 || true; docker run -d --rm --name echo -p 8080:80 ealen/echo-server >/dev/null"
  sleep 60
  echo "<<<<<<<< PONG OFF >>>>>>>>"
  vagrant ssh node2 -c "docker stop echo >/dev/null"

  round=$((round + 1))

done
      

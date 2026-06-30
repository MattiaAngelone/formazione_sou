#!/usr/bin/env bash

target="$1"
start="$2"
end="$3"

if [ "$#" -ne 3 ]; then
  echo "uso: $0 <indirizzo_target> <porta_iniziale> <porta_finale>"
  exit 1
fi
if ! [[ "$start" =~ ^[0-9]+$ ]]; then
  echo "La porta iniziale deve essere un numero!"
  exit 1
fi
if ! [[ "$end" =~ ^[0-9]+$ ]]; then
  echo "La porta finale deve essere un numero!"
  exit 1
fi

if [ "$start" -lt 1 ] || [ "$end" -gt 65535 ]; then
  echo "Le porte devono essere tra 1 e 65535!"
  exit 1
fi
if [ "$start" -gt "$end" ]; then
  echo "La porta iniziale non può superare la finale!"
  exit 1
fi

if ! ping -c 1 "$target" > /dev/null 2>&1; then
  echo "L'host $target non risponde al ping"
fi

for (( port="$start"; port<="$end"; port++ )); do
 if nc -w 1 "$target" "$port" < /dev/null 2>/dev/null; then
  echo "porta $port APERTA"
fi
done

#!/bin/bash

IP="$1"

if [ $# -ne 1 ]; then
  echo "=================================="
  echo "   CLASSIFICATORE INDIRIZZI IPv4"
  echo "=================================="
  read -p "Inserisci un indirizzo IP: " IP
fi

REGEX_VALIDA='^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$'

if echo "$IP" | egrep -q "$REGEX_VALIDA"; then

  if echo "$IP" | egrep -q '^10\.|^192\.168\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.'; then
    TIPO="PRIVATO"
  else
    TIPO="PUBBLICO"
  fi

  if echo "$IP" | egrep -q '^255\.255\.255\.255$'; then
    CLASSE="BROADCAST"
  elif echo "$IP" | egrep -q '^127\.'; then
    CLASSE="LOOPBACK"
  elif echo "$IP" | egrep -q '^(12[0-6]|1[01][0-9]|[0-9]?[0-9])\.'; then
    CLASSE="CLASSE A"
  elif echo "$IP" | egrep -q '^(19[0-1]|1[3-8][0-9]|12[8-9])\.'; then
    CLASSE="CLASSE B"
  elif echo "$IP" | egrep -q '^(22[0-3]|2[01][0-9]|19[2-9])\.'; then
    CLASSE="CLASSE C"
  elif echo "$IP" | egrep -q '^(23[0-9]|22[4-9])\.'; then
    CLASSE="CLASSE D"
  else 
    echo "$IP è un indirizzo di CLASSE E o non classifiato"
  fi
  echo "$IP è un idirizzo $TIPO di $CLASSE"
else 
  echo "$IP non è un indirizzo ip VALIDO"
fi
 

#!/usr/bin/env bash

while true; do
  curl -s --max-time 2 http://192.168.56.11:8080 >/dev/null && echo "node 1: ATTIVO" || echo "node1: SPENTO"
  curl -s --max-time 2 http://192.168.56.12:8080 >/dev/null && echo "node 2: ATTIVO" || echo "node2: SPENTO"
  echo "---"
  sleep 5
done

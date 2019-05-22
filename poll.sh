#!/bin/bash 

set -eu 

IP_ADDRESS=$(knctl route list -n next-paris --column Domain| grep greeter)

while true
do
  http $IP_ADDRESS
  sleep 1
done;

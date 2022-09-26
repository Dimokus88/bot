#!/bin/bash
binary=$1
SNAP_RPC=`cat /root/bot/RPC.txt`
addr=`cat /root/bot/tmp/explorer.txt`
result=/root/bot/tmp/explorer.txt
$binary query bank balances $addr --node "$SNAP_RPC" -o json > /root/bot/tmp/balance.json
$binary query staking delegations $addr --node "$SNAP_RPC" -o json > /root/bot/tmp/delegate.json
echo Balances: > $result
echo  >> $result
echo Address: $addr >> $result
count=0
b=`cat /root/bot/tmp/balance.json | jq -r .balances[$count].amount`
while [[ "$b" -ne "null" ]]
do
bal=`cat /root/bot/tmp/balance.json | jq -r .balances[$count].amount`
den=`cat /root/bot/tmp/balance.json | jq -r .balances[$count].denom`
echo Spendable Balance: $bal $den >> $result
let count=$count+1
b=`cat /root/bot/tmp/balance.json | jq -r .balances[$count].amount`
done

count=0
a=`cat /root/bot/tmp/delegate.json | jq  -r .delegation_responses[$count].balance.amount`
amount=$a
while [[ "$a" -ne "null" ]]
do 
   let count="$count"+1
   a=`cat /root/bot/tmp/delegate.json | jq  -r .delegation_responses[$count].balance.amount`
   amount=$(echo "$a+$amount" | bc)
   
done
echo Delegated: $amount $den >> $result

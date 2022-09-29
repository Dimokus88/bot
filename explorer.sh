#!/bin/bash
explorer=/root/bot/tmp/explorer.txt
prefix=`curl -s localhost:26657/genesis | grep validator_address -m 1 | sed s/'\s'//g | sed 's/"validator_address":"//;s/",//' | sed "s/\(valoper\).*//g"`
bin=`echo $binary | sed "s/d//"`
symbol=`cat  $explorer`
symbol=`echo ${#symbol}`

if grep valoper $explorer
then
/root/bot/valoper.sh $binary
exit
fi

if grep $prefix $explorer
then
/root/bot/address.sh $binary
exit
fi

if [[ "$symbol" -eq 64 ]]
then
/root/bot/txs.sh $binary
exit
fi

if [[ "$symbol" -lt 39 ]] 
then
echo NOT FOUND > /root/bot/tmp/explorer.txt
exit
fi

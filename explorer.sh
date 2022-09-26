#!/bin/bash
explorer=/root/bot/tmp/explorer.txt
bin=`echo $binary | sed "s/d//"`
symbol=`cat  $explorer`
symbol=`echo ${#symbol}`

if grep valoper $explorer
then
/root/bot/valoper.sh $binary
exit
fi

if grep $bin $explorer
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

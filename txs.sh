#!/bin/bash
binary=$1
SNAP_RPC=`cat /root/bot/RPC.txt`
echo "$SNAP_RPC"
txs=`cat /root/bot/tmp/explorer.txt`
JSON="/root/bot/tmp/txs.json"
text="/root/bot/tmp/explorer.txt"
$binary query tx $txs --node "$SNAP_RPC" -o json | jq -r > $JSON

if  grep MsgCreateValidator $JSON
then
t=`cat $JSON | jq -r .code`
   if [[ "$t" == 0 ]]
   then
   echo Transaction: > $text
   echo  >> $text
   echo Status: Sucsess >> $text
   echo Type:   Create validator  >> $text 
   echo Moniker: `cat $JSON | grep moniker | uniq | sed 's/            //;s/"moniker": "//;s/",//'` >> $text
   echo Valoper: `cat $JSON | jq -r .raw_log | sed -e "s/^.//;s/.$//" | jq -r .events[2].attributes[0].value` >> $text  
   echo Details: `cat $JSON | grep details | uniq | sed 's/            //;s/"details": "//;s/"//'` >> $text
   echo Website: `cat $JSON | grep website | uniq | sed 's/            //;s/"website": "//;s/",//'` >> $text
   echo Time:    `cat $JSON | grep -m2 "time" | uniq | awk '{print$2}' | sed '2!D;s/"//;s/",//'` >> $text
   else
   echo Transaction: > $text
   echo  >> $text
   echo Status: Fail >> $text
   echo Type:   Create validator  >> $text
   echo Error: `cat $JSON | jq -r .raw_log` >> $text
   fi
elif grep MsgSend $JSON
then
echo Transaction: > $text
echo  >> $text
echo Type:    `cat $JSON | jq -r .raw_log | sed -e "s/^.//;s/.$//" | jq -r .events[3].type | sed "s/t/T/"` >> $text 
echo From: `cat $JSON | jq -r .raw_log | sed -e "s/^.//;s/.$//" | jq -r .events[2].attributes[1].value` >> $text
echo To: `cat $JSON | jq -r .raw_log | sed -e "s/^.//;s/.$//" | jq -r .events[0].attributes[0].value` >> $text  
echo Amount: `cat $JSON | jq -r .raw_log | sed -e "s/^.//;s/.$//" | jq -r .events[0].attributes[1].value` >> $text
echo Memo: `cat $JSON | grep memo | uniq | sed 's/            //;s/"memo": "//;s/",//'` >> $text
echo Height: `cat $JSON | grep -m1 height | awk '{print$2}'|sed 's/"//;s/",//'`>> $text
echo Time:    `cat $JSON | grep -m2 "time" | uniq | awk '{print$2}' | sed '2!D;s/"//;s/",//'` >> $text

elif grep MsgVote $JSON
then
echo Transaction: > $text
echo  >> $text
echo Type:    `cat $JSON | jq -r .logs[0].events[1].type | sed "s/p/P/;s/_/ /"` >> $text 
echo Proposal ID:  `cat $JSON | jq -r .logs[0].events[1].attributes[1].value | sed "s/p/P/;s/_/ /"` >> $text 
echo  >> $text
echo Proposal text: >> $text
echo `$binary query gov proposal 2 -o json | jq -r .content.description` >> $text
echo  >> $text
echo Vote:  `cat $JSON | jq  .tx.body.messages[0].option | sed "s/VOTE_OPTION_//"` >> $text 


elif grep MsgUnjail $JSON
then
echo Transaction: > $text
echo  >> $text
echo Type: Unjail >> $text
echo  >> $text
if grep failed $JSON
then
 echo Status: Error >> $text
 echo  >> $text
 echo Message: `cat $JSON | jq .raw_log`
else
 echo Status: Sucsessfull >> $text
 echo  >> $text
 echo Message: `cat $JSON | jq .raw_log`

fi
else
echo RAW_LOG: > $text
echo `cat $JSON | jq .raw_log` >> $text
fi

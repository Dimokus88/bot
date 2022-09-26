#!/bin/bash
binary=$1
RPC=`cat /root/bot/RPC.txt`
text=/root/bot/cheker/message1.txt
echo Avaliable proposals: > $text
count=0
id=`cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id`

while [[ "$id" -ne null  ]]
do
echo  >> $text
echo Proposal id: `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id` >> $text
echo Description: >> $text
echo `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].content.description` >> $text
echo  >> $text
echo Voting start: `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].voting_start_time` >> $text
echo Voting end: `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].voting_end_time` >> $text
echo ------ >> $text
echo  >> $text
let count=$count+1
id=`cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id`
done

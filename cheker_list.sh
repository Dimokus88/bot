#!/bin/bash
binary=$1
RPC=`cat /root/bot/RPC.txt`
echo Avaliable proposals: > /root/bot/cheker/message.txt
count=0
id=`cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id`

while [[ "$id" -ne null  ]]
do
echo  >> /root/bot/cheker/message.txt
echo Proposal id: `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id` >> /root/bot/cheker/message.txt
echo Description: >> /root/bot/cheker/message.txt
echo `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].content.description` >> /root/bot/cheker/message.txt
echo  >> /root/bot/cheker/message.txt
echo Voting start: `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].voting_start_time` >> /root/bot/cheker/message.txt
echo Voting end: `cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].voting_end_time` >> /root/bot/cheker/message.txt
echo ------ >> /root/bot/cheker/message.txt
echo  >> /root/bot/cheker/message.txt
let count=$count+1
id=`cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id`
done

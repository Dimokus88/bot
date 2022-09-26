#!/bin/bash
binary=$1
$binary q gov proposals --status VotingPeriod --node $RPC -o json  > /root/bot/tmp/proposal.json
md5=`md5sum /root/bot/tmp/proposal.json`
TOKEN=$2
CHAT_ID=`cat /root/bot/CHAT_ID.txt`
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
TTL="10"
PARSER="HTML"
for ((;;))
do
if [[ `md5sum /root/bot/tmp/proposal.json` == "$md5" ]]
then
sleep 15m
$binary q gov proposals --status VotingPeriod --node $RPC -o json  > /root/bot/tmp/proposal.json
else
echo Actual proposals: > /root/bot/cheker/message.txt
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
echo ------  >> /root/bot/cheker/message.txt
echo  >> /root/bot/cheker/message.txt

let count=$count+1
id=`cat /root/bot/tmp/proposal.json | jq -r .proposals[$count].proposal_id`
done
MESSAGE=`cat /root/bot/cheker/message.txt`
curl -s --max-time $TTL -d "chat_id=$CHAT_ID&parse_mode=$PARSER&disable_web_page_preview=1&text=$MESSAGE" $URL
$binary q gov proposals --status VotingPeriod -o json  > /root/bot/tmp/proposal.json
md5=`md5sum /root/bot/tmp/proposal.json
fi
 
done

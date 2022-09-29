#!/bin/bash
binary=$1
valoper=`cat /root/bot/tmp/explorer.txt`
text=/root/bot/tmp/explorer.txt
SNAP_RPC=`cat /root/bot/RPC.txt`
$binary query staking validator $valoper -o json > /root/bot/tmp/valoper.json
echo Validator information: > $text
echo >> $text
echo Moniker: `cat /root/bot/tmp/valoper.json | jq -r .description.moniker` >> $text
if grep BOND_STATUS_BONDED /root/bot/tmp/valoper.json
then
status="Active"
else
status="InActive"
fi
echo Status: $status >> $text
echo >> $text
echo Operator: `cat /root/bot/tmp/valoper.json | jq -r .operator_address` >> $text
echo Tx crearing validator: >> $text
echo $valoper
echo $($binary query txs --events="create_validator.validator=$(echo $valoper)" --node $SNAP_RPC -o json | jq .txs[0].txhash -r) >> $text
echo >> $text
echo Website: `cat /root/bot/tmp/valoper.json | jq -r .description.website` >> $text
echo Details: `cat /root/bot/tmp/valoper.json | jq -r .description.details` >> $text
echo Identity: `cat /root/bot/tmp/valoper.json | jq -r .description.identity`  >> $text
echo Contact: `cat /root/bot/tmp/valoper.json | jq -r .description.security_contact` >> $text
echo >> $text
echo Jail: `cat /root/bot/tmp/valoper.json | jq -r .jailed` >> $text
echo >> $text
echo Bonded: `cat /root/bot/tmp/valoper.json | jq -r .tokens` >> $text
com=`cat /root/bot/tmp/valoper.json | jq -r .commission.commission_rates.rate | awk '{printf("%.2f\n",$1)}'`
com=$(echo "$com*100" | bc)
echo Commission: $com% >> $text

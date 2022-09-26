#!/bin/bash
binary=$1
TOKEN=$2
apt install -y python3 pip bc
pip install pyTelegramBotAPI
sleep 10
mkdir /root/bot/tmp/
/root/bot/parameters.sh $binary
mkdir /root/bot/log
sleep 5  
cat > /root/bot/run <<EOF 
#!/bin/bash
exec 2>&1
export binary=$binary
export TOKEN=$TOKEN
exec python3 /root/bot/CosmoBot.py
EOF
chmod +x /root/bot/run
LOG=/var/log/bot

cat > /root/bot/log/run <<EOF 
#!/bin/bash
mkdir $LOG
exec svlogd -tt $LOG
EOF
chmod +x /root/bot/log/run
ln -s /root/bot /etc/service

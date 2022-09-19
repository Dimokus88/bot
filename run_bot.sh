#!/bin/bash
apt install -y python3 pip bc
pip install pyTelegramBotAPI
sleep 10
mkdir /root/bot/tmp/
source ~/.bashrc
mkdir /root/bot/log
sleep 5  
cat > /root/bot/run <<EOF 
#!/bin/bash
exec 2>&1
export binary=$binary
export $TOKEN
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
sleep 5

echo == Установка cheker proposal ==
mkdir /root/tmp/
mkdir /root/cheker/
wget -O /root/cheker/cheker_proposal.sh https://raw.githubusercontent.com/Dimokus88/universe/main/script/cheker_proposal.sh && chmod +x /root/cheker/cheker_proposal.sh
mkdir /root/cheker/log
sleep 5  
cat > /root/cheker/run <<EOF 
#!/bin/bash
exec 2>&1
exec /root/cheker/cheker_proposal.sh $binary $TOKEN $CHAT_ID 
EOF
chmod +x /root/cheker/run
LOG=/var/log/cheker

cat > /root/cheker/log/run <<EOF 
#!/bin/bash
mkdir $LOG
exec svlogd -tt $LOG
EOF
chmod +x /root/cheker/log/run
ln -s /root/cheker /etc/service
sleep 5
echo == Cheker proposal установлен ==

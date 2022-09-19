#!/bin/bash
apt install -y python3 pip bc
pip install pyTelegramBotAPI
sleep 10
cd /root/ && gitclone 
mkdir /root/bot/tmp/
source ~/.bashrc && curl -s https://raw.githubusercontent.com/Dimokus88/universe/main/script/parameters.sh | bash
wget -O /root/bot/status.sh https://raw.githubusercontent.com/Dimokus88/universe/main/bots/status.sh && chmod +x /root/bot/status.sh
cat > /root/bot/CosmoBot.py <<EOF 
import telebot
from telebot import types
import os
import subprocess
bot = telebot.TeleBot("$TOKEN")
binary = os.getenv('binary')
@bot.message_handler(commands=['start'])
def start_message(message):
        bot.send_message(message.chat.id,"Welcome to Akash Nodes Alert Bot!")
        markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
        item1=types.KeyboardButton("Status")
        markup.add(item1)
        bot.send_message(message.chat.id,"Select functions please!",reply_markup=markup)

@bot.message_handler(content_types=['text'])
def handle_text(message):
        if message.text == "Status":
                subprocess.check_call("/root/bot/status.sh '%s'" % binary, shell=True)
                text = open ('/root/bot/text.txt')
                bot.send_message(message.chat.id,text.read())
bot.infinity_polling()
EOF
chmod +x /root/bot/CosmoBot.py

mkdir /root/bot/log
sleep 5  
cat > /root/bot/run <<EOF 
#!/bin/bash
exec 2>&1
export binary=$binary
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
echo == Оповещение Telegram включено ==
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

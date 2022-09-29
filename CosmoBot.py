import telebot
from telebot import types
import os
import subprocess
TOKEN = os.getenv("TOKEN")
bot = telebot.TeleBot(TOKEN)
binary = os.getenv("binary")
@bot.message_handler(commands=['start'])
def start_message(message):
  markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
  item1=types.KeyboardButton("About me")
  item2=types.KeyboardButton("Main menu")
  markup.add(item2,item1)
  message =  bot.send_message(message.chat.id,"Welcome to Akash nodes bot manager!",reply_markup=markup)
#  bot.delete_message(message.chat.id, message_id=msg.message_id)
@bot.message_handler(content_types=['text'])
def start_message(message):
  if message.text == "Main menu":
     file = open('/root/bot/CHAT_ID.txt', 'w')
     file.write(str(message.chat.id))
     file.close()
#     bot.delete_message(message.chat.id, message_id=message.message_id)
     markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
     item1=types.KeyboardButton("Status")
     item2=types.KeyboardButton("Blockchain explorer")
     item3=types.KeyboardButton("Manage node")
     markup.add(item1,item2,item3)
     bot.send_message(message.chat.id,"You are in the main menu!",reply_markup=markup)

  if message.text == "Status":
#     bot.delete_message(message.chat.id, message_id=message.message_id)
     markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
     item1=types.KeyboardButton("Status node hardware")
     item2=types.KeyboardButton("Blockchain Parameters")
     item3=types.KeyboardButton("Main menu")
     markup.add(item1,item2)
     markup.add(item3)
     bot.send_message(message.chat.id,"Status node & info network:",reply_markup=markup)

  if message.text == "Blockchain explorer":
#     bot.delete_message(message.chat.id, message_id=message.message_id)
     a = telebot.types.ReplyKeyboardRemove()
     text = bot.send_message(message.chat.id,"Enter valoper/address/TX_HASH:",reply_markup=a)
     bot.register_next_step_handler(text,explorer)


  if message.text == "About me":
#     bot.delete_message(message.chat.id, message_id=message.message_id)
     text = open ('/root/bot/about.txt')
     bot.send_message(message.chat.id,text.read())

  if message.text == "Manage node":
     markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
     item1=types.KeyboardButton("Governance")
     item2=types.KeyboardButton("Staking")
     item3=types.KeyboardButton("Send tokens")
     item4=types.KeyboardButton("Main menu")
     markup.add(item1,item2,item3)
     markup.add(item4)
     bot.send_message(message.chat.id,"Manage a node, vote, or send tokens to a friend!",reply_markup=markup)

  if message.text == "Status node hardware":
     subprocess.check_call("/root/bot/status.sh '%s'" % binary, shell=True)
     text = open ('/root/bot/text.txt')
     bot.send_message(message.chat.id,text.read())
 
  if message.text == "Blockchain Parameters":
     text = open ('/root/bot/tmp/parameters.txt')
     bot.send_message(message.chat.id,text.read())

  if message.text == "Governance":
     markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
     item1=types.KeyboardButton("Actual proposal")
     item2=types.KeyboardButton("Vote")
     item3=types.KeyboardButton("Main menu")
     markup.add(item1,item2)
     markup.add(item3)
     text = bot.send_message(message.chat.id,"Select section",reply_markup=markup)
     bot.register_next_step_handler(text,prop) 

def prop(message):
     markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
     item1=types.KeyboardButton("Main menu")
     item2=types.KeyboardButton("Vote")
     subprocess.check_call("/root/bot/cheker/cheker_list.sh '%s'" % binary , shell=True)
     text = open ('/root/bot/cheker/message.txt')
     markup.add(item1,item2)
     bot.send_message(message.chat.id,text.read(),reply_markup=markup)

def explorer(message):
     markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
     item1=types.KeyboardButton("Main menu")
     item2=types.KeyboardButton("Blockchain explorer")
     text = message.text
     file = open('/root/bot/tmp/explorer.txt', 'w')
     file.write("{explorer}".format(explorer=message.text))
     file.close()
     subprocess.check_call("/root/bot/explorer.sh '%s'" % binary , shell=True)
     text = open ('/root/bot/tmp/explorer.txt')
     markup.add(item1,item2)
     bot.send_message(message.chat.id,text.read(),reply_markup=markup)

def hash(message):
    markup=types.ReplyKeyboardMarkup(resize_keyboard=True)
    item1=types.KeyboardButton("Info")
    text = message.text
    file = open('/root/bot/tmp/transaction.txt', 'w')
    file.write("{hash}".format(hash=message.text))
    file.close()
    subprocess.check_call("/root/bot/txs.sh '%s'" , shell=True)
    text = open ('/root/bot/tmp/txs.txt')
    markup.add(item1)
    bot.send_message(message.chat.id,text.read(),reply_markup=markup)

bot.infinity_polling()

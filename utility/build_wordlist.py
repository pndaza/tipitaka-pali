# this script will extract wordlist from pali canon and
# add these wordlist to sqlite database
# table name for wordlist : words
# columns : word , frequency


import os
import sqlite3
import re

def cleanhtml(raw_html):
    re_html = re.compile('<[^>]*>')
    cleantext = re.sub(re_html, '', raw_html)
    return cleantext

def cleanWord(word):
    re_token = re.compile(r'[^a-zāīūṅñṭḍṇḷṃ]')
    clean_word = re.sub(re_token, '', word)
    return clean_word


words = {}

dbfile = '../assets/database/tipitaka_pali.db'

print('building wordlist ...\nplease wait a moment ...')

conn = sqlite3.connect(dbfile)
cursor = conn.cursor()

cursor.execute('DROP TABLE words')
cursor.execute('CREATE TABLE "words" ("word" TEXT, "frequency" INTEGER)')
cursor.execute('SELECT rowid, content FROM pages')
rows = cursor.fetchall()

for row in rows:
    rowid = row[0]
    content = row[1]
    content = cleanhtml(content)
    wordlist = content.split()

    for idx, word in enumerate(wordlist):
        word = cleanWord(word)
        if(len(word) > 0):
            if word in words:
                words[word] += 1
            else:
                words[word] = 1

for key, value in words.items():
    cursor.execute(f"insert into words (word, frequency) values ('{key}','{value}')")
conn.commit()
conn.close()

print('sucessfully create word list table')

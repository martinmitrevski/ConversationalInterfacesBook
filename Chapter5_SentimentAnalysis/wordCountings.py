import os
import re
import json
import sys
sys.stdout=open('words.json','w')
from collections import Counter
from glob import iglob

wordsRaw = open('words_ordered.txt', 'r')   
words_array = []
for line in wordsRaw: 
	words_array.append(line.rstrip())

frequency = {}

def removegarbage(text):
    text=re.sub(r'\W+',' ',text)
    text=text.lower()
    return text

folderpaths=['txt_sentoken/pos/', 'txt_sentoken/neg/']
counter=Counter()

for folderpath in folderpaths: 
	for filepath in iglob(os.path.join(folderpath,'*.txt')):
    		with open(filepath,'r') as filehandle:
        		counter.update(removegarbage(filehandle.read()).split())

for word,count in counter.most_common():
	frequency[word] = count

result = {}

index = 0
for word in words_array:
	info = {}
	info["count"] = frequency[word]
	info["index"] = index
	result[word] = info
	index += 1

print(json.dumps(result))
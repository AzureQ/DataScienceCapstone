import sys
import re
import string

_digits = re.compile('\d')
_nonenglish = re.compile('[\x80-\xFF]')
_tags = re.compile("[`|'|$|^|%|&|@|#|]")
_table = string.maketrans("","")

def remove_punc(token):
    return token.translate(_table, string.punctuation)

def containDigit(token):
    return bool(_digits.search(token))

def containNonEnglish(token):
        return bool(_nonenglish.search(token))

def containSmileyFace(token):
	return bool(_smileyfaces.search(token))

tags = ("\t","\r","\n","`","'","#","\"","$","%","^","&","*","@","-","~","/","\\","_","+","=","-","|","<",">")

for line in sys.stdin:
        words = [remove_punc(word.lower()) for word in line.split(" ") 
            if not containDigit(word)
        	and not containNonEnglish(word)
        	and word.strip(''.join(tags))
            and word.strip(string.punctuation)
            and word not in tags
            ]
        sys.stdout.write(" ".join(words))

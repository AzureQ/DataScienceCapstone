import sys
import re

_digits = re.compile('\d')
_nonenglish = re.compile('[\x80-\xFF]')
_tags = re.compile("[`|'|$|^|%|&|@|#|]")
def containDigit(token):
    return bool(_digits.search(token))

def containNonEnglish(token):
        return bool(_nonenglish.search(token))

def containtags(token):
        return

tags = ("\t","\r","\n","`","'","#","\"","$","%","^","&","*","@","-","~","/","\\","_","+","=","-","|","<",">")

for line in sys.stdin:
        words = line.split(" ")
        words = [word for word in words if not containDigit(word)
        	and not (word in tags)
        	and not containNonEnglish(word)
        	and word.strip(''.join(tags))]

        sys.stdout.write(" ".join(words))

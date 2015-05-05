#!user/bin/ bash
echo "Downloading Coursera-SwiftKey.zip ..."
rm Coursera-SwiftKey.zip
curl -O https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
echo "Unziping Coursera-SwiftKey.zip..."
rm -r dataset
mkdir dataset
tar xvf Coursera-SwiftKey.zip -C `pwd`/dataset --strip-components 1



echo "Downloading Stanford parser ..."
curl -O http://nlp.stanford.edu/software/stanford-parser-full-2015-01-29.zip
rm -r stanford
mkdir stanford 
tar xvf stanford-parser-full-2015-01-29.zip -C `pwd`/stanford --strip-components 1

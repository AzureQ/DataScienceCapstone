#!user/bin bash

twitter="en_US.twitter.txt"
blogs="en_US.blogs.txt"
news="en_US.news.txt"

function statistics(){
  echo "File Info:"
    echo "  File name: $1"
    filesze=`ls -lah dataset/* | grep -w $1 | awk '{print $5}'`
    echo "  FileSize: $filesze"
    file=`find . -name $1`
    nlines=`wc -l $file | awk '{print $1}'`
    echo "  Number of lines: $nlines"
    nwords=`wc -w $file | awk '{print $1}'`
    echo "  Number of words: $nwords"
}

function tokenization(){
    file=`find . -name $1`
    output="dataset/en_US/tokenized_`basename $file`"
    echo "Tokenizing $file..."
    export CLASSPATH=stanford/stanford-parser.jar
    java edu.stanford.nlp.process.PTBTokenizer -preserveLines -options untokenizable=noneDelete,normalizeParentheses=false,normalizeOtherBrackets=false < $file > $output
    echo "Tokenization data generated successfully: tokenized_`basename $file`"
}

tokenizedfiles=()
for src in $twitter $blogs $news
do
    echo "======================================================"
    echo "Processing $src..."
    statistics $src
    tokenization $src
    statistics "tokenized_$src"
    echo "======================================================"
    tokenizedfiles+=("tokenized_$src")
done
echo "Tokenized files generated under dataset/en_US/"
echo ${tokenizedfiles[@]}

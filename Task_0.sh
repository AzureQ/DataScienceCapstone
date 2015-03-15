#!user/bin/ bash
#Dataset

# This is the training data to get you started that will be the basis for most of the capstone. You must download the data from the Coursera site and not from external websites to start.

# Capstone Dataset (https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
# Your original exploration of the data and modeling steps will be performed on this data set. Later in the capstone, if you find additional data sets that may be useful for building your model you may use them.

# Tasks to accomplish

# Obtaining the data - Can you download the data and load/manipulate it in R?
# Familiarizing yourself with NLP and text mining - Learn about the basics of natural language processing and how it relates to the data science process you have learned in the Data Science Specialization.
# Questions to consider

# What do the data look like?
# Where do the data come from?
# Can you think of any other data sources that might help you in this project?
# What are the common steps in natural language processing?
# What are some common issues in the analysis of text data?
# What is the relationship between NLP and the concepts you have learned in the Specialization?


echo "Cleaning Up ..."
echo "Removing Coursera-SwiftKey.zip"
rm Coursera-SwiftKey.zip
echo "Removing dataset folder"
rm -r dataset

echo "Downloading Coursera-SwiftKey.zip ..."
curl -O https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
echo "Unziping to dataset folder..."
unzip Coursera-SwiftKey.zip 
mv final dataset


echo "==========================="
echo "|                         |"
echo "|         Quiz 1          |"
echo "|                         |"
echo "==========================="

echo "Q1: The en_US.blogs.txt file is how many megabytes?"
ls -lah dataset/* | grep en_US.blogs.txt | awk '{print $5, $9}'
echo "==========================="

echo "Q2: The en_US.twitter.txt has how many lines of text?"
twitterFile=`find . -name en_US.twitter.txt`
wc -l $twitterFile | awk '{print $1}'
echo "==========================="

echo "Q3: What is the length of the longest line seen in any of the three en_US data sets?"
FILES=dataset/en_US/*
for f in $FILES
do
  echo "Processing $f file..."
  awk 'length > max_length { max_length = length; longest_line = $0 } END { print max_length }' $f
done

echo "==========================="

echo "Q4: In the en_US twitter data set, if you divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?"
twitterFile=`find . -name en_US.twitter.txt`
loveLineCount=`grep "love" $twitterFile | wc -l`
hateLineCount=`grep "hate" $twitterFile | wc -l` 
echo "Line count with world "love"" $loveLineCount
echo "Line count with world "hate"" $hateLineCount
echo "Final results" $((loveLineCount/hateLineCount))
echo "==========================="


echo "Q5: The one tweet in the en_US twitter data set that matches the word "biostats" says what?"
twitterFile=`find . -name en_US.twitter.txt`
tweet=`grep -i "biostats" $twitterFile`
echo $tweet
echo "==========================="


echo "Q6: How many tweets have the exact characters "A computer once beat me at chess, but it was no match for me at kickboxing". (I.e. the line matches those characters exactly.)"
twitterFile=`find . -name en_US.twitter.txt`
#grep -x will return 0 in Mac but 3 in linux
numberOfMatchedTweets=`grep "A computer once beat me at chess, but it was no match for me at kickboxing" $twitterFile | wc -l`
echo $numberOfMatchedTweets
echo "==========================="


echo "Cleaning Up ..."
echo "Removing Coursera-SwiftKey.zip"
rm Coursera-SwiftKey.zip
echo "Removing dataset folder"
rm -r dataset

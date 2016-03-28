#!/bin/bash 
# Parameters 
BASEDIR=$(dirname $0) 
CURDIR=$(pwd) 
MAILDIR=./maildata 
LOGFILE=./logs/printmail.log 
ATTACH_DIR=./attachments 
# change directory 
echo "Switching directory to : $BASEDIR" 
cd $BASEDIR 
# create log file if it does not exist 
touch $LOGFILE 
date +%r-%-d/%-m/%-y >> $LOGFILE 
# fetch mail 
echo "Checking for new mail..." 
fetchmail -f ./fetchmail.conf -L $LOGFILE 
# process new mails 
shopt -s nullglob 
for i in $MAILDIR/new/* 
do 
   echo "Processing : $i" | tee -a $LOGFILE 
   uudeview $i -i -p $ATTACH_DIR/ 
   echo "Printing PDFs" | tee -a $LOGFILE 
   for x in $ATTACH_DIR/*.pdf 
   do 
           echo "Printing : $x" | tee -a $LOGFILE 
           lpr $x 
           echo "Deleting file : $x" | tee -a $LOGFILE 
           rm $x | tee -a $LOGFILE 
   done 
   echo "Clean up and remove any other attachments" 
   for y in $ATTACH_DIR/* 
   do 
   rm $y 
   done 
   # delete mail 
   echo "Deleting mail : $i" | tee -a $LOGFILE 
   rm $i | tee -a $LOGFILE 
done 
shopt -u nullglob 
echo "Job finished." | tee -a $LOGFILE 
cd $CURDIR
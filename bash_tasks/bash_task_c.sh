#!/bin/bash

#C. Create a data backup script that takes the following data as parameters:
#1. Path to the syncing directory.
#2. The path to the directory where the copies of the files will be stored.
#In case of adding new or deleting old files, the script must add a corresponding entry to the log file
#indicating the time, type of operation and file name. [The command to run the script must be added to
#crontab with a run frequency of one minute]


DATE=$(date +%F-%H-%M)						#current date
BACKUP_DIR=/home/katroo/Desktop/level1/bash_tasks/one			#source directory
DEST=/home/katroo/Desktop/level1/bash_tasks/one_backup			#destination direcroty

BACKUP=$(rsync -av $BACKUP_DIR $DEST --delete | grep one) 	#backup with rsync command and grep only lines with word "one" - because it means changes was done
DELETED_FILES="[^deleting one]"					#to choose only lines with files were deleted
NEW_FILES="[^one/.*]"						#to choose only lines with new files

echo "$BACKUP" > /dev/null					#to not show result in command line

if [[ "$BACKUP" =~ $DELETED_FILES ]]; then			#check if there're files that were deleted

	FILES_REMOVED=$(echo "$BACKUP" | grep deleting | cut -d "/" -f 2)	#cutting only file names
	for Line in $FILES_REMOVED; do 						#for every line adding description and directing to logs
		echo "Removed: $Line $DATE" >> $DEST/one_logs.txt   
	done

fi

if [[ "$BACKUP" =~ $NEW_FILES ]]; then				#check if there're new files

	FILES_ADDED=$(echo "$BACKUP" | grep -v deleting | cut -d "/" -f 2 | grep -v -e '^[[:space:]]*$')	#cutting only file names and deleting empty lines
		if [[ "$FILES_ADDED" =~ $NEW_FILES ]]; then						#check if there're file names left
       			for Line in $FILES_ADDED; do							#for every line adding description and directing to logs
				echo "Added: $Line $DATE" >> $DEST/one_logs.txt
			done
		fi
fi









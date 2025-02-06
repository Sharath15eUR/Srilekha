#!/usr/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
	exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
FILE_EXT="$3"



if [ ! -d "$SOURCE_DIR" ]; then
	echo "Src dir $SOURCE_DIR doesnt exist"
	exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup dir $BACKUP_DIR doesnt exist,create it"
	mkdir -p "$BACKUP_DIR"
fi

BACKUP_COUNT=0
TOTAL_SIZE=0

FILES_TO_BACKUP=()


echo "Finding *$FILE_EXT files in $SOURCE_DIR..."
while IFS= read -r file; do
    FILES_TO_BACKUP+=("$file")  
done < <(find "$SOURCE_DIR" -type f -name "*$FILE_EXT")


echo "Files to be backed up:"
for file in "${FILES_TO_BACKUP[@]}"; do
    file_size=$(stat --format="%s" "$file")  
    echo "$file - $file_size bytes"
    TOTAL_SIZE=$((TOTAL_SIZE + file_size)) 
done 


echo "Backing up files..."
for file in "${FILES_TO_BACKUP[@]}"; do
    cp "$file" "$BACKUP_DIR"
    BACKUP_COUNT=$((BACKUP_COUNT + 1))  
done


export BACKUP_COUNT

# Generate the summary report
REPORT_FILE="$BACKUP_DIR/backup_report.log"

echo "Generating report at $REPORT_FILE..."

echo "Backup Report" > "$REPORT_FILE"
echo "--------------" >> "$REPORT_FILE"
echo "Total files processed: $BACKUP_COUNT" >> "$REPORT_FILE"
echo "Total size of files backed up: $TOTAL_SIZE bytes" >> "$REPORT_FILE"
echo "Backup directory path: $BACKUP_DIR" >> "$REPORT_FILE"

# Display the summary
echo "Backup completed. Total files backed up: $BACKUP_COUNT"
echo "Total size of files backed up: $TOTAL_SIZE bytes"
echo "Backup directory path: $BACKUP_DIR"
echo "The report has been saved as $REPORT_FILE"

	


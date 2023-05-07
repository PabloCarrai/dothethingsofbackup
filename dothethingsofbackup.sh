#!/bin/bash

DOCK=$(which docker)
DNCDB=$("$DOCK" ps -aqf "name=db")
HOY=$(date +"%d-%m-%Y")
FD="/home/ed"
ARCHIVO=$(find "$FD" -type f -name .env)
.	"$ARCHIVO"
FBACK="$FD/backups/"
RFD=$(find "$FD" -type d -name "$WORDPRESS_DB_NAME")

if [ -d "$FBACK" ];
then
    echo ":)"
else
	mkdir -p "$FBACK"/{archivos,db}
fi

"$DOCK" exec "$DNCDB" /usr/bin/mysqldump -u root --password="$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" > "$FD"/backups/db/"$HOY"-"$MYSQL_DATABASE".sql
find "$FD" -maxdepth 2 -name "$WORDPRESS_DB_NAME" -printf "%P\0" | tar --null -czf "$FD/backups/archivos/"$HOY"-"$MYSQL_DATABASE".tar.gz" -C "$FD" -T -


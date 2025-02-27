#!/bin/sh
# Deployment tool for managing application versions with backup and restore capabilities
SERVER=$(/bin/pwd)

EXCLUDE='ryc_tool|other'
NEW_FOLDER=$SERVER/.new_version
BACKUP_FOLDER=$SERVER/.backup_version


cd $SERVER
mkdir -p $NEW_FOLDER  
mkdir -p $BACKUP_FOLDER

case "$1" in  
  deploy)
    if [ "$(ls -A $NEW_FOLDER)" ]; then
      echo "find new version to deploy"
    else
      echo "No new version file to deploy! $NEW_FOLDER is Empty"
      exit 1
    fi

    BACKUP_VERSION=$BACKUP_FOLDER/$(date +%y-%m-%d_%H:%M:%S)
    echo 'backup runing file to foler:'$BACKUP_VERSION
    mkdir -p $BACKUP_VERSION && cp -r $(ls | grep -Ev "$EXCLUDE") $BACKUP_VERSION

    echo 'replace runing file from foler:'$NEW_FOLDER
    (cd $NEW_FOLDER && tar c .) | (cd $SERVER && tar xf -)

    echo 'clean the cache'
    rm -rf $NEW_FOLDER/*
  ;;
  *)
    echo " "
    echo "--------------------------------version: 2.0.7"   
    echo "./ryc_tool {option}"
    echo "    OPTION:"
    echo "        | deploy    deploy the file to runing file." 
    echo " "
    echo ""
  ;;  
esac

exit 0
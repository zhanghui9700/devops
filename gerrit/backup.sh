#!/bin/sh

DATE=`date +%Y-%m-%d`
BACKUP_PATH='/opt/back/review'
BACKUP_SERVER='10.10.38.168'
BACKUP_USER='ubuntu'
BACKUP_TARGET=/opt/bak/gerrit/$DATE

if test ! -d $BACKUP_PATH; then
   echo "Create backup directory"
   mkdir -p $BACKUP_PATH
fi

clean() {
    rm -rf $BACKUP_PATH/*	
}

backup_gerrit() {
    echo "backup gerrit"
    cd /home/gerrit2 && tar zcf $BACKUP_PATH/review.tar.gz review
}

backup_db() {
    echo "backup reviewdb"
    mysqldump -ugerrit2 -ppassword -h127.0.0.1 reviewdb > $BACKUP_PATH/review.sql
}

send_to_backup_server() {
    echo "send to backup server"
    ssh $BACKUP_USER@$BACKUP_SERVER "mkdir -p $BACKUP_TARGET"
    scp $BACKUP_PATH/review.tar.gz $BACKUP_USER@$BACKUP_SERVER:$BACKUP_TARGET
    scp $BACKUP_PATH/review.sql $BACKUP_USER@$BACKUP_SERVER:$BACKUP_TARGET
}

usage() {
    me=`basename "$0"`
    echo >&2 "Usage: $me {backup}"
    exit 1
}

test $# -gt 0 || usage

ACTION=$1
shift

##################################################
# Do the action
##################################################
case "$ACTION" in
  backup)
    printf '%s' "Starting Backup Gerrit "
    clean
    backup_gerrit
    backup_db 
    send_to_backup_server

    echo OK
    exit 0
  ;;

  *)
    usage
  ;;
esac

exit 0

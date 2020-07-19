#!/bin/bash
# JetsonHacks, 2020
# Copy rootfs to a folder
# This is useful for backup up a Jetson system.
# Note that this only copies the rootfs on the APP partition
# There are typically several different partions on a Jetson disk

DESTINATION_TARGET=""

function usage
{
    echo "usage: ./backup-rootfs.sh [ -d directory | [-h]]"
    echo "-h | --help  This message"
}

# We need the directory argument
if [ "$1" == "" ]; then
	usage
	exit 1
fi

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -d | --directory )      shift
				DESTINATION_TARGET=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ "$DESTINATION_TARGET" == "" ]; then
	usage
	exit 1
fi

if [ ! -d $DESTINATION_TARGET ]; then
  echo "The destination directory: $DESTINATION_TARGET does not exist" 
  echo "You must enter a valid directory"
  exit 1
fi

TODAY=$(date +"%m-%d-%Y")
echo $TODAY
BACKUP_FILENAME="backup-rootfs-$TODAY"
if [ "${DESTINATION_TARGET: -1}" == '/' ]; then
	FULL_BACKUP_FILENAME="$DESTINATION_TARGET$BACKUP_FILENAME"
else
	FULL_BACKUP_FILENAME="$DESTINATION_TARGET/$BACKUP_FILENAME"
fi

echo "Backing up rootfs (/) to $FULL_BACKUP_FILENAME"
echo "Please make sure you have enough space to create the backup copy"
read -p "Continue? [Y/n] " yn
case $yn in
  [Y]* ) ;;
  [Nn]* ) exit 1;;
  * ) exit 1;;
esac
# We have a semi-qualified filepath
# -a, --archive   archive mode; equals -rlptgoD (no -H,-A,-X)
# -c              use checksum, not time and date
# -v              verbose
# -x              don't cross file system boundaries
# -A              preserve Access Control List (ACLs)

sudo rsync -acvxAP --info=progress,stats2 --delete-before --numeric-ids \
--exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} \
 / $FULL_BACKUP_FILENAME





#!/bin/bash
# JetsonHacks, 2020
# Restore rootfs from a folder
# rootfs should have been save from backup-rootfs.sh 

SOURCE_TARGET=""

function usage
{
    echo "usage: ./restore-rootfs.sh [ -d directory | [-h]]"
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
				SOURCE_TARGET=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [ "$SOURCE_TARGET" == "" ]; then
	usage
	exit 1
fi

# Append a / to the folder
if [ "${SOURCE_TARGET: -1}" != '/' ] ; then
	SOURCE_TARGET+="/"
fi

if [ ! -d $SOURCE_TARGET ]; then
  echo "The source directory: $SOURCE_TARGET does not exist" 
  echo "You must enter a valid directory"
  exit 1
fi


echo "Restoring rootfs (/) from $SOURCE_TARGET"
read -p "Continue? [Y/n] " yn
case $yn in
  [Y]* ) ;;
  [Nn]* ) exit 1;;
  * ) exit 1;;
esac
# We have a semi-qualified filepath
sudo rsync -acvxAP --info=progress,stats2 --delete-before --numeric-ids \
--exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} \
 $SOURCE_TARGET / 





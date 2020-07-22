# backupJetson
Backup a NVIDIA Jetson Developer Kit root system: Full article on JetsonHacks: https://wp.me/p7ZgI9-3a1

There are many ways to backup a Linux system. There are many apps and command line utilities that provide elegant solutions to this problem.

This, on the other hand, is a very simple script using the utility rsync for making a copy of the rootfs (everything under the / directory) in another folder on a different drive. Generally, the expected use is to make a copy of the rootfs as a system backup or as part of preparation for upgrading a system.

The backup-rootfs script is explicitly dumb, with the intention that you will modify it to meet your needs. The script will recursively copy the '/' directory to the specified directory. The specified directory must exist, and it is up to you to check to make sure there is enough space available for the copy.

## backup-rootfs.sh
```
./backup-rootfs.sh [ -d directory | [-h]]
```
This will copy the rootfs into the given directory. Typically, the directory is on a different storage device. Also it must exist. Some temporary files and system generated information is excluded in the copy, see the script for more details.

## restore-rootfs
```
./restore-rootfs.sh [ -d directory | [-h]]
```
This is the compliment to the backup. The rootfs is restored from the archive in the given directory.


## About the rsync command used

For the backup we use rsync, a very flexible remote and local file synchronization tool. You should modify the rsync commands for your particular needs, and take into account where you need to store the backup file. 

The backup-rootfs script assumes a local file. The command looks like:
``` 

sudo rsync -acvxAP --info=progress,stats2 --delete-before --numeric-ids \
--exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} \
/ <filepath>
```

Note that you may want to add "--dry-run" as a parameter to rsync if you want to make a practice run without actually copy the contents.

For a similar operation over SSH, you would change the command to something along the lines:
```
sudo rsync -avczrx --numeric-ids \
--exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} \
 -e 'ssh' --delete-before / root@YOUR_HOST_IP_ADDRESS:/home/someone/rsync_stuff/
```

Of course, you can also modify the script to make backups of only certain folders, files and so on.

## Notes

Here's a nice summary from the NVIDIA Jetson forums from linuxdev:

https://forums.developer.nvidia.com/t/how-to-git-versin-rootfs/84029/10

Thank you linuxdev!

## Releases
* JetPack 4.4 L4T 32.4.3
* Initial Release

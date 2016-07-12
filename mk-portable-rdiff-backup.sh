#!/bin/bash

# mk-portable-rdiff-backup.sh
#
# Copyright 2016 Brendan Kidwell
# https://github.com/bkidwell/rdiff-backup-ubuntu-portable
# License: GPLv3

echo This script will take the following files in its folder:
echo "   librsync1_*.deb"
echo "   rdiff-backup_*.deb"
echo and build a portable copy of \'rdiff-backup\' for use on DreamHost.

read -p "Press [Enter] key to continue..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR"
if [ -e build ]; then rm -rf build; fi
mkdir build

echo Extracting librsync and rdiff-backup...

cd build
ar p ../librsync1_*.deb data.tar.gz | tar zx
ar p ../rdiff-backup_*.deb data.tar.gz | tar zx

echo Building app folder...

cd "$SCRIPT_DIR"
if [ -e portable ]; then rm -rf portable; fi
mkdir -p portable/rdiff-backup.files/rdiff_backup
cp build/usr/share/pyshared/rdiff_backup/*.py portable/rdiff-backup.files/rdiff_backup/
cp build/usr/lib/python2.7/dist-packages/rdiff_backup/*.so portable/rdiff-backup.files/rdiff_backup/
cp build/usr/bin/rdiff-backup* portable/rdiff-backup.files
cp --dereference build/usr/lib/librsync.so.1 portable/rdiff-backup.files

cat >portable/rdiff-backup <<EndOfText
#!/bin/bash
SCRIPT_DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
FILES_DIR=\$(readlink -f "\$SCRIPT_DIR/rdiff-backup.files")
LD_LIBRARY_PATH=\$FILES_DIR
export LD_LIBRARY_PATH
exec "\$FILES_DIR/rdiff-backup" \$*
EndOfText
chmod +x portable/rdiff-backup

cat >portable/rdiff-backup-statistics <<EndOfText
#!/bin/bash
SCRIPT_DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
FILES_DIR=\$(readlink -f "\$SCRIPT_DIR/rdiff-backup.files")
LD_LIBRARY_PATH=\$FILES_DIR
export LD_LIBRARY_PATH
exec "\$FILES_DIR/rdiff-backup-statistics" \$*
EndOfText
chmod +x portable/rdiff-backup-statistics

filename=$(ls rdiff*.deb)
filename="${filename%.*}"
echo Building \'$filename.tar.gz\'...
cd portable
tar zcf ../$filename.tar.gz *

cd "$SCRIPT_DIR"
rm -rf portable build

echo Done!
read -p "Press [Enter] key to continue..."

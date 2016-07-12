# rdiff-backup-ubuntu-portable

Brendan Kidwell  
11 July 2016

This script will create a portable (user-installable) copy of Ubuntu's `rdiff-backup` package, good for shared hosting like DreamHost.

## Usage

Do the following on a local Linux machine or on the remote machine where you eventually want to install `rdiff-backup`:

1. Copy `mk-portable-rdiff-backup.sh` to a temp folder such as `~/Temp/rdiff-backup`.
2. Go to http://packages.ubuntu.com and download the `.deb` files for `rdiff-backup` and `librsync1` for the Ubuntu distribution running on your target machine. (In the case of DreamHost, that would be the `amd64` build of Ubuntu 12.04 "precise", at the time of this writing.)
3. Copy the two `.deb` files you downloaded into your working folder (`~/Temp/rdiff-backup`).
4. Run `mk-portable-rdiff-backup.sh`

You will get `rdiff-backup_$VERSION_$ARCH.tar.gz`.

## Installation

Go to `~/bin` (create it if necessary) on the target machine and extract the contents of the `.tar.gz` file created in the previous step.

## Using the Portable rdiff-backup in Server Mode

If your target system is a shared web host like DreamHost, you probably don't have `~/bin` in the `$PATH` environment variable for "non-interactive" shells. To use your remote `rdiff-backup` in "server" mode, you must specify a command line invocation on the client.

For example, if you want to use `rdiff-backup` to login to `HOST` as `FOO` and backup the `/BAR.com` folder, use the following command line on the client:

```
rdiff-backup --remote-schema 'ssh -C %s bin/rdiff-backup --server' \
FOO@HOST::/home/FOO/BAR.com BAR.com
```

(Don't forget to install your client's SSH key on the server, and other details needed to make this work from an automated script, if needed.)

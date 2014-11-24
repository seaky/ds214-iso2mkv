ds214-iso2mkv for dsdownload (manual)
=============

Guide to create iso2mkv converter for your Synology ds214/ds213j and other Marvell Armada based models.

Introduction
------------

Smart TVs does not support to play ISO-DVD media format. One of the reason could be .iso is not a media format. It's a filesystem. Moder TVs can play several format such as mpeg, avi, mkv. Obious soultion to convert .iso file to a media format supported your TV. There are tools for desktop class computers to make this process but none for embedded systems eg. NAS. Because media conversion is a highly CPU intensive process.

Some formats can encapsulate multiple media files together so called container formats eg. mkv, avi. To reduce CPU intensive process our iso2mkv converter will not reconvert dvds to other media format just repackage the appropiate content to an mkv file. So no CPU burning computation just some file manipulation.

### Recommended ds214
Although the script just do some file manipulation on ds214 this process loads one cpu and a dvd conversion takes to five minutes. DS214 has dual core processor so under the conversion the system will be stable and responsive.

Build steps
-----------

1. Install optware bootstrap
2. Install mkvmerge via ipkg
3. Install armv7 mplayer binaries from this repo
4. Create conversion script for dsdownload (optional)
5. Setup scheduled task to run conversion script (optional)
6. Create conversion script for command line (optional)

under consruction

1. Install optware bootstrap
------------
Follow this link and install optware to your device.
https://github.com/trepmag/ds213j-optware-bootstrap

2. Install mkvmerge via ipkg
-------------
<pre>
$ ipkg install mkvtoolnix
</pre>

3. Install armv7 mplayer binaries 
-------------
coming soon

4. Create conversion script for dsdownload (optional)
-------------
This script extracts english and hungarian audio dub if you want to modify this change:
<pre>mplayer -alang [langcode] lines and mkvmerge --language line.</pre>

Create the /root/mkvconverter.sh file (chmod 755) and insert: 
<pre>
#!/bin/sh

# ISO2MKV Converter v1.0
# written by Robert Szakalli

BASEPATH=/volume1
POSTFIX=-tv
MPLAYER=/root/3rdparty/mplayer
MKVMERGE=/opt/bin/mkvmerge

makemkv() {
  STARTTIME=$(date +%s)
  trap "" HUP
  ISONAME=$(basename $1 .iso)
  ISODIR=$(dirname $1)
  echo "making: $ISONAME"

  $MPLAYER -alang en -dumpaudio -dumpfile $ISODIR/dvdrip.a.en -dvd-device $1 dvd://0
  $MPLAYER -alang hu -dumpaudio -dumpfile $ISODIR/dvdrip.a.hu -dvd-device $1 dvd://0
  $MPLAYER -dumpvideo -dumpfile $ISODIR/dvdrip.v -dvd-device $1 dvd://0
  $MKVMERGE -o $ISODIR/$ISONAME$POSTFIX.mkv.tmp $ISODIR/dvdrip.v --language 0:hu $ISODIR/dvdrip.a.hu --language 0:en $ISODIR/dvdrip.a.en
  mv $ISODIR/$ISONAME$POSTFIX.mkv.tmp $ISODIR/$ISONAME$POSTFIX.mkv
  rm $ISODIR/dvdrip.v $ISODIR/dvdrip.a.en $ISODIR/dvdrip.a.hu 
  synoindex -R $ISODIR
  ENDTIME=$(date +%s)
  echo "conversion took: $(($ENDTIME - $STARTTIME)) seconds"
}

for i in $(/usr/syno/pgsql/bin/psql -t -A -U admin -d download -c \
'SELECT DISTINCT Download_queue.destination, Download_queue.filename 
FROM Download_queue 
WHERE 
(((Download_queue.status)='5' or (Download_queue.status)='8'));' |sed 's/|/\//g'); 
do 
  CPATH=$BASEPATH/$i
  CISO=$(find $CPATH -iname *.iso)

  if [ -n "$CISO" ]
  then
   mkvmaking=$CPATH/mkvmaking
   mkvdone=$CPATH/mkvdone

   if [ -f $mkvmaking ]
   then
      echo "inprogress: $i"
      break
   else
      if [ -f $mkvdone ]
      then
        echo "already done: $i"
        continue
      else
        echo "starting: $i"
        touch $mkvmaking
        makemkv $CISO
        mv $mkvmaking $mkvdone
        break
      fi
   fi
  fi
   
done
</pre>

5. Setup scheduled task to run conversion script (optional)
-------------
coming soon

6. Create conversion script for command line (optional)
-------------
coming soon

test












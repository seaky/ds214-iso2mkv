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


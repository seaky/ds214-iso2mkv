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

5. Setup scheduled task to run conversion script (optional)
-------------

6. Create conversion script for command line (optional)
-------------















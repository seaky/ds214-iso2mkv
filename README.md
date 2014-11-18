ds214-iso2mkv (manual)
=============

Guide to create iso2mkv converter for your Synology ds214/ds213j and other Marvell Atmada based models.

Introduction
------------

Smart TVs does not support to play ISO-DVD media format. One of the reason could be .iso is not a media format. It's a filesystem. Moder TVs can play several format such as mpeg, avi, mkv. Obious soultion to convert .iso file to a media format supported your TV. There are tools for desktop class computers to make this process but none for embedded systems eg. NAS. Because media conversion is a highly CPU intensive process.

Some formats can encapsulate multiple media files together so called container formats eg. mkv, avi.

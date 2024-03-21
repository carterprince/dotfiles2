#!/bin/bash

mkdir -p ~/{Pictures,Documents,Videos,Audio}

mv {~/Downloads,~}/*.{png,bmp,tiff,jpg,jpeg,gif,webp,svg} ~/Pictures
mv {~/Downloads,~}/*.{pdf,docx,doc,odt,txt,org,norg,org\#,org\~} ~/Documents
mv {~/Downloads,~}/*.{mp4,webm} ~/Videos
mv {~/Downloads,~}/*.{mp3,flac,wav} ~/Audio

#!/bin/bash

mkdir -p ~/{Pictures,Documents,Videos,Audio,Data,Code}

mv {~/Downloads,~}/*.{png,bmp,tiff,jpg,jpeg,gif,webp,svg} ~/Pictures
mv {~/Downloads,~}/*.{pdf,docx,html,opml,OPML,log,tex,css,aux,doc,odt,txt,org,norg,org\#,org\~} ~/Documents
mv {~/Downloads,~}/*.{csv,xlsx,json,xml} ~/Data
mv {~/Downloads,~}/*.{py,c,r,R,cs,java} ~/Code
mv {~/Downloads,~}/*.{mp4,webm,mkv} ~/Videos
mv {~/Downloads,~}/*.{mp3,flac,wav,opus} ~/Audio

rm -rf {~/Downloads,~}/*.{class,out,part}

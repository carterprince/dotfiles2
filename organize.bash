#!/bin/bash

mkdir -p ~/{Pictures,Documents,Videos,Audio,Data,Code}

mv {~/Downloads,~}/*.{png,bmp,tiff,jpg,jpeg,gif,webp,svg} ~/Pictures
mv {~/Downloads,~}/*.{pdf,docx,html,md,opml,OPML,log,tex,css,aux,doc,odt,txt,org,norg,org\#,org\~} ~/Documents
mv {~/Downloads,~}/*.{csv,xlsx,json,xml,stata,dta} ~/Data
mv {~/Downloads,~}/*.{py,c,r,R,cs,java} ~/Code
mv {~/Downloads,~}/*.{mp4,webm,mkv} ~/Videos
mv {~/Downloads,~}/*.{mp3,flac,wav,opus} ~/Audio
mv {~/Downloads,~}/*.{safetensors,sft,ckpt} ~/.local/src/ComfyUI/unused_models

rm -rf {~/Downloads,~}/*.{class,out,part}

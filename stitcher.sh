#! /bin/sh
rm public/final.mp4
words=($1)
echo ${words[*]}
i=0
for word in "${words[@]}"
do
   first_letter="$(echo $word | head -c 1)"
   err_code=`curl http://www.handspeak.com/word/$first_letter/$word.mp4 -o $i.mp4`
   i=$((i+1))
done

ls
i=0
for orig_mp4 in *.mp4; do
   ffmpeg -i $orig_mp4 -r 20 $i.mpg
   rm $orig_mp4
   i=$((i+1))
done

cat *.mpg > public/final.mpg

ffmpeg -i public/final.mpg -r 20 public/stage.mp4
ffmpeg -i public/stage.mp4 -vf scale=920:640 public/final.mp4

rm *.mpg   
rm public/stage.mp4
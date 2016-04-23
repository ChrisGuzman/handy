rm final.mp4
words=($1)
echo ${words[*]}
for word in "${words[@]}"
do
   first_letter="$(echo $word | head -c 1)"
   err_code=`curl -O http://www.handspeak.com/word/$first_letter/$word.mp4`
   if [ err_code -ne 0]
      then
         echo "This word does not exist..."
   fi
done

i=0
for orig_mp4 in *.mp4; do
   ffmpeg -i $orig_mp4 -r 20 $i.mpg
   rm $orig_mp4
   i=$((i+1))
done

cat *.mpg > final.mpg
ffmpeg -i final.mpg -r 20 final.mp4

rm *.mpg

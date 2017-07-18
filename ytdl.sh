echo Downloading video with id: $1
youtube-dl https://www.youtube.com/watch?v=$1 -f 'bestaudio' -x --audio-format mp3 --audio-quality 0 -o "downloads/$1.%(ext)s" 2>&1 >>log
echo Downloaded video with id: $1

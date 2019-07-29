# reencode_audio_language (linux only | uses ffmpeg)
Re-encodes Audio stream to English (To be used for One Pace collections)

I noticed that some of the files in the One Pace collection have their audio stream metadata incorrectly set to English. If you are downloading One Pace to view from a Plex server, which automatically enables subtitles ONLY if the default language is not English, then these english-encoded files will not default to showing subtitles.

This simple script loops through a folder looking for .mkv files, ignores any files already encoded with Japanese audio, and re-encodes any others as Japanese.

__This script is fairly dumb. It can overwrite files improperly if not used properly. USE AT YOUR OWN DISCRETION"__

## Usage

1. Copy the file reencode_audio.sh anywhere on your computer
2. Ensure that ffmpeg is installed:
    * `sudo apt update && sudo apt install ffmpeg`
3. Set reencode_audio.sh to be executable
    * `chmod u+x reencode_audio.sh`
4. Run the script, passing in the location of the directory containing the files you'd like to reencode.
    * e.g.: `./reencode_audio.sh /tv/One\ Pace/Season\ 29/`
    
## What it does

The script will do the following for each .mkv file in a folder when run:

1. run `ffprobe` on the file, and grep the output to see if it contains the string "(jpn): Audio"
    * if found, skips the file (japanese audio exists already)
    * if not found, continue to step 2
2. run the command `ffmpeg -i "$filename" -map 0 -c copy -metadata:s:a:0 language=jpn "$tmpfilename";`
    * `$filename` is the filename for the mkv file
    * `$tmpfilename` is a temporary file to write the newly encoded file into (which is `$filename + ".tmp.mkv"`)
    * the command maps all input streams from `$filename` and copies them to `$tmpfilename` with language meta-data for the audio stream reencoded as japanese
3. if previous command successful, overwrites `$filename` with `$tmpfilename`
4. Logs all of this in `reencode_log.txt`

## Example `reencode_log.txt`

Captured after running `./reencode_audio.sh` on the Fishman Island arc, which was stored in `"/tv/One Pace/Season 29/"`.

`./reencode_audio.sh /tv/One\ Pace/Season\ 29/`

```
Re-encode Audio Log
Mon Jul 29 13:29:37 EDT 2019


/tv/One Pace/Season 29/Fishman Island 01.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 02.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 03.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 04.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 05.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 06.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 07.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 08.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 09.mkv
	SKIPPED: Japanese audio channel already exists

/tv/One Pace/Season 29/Fishman Island 10.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 11.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 12.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 13.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 14.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 15.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 16.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 17.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 18.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 19.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 20.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 21.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 22.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 23.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file


/tv/One Pace/Season 29/Fishman Island 24.mkv
	FFMPEG RESULT: 0
	SUCCESS: Overwrote original file
```

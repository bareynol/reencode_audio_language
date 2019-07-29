#!/bin/bash

# Simple Script to iterate through a folder full of MKV files
# And re-encode the English labeled audio channel to Japanese.

echo "Looking in $1 for MKV files";

LOGFILE="$1/reencode_log.txt";
echo "$LOGFILE"

echo "Re-encode Audio Log" > "$LOGFILE";
echo `date` >> "$LOGFILE";
echo -e "\n" >> "$LOGFILE";

shopt -s nullglob # if there are no .mkv files, don't include "*.mkv" in for loop
for filename in "$1"*.mkv; do
  tmpfilename="$filename.tmp.mkv";
  echo "Found $filename, testing file...";
  echo "$filename" >> "$LOGFILE";

  # Run ffprobe on file and store result
  ffproberesult=`ffprobe "$filename" 2>&1`;

  # Check ffprobe result for japanese audio channel
  if echo "$ffproberesult" | grep -q "(jpn): Audio"; then
    echo "Japanese Audio Channel for $filename FOUND. Skipping";
    echo -e "\tSKIPPED: Japanese audio channel already exists\n" >> "$LOGFILE";
    echo -e "\n\n";
    continue;
  fi

  echo "Re-encoding $filename to $tmpfilename...";

  # RE-ENCODE HAPPENDS HERE, uses ffmpeg to copy all input streams from the mkv file, and reencodes
  # the audio stream with language metadata set to japanese.
  ffmpeg -i "$filename" -map 0 -c copy -metadata:s:a:0 language=jpn "$tmpfilename";
  ffmpegresult=$?;

  echo "FFMPEG RESULT: $ffmpegresult";
  echo -e "\tFFMPEG RESULT: $ffmpegresult" >> "$LOGFILE";

  # If ffmpeg command ran successfully, overwrite original file with the created temporary file
  # Else, log that it could not complete
  if [ $ffmpegresult -eq 0 ]; then
    echo "Finished re-encoding, overwriting original file with re-encoded file...";
    mv "$tmpfilename" "$filename";
    echo -e "\tSUCCESS: Overwrote original file" >> "$LOGFILE";
  else
    echo "Error reencoding $filename. Skipping.";
    echo -e "\tERROR: Skipped" >> "$LOGFILE";
  fi
  echo -e "\n\n";
  echo -e "\n" >> "$LOGFILE";
done

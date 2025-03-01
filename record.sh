#!/bin/bash

# Defualt values
framerate=""
name=""


# Default values
framerate=30
output="output.mp4"

# Parse command-line options using getopt
# The string 'f:o:' means -f and -o require arguments
TEMP=$(getopt -o f:o: -n 'record.sh' -- "$@")

# If getopt fails, exit with an error
if [ $? != 0 ]; then
  echo "Usage: $0 -f <framerate> -o <output>"
  exit 1
fi

# Evaluate the arguments using eval
eval set -- "$TEMP"

# Process the options
while true; do
  case "$1" in
    -f)  # Handle -f (framerate)
      framerate="$2"
      shift 2
      ;;
    -o)  # Handle -o (output file)
      output="$2"
      shift 2
      ;;
    --)  # End of options
      shift
      break
      ;;
    *)  # Unknown option
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Output the parsed values
echo "Framerate: $framerate"
echo "Output file: $output"

# ximagesrc: video stream from screen and do not show mouse cursor
# videoconvert: just converts to correct format to next plugin
# x264enc: converts to h264
# mp4mux: to mp4
gst-launch-1.0 ximagesrc show-pointer=false ! video/x-raw,framerate=${framerate}/1 ! videoconvert ! x264enc ! mp4mux ! filesink location=$output -e

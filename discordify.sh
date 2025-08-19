#!/bin/bash
# discordify.sh
# Version: 0.1.0
# Usage:
#   discordify [--version] | video input_video_path [export_video_path] [-v|--verbose] [-f|--force]
# This script compresses video to be no larger than 10MB with ffmpeg,
# saving output with "_sharable" appended by default or to a custom path.
# Shows a progress bar by default with dots and logs compression start.
# Use -v/--verbose for full output and -f/--force to overwrite without prompt.
# Adds color to output messages and prints overwrite warning in orange.

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

VERSION="0.1.0"

if [[ "$1" == "--version" || "$1" == "-V" ]]; then
  echo "discordify version $VERSION"
  exit 0
fi

if [[ "$1" != "video" ]] || [[ -z "$2" ]]; then
  echo -e "${RED}Usage:${NC} $0 video {input_video_path} [export_video_path] [-v|--verbose] [-f|--force]"
  exit 1
fi

input_video="$2"
export_video=""
show_verbose=0
force_overwrite=0

# Parse optional arguments
args=("${@:3}")

for arg in "${args[@]}"; do
  case "$arg" in
    -v|--verbose)
      show_verbose=1
      ;;
    -f|--force)
      force_overwrite=1
      ;;
    *)
      if [[ -z "$export_video" ]]; then
        export_video="$arg"
      else
        echo -e "${RED}Unknown argument:${NC} $arg"
        echo -e "${RED}Usage:${NC} $0 video {input_video_path} [export_video_path] [-v|--verbose] [-f|--force]"
        exit 1
      fi
      ;;
  esac
done

if [[ ! -f "$input_video" ]]; then
  echo -e "${RED}Error:${NC} Input video file '$input_video' not found!"
  exit 1
fi

# Set output filename if not provided
if [[ -z "$export_video" ]]; then
  extension="${input_video##*.}"
  filename="${input_video%.*}"
  export_video="${filename}_sharable.${extension}"
fi

# Check if output file exists and prompt unless forced
if [[ -f "$export_video" && $force_overwrite -eq 0 ]]; then
  echo -e "${ORANGE}Warning:${NC} Output file '$export_video' already exists."
  read -rp "Overwrite? (y/N): " answer
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo -e "${ORANGE}Aborted to avoid overwriting existing file.${NC}"
    exit 1
  fi
fi

# Get input video duration in seconds (float)
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_video")
if [[ -z "$duration" ]]; then
  echo -e "${RED}Error:${NC} Could not get video duration."
  exit 1
fi

# Target max file size in bytes (10MB)
max_size_bytes=$((10*1024*1024))

# Calculate total bitrate kbps (video + audio)
audio_bitrate=128
total_bitrate=$(echo "scale=2; ($max_size_bytes*8)/$duration/1000" | bc)

# Video bitrate target kbps
video_bitrate=$(echo "$total_bitrate - $audio_bitrate" | bc)

min_video_bitrate=100
video_bitrate_int=$(printf "%.0f" $video_bitrate)
if (( video_bitrate_int < min_video_bitrate )); then
  video_bitrate_int=$min_video_bitrate
fi

# Get input file size for logging (human readable)
filesize=$(du -h "$input_video" | cut -f1)
base_filename=$(basename "$input_video")

# Log start message with color
echo -ne "${BLUE}Compressing${NC} ${GREEN}${base_filename^}${NC} (${filesize})"

if (( show_verbose )); then
  # Verbose full output
  ffmpeg -y -i "$input_video" -c:v libx264 -b:v "${video_bitrate_int}k" -bufsize "${video_bitrate_int}k" -maxrate "${video_bitrate_int}k" -preset slow -c:a aac -b:a "${audio_bitrate}k" "$export_video"
else
  # Quiet with progress dots
  ffmpeg -y -hide_banner -v error -progress pipe:1 -i "$input_video" -c:v libx264 -b:v "${video_bitrate_int}k" -bufsize "${video_bitrate_int}k" -maxrate "${video_bitrate_int}k" -preset slow -c:a aac -b:a "${audio_bitrate}k" "$export_video" | \
  while IFS= read -r line; do
    case "$line" in
      progress=continue)
        echo -n "."
        ;;
      progress=end)
        echo -e "\n${GREEN}Compression complete.${NC} Output saved to: ${BLUE}$export_video${NC}"
        ;;
    esac
  done
fi

exit 0


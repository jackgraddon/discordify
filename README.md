# discordify

A WIP CLI tool to compress video files for the lowly Discord user.

## Overview

`discordify` is a simple command-line script to compress videos to a maximum file size of 10MB—ideal for sharing on Discord, which has file size limits. It uses `ffmpeg` to re-encode videos with an optimized bitrate to meet this target, while preserving reasonable video quality.

## Features

- Compress any video to ≤10MB target size.
- Automatically calculates required bitrate based on input video duration.
- Saves output file with `_sharable` appended by default.
- Option to specify custom output filename or path.
- Progress bar with simple dot animation for non-verbose mode.
- Verbose mode to show full ffmpeg output.
- File overwrite warning with option to force overwrite.
- Colorized terminal output for improved readability.

## Requirements

- `bash` shell environment
- `ffmpeg` with `ffprobe` installed and accessible in your PATH
- `curl` or `wget` (for installation script)

## Installation

### Manual Install

Download the script and put it in your system executable path:

```
curl -Lo /usr/local/bin/discordify https://raw.githubusercontent.com/jackgraddon/discordify/main/discordify.sh && chmod +x /usr/local/bin/discordify
```

### Install via Script

You can use the provided install script to install easily:

```
chmod +x install-discordify.sh
sudo ./install-discordify.sh
```

The `install-discordify.sh` script downloads the latest `discordify.sh` to `/usr/local/bin/discordify` and sets executable permissions.

### One-liner Install

Run this command to download and run the installer in one step (requires sudo):

Using `curl`:

```
curl -fsSL https://raw.githubusercontent.com/jackgraddon/discordify/main/install-discordify.sh | sudo bash
```

Or using `wget`:

```
wget -qO- https://raw.githubusercontent.com/jackgraddon/discordify/main/install-discordify.sh | sudo bash
```

## Usage

```
discordify video input_video_path [export_video_path] [-v|--verbose] [-f|--force]
```

- `input_video_path`: Path to the input video file to compress.
- `export_video_path` *(optional)*: Custom path or filename for the compressed output.
- `-v` or `--verbose` *(optional)*: Show full ffmpeg output instead of progress dots.
- `-f` or `--force` *(optional)*: Overwrite output file without prompting.

## Examples

1. Compress a video with default output filename:

   ```
   discordify video myvideo.mp4
   ```

2. Compress with a custom output filename:

   ```
   discordify video myvideo.mp4 compressed_video.mp4
   ```

3. Compress with verbose ffmpeg output:

   ```
   discordify video myvideo.mp4 -v
   ```

4. Force overwrite an existing output file without prompt:

   ```
   discordify video myvideo.mp4 -f
   ```

## Notes

- The script calculates the bitrate dynamically to fit the compressed video into a 10MB file size limit.
- Audio bitrates are fixed at 128 kbps; video bitrate adjusts based on video duration.
- By default, the output filename appends `_sharable` before the file extension.

## Version

Currently at version 0.1.0.

## License

This project is a Work In Progress (WIP) and provided as-is without warranties.

---

Built with ❤️ for Discord users who need manageable video sizes.

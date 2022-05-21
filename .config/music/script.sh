#!/usr/bin/env bash

yt-dlp --download-archive download-cache.txt \
	--batch-file playlists.conf \
	-o "$HOME/Music/dl/%(playlist_title)s/%(title)s - %(uploader)s.%(ext)s" \
	--no-overwrites \
	--embed-thumbnail \
	--extract-audio \
	--audio-format mp3 \
	--audio-quality 0

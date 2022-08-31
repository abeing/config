if status is-interactive
    # Commands to run in interactive sessions can go here
end

function bc-dl
    yt-dlp -o '%(artist)s - %(album)s - %(track_number)02d - %(track)s.mp3' $argv
end

function sdl
    python -m spotdl "https://open.spotify.com/album/"$argv
end

fish_add_path ~/bin

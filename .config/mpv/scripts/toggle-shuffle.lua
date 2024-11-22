local mp = require 'mp'

local cli_shuffled = mp.get_property_native("shuffle")
local is_shuffled = cli_shuffled
local initial_check_done = false

local audio_extensions = {mp3 = true, wav = true, flac = true, ogg = true, aac = true, m4a = true}

local function all_audio_files()
    local playlist_count = mp.get_property_number("playlist-count", 0)
    for i = 0, playlist_count - 1 do
        local path = mp.get_property(string.format("playlist/%d/filename", i))
        if path then
            local ext = path:match("^.+%.(.+)$")
            if not ext or not audio_extensions[ext:lower()] then
                return false
            end
        end
    end
    return true
end

local function unshuffle()
    mp.command('playlist-unshuffle')
    is_shuffled = false
    mp.osd_message('Playlist unshuffled')
end

local function shuffle()
    mp.command('playlist-shuffle')
    is_shuffled = true
    mp.osd_message('Playlist shuffled')
end

local function toggle_shuffle()
    if is_shuffled then
        unshuffle()
    else
        shuffle()
    end
end

mp.register_event("file-loaded", function()
    if not initial_check_done then
        if not is_shuffled and all_audio_files() then
            shuffle()
        end
        initial_check_done = true
    end
end)

mp.add_key_binding(nil, 'toggle-shuffle', toggle_shuffle)

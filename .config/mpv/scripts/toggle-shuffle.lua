-- shuffle-toggle.lua
local mp = require 'mp'

-- Variable to track shuffle state
local is_shuffled = false

-- Function to toggle between shuffle and unshuffle
local function toggle_shuffle()
    if is_shuffled then
        -- If currently shuffled, unshuffle
        mp.command('playlist-unshuffle')
        is_shuffled = false
        mp.osd_message('Playlist unshuffled')
    else
        -- If currently unshuffled, shuffle
        mp.command('playlist-shuffle')
        is_shuffled = true
        mp.osd_message('Playlist shuffled')
    end
end

-- Bind the toggle function to a key
mp.add_key_binding(nil, 'toggle-shuffle', toggle_shuffle)

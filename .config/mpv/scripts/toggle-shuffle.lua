-- toggle-shuffle.lua
-- Toggles shuffle mode for the playlist in MPV. Restores original order on toggle off.

local mp = require 'mp'

-- Variables to track state
local original_order = nil
local shuffle_active = false

-- Function to save the current playlist order
local function save_playlist_order()
    local playlist = {}
    local count = mp.get_property_number("playlist-count", 0)
    for i = 0, count - 1 do
        playlist[i] = mp.get_property("playlist/" .. i .. "/filename")
    end
    return playlist
end

-- Function to restore the saved playlist order
local function restore_playlist_order(order)
    if not order then return end

    -- Map filenames to their original indices
    local index_map = {}
    for i, filename in pairs(order) do
        index_map[filename] = i
    end

    local count = mp.get_property_number("playlist-count", 0)
    for i = 0, count - 1 do
        local current_filename = mp.get_property("playlist/" .. i .. "/filename")
        local original_index = index_map[current_filename]
        if original_index and original_index ~= i then
            mp.commandv("playlist-move", i, original_index)
        end
    end
end

-- Function to shuffle the playlist
local function shuffle_playlist()
    mp.command("playlist-shuffle")
end

-- Main toggle function
local function toggle_shuffle()
    if shuffle_active then
        -- Restore original order
        restore_playlist_order(original_order)
        original_order = nil
        shuffle_active = false
        mp.osd_message("Shuffle Off: Playlist order restored")
    else
        -- Save original order and shuffle
        original_order = save_playlist_order()
        shuffle_playlist()
        shuffle_active = true
        mp.osd_message("Shuffle On: Playlist shuffled")
    end
end

-- Bind the toggle function to a script-binding
mp.add_key_binding(nil, "toggle-shuffle", toggle_shuffle)

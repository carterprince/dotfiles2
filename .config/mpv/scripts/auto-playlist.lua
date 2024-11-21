local utils = require 'mp.utils'

mp.register_event("start-file", function()
    -- Get the directory of the currently playing file
    local path = mp.get_property("path")
    if not path then return end

    local dir, filename = utils.split_path(path)
    if not dir then return end

    -- List all files in the directory
    local files = utils.readdir(dir, "files")
    if not files then return end

    -- Sort files alphabetically
    table.sort(files)

    -- Add all files to the playlist
    for _, file in ipairs(files) do
        if file ~= filename then
            mp.commandv("loadfile", utils.join_path(dir, file), "append")
        end
    end
end)

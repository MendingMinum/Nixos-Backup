local mp = require 'mp'

function save_playlist()
    local playlist = mp.get_property_native("playlist")
    if not playlist or #playlist == 0 then
        mp.osd_message("empty")
        return
    end

    local playlist_dir = os.getenv("HOME") .. "/playlist"
    local sep = package.config:sub(1,1)
	
    
    os.execute('mkdir -p "' .. playlist_dir .. '"')	
	
    
    local i = 1
    local filename = ""
    while true do
        filename = playlist_dir .. sep .. "playlist" .. i .. ".m3u"
        local f = io.open(filename, "r")
        if f ~= nil then
            f:close()
            i = i + 1
        else
            break
        end
    end

    local file, err = io.open(filename, "w")
    if not file then
        mp.osd_message("fail open file: " .. err)
        return
    end

    file:write("#EXTM3U\n")

    for _, entry in ipairs(playlist) do
        local path = entry.filename or entry.path or entry.url or ""
        local title = entry.title or path
        local duration = entry.duration or -1
        file:write(string.format("#EXTINF:%d,%s\n", duration, title))
        file:write(path .. "\n")
    end

    file:close()
    mp.osd_message("Playlist save " .. filename)
end

mp.add_key_binding("Ctrl+s", "save-playlist", save_playlist)


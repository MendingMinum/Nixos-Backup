local mp = require 'mp'

local show = false
local timer = nil

local brightness_original = mp.get_property_number("brightness", 0)

local function format_time(seconds)
    if seconds == nil or seconds < 0 then return "00:00" end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    else
        return string.format("%02d:%02d", m, s)
    end
end

local function strip_extension(filename)
    return filename:gsub("%.[^%.]+$", "") 
end

local function update()
    local pos = mp.get_property_number("time-pos", 0)
    local dur = mp.get_property_number("duration", 0)
    local vol = mp.get_property_number("volume", 100) or 0

    if dur == 0 then
        mp.set_osd_ass(1280, 720, "")
        return
    end

    local bar_width = 30
    local filled = math.floor((pos / dur) * bar_width)
    local empty = bar_width - filled
    local bar = string.rep("█", filled) .. string.rep("─", empty)

    local time_start = format_time(pos)
    local time_end = format_time(dur)

    local text = string.format("%s %s %s", time_start, bar, time_end)

    
    local filename = mp.get_property("filename/no-ext", "")

    
    local ass_bar = string.format("{\\an5\\fs36\\bord2\\shad1\\1c&HFFFFFF&\\3c&H000000&\\pos(640,340)}%s", text)

    
    local ass_title = string.format("{\\an5\\fs48\\bord1\\shad1\\1c&HFFFFFF&\\3c&H000000&\\pos(640,370)}%s", filename)

    
    local ass_vol = string.format("{\\an5\\fs32\\bord1\\shad1\\1c&HFFFFFF&\\3c&H000000&\\pos(640,400)}Volume: %d%%", vol)

    
    local ass = ass_bar .. "\\N" .. ass_title .. "\\N" .. ass_vol

    mp.set_osd_ass(1280, 720, ass)
end

local function toggle()
    show = not show
    if show then
        
        mp.command("script-message osc-visibility never")

        
        brightness_original = mp.get_property_number("brightness", 0)
        gamma_original = mp.get_property_number("gamma", 0)
        saturation_original = mp.get_property_number("saturation", 100)
        contrast_original = mp.get_property_number("contrast", 100)

        
        mp.set_property_number("brightness", -100)
        mp.set_property_number("gamma", -100)
        mp.set_property_number("saturation", -100)
        mp.set_property_number("contrast", -100)

        update()
        timer = mp.add_periodic_timer(0.2, update)
    else
        if timer then
            timer:kill()
            timer = nil
        end
        
        mp.command("script-message osc-visibility auto")

        
        mp.set_property_number("brightness", brightness_original)
        mp.set_property_number("gamma", gamma_original)
        mp.set_property_number("saturation", saturation_original)
        mp.set_property_number("contrast", contrast_original)

        mp.set_osd_ass(1280, 720, "")
    end
end

mp.add_key_binding("ctrl+b", "toggle_duration_bar_inline", toggle)


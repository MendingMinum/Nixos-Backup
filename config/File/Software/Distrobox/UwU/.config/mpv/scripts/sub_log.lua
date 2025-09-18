local mp = require 'mp'

local last_text = ""

function log_subtitle(name, value)
    if value ~= nil and value ~= "" and value ~= last_text then
        last_text = value
        print(string.format("[%s] %s", mp.get_property_osd("time-pos"), value))
    end
end

mp.observe_property("sub-text", "string", log_subtitle)

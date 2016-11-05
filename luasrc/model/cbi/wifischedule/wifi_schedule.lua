-- Copyright (c) 2016, prpl Foundation
--
-- Permission to use, copy, modify, and/or distribute this software for any purpose with or without
-- fee is hereby granted, provided that the above copyright notice and this permission notice appear
-- in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
-- INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
-- FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
-- LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
-- ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--
-- Author: Nils Koenig <mail_openwrt@newk.it>

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end


function time_validator(self, value, desc)
    if value ~= nil then
        
        h_str, m_str = string.match(value, "^(%d%d?):(%d%d?)$")
        h = tonumber(h_str)
        m = tonumber(m_str)
        if ( h ~= nil and
             h >= 0   and
             h <= 23  and
             m ~= nil and
             m >= 0   and
             m <= 59) then
            return value
        end
    end 
    return nil, translate("The value '" .. desc .. "' is invalid")
end

-- -------------------------------------------------------------------------------------------------

-- BEGIN Map
m = Map("wifi_schedule", translate("Wifi Schedule"), translate("Defines a schedule when to turn on and off wifi.")) 
function m.on_commit(self)
    luci.sys.exec("/usr/bin/wifi_schedule.sh cron")
end
-- END Map

-- BEGIN Global Section
global_section = m:section(TypedSection, "global", "Global")
global_section.optional = false
global_section.rmempty = false
global_section.anonymous = true
-- END Section

-- BEGIN Global Enable Checkbox
global_enable = global_section:option(Flag, "enabled", translate("Enable Wifi Schedule"))
global_enable.optional=false; 
global_enable.rmempty = false;

function global_enable.validate(self, value, global_section)
    if value == "1" then
        if file_exists("/sbin/wifi") then
            return value
        else
            return nil, translate("Could not find required /sbin/wifi")
        end
    else
        return "0"
    end
end
-- END Global Enable Checkbox


-- BEGIN Logging Checkbox
global_logging = global_section:option(Flag, "logging", translate("Enable logging"))
global_logging.optional=false; 
global_logging.rmempty = false;
global_logging.default = 0
-- END Global Enable Checkbox

-- BEGIN Section
d = m:section(TypedSection, "entry", "Schedule events")
d.addremove = true  
--d.anonymous = true
-- END Section

-- BEGIN Enable Checkbox
c = d:option(Flag, "enabled", translate("Enable"))
c.optional=false; c.rmempty = false;
-- END Enable Checkbox


-- BEGIN Day(s) of Week
dow = d:option(MultiValue, "daysofweek", translate("Day(s) of Week"))
dow.optional = false
dow.rmempty = false
dow:value("Monday")
dow:value("Tuesday")
dow:value("Wednesday")
dow:value("Thursday")
dow:value("Friday")
dow:value("Saturday")
dow:value("Sunday")
-- END Day(s) of Weel

-- BEGIN Start Wifi Dropdown
starttime =  d:option(Value, "starttime", translate("Start WiFi"))
starttime.optional=false; 
starttime.rmempty = false;
starttime:value("00:00")
starttime:value("01:00")
starttime:value("02:00")
starttime:value("03:00")
starttime:value("04:00")
starttime:value("05:00")
starttime:value("06:00")
starttime:value("07:00")
starttime:value("08:00")
starttime:value("09:00")
starttime:value("10:00")
starttime:value("11:00")
starttime:value("12:00")
starttime:value("13:00")
starttime:value("14:00")
starttime:value("15:00")
starttime:value("16:00")
starttime:value("17:00")
starttime:value("18:00")
starttime:value("19:00")
starttime:value("20:00")
starttime:value("21:00")
starttime:value("22:00")
starttime:value("23:00")

function starttime.validate(self, value, d)
    return time_validator(self, value, translate("Start Time"))
end

-- END Start Wifi Dropdown


-- BEGIN Stop Wifi Dropdown
stoptime =  d:option(Value, "stoptime", translate("Stop WiFi"))
stoptime.optional=false;
stoptime.rmempty = false;
stoptime:value("00:00")
stoptime:value("01:00")
stoptime:value("02:00")
stoptime:value("03:00")
stoptime:value("04:00")
stoptime:value("05:00")
stoptime:value("06:00")
stoptime:value("07:00")
stoptime:value("08:00")
stoptime:value("09:00")
stoptime:value("10:00")
stoptime:value("11:00")
stoptime:value("12:00")
stoptime:value("13:00")
stoptime:value("14:00")
stoptime:value("15:00")
stoptime:value("16:00")
stoptime:value("17:00")
stoptime:value("18:00")
stoptime:value("19:00")
stoptime:value("20:00")
stoptime:value("21:00")
stoptime:value("22:00")
stoptime:value("23:00")

function stoptime.validate(self, value, d)
    return time_validator(self, value, translate("Stop Time"))
end
-- END Stop Wifi Dropdown


-- BEGIN Force Wifi Stop Checkbox
force_wifi = d:option(Flag, "forcewifidown", translate("Force disabling wifi even if stations associated"))
force_wifi.default = false
force_wifi.rmempty = false;

function force_wifi.validate(self, value, d)
    if value == "0" then
        if file_exists("/usr/sbin/iw") then
            return value
        else
            return nil, translate("Could not find required programm /usr/sbin/iw")
        end
    else
        return "1"
    end
end
-- END Force Wifi Checkbox


return m

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local awesome, client, os = awesome, client, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}

--Gaps
theme.gap_single_client            							= false -- No gaps for single client
theme.useless_gap                               = dpi(4)

--Themes vars
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/spekuro-home"
theme.wallpaper                                 = "~/Images/Wallpapers/wall.png"
theme.font                                      = "Montserrat SemiBold 10"
theme.icon_font                                 = "IcoMoon-Free 12"
theme.icon_theme																=	"Vimix"
theme.fg_normal                                 = "#7c7977"
theme.fg_focus                                  = "#BBBBBB"
theme.bg_wibox																	= "#00000066"
theme.bg_normal                                 = "#1D1F2066"
theme.bg_focus                                  = "#35394500"
theme.fg_urgent                                 = "#21232900"
theme.bg_urgent                                 = "#CC6666"
theme.border_width                              = dpi(3)
theme.border_normal                             = "#1D1F2199"
theme.border_focus                              = "#BBBBBB"
theme.taglist_bg_focus                          = "#BBBBBB"
theme.taglist_bg_normal                         = "#21232900"
theme.taglist_fg_focus                          = "#01061a" -- Get with color pick
theme.bg_systray 																= "#020d25" -- Get with color pick
theme.disk                                      = theme.dir .. "/icons/custom/disk.svg"
theme.clock                                     = theme.dir .. "/icons/custom/clock.svg"
theme.calendar                                  = theme.dir .. "/icons/custom/calendar.svg"
theme.vol                                       = theme.dir .. "/icons/custom/volume-level-high.svg"
theme.vol_low                                   = theme.dir .. "/icons/custom/volume-level-medium.svg"
theme.vol_no                                    = theme.dir .. "/icons/custom/volume-level-low.svg"
theme.vol_mute                                  = theme.dir .. "/icons/custom/volume-level-muted.svg"
theme.ac                                        = theme.dir .. "/icons/custom/battery-full-charging.svg"
theme.bat                                       = theme.dir .. "/icons/custom/battery-100.svg"
theme.bat_low                                   = theme.dir .. "/icons/custom/battery-040.svg"
theme.bat_no                                    = theme.dir .. "/icons/custom/battery-000.svg"
theme.layout_tile                               = theme.dir .. "/icons/custom/layouts/tile232.png"
theme.layout_fairv                              = theme.dir .. "/icons/custom/layouts/fairv232.png"
theme.layout_max                                = theme.dir .. "/icons/custom/layouts/max232.png"

local markup = lain.util.markup
local red    = "#CC6666"
--local green  = "#B5BD68"
local green  = theme.fg_focus

--Notifications
theme.notification_border_width    = dpi(0)
theme.notification_bg              = "#1D1F2190"
theme.notification_border_color    = "#1D1F2190"
theme.notification_fg              = "#FFFFFF"
theme.notification_icon_size       = 24
theme.notification_width           = 256

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock("<span font='Montserrat SemiBold 5'> </span> %H:%M ")
mytextclock.font = theme.font
local clockicon = wibox.widget.imagebox(theme.clock)

os.setlocale(os.getenv("LANG")) -- to localize the calendar
local mytextcalendar = wibox.widget.textclock("<span font='Montserrat SemiBold 5'> </span> %d %B %Y ")
mytextcalendar.font = theme.font
local calendaricon = wibox.widget.imagebox(theme.calendar)

-- Battery
local baticon = wibox.widget.imagebox(theme.bat)
local batbar = wibox.widget {
    forced_height    = dpi(1),
    forced_width     = dpi(59),
    color            = theme.fg_focus,
    background_color = theme.bg_systray,
    margins          = 1,
    paddings         = 1,
    ticks            = true,
    ticks_size       = dpi(6),
    widget           = wibox.widget.progressbar,
}
local batupd = lain.widget.bat({
    settings = function()
        if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then return end

        if bat_now.status == "Charging" then
            baticon:set_image(theme.ac)
            if bat_now.perc >= 98 then
                batbar:set_color(green)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_focus)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_focus)
            else
                batbar:set_color(red)
            end
        else
            if bat_now.perc >= 98 then
                batbar:set_color(green)
            elseif bat_now.perc > 50 then
                batbar:set_color(theme.fg_focus)
                baticon:set_image(theme.bat)
            elseif bat_now.perc > 15 then
                batbar:set_color(theme.fg_focus)
                baticon:set_image(theme.bat_low)
            else
                batbar:set_color(red)
                baticon:set_image(theme.bat_no)
            end
        end
        batbar:set_value(bat_now.perc / 100)
    end
})
local batbg = wibox.container.background(batbar, "#35394500", gears.shape.rectangle)
local batwidget = wibox.container.margin(batbg, dpi(6), dpi(6), dpi(6), dpi(6))

-- / fs
local fsicon = wibox.widget.imagebox(theme.disk)
local fsbar = wibox.widget {
    forced_height    = dpi(1),
    forced_width     = dpi(59),
    color            = theme.fg_focus,
    background_color = theme.bg_systray,
    margins          = 1,
    paddings         = 1,
    ticks            = true,
    ticks_size       = dpi(6),
    widget           = wibox.widget.progressbar,
}
theme.fs = lain.widget.fs {
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = theme.font },
    settings  = function()
        if fs_now["/"].percentage < 85 then
            fsbar:set_color(theme.fg_focus)
        else
            fsbar:set_color(red)
        end
        fsbar:set_value(fs_now["/"].percentage / 100)
    end
}
local fsbg = wibox.container.background(fsbar, "#35394500", gears.shape.rectangle)
local fswidget = wibox.container.margin(fsbg, dpi(6), dpi(6), dpi(6), dpi(6))


-- ALSA volume bar
local volicon = wibox.widget.imagebox(theme.vol)
theme.volume = lain.widget.alsabar {
    width = dpi(59), border_width = 0, ticks = true, ticks_size = dpi(6),
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = theme.font },
    --togglechannel = "IEC958,3",
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.vol_mute)
        elseif volume_now.level == 0 then
            volicon:set_image(theme.vol_no)
        elseif volume_now.level <= 50 then
            volicon:set_image(theme.vol_low)
        else
            volicon:set_image(theme.vol)
        end
    end,
    colors = {
        background   = theme.bg_systray,
        mute         = red,
        unmute       = theme.fg_focus
    }
}
theme.volume.bar:buttons(my_table.join (
          awful.button({}, 3, function()
            awful.spawn(string.format("%s -e pavucontrol", awful.util.terminal))
          end),
          awful.button({}, 2, function()
            os.execute(string.format("%s -D pulse set %s 100%%", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 1, function()
            os.execute(string.format("%s -D pulse set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 4, function()
            os.execute(string.format("%s -D pulse set %s 5%%+", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 5, function()
            os.execute(string.format("%s -D pulse set %s 5%%-", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end)
))
local volumebg = wibox.container.background(theme.volume.bar, "#35394500", gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, dpi(6), dpi(6), dpi(6), dpi(6))

-- Systray
local systray   = wibox.widget.systray()
local systraywidget = wibox.widget.systray()
systray.visible = true

-- Separators
local spr       = wibox.widget.textbox(' ')
local bar		    = wibox.widget.textbox(markup.font("Montserrat SemiBold 12", " | "))

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Tags layouts
    awful.util.tagnames = {"", "", "", "", "" , ""}
		awful.layout.layouts = {awful.layout.suit.fair,	awful.layout.suit.tile,	awful.layout.suit.max}
    local layouts = awful.layout.layouts 
    awful.tag(awful.util.tagnames, s, { layouts[3], layouts[1], layouts[1], layouts[3], layouts[1], layouts[3] })

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = {
            font    = theme.icon_font,
            shape = gears.shape.rectangle,
            bg_normal = theme.bg_focus,
            bg_focus = "#BBBBBB",
            shape_border_width = 0,
            shape_border_color = theme.bg_focus,
            margins = 0,
            align = "center",
        },
        layout   = {
            spacing = 4,
            forced_num_rows = 1,
            layout = wibox.layout.grid.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
										left   = 8,
										right  = 0,
										top    = 0,
										bottom = 0,                    
                    widget  = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            id              = 'background_role',
            forced_width    = 32,
            forced_height   = 24,
            widget          = wibox.container.background,
        },
        buttons = awful.util.taglist_buttons,
    }


    -- Create a tasklist widget
		s.mytasklist = awful.widget.tasklist {
				screen  = s,
				filter  = awful.widget.tasklist.filter.currenttags,
				style   = {
						font    = theme.font,
						shape = gears.shape.rectangle,
						bg_normal = theme.bg_focus,
						bg_focus = "#BBBBBB",
						shape_border_width = 0,
						shape_border_color = theme.bg_focus,
						margins = 0,
						align = "left",
				},
        layout   = {
            spacing = 4,
            forced_num_rows = 1,
            layout = wibox.layout.grid.horizontal
        },
        widget_template = {
            {
            {
                {
                    {
                        id     = 'clienticon',
                        widget = awful.widget.clienticon,
                    },
                    margins = 3,
                    widget  = wibox.container.margin,
                },
--                {
--                    id     = 'text_role',
--                    widget = wibox.widget.textbox,
--                },
                layout = wibox.layout.fixed.horizontal,
            },

                margins = 0,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = 32,
            forced_height   = 32,
            widget          = wibox.container.background,
						create_callback = function(self, c, index, objects)
						local tooltip = awful.tooltip {
							objects = { self },
							timer_function = function()
								return c.name
							end,
						}
	  	    	tooltip.align = "left"
		 	      tooltip.mode = "outside"
			      tooltip.preferred_positions = {"left"}
						tooltip.margins = dpi(4)
						tooltip.border_width = dpi(4)
						tooltip.border_color = "#00000095"
						end,
        },
				buttons = awful.util.tasklist_buttons,
		}


theme.tooltip_bg = "#00000095"
theme.tooltip_fg = theme.fg_focus

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(24), bg = theme.bg_wibox, fg = theme.fg_focus , border_width = dpi(0), border_color = theme.bg_wibox})
    s.mywiboxbot = awful.wibar({ position = "bottom", screen = s, height = dpi(32), bg = theme.bg_wibox, fg = theme.fg_focus , border_width = dpi(0), border_color = theme.bg_wibox})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { 
					-- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            spr,
        },
					-- Middle widget
						spr,
        { 
					-- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systraywidget,
						spr,
            volicon,
            volumewidget,
            spr,
            fsicon,
            fswidget,
            spr,
            baticon,
            batwidget,
            spr,
            calendaricon,
            mytextcalendar,
            spr,
						clockicon,
            mytextclock,
            spr,
        },
    }

    s.mywiboxbot:setup {
        layout = wibox.layout.align.horizontal,
        {
          -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
          -- Middle widget
            s.mytasklist,
        {
          -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr,
            s.mylayoutbox,
            spr,
        },
    }

end

return theme

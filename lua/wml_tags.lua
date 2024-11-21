function wesnoth.wml_actions.fade_out_music(cfg)
    local duration = cfg.duration

    if duration == nil then
        duration = 1000
    end

    duration = duration - 10

    local delay_granularity = 10

    duration = math.max(delay_granularity, duration)
    local rem = duration % delay_granularity

    if rem ~= 0 then
        duration = duration - rem
    end

    local steps = duration / delay_granularity

    for k = 1, steps do
        local v = mathx.round(100 - (100*k / steps))
        wesnoth.music_list.volume = v
        wesnoth.delay(delay_granularity)
    end

    wesnoth.music_list.clear()

    if wesnoth.music_list.current then
        wesnoth.music_list.current.ms_after = 0
    end

    wesnoth.music_list.add("silence.ogg", true)

    wesnoth.delay(10)

    wesnoth.music_list.volume = 100.0
end

local function wml_sfx_volume_fade_internal(duration, is_fade_out)
    if duration == nil then
        duration = 1000
    end

    local delay_granularity = 10

    duration = math.max(delay_granularity, duration)
    duration = duration - (duration % delay_granularity)

    local steps = duration / delay_granularity

    for k = 1, steps do
        local v = 0

        if is_fade_out then
            v = mathx.round(100 - (100*k / steps))
        else
            v = mathx.round(100*k / steps)
        end

        wesnoth.sound_volume(v)

        wesnoth.delay(delay_granularity)
    end
end

local T = wml.tag

function wesnoth.wml_actions.transient_message(cfg)
    local dd = {
        maximum_width = 800,
        maximum_height = 600,
        click_dismiss = true,
        T.helptip { id="tooltip_large" },
        T.tooltip { id="tooltip_large" },

        T.grid {
            T.row {
                T.column {
                    border = "all", border_size = 5,
                    horizontal_alignment = "center",
                    vertical_alignment = "center",
                    T.image { id = "image" }
                },
                T.column {
                    vertical_alignment = "top",
                    horizontal_alignment = "left",
                    T.grid {
                        T.row {
                            T.column {
                                border = "all", border_size = 5,
                                vertical_alignment = "top",
                                horizontal_alignment = "left",
                                T.label {
                                    id = "caption",
                                    definition = "title"
                                }
                            }
                        },
                        T.row {
                            T.column {
                                border = "all", border_size = 5,
                                vertical_alignment = "top",
                                horizontal_alignment = "left",
                                T.label {
                                    id = "message",
                                    definition = "wml_message",
                                    wrap = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    local transparent = cfg.transparent
    if transparent == nil then transparent = true end

    if transparent then
        dd.definition = "message"
    end

    local caption = cfg.caption
    if caption == nil then caption = "" end
    local message = cfg.message
    if message == nil then message = "" end

    local function preshow()
        wesnoth.set_dialog_value(caption, "caption")
        wesnoth.set_dialog_value(message, "message")
        wesnoth.set_dialog_markup(true, "message")

        if cfg.image ~= nil and tostring(cfg.image):len() > 0 then
            wesnoth.set_dialog_value(cfg.image, "image")
        else
            wesnoth.set_dialog_visible(false, "image")
        end
    end

    local sound = cfg.sound
    if sound ~= nil then wesnoth.play_sound(sound) end

    wesnoth.show_dialog(dd, preshow, nil)
end

_G.PerfectFOV = _G.PerfectFOV or {}
PerfectFOV.ModPath = ModPath

local MINIMUM_FOV = 55
local MAXIMUM_FOV = 160

-- don't change this
local GAME_DEFAULT_FOV = 65

function PerfectFOV:ApplyFOV(fov)
    local multiplier = fov / GAME_DEFAULT_FOV
    managers.user:set_setting("fov_multiplier", multiplier)
    if alive(managers.player:player_unit()) then
        managers.player:player_unit():movement():current_state():update_fov_external()
    end
end

function PerfectFOV:GetCurrentFOV()
    if not managers.user then
        return nil
    end

    return GAME_DEFAULT_FOV * managers.user:get_setting("fov_multiplier")
end

Hooks:PostHook(MenuOptionInitiator, "modify_adv_video", "PerfectFOVChangeBaseGameSelectorRemoveOldOne", function(self, node)
    local fov_multiplier_item = node:item("fov_multiplier")
    
    if not fov_multiplier_item then
        return
    end

    node:delete_item("fov_multiplier")
end)

Hooks:PostHook(MenuOptionInitiator, "modify_video", "PerfectFOVChangeBaseGameSelector", function(self, node)
    local fov_multiplier_item = node:item("fov_multiplier")
    
    if not fov_multiplier_item then
        return
    end

    log("[PerfectFOV] Menu setup thingie uwu")

    function MenuCallbackHandler:on_change_fov_value(pfov_item)
        local fov_value = pfov_item:value()

        -- we doin' some string math TM :sunglasses:
        fov_value = tonumber(string.format("%.1f", fov_value))

        pfov_item:set_value(fov_value)

        PerfectFOV:ApplyFOV(fov_value)
    end

    local fov_multiplier_item_params = fov_multiplier_item:parameters()

    local params = {
        name = "pfov_value",
        text_id = fov_multiplier_item_params.text_id,
        help_id = fov_multiplier_item_params.help_id,
        callback = "on_change_fov_value",
        filter = false
    }

    node:delete_item("fov_multiplier")

    local data_node = {
        type = "CoreMenuItemSlider.ItemSlider",
        show_value = true,
        min = MINIMUM_FOV,
        max = MAXIMUM_FOV,
        step = 0.1,
        decimal_count = 1
    }

    local pfov_item = node:create_item(data_node, params)
    pfov_item:set_value(PerfectFOV:GetCurrentFOV() or GAME_DEFAULT_FOV)
    node:insert_item(pfov_item, 6)
end)

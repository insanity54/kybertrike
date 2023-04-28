-- Define the tool
minetest.register_tool("kybertrike:dampener", {
    description = "Inertial Dampener",
    inventory_image = "kybertrike_dampener.png",
    groups = {not_in_creative_inventory = 1},
    sound = {
        breaks = {
            name = "kybertrike_dampener_break3",
            gain = 1
        },
        punch_use_air = {
            name = "kybertrike_dampener_break3",
            gain = 1
        },
    }
})

minetest.register_tool("kybertrike:dampener_alt", {
    description = "Inertial Dampener",
    inventory_image = "kybertrike_dampener_alt.png",
    groups = {not_in_creative_inventory = 1},
    sound = {
        breaks = {
            name = "kybertrike_dampener_break3",
            gain = 1
        },
        punch_use_air = {
            name = "kybertrike_dampener_break3",
            gain = 1
        },
    }
})

-- Define the crafting recipe
minetest.register_craft({
    output = "kybertrike:dampener",
    recipe = {
        {"", "default:mese_crystal_fragment", ""},
        {"", "default:snow", ""},
        {"", "default:cactus", ""},
    },
})


local uses = 128



minetest.register_on_player_hpchange(function(player, hp_change, reason)



    -- Negate fall damage if holding dampener
    -- local dampener = ItemStack('kybertrike:dampener')
    local has_dampener = player:get_inventory():contains_item('main', 'kybertrike:dampener') or player:get_inventory():contains_item('main', 'kybertrike:dampener_alt')


    if reason.type == "fall" then
        if has_dampener then



            minetest.log("action", player:get_player_name().."'s inertial dampener broke their fall.")

            -- Find the slot containing the dampener and update it
            local inventory = player:get_inventory()
            for i = 1, inventory:get_size("main") do
                local stack = inventory:get_stack("main", i)
                local stack_name = ItemStack(stack):get_name()
                if stack_name == 'kybertrike:dampener' or stack_name == 'kybertrike:dampener_alt' then

                    local tool_name = (stack_name == "kybertrike:dampener") and "kybertrike:dampener_alt" or "kybertrike:dampener"
                    local updated_dampener = ItemStack(tool_name)

                    updated_dampener:set_wear(stack:get_wear())
                    updated_dampener:add_wear_by_uses(uses)

                    -- play sound if broken.
                    -- for whatever reason, the breaks sound in the tool def. has no effect
                    -- this is a workaround for that.
                    if updated_dampener:get_wear() == 0 then
                        minetest.sound_play("default_tool_breaks", {
                            object = player,
                            gain = 0.25
                        })
                    end

                    inventory:set_stack("main", i, updated_dampener)
                    break
                end
            end


            -- play sound when we negate fall damage
            minetest.sound_play("kybertrike_dampener_activate2", {
                object = player,
                gain = 0.8,
                max_hear_distance = 10,
            })



            return 0
        end
    end

    return hp_change

end, true)


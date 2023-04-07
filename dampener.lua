-- Define the boots item
minetest.register_tool("kybertrike:dampener", {
    description = "Inertial Dampener",
    inventory_image = "kybertrike_dampener.png",
    groups = {not_in_creative_inventory = 1}
})

-- Define the crafting recipe for the boots
minetest.register_craft({
    output = "kybertrike:dampener",
    recipe = {
        {"", "default:mese_crystal_fragment", ""},
        {"", "default:snow", ""},
        {"", "default:cactus", ""},
    },
})


minetest.register_on_player_hpchange(function(player, hp_change, reason)



    -- Negate fall damage if holding dampener
    -- local dampener = ItemStack('kybertrike:dampener')
    local has_dampener = player:get_inventory():contains_item('main', 'kybertrike:dampener')


    if reason.type == "fall" then
        if has_dampener then
            minetest.log("action", player:get_player_name().."'s inertial dampener broke their fall.")

            -- Find the slot containing the dampener and update it
            local inventory = player:get_inventory()
            for i = 1, inventory:get_size("main") do
                local stack = inventory:get_stack("main", i)
                if ItemStack(stack):get_name() == 'kybertrike:dampener' then
                    local updated_dampener = ItemStack('kybertrike:dampener')
                    updated_dampener:set_wear(stack:get_wear())
                    updated_dampener:add_wear_by_uses(128)
                    inventory:set_stack("main", i, updated_dampener)
                    break
                end
            end

            return 0
        end
    end

    return hp_change

end, true)


-- -- Register an on_fall function to negate fall damage if the player is holding the dampener tool
-- minetest.register_on_player_fall(function(player, fall_distance)
--     if player:get_wielded_item():get_name() == "kybertrike:dampener" then
--         -- Negate fall damage
--         return true
--     end
-- end)



function kybertrike.jumpjet_on_use(itemstack, user, pointed_thing)
    -- Check if the player is already holding a jumpjet
    -- if user:get_inventory():contains_item("main", "kybertrike:jumpjet") then
    --     minetest.chat_send_player(user:get_player_name(), "You can only hold one jumpjet at a time!")
    --     return
    -- end
    
    local pos = user:get_pos()

    -- Remove the jumpjet from the player's inventory
    itemstack:take_item()
    user:set_wielded_item(itemstack)
    
    -- Accelerate the player into the sky and forward
    -- Define acceleration values
    local acceleration_up = 50
    local acceleration_forward = 49

    -- Get player's current velocity
    local vel = user:get_velocity()

    -- Calculate new velocity
    vel.y = vel.y + acceleration_up
    local dir = user:get_look_dir()  -- get the direction the player is facing
    dir.y = 0  -- ignore the vertical component of the direction
    dir = vector.normalize(dir)  -- normalize the direction vector to have length 1
    vel = vector.add(vel, vector.multiply(dir, acceleration_forward))  -- add the forward acceleration to the velocity vector


    -- Set player's new velocity
    user:add_velocity(vel)
    
    -- Emit particles
    minetest.add_particlespawner({
        amount = 100,
        time = 2,
        minpos = pos,
        maxpos = pos,
        minvel = {x = -1, y = -1, z = -1},
        maxvel = {x = 1, y = 1, z = 1},
        minacc = {x = 0, y = 0, z = 0},
        maxacc = {x = 0, y = 0, z = 0},
        minexptime = 1,
        maxexptime = 2,
        minsize = 2,
        maxsize = 3,
        collisiondetection = true,
        collision_removal = true,
        object_collision = true,
        vertical = false,
        texture = "default_item_smoke.png",
        playername = user:get_player_name(),
    })
    
    -- Play sound
    minetest.sound_play("kybertrike_jumpjet", {
        object = user,
        gain = 1.0,
        max_hear_distance = 50,
    })
    
    return itemstack
end


minetest.register_craftitem("kybertrike:jumpjet", {
    description = "Jumpjet",
    inventory_image = "kybertrike_jumpjet.png",
    on_use = kybertrike.jumpjet_on_use,
})

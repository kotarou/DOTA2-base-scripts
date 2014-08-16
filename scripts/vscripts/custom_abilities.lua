PLACED_BUILDING_RADIUS = 45.0;

function swapSetUp(keys)
	print("ahoy")
	
end

function swapper(keys)
	call = keys.call

	two = keys.caster:GetAbilityByIndex(3)
	one = keys.caster:GetAbilityByIndex(2)
	
	ability_level = one:GetLevel()
	two:SetLevel(ability_level)
	
	if call == "s1_on" and two:GetToggleState() then
		two:ToggleAbility()
	end
	if call == "s1_off" and not two:GetToggleState() then
		two:ToggleAbility()
	end
	if call == "s2_on" and one:GetToggleState() then
		one:ToggleAbility()
	end
	if call == "s2_off" and not one:GetToggleState() then
		one:ToggleAbility()
	end
end

function fireRockets(keys)
	location = GetGroundPosition(keys.caster:GetOrigin(), nil)

	ability_damage 	= keys.ability:GetAbilityDamage()
	ability_type 	= keys.ability:GetAbilityDamageType()
	caster 			= keys.caster
	ability_radius 	= keys.radius

	--print(type(keys.modifier))
	--checkKeys(keys)


	for _,thing in pairs(Entities:FindAllInSphere(location, ability_radius) )  do
		if thing:GetClassname() == "npc_dota_creature" then

			local mod = {
					EffectName = "generic_buff_1",
					EffectAttachType = "follow_overhead",
					EffectLifeDurationScale = "1",
					EffectColorA = "0 255 255"
				}

			--thing:AddNewModifier(caster, nil, "GETTING SHOT AT", mod)

        	local dtable = {
        		victim 		= thing, 
        		attacker 	= caster, 
        		damage 		= ability_damage, 
        		damage_type = ability_type
        	}
        	ApplyDamage(dtable)
        end
    end
end

function dropItem(keys)
	caster 			= keys.caster
	origin = caster:GetOrigin()
	position = Vector(0,150,0) + origin
	item = 	caster:GetItemInSlot(0)
	caster:DropItemAtPosition(position, item)
end



function placeBuilding(keys)
    -- We need a few variables. They should be self-explanatory
    blocking_counter = 0
    attempt_place_location = keys.target_points[1]
   -- Hoooooly complicated! Basically, this line finds all entities within PLACED_BUILDING_RADIUS of where we want to put the tower
    -- The for loop then counts them
    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(attempt_place_location, nil), PLACED_BUILDING_RADIUS) )  do
        -- is this a valid blocker?
        if thing:GetClassname() == "npc_dota_creature" then
        	blocking_counter = blocking_counter + 1
        	print("blocking creature")
        end
    end
    print(blocking_counter .. " blockers")
        
    -- If there are any entities to block us placing the tower, don't place it, otherwise: do!
    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_dota_building_homebase", keys.target_points[1], false, nil, nil,keys.caster:GetPlayerOwner():GetTeam() ) 
        tower:SetAngles(90.0,90.0,90.0)
    end
end 

function checkKeys(keys)
    for key, value in pairs(keys) do
        print (key,value)
        checkType(value)
	end
end    

function checkType(stuff)
    if (type(stuff)=="table") then
            for k, v in pairs(stuff) do
                print(k,v)
                checkType(v)
            end
    end
end

require "constants"
require "__DragonIndustries__.di-utils"
require "__DragonIndustries__.mathhelper"
require "__DragonIndustries__.tiles"
require "__DragonIndustries__.arrays"
require "__DragonIndustries__.world"

---@class (exact) GeoSpawnRules
---@field planet string
---@field tiles GeoTileRuleset
---@field size number
---@field frequency number
---@field minDist number
---@field distanceFactor number
---@field rateClamp number
---@field version int

---@class (exact) GeoTileRuleset
---@field set {string:GeoTileRule}
---@field populated boolean

---@class (exact) GeoTileRule
---@field rate number
---@field radius number
---@field count_min? int
---@field count_max? int

---@class (exact) LocalSpawnData
---@field multiplier number
---@field count_min int
---@field count_max int
---@field radius number

---@class (exact) ExchangerEntry
---@field entity LuaEntity
---@field input LuaEntity
---@field hot boolean

---@class (exact) HeatWellEntry
---@field entity LuaEntity
---@field graphics LuaEntity
---@field animation LuaRenderObject
---@field patches {string: LuaRenderObject}

local function onEntityRotated(event)
	
end

local function onEntityRemoved(event)
	if event.entity and event.entity.valid then
		if string.find(event.entity.name, "geothermal-exchanger", 1, true) then
			if storage.geothermal and storage.geothermal.exchangers then
				local entry = storage.geothermal.exchangers[event.entity.unit_number]
				if entry and entry.logic and entry.logic.valid then
					entry.logic.destroy()
					storage.geothermal.exchangers[event.entity.unit_number] = nil
				end
			end
		elseif string.find(event.entity.name, "geothermal-heat-well", 1, true) then
			if storage.geothermal and storage.geothermal.wells then
				local entry = storage.geothermal.wells[event.entity.unit_number]
				if entry and entry.graphics and entry.graphics.valid then
					entry.graphics.destroy()
				end
				if entry and entry.animation and entry.animation.valid then
					entry.animation.destroy()
				end
				if entry and entry.patches then
					for _,r in pairs(entry.patches) do
						if r.valid then r.destroy() end
					end
				end
				storage.geothermal.wells[event.entity.unit_number] = nil
			end
		end
	end
end

script.on_event(defines.events.on_entity_died, onEntityRemoved)
script.on_event(defines.events.on_pre_player_mined_item, onEntityRemoved)
script.on_event(defines.events.on_robot_pre_mined, onEntityRemoved)
script.on_event(defines.events.script_raised_destroy, onEntityRemoved)

script.on_event(defines.events.on_player_rotated_entity, onEntityRotated)

--might even want to move the whole compound entity framework to DI
script.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id

	local entity = event.target_entity
	if not (entity and entity.valid) then
		return
	end

	if effect_id == "on-create-geothermal-extractor" then
		local assembler = entity.surface.create_entity{name="geothermal-extractor-fluid-input", position = {entity.position.x, entity.position.y-1}, force=entity.force, direction=entity.direction}
		assembler.operable = false
		assembler.destructible = false
		assembler.minable_flag = false
		assembler.rotatable = false
		
		addGlobalKV({"extractors", entity.unit_number}, {entity=entity, logic=assembler})
	elseif effect_id == "on-create-geothermal-well" then
		entity.operable = false
		local well = entity.surface.create_entity{name="geothermal-heat-well", position = {entity.position.x, entity.position.y}, force=entity.force, direction=entity.direction, quality = entity.quality}
		local reactor = entity.surface.create_entity{name="geothermal-heat-well-graphics", position = {entity.position.x, entity.position.y}, force=entity.force, direction=entity.direction}
		entity.destroy()
		well.update_connections()
		reactor.destructible = false
		reactor.minable_flag = false
		reactor.operable = false
		reactor.rotatable = false

		local anim = rendering.draw_animation{animation="heat-well-animation", render_layer="object", animation_speed=0, target=well, surface=well.surface, visible=true, only_in_alt_mode=false}
		local patches = {}

		for patch,coord in pairs(WELL_PATCHES) do
			local r = rendering.draw_sprite{sprite="heat-well-patch-" .. patch, render_layer="ground-patch", target=well, surface=well.surface, visible=false, only_in_alt_mode=false}
			patches[patch] = r
		end

		addGlobalKV({"wells", well.unit_number}, {entity=well, graphics=reactor, animation = anim, patches = patches})
	elseif effect_id == "on-create-geothermal-exchanger" then
		local pos = entity.position
		if entity.direction == defines.direction.north then
			--pos.y = pos.y+1
		end
		if entity.direction == defines.direction.south then
			--pos.y = pos.y-1
		end
		if entity.direction == defines.direction.east then
			--pos.x = pos.x-1
		end
		if entity.direction == defines.direction.west then
			--pos.x = pos.x+1
		end
		local assembler = entity.surface.create_entity{name="geothermal-exchanger-fluid-input", position = pos, force=entity.force, direction=getOppositeDirection(entity.direction)}
		assembler.operable = false
		assembler.destructible = false
		assembler.minable_flag = false
		assembler.rotatable = false
		addGlobalKV({"exchangers", entity.unit_number}, {entity=entity, input=assembler, hot=string.find(entity.name, "hot", 1, true) ~= nil})
	end
end)

script.on_nth_tick(10, function(data)
	if storage.geothermal then
		if storage.geothermal.wells then
			for unit,entry in pairs(storage.geothermal.wells) do
				if entry.entity.valid then
					--entry.entity.temperature = 625
					local surface = entry.entity.surface
					local x = entry.entity.position.x
					local y = entry.entity.position.y
					local lava = false
					if entry.patches then
						for patch,coord in pairs(WELL_PATCHES) do
							local r = entry.patches[patch]
							if r and r.valid then
								r.visible = isTileType(surface, x+coord.x, y+coord.y, {"lava", "geothermal", "molten"})
								if r.visible then lava = true end
							end
						end
					end
					local tiername = nil
					if lava then
						tiername = "hot" --lava is hot
					else
						local tier = -1
						local res = surface.find_entities_filtered{area = {{x-0.2, y-0.2}, {x+0.2, y+0.2}}, type = "resource"}
						for _,item in pairs(res) do
							if string.find(item.name, "geothermal-patch", 1, true) and item.position.x == entry.entity.position.x and item.position.y == entry.entity.position.y then
								local tierat = -1
								for i,name in ipairs(TEMPERATURE_INDICES) do
									if string.find(item.name, name, 1, true) then
										tierat = i
									end
								end
								tier = math.max(tier, tierat)
							end
						end
						tiername = tier >= 0 and TEMPERATURE_INDICES[tier] or nil
					end
					local active = tiername ~= nil and entry.graphics and entry.graphics.valid and entry.graphics.energy > 0
					if active then
						local factor = 0.24
						if entry.entity.force.technologies["geothermal-heat-well-efficiency"].researched then factor = factor*(1+HEAT_WELL_EFFICIENCY_TECH_AMOUNT) end
						factor = factor*getHeatWellEfficiency(entry.entity.quality)
						local dT = (PATCH_TEMPERATURES[tiername].temperature-entry.entity.temperature)*factor/60
						--game.print(entry.entity.temperature .. " + " .. dT)
						entry.entity.set_heat_setting({temperature = dT, mode = "add"})
					else
						entry.entity.set_heat_setting({temperature = entry.entity.temperature-5, mode = "at-most"})
					end
					if entry.animation and entry.animation.valid then
						if active then
						local animTemp = math.min(600, math.max(0, entry.entity.temperature-20))
						local round = math.floor(animTemp / 50 + 0.5)*0.5
						entry.animation.animation_speed = 0.25*round
						--game.print(entry.entity.temperature .. " > " .. animTemp .. " > " .. round .. " > " .. entry.animation.animation_speed)
						else
							entry.animation.animation_speed = 0
						end
					end
					if entry.graphics and entry.graphics.valid then
						entry.graphics.temperature = entry.entity.temperature
						--[[
						local inv = entry.graphics.get_inventory(defines.inventory.fuel)
						if active then
							inv.insert("uranium-fuel-cell")
						else
							inv.clear()
						end
						--]]
					end
				end
			end
		end
		if storage.geothermal.exchangers then
			for unit,entry in pairs(storage.geothermal.exchangers) do
				if entry.entity.valid and entry.input.valid then
					--entry.entity.temperature = 625
					local surface = entry.entity.surface
					local input = entry.input.get_inventory(defines.inventory.crafter_output)
					local count = input.get_item_count()
					if count > 0 then
						--entry.entity.energy = entry.entity.energy + 1000
						local qualityFactor = 1+0.3*entry.entity.quality.level --basic = 1x, improved 1.3x, exceptional 1.6x, etc up to masterwork 2.5x (this matches boiler rate)
						entry.entity.temperature = math.min(entry.entity.temperature+1.5*qualityFactor*count, entry.hot and 625 or 325)
						--game.print("setting temp to " .. entry.entity.temperature)
					end
					input.clear()
				end
			end
		end
	end
end)

local SET_VERSION = 3

---@param set {string:GeoTileRule}
---@param name string
local function computePatchSize(set, name)
	local e = set[name]
	local low = 2
	local high = 6
	if string.find(name, "volcanic", 1, true) then
		high = 2--32
		low = high
	end
	if string.find(name, "snow", 1, true) then
		low = 5
		high = 10
	end
	if string.find(name, "desert", 1, true) then
		low = 4
		high = 6
	end
	e.count_min = low
	e.count_max = high
end

---@param name string
---@param setting string
---@param rules GeoSpawnRules
local function processTileRule(name, setting, rules)
	if rules.planet == "nauvis" then
		if string.find(name, "volcanic", 1, true) then
			local heat = tonumber(string.sub(name, -1)) -- 1-4, 4 is hotter & brighter
			if not heat then
				if string.find(name, "hot", 1, true) then
					heat = 4
				elseif string.find(name, "warm", 1, true) then
					heat = 2
				elseif string.find(name, "cool", 1, true) then
					heat = 1
				else
					heat = 0
				end
			end
			if not heat then error("Error getting tile rules on " .. rules.planet .. ": Was not able to determine heat from volcanic tile " .. name) end
			if heat > 0 then
				local f2 = 9*0.36*((heat/4)^2)--0.4*((heat/4)^2)--0.25*heat/4
				rules.tiles.set[name] = {rate = f2, radius = 4}--16}
				computePatchSize(rules.tiles.set, name)
			end
		end
		if setting == "volcanic-and-snow" or setting == "volcanic-snow-and-red-desert" then
			if string.find(name, "frozen-snow", 1, true) then
				rules.tiles.set[name] = {rate = 0.055, radius = 9} --was 0.03, then 0.045
				computePatchSize(rules.tiles.set, name)
			end
		end
		if setting == "volcanic-snow-and-red-desert" then
			if string.find(name, "red-desert", 1, true) then
				rules.tiles.set[name] = {rate = 0.04, radius = 8} --was 0.006, then 0.02
				computePatchSize(rules.tiles.set, name)
			end
		end
	elseif rules.planet == "gleba" then
		if string.find(name, "highland", 1, true) then
			rules.tiles.set[name] = {rate = 0.02, radius = 20}
			computePatchSize(rules.tiles.set, name)
		elseif setting == "highlands-and-midlands" and string.find(name, "midland", 1, true) then
			rules.tiles.set[name] = {rate = 0.02, radius = 20}
			computePatchSize(rules.tiles.set, name)
		end
	elseif rules.planet == "maraxsis" then
		if string.find(name, "dirt", 1, true) then
			rules.tiles.set[name] = {rate = 0.2, radius = 4}
			computePatchSize(rules.tiles.set, name)
		elseif setting == "deep-only" and string.find(name, "underwater", 1, true) then
			rules.tiles.set[name] = {rate = 0.08, radius = 6}
			computePatchSize(rules.tiles.set, name)
		end
	end
end

---@param rules GeoSpawnRules
local function calculateSpawnSet(rules)
	rules.tiles = {populated=false, set = {}}
	local setting = settings.startup["geothermal-spawn-rules-" .. rules.planet].value
	if setting == "nowhere" then rules.tiles.populated = true return end
	if setting ~= "everywhere" then
		for name,tile in pairs(prototypes.tile) do
			processTileRule(name, setting, rules)
		end
		rules.tiles.populated = getTableSize(rules.tiles.set) > 0
	end
	if not rules.tiles.populated then
		for name,tile in pairs(prototypes.tile) do
			rules.tiles.set[name] = {rate = 0.012, radius = 6} --0.0015 is too rare to appear enough; as was 0.006 and 0.009
			computePatchSize(rules.tiles.set, name)
		end
		rules.tiles.populated = true
	end
	--game.print(serpent.block(set))
end

---@param planet string
---@return GeoSpawnRules
local function calculateSpawnRules(planet)
	fmtlog("Generating spawn rules for planet '%s'...", planet)
	local size = settings.startup["geothermal-size-" .. planet].value
	local freq = settings.startup["geothermal-spawn-frequency-" .. planet].value
	local minDist = settings.startup["geothermal-min-distance-" .. planet].value
	local distFac = settings.startup["geothermal-distance-scalar-" .. planet].value
	local rateClamp = settings.startup["geothermal-rate-clamp-" .. planet].value
	local ret = {planet=planet, size=size, frequency=freq, minDist=minDist, distanceFactor=distFac, rateClamp=rateClamp, version=SET_VERSION}
	calculateSpawnSet(ret)
	fmtlog("Computed spawn rules for planet '%s':\n%s", planet, ret)
	return ret
end

---@param planet string
---@return GeoSpawnRules
local function getSpawnRules(planet)
	local geo = storage.geothermal
	--fmtlog("Geo cache: %s", geo)
	if not geo then
		geo = {}
		storage.geothermal = geo
	end
	if geo.spawnRules and geo.spawnRules[planet] and (geo.spawnRules[planet].version == nil or geo.spawnRules[planet].version < SET_VERSION) then
		--fmtlog("Nulled planet %s geo spawn rules V%s", planet, geo.spawnRules[planet].version)
		geo.spawnRules[planet] = nil
	end
	if not geo.spawnRules then geo.spawnRules = {} end
	if not geo.spawnRules[planet] and settings.startup["geothermal-size-" .. planet] then --skip compute for planets without configurations
		addGlobalKV({"spawnRules", planet}, calculateSpawnRules(planet))
	end
	--fmtlog("New Geo cache: %s", geo)
	return geo.spawnRules[planet]
end

---@param surface LuaSurface
---@param x int
---@param y int
---@param rules GeoSpawnRules
---@return boolean
local function isNonZeroTile(surface, x, y, rules)
	for i = -1,1 do
		for k = -1,1 do
			local tile = surface.get_tile(x+i, y+k)
			--game.print(tile.name .. " > " .. serpent.block(set[tile.name]))
			if rules.tiles.set[tile.name] and rules.tiles.set[tile.name].rate > 0 then
				return true
			end
		end
	end
	return false
end

---@param surface LuaSurface
---@param x int
---@param y int
---@param rules GeoSpawnRules
---@return boolean
function canPlaceAt(surface, x, y, rules)
	return surface.can_place_entity{name = "geothermal-patch-hot", position = {x, y}} and isNonZeroTile(surface, x, y, rules)
end

---@param surface LuaSurface
---@param x int
---@param y int
---@return string?
local function getTileColor(surface, x, y)
	local tile = surface.get_tile(x, y)
	local clr = nil
	if string.find(tile.name, "volcanic", 1, true) then
		clr = string.sub(tile.name, string.len("volcanic")+2, -2-string.len("heat")-2)
	end
	--game.print(tile.name .. " > " .. (clr and clr or "nil"))
	return clr
end

---@param surface LuaSurface
---@param x int
---@param y int
---@return string?
local function getPrevailingColor(surface, x, y)
	local clrs = {}
	--game.print(clr)
	for dx = x-4,x+4 do
		for dy = y-4,y+4 do
			local clr = getTileColor(surface, dx, dy)
			if clr then
				clrs[clr] = clrs[clr] and clrs[clr]+1 or 1
			end
		end
	end
	return getHighestTableKey(clrs)
end

---@param surface LuaSurface
---@param dx int
---@param dy int
---@params rand LuaRandomGenerator
---@params color string
---@param rules GeoSpawnRules
function createResource(surface, dx, dy, rand, color, rules)
	if canPlaceAt(surface, dx, dy, rules) then
		local clrAt = getTileColor(surface, dx, dy)
		if clrAt or not color then color = getPrevailingColor(surface, dx, dy) end
		local clr = (color and color ~= "red" and color ~= "orange") and color or ""
		local temp = getRandomTemperature(rand)
		local entity = "geothermal-patch-" .. temp .. clr
		if (prototypes.entity[entity] == nil) then
			clr = ""
		end
		surface.create_entity{name = entity, position = {x = dx, y = dy}, force = game.forces.neutral, amount = 1000}
		surface.create_entity{name = "geothermal-light-" .. temp .. clr, position = {x = dx+0.5, y = dy+0.5}, force = game.forces.neutral}
		surface.destroy_decoratives{area={{dx-6, dy-6}, {dx+6, dy+6}}, exclude_soft=false}
	end
end

---@param surface any
---@param x int
---@param y int
---@param rules GeoSpawnRules
---@return LocalSpawnData
local function getSpawnData(surface, x, y, rules)
	local ret = {multiplier = 0, count_min = 0, count_max = 0, radius = 0}
	local set = rules.tiles.set
	local c = 0
	for i = -1,1 do
		for k = -1,1 do
			local tile = surface.get_tile(x+i, y+k)
			if tile.valid and set[tile.name] then
				ret.multiplier = ret.multiplier+set[tile.name].rate
				ret.count_min = math.max(ret.count_min, set[tile.name].count_min)
				ret.count_max = math.max(ret.count_max, set[tile.name].count_max)
				ret.radius = math.max(ret.radius, set[tile.name].radius)
				c = c+1
			end
		end
	end
	ret.multiplier = (c > 0 and ret.multiplier/c or 0)
	return ret
end

---@params rand LuaRandomGenerator
---@param surface LuaSurface
---@param x int
---@param y int
---@params df number
---@params localSpawn LocalSpawnData
---@param rules GeoSpawnRules
local function trySpawnPatchAt(rand, surface, x, y, df, localSpawn, rules)
	--game.print("Genning Chunk at " .. x .. ", " .. y)
	x = x-6+rand(0, 12)
	y = y-6+rand(0, 12)
	local count = rand(localSpawn.count_min, localSpawn.count_max)
	count = math.max(1, math.ceil(df*1.5*count*rules.size))
	local color = getRandomColor(rand)
	--game.print("Chunk at " .. x .. ", " .. y .. " attempting " .. count)
	for i = 1, count do
		local r = math.floor(localSpawn.radius*rules.size+0.5)
		local dx = x-r+rand(0, r*2)
		local dy = y-r+rand(0, r*2)
		createResource(surface, dx, dy, rand, color, rules)
	end
end

---@param surface LuaSurface
---@param area BoundingBox
local function controlChunk(surface, area)
	local x = (area.left_top.x+area.right_bottom.x)/2
	local y = (area.left_top.y+area.right_bottom.y)/2
	local rules = getSpawnRules(surface.name)
	if not rules then return end --is nil if no configurations
	local dd = x*x+y*y
	local mind = rules.minDist
	if dd < mind*mind then
		return
	end
	local rand = game.create_random_generator()
	local df = math.min(1, (math.sqrt(dd)-mind)/(mind+100))
	--game.print(df .. " @ " .. math.sqrt(dd))
	local seed = createSeed(surface, x, y) --[[@as uint]]
	rand.re_seed(seed)
	local dx = area.left_top.x+rand(0, 32)
	local dy = area.left_top.y+rand(0, 32)
			if df >= 1 or rand(0, 100)/100 < df then
				local localSpawn = getSpawnData(surface, dx, dy, rules)
				--if f0 > 0 then game.print(f0) end
				local f = localSpawn.multiplier*math.min(rules.rateClamp, 1+(math.sqrt(dd)/(1000*rules.distanceFactor)))*256
				f = f*rules.frequency*PATCH_RATE_FACTOR*0.003 -- *0.003 because of 0.17 algo change
				local f1 = rand(0, 2147483647)/2147483647
				local shouldGen = f1 < f
				--game.print("Chunk at " .. x .. ", " .. y .. " with chance " .. f .. " / " .. f1)
				if shouldGen then
					--game.print("Genning patch at " .. dx .. " , " .. dy)
					trySpawnPatchAt(rand, surface, dx, dy, df, localSpawn, rules)
				end
			end
end

script.on_event(defines.events.on_chunk_generated, function(event)
	controlChunk(event.surface, event.area)
end)
--[[
script.on_event(defines.events.on_tick, function(event)	
	if not ranTick and Config.retrogenDistance >= 0 then
		local surface = game.surfaces["nauvis"]
		for chunk in surface.get_chunks() do
			local x = chunk.x
			local y = chunk.y
			if surface.is_chunk_generated({x, y}) then
				local area = {
					left_top = {
						x = x*CHUNK_SIZE,
						y = y*CHUNK_SIZE
					},
					right_bottom = {
						x = (x+1)*CHUNK_SIZE,
						y = (y+1)*CHUNK_SIZE
					}
				}
				local dx = x*CHUNK_SIZE+CHUNK_SIZE/2
				local dy = y*CHUNK_SIZE+CHUNK_SIZE/2
				local dist = math.sqrt(dx*dx+dy*dy)
				if dist >= Config.retrogenDistance then
					controlChunk(surface, area)
				end
			end
		end
		ranTick = true
		for name,force in pairs(game.forces) do
			force.rechart()
		end
		--game.print("Ran load code")
	end
	
	if event.tick%60 == 0 then
		for name,force in pairs(game.forces) do
			for _,train in pairs(force.get_trains()) do
				for __,car in pairs(train.fluid_wagons) do
					if car.prototype.name ~= "insulated-wagon" then
					--[[
						for name,amt in pairs(car.get_fluid_contents()) do
							if string.find(name, "geothermal-water", 1, true) then
								car.remove_fluid{name=name, amount=100}
							end
						end
					--]]--[[
						for i = 1,#car.fluidbox do
							local box = car.fluidbox[i]
							if box and string.find(box.name, "geothermal-water", 1, true) then
								if box.temperature > 95 then
									box.name = "cooling-geothermal-water"
								else
									box.name = "water"
								end
								box.temperature = box.temperature-5
								car.fluidbox[i] = {name = box.name, temperature = box.temperature, amount = box.amount}
							end
						end
					end
				end
			end
		end
	end
	
	--local pos=game.players[1].position
	--for k,v in pairs(game.surfaces.nauvis.find_entities_filtered{area={{pos.x-1,pos.y-1},{pos.x+1,pos.y+1}}, type="resource"}) do v.destroy() end
end)
--]]

--[[
Good AlienBiomes test map: (0.15)

>>>AAAPABUAAAADAwgAAAAEAAAAY29hbAMDAwoAAABjb3BwZXItb3Jl
AwMDCQAAAGNydWRlLW9pbAMDAwoAAABlbmVteS1iYXNlAwMDCAAAAGl
yb24tb3JlAwMDBQAAAHN0b25lAwMDBgAAAHN1bGZ1cgMDAwsAAAB1cm
FuaXVtLW9yZQMDA0FmC0KAhB4AgIQeAAMBAQEBAAAAAAAA0D8BAAAAA
AAAFEABmpmZmZmZqT8BAAAAAABYu0ABAAAAAADghUABAAAAAABYq0AB
AAAAAACIw0ABAAAAAABAn0ABAAAAAABAf0ABAAAAAABAj0ABMzMzMzM
z8z8BMzMzMzMz8z8BexSuR+F6dD8BAAEAAAAAAAAIQAEAAAAAAAAIQA
F7FK5H4XqEPwEAAQEBje21oPfG0D4B/Knx0k1iYD8BaR1VTRB1zz4BA
QEHAAAAAQIAAAABAgAAAAGamZmZmZm5PwEAAAAAAAAAQAEAAAAAAADg
PwGamZmZmZnZPwHNzMzMzMzsPwEFAAAAARQAAAABQDgAAAHASwMAARA
OAAABoIwAAAEgHAAAAQAAAAAAAD5AAQAAAAAAABRAAWZmZmZmZvY/AT
MzMzMzM+M/ATMzMzMzM9M/AQAAAAAAAAhAAQAAAAAAACRAATwAAAABH
gAAAAHIAAAAAQUAAAABAAAAAAAAAEABAQEAAAAAAABZQAEFAAAAARkA
AAABAAAAAAAAJEABMgAAAAEAAAAAAAA+QAFkAAAAAZqZmZmZmck/ATM
zMzMzM8M/ATMzMzMzM9M/ATMzMzMzM9M/AQAAAAAAACRAAQAAAAAAAD
RAAQAAAAAAAD5AAQAAAAAAABRAAQAAAAAAAD5AAQAAAAAAACRAAQAAA
AAAAAhAAQoAAAABZAAAAAFkAAAAAegDAAABAAAAAAAA4D8B0AcAAAEA
AAAAAEB/QAMAAAAAAAAAAAAAAPA/5tUb0Q==<<<


0.16:

>>>eNptUjFoFEEUnXFzuSRnLinSCCGmSHsgKmKh2ZWAFtrYaTm3O7cZ
MrdzmZ25804wFlEsBBsbrWy10DaCiGAlKARsFBGMaQKxEAQLQeLM7Mz
s5fAf8++9/+fP/D9vAZhVvzEQBOdrTSRvEIEbjOMgCMZihqj6n4pZE1
Fho4p1OphbNhlzmagCojfWE8JFA8km5inJzGYTaWKSDjGK4rWScdbLP
Is5Rm1/UiJz0ecsNxeZSMpxX5GaIR3JO1TnJgzlOPFYoMxv6xJGsfBX
9FbVhJrhDLf7jSYyx4+3OBtgXVRNcdsON5EymrixU47yXDUvNasVTLV
jaixtI9kdyjJKDD1qKUdZOsR9+5MFL/qfKYiQfF0ykg/t93NY3seUsl
7BmcySRg8JzHXbhLPMjUAx8iNkJF7D1LLxdYm4GOg4l4JQp3o9R+qsQ
yKaiBexYE7EgjkRDfMiGnZIRBNxIhpSimioFdFgK6LBpYiGehFzQrv+
Y6zkgpmOa2KVcSKdjlVB3HtUhJIs148mZJbmArtETSp5ypLpLqOxCsR
O8boPONFnfMQrW4bKsQYki+2hAB6/mO/d3lwAeh1sgBMHB3optA2AWc
rUNhVwVokpabUAWLygF4Tw8SNtT0NY5OciC4AF93ZdhFjwcMeCK38ti
F448MClvkbwlLFfYQluzj2/tDMQ6i575ERUgiK5qZMQNlbm97+f+fMa
bi3c2b+6dSuEr/rPVrK7X5ZVsqoK4BHviglehiONg2+hTX0O4Yf32n6
EsKIr5rSLzir35rJ6ntm6Qk/uK7c4D1xry1H5Ii1jv90kuw58DEfnWI
rgOX34gnZT2pkLfWfQwutRkThWZlXpSTB8fVIO987d+Hbo6pEellwPp
6P/jDASWRp6eNNm4t1e4JtQL7hddSzaiAJQ2s9wGny69g/+42si<<<

0.17:

>>>eNptUT2IE0EUfmOMiYmIQgoPjpAibSzUwkJuRi0stLnm4MrN7
iQ3uDd7zs7qXQQvxflTCNreVbZaeJYnWBxco6ggWIkIkWsELQTBT
uJMdie7O5sH8/ab733z/hbgNHQAgbIh1v5MvetE60zSTiCoIfX3q
Bs4fpaouUHX8eUMne8B7BN1I4lubY0KW3fcFZGnqrB8Usrp6kan6
4Q5caVPV+0E1b4qZJMn+iKIuNe540gqsoHSSiCzXVWZCHghpU+dQ
soaZ+5N6tv0sVuRI+QgpxSRZH5hc7WQ+beLCyiHMuA5pi5XAsGiw
qQVyQqtlqWgNMyNLiPeDyUtSOuRcPiMtNUB465NAlo6210fbjVBn
/EmtMZjfRQaKcEIIFUqzljZ9VmvB9C6rM4VzSBAO9vanmMUaxokA
ZCAR4eGYTEYPjxImBv/EkB2DXhiQt/Mq98YnZ/Ynwy423h57ftAq
qKJqkpSEAe3dBCZZgDtNe//XNy7h9GbjRdX+YOvCypY0YEjUxeP8
hpbE8AIJ6EvGH38oO0XRmX9oqEduajc/vUSoFMnFXr2WLnWPJjWF
ki6mt7E/ppJDg34jO052gRd0smb2r3VblJw2pmZbJnEgbk0qp6eg
2x5Lx3unal4kClt9dA2PVwgM0awmHZm8TVdx5u6H6VpE2qDnyrmR
jZJCVJTP5i8f/X0P2w45GQ=<<<

--]]
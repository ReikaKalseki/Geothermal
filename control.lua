require "config"
require "constants"

require "__DragonIndustries__.arrays"
require "__DragonIndustries__.world"

local SET_VERSION = 2

local function getPatchSize(tile)
	local low = 2
	local high = 6
	if string.find(tile, "volcanic", 1, true) then
		high = 2--32
		low = high
	end
	if string.find(tile, "snow", 1, true) then
		low = 5
		high = 10
	end
	if string.find(tile, "desert", 1, true) then
		low = 4
		high = 6
	end
	return low, high
end

local function calculateSpawnSet(set)
	local lavatiles = game.tile_prototypes["volcanic-orange-heat-1"]
	local snowtiles = game.tile_prototypes["frozen-snow-0"]
	local set = {}
	for name,tile in pairs(game.tile_prototypes) do
		if string.find(name, "volcanic", 1, true) then
			local heat = tonumber(string.sub(name, -1)) -- 1-4, 4 is hotter & brighter
			--game.print(name .. " > " .. heat)
			local f2 = 36*0.36*((heat/4)^2)--0.4*((heat/4)^2)--0.25*heat/4
			set[name] = {rate = f2, radius = 4}--16}
		end
		if Config.geothermalSpawnRules == "volcanic-and-snow" or Config.geothermalSpawnRules == "volcanic-snow-and-red-desert" then
			if string.find(name, "frozen-snow", 1, true) then
				set[name] = {rate = 0.055, radius = 9} --was 0.03, then 0.045
			end
		end
		if Config.geothermalSpawnRules == "volcanic-snow-and-red-desert" then
			if string.find(name, "red-desert", 1, true) then
				set[name] = {rate = 0.04, radius = 8} --was 0.006, then 0.02
			end
		end
	end
	if Config.geothermalSpawnRules == "everywhere" or getTableSize(set) == 0 then
		for name,tile in pairs(game.tile_prototypes) do
			set[name] = {rate = 0.012, radius = 6} --0.0015 is too rare to appear enough; as was 0.006 and 0.009
		end
	end
	for k,v in pairs(set) do
		if type(v) == "number" then
			local low,high = getPatchSize(k)
			set[k] = {rate = v, count_min = low, count_max = high}
			--game.print(k)
		elseif type(v) == "table" and not v[count_min] then
			local low,high = getPatchSize(k)
			v.count_min = low
			v.count_max = high
		end
	end
	--game.print(serpent.block(set))
	set.version = SET_VERSION
	return set
end

local function getSpawnSet()
	local geo = global.geo
	if not geo then
		geo = {}
		global.geo = geo
	end
	if geo.set and (geo.set.version == nil or geo.set.version < SET_VERSION) then
		geo.set = nil
	end
	if not geo.set then
		geo.set = calculateSpawnSet(geo)
	end
	return geo.set
end

local function isNonZeroTile(surface, x, y)
	local set = getSpawnSet()
	for i = -1,1 do
		for k = -1,1 do
			local tile = surface.get_tile(x+i, y+k)
			--game.print(tile.name .. " > " .. serpent.block(set[tile.name]))
			if set[tile.name] and set[tile.name].rate > 0 then
				return true
			end
		end
	end
	return false
end

function canPlaceAt(surface, x, y)
	return surface.can_place_entity{name = "geothermal", position = {x, y}} and not isWaterEdge(surface, x, y) and isNonZeroTile(surface, x, y)
end

local function getTileColor(surface, x, y)
	if not Config.geothermalColor then return nil end
	local tile = surface.get_tile(x, y)
	local clr = nil
	if string.find(tile.name, "volcanic", 1, true) then
		clr = string.sub(tile.name, string.len("volcanic")+2, -2-string.len("heat")-2)
	end
	--game.print(tile.name .. " > " .. (clr and clr or "nil"))
	return clr
end

local function getPrevailingColor(surface, x, y)
	if not Config.geothermalColor then return nil end
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

function createResource(surface, dx, dy)
	if canPlaceAt(surface, dx, dy) then
		local color = getPrevailingColor(surface, dx, dy)
		local clr = (color and color ~= "red" and color ~= "orange") and ("-" .. color) or ""
		local entity = "geothermal" .. clr;
		if (game.entity_prototypes[entity] == nil) then
			clr = ""
		end
		surface.create_entity{name = entity, position = {x = dx, y = dy}, force = game.forces.neutral, amount = 1000}
		surface.create_entity{name = "geothermal-light" .. clr, position = {x = dx+0.5, y = dy+0.5}, force = game.forces.neutral}
	end
end

function cantorCombine(a, b)
	--a = (a+1024)%16384
	--b = b%16384
	local k1 = a*2
	local k2 = b*2
	if a < 0 then
		k1 = a*-2-1
	end
	if b < 0 then
		k2 = b*-2-1
	end
	return 0.5*(k1 + k2)*(k1 + k2 + 1) + k2
end

function createSeed(surface, x, y) --Used by Minecraft MapGen
	local seed = surface.map_gen_settings.seed
	if Config.seedMixin ~= 0 then
		seed = bit32.band(cantorCombine(seed, Config.seedMixin), 2147483647)
	end
	return bit32.band(cantorCombine(seed, cantorCombine(x, y)), 2147483647)
end

local function getSpawnData(surface, x, y)
	local set = getSpawnSet()
	local ret = 0
	local sizes = {0, 0}
	local radius = 0
	c = 0
	for i = -1,1 do
		for k = -1,1 do
			local tile = surface.get_tile(x+i, y+k)
			--game.print(tile.name .. " > " .. serpent.block(set[tile.name]))
			if tile.valid and set[tile.name] then
				ret = ret+set[tile.name].rate
				sizes[1] = math.max(sizes[1], set[tile.name].count_min)
				sizes[2] = math.max(sizes[2], set[tile.name].count_max)
				radius = math.max(radius, set[tile.name].radius)
				c = c+1
				--if ret > 0 then game.print(tile.name) end
				--surface.set_tiles({{name = "water", position = {x+i, y+k}}})
			end
		end
	end
	return (c > 0 and ret/c or 0), sizes, radius
end

local function trySpawnPatchAt(rand, surface, x, y, df, counts, radius)
	--game.print("Genning Chunk at " .. x .. ", " .. y)
	x = x-4+rand(0, 8)
	y = y-4+rand(0, 8)
	local count = rand(counts[1], counts[2])
	count = math.max(1, math.ceil(df*count*Config.size))
	--game.print("Chunk at " .. x .. ", " .. y .. " attempting " .. count)
	for i = 1, count do
		local r = math.floor(radius*Config.size+0.5)
		local dx = x-r+rand(0, r*2)
		local dy = y-r+rand(0, r*2)
		createResource(surface, dx, dy)
	end
end

local function controlChunk(surface, area)
	local rand = game.create_random_generator()
	local x = (area.left_top.x+area.right_bottom.x)/2
	local y = (area.left_top.y+area.right_bottom.y)/2
	local dd = math.sqrt(x*x+y*y)
	if dd < 300 then
		return
	end
	local df = math.min(1, (dd-300)/400)
	local seed = createSeed(surface, x, y)
	rand.re_seed(seed)
	for dx = area.left_top.x,area.right_bottom.x,2 do
		for dy = area.left_top.y,area.right_bottom.y,2 do
			if df >= 1 or math.random() < df then
				local f0,counts,radius = getSpawnData(surface, dx, dy)
				--if f0 > 0 then game.print(f0) end
				local f = f0*math.min(10, 1+(dd/1000))
				f = f*Config.frequency*PATCH_RATE_FACTOR*0.003 -- *0.003 because of 0.17 algo change
				--if counts[1] > 0 then
				--	game.print("For area " .. dx .. " , " .. dy .. " got " .. f0 .. ">" .. f .. " and " .. serpent.block(counts))
				--end
				local f1 = rand(0, 2147483647)/2147483647
				local shouldGen = f1 < f
				--game.print("Chunk at " .. x .. ", " .. y .. " with chance " .. f .. " / " .. f1)
				if shouldGen then
					--game.print("Genning patch at " .. dx .. " , " .. dy)
					trySpawnPatchAt(rand, surface, dx, dy, df, counts, radius)
				end
			end
		end
	end
end

script.on_event(defines.events.on_chunk_generated, function(event)
	controlChunk(event.surface, event.area)
end)

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
					--]]
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
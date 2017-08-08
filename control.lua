function canPlaceAt(surface, x, y)
	return surface.can_place_entity{name = "geothermal", position = {x, y}} and not isWaterEdge(surface, x, y)
end

function isWaterEdge(surface, x, y)
	if surface.get_tile{x-1, y}.valid and surface.get_tile{x-1, y}.prototype.layer == "water-tile" then
		return true
	end
	if surface.get_tile{x+1, y}.valid and surface.get_tile{x+1, y}.prototype.layer == "water-tile" then
		return true
	end
	if surface.get_tile{x, y-1}.valid and surface.get_tile{x, y-1}.prototype.layer == "water-tile" then
		return true
	end
	if surface.get_tile{x, y+1}.valid and surface.get_tile{x, y+1}.prototype.layer == "water-tile" then
		return true
	end
end

function isInChunk(x, y, chunk)
	local minx = math.min(chunk.left_top.x, chunk.right_bottom.x)
	local miny = math.min(chunk.left_top.y, chunk.right_bottom.y)
	local maxx = math.max(chunk.left_top.x, chunk.right_bottom.x)
	local maxy = math.max(chunk.left_top.y, chunk.right_bottom.y)
	return x >= minx and x <= maxx and y >= miny and y <= maxy
end

function createResource(surface, chunk, dx, dy)
	if --[[isInChunk(dx, dy, chunk) and ]]canPlaceAt(surface, dx, dy) then
		surface.create_entity{name = "geothermal", position = {x = dx, y = dy}, force = game.forces.neutral, amount = 1000}
		surface.create_entity{name = "geothermal-light", position = {x = dx+0.5, y = dy+0.5}, force = game.forces.neutral}
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
	return bit32.band(cantorCombine(surface.map_gen_settings.seed, cantorCombine(x, y)), 2147483647)
end

script.on_event(defines.events.on_chunk_generated, function(event)
	local rand = game.create_random_generator()
	local x = (event.area.left_top.x+event.area.right_bottom.x)/2
	local y = (event.area.left_top.y+event.area.right_bottom.y)/2
	local dd = math.sqrt(x*x+y*y)
	if dd < 300 then
		return
	end
	local df = math.min(1, (dd-300)/400)
	if df < 1 and math.random() > df then
		return
	end
	local seed = createSeed(event.surface, x, y)
	rand.re_seed(seed)
	local f0 = 0.005
	local lavatiles = game.tile_prototypes["volcanic-medium"]
	if lavatiles then
		f0 = 0.5
	end
	local f = f0*math.min(10, 1+(dd/1000))
	local f1 = rand(0, 2147483647)/2147483647
	--game.print("Chunk at " .. x .. ", " .. y .. " with chance " .. f .. " / " .. f1)
	if f1 < f then
		--game.print("Genning Chunk at " .. x .. ", " .. y)
		x = x-16+rand(0, 32)
		y = y-16+rand(0, 32)
		local count = rand(2, 6)
		if lavatiles then
			count = 48
		end
		count = math.max(1, math.ceil(df*count))
		for i = 0, count do
			local dx = x-3+rand(0, 6)
			local dy = y-3+rand(0, 6)
			if lavatiles then
				dx = x-16+rand(0, 32)
				dy = y-16+rand(0, 32)
			end
			if lavatiles then
				local tile = event.surface.get_tile(dx, dy).name
				if string.find(tile, "volcanic") then
					local f2 = 0.25
					if tile == "volcanic-cool" then
						f2 = 0.03125/2
					end
					if tile == "volcanic-medium" then
						f2 = 0.125/1.5
					end
					f1 = rand(0, 2147483647)/2147483647
					if f1 < f2 then
						createResource(event.surface, event.area, dx, dy)
					end
				end
			else
				createResource(event.surface, event.area, dx, dy)
			end
		end
	end
end)

--[[
Good AlienBiomes test map:

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

--]]
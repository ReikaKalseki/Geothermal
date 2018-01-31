require "config"

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

function createResource(surface, chunk, dx, dy, color)
	if --[[isInChunk(dx, dy, chunk) and ]]canPlaceAt(surface, dx, dy) then
		local clr = (color and color ~= "red" and color ~= "orange") and ("-" .. color) or ""
		surface.create_entity{name = "geothermal" .. clr, position = {x = dx, y = dy}, force = game.forces.neutral, amount = 1000}
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
	local lavatiles = game.tile_prototypes["volcanic-orange-heat-1"]
	if lavatiles then
		f0 = 0.5
	end
	local f = f0*math.min(10, 1+(dd/1000))
	f = f*Config.frequency
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
		count = math.max(1, math.ceil(df*count*Config.size))
		for i = 0, count do
			local r = 3
			if lavatiles then
				r = 16
			end
			r = math.floor(r*Config.size+0.5)
			local dx = x-r+rand(0, r*2)
			local dy = y-r+rand(0, r*2)
			if lavatiles then
				local tile = event.surface.get_tile(dx, dy).name
				--game.print(tile)
				if string.find(tile, "volcanic", 1, true) then
					local heat = tonumber(string.sub(tile, -1)) -- 1-4, 4 is hotter & brighter
					--game.print(tile .. " > " .. heat)
					local f2 = 0.4*((heat/4)^2)--0.25*heat/4
					f1 = rand(0, 2147483647)/2147483647
					if f1 < f2 then
						local clr = nil
						if Config.geothermalColor then
							clr = string.sub(tile, string.len("volcanic")+2, -2-string.len("heat")-2)
							--game.print(clr)
						end
						createResource(event.surface, event.area, dx, dy, clr)
					end
				end
			else
				--game.print("No lavatiles found?!")
				createResource(event.surface, event.area, dx, dy)
			end
		end
	end
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

--]]
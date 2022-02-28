require'game'
math.randomseed(os.time())
game.max_pop = 16
game.organisms = {}
for i=1, 6 do
	game.organisms[i] = {Mass=13*math.random(3), Hair=13*math.random(3), Legs=13*math.random(3), Neck=7*math.random(2), Striped=7*math.random(2)}
end
function game.print()
	local x
	for i,v in ipairs(game.organisms) do
		x = v.Mass
		io.write("Mass")
		io.write(tostring(x % 3))
		x = math.floor(x/3)
		io.write(tostring(x % 3))
		x = math.floor(x/3)
		io.write(tostring(x % 3))
		io.write(" ")
		x = v.Hair
		io.write("Hair")
		io.write(tostring(x % 3))
		x = math.floor(x/3)
		io.write(tostring(x % 3))
		x = math.floor(x/3)
		io.write(tostring(x % 3))
		io.write(" ")
		x = v.Legs
		io.write("Legs")
		io.write(tostring(x % 3))
		x = math.floor(x/3)
		io.write(tostring(x % 3))
		x = math.floor(x/3)
		io.write(tostring(x % 3))
		io.write(" ")
		x = v.Neck
		io.write("Neck")
		io.write(tostring(x % 2))
		x = math.floor(x/2)
		io.write(tostring(x % 2))
		x = math.floor(x/2)
		io.write(tostring(x % 2))
		io.write(" ")
		x = v.Striped
		io.write("Striped")
		io.write(tostring(x % 2))
		x = math.floor(x/2)
		io.write(tostring(x % 2))
		x = math.floor(x/2)
		io.write(tostring(x % 2))
		io.write("\n")
	end
end
while true do
	game.reproduce()
	print("After reproduction:")
	game.print()
	io.read("*line")
	game.kill()
	print("After death:")
	game.print()
	print("Get disaster? ")
	game.disaster = io.read("*line")
	if game.disaster == "" then game.disaster = nil end
end

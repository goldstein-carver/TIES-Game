require'game'
math.randomseed(os.time())
game.max_pop = 16
game.organisms = {}
simwins = 0
simlosses = 0
function game.run_sound(x) end
while simwins + simlosses < 1000 do
	for i=1, 6 do
		game.organisms[i] = {Mass=13*math.random(3), Hair=13*math.random(3), Legs=13*math.random(3), Neck=7*math.random(2), Striped=7*math.random(2)}
	end
	local totalrounds = 0
	local roundsofdisaster = 0
	while game.organisms[1] and game.organisms[2] and totalrounds < 18 do
		game.reproduce()
		game.kill()
		roundsofdisaster = roundsofdisaster + 1
		if roundsofdisaster == 3 and not game.disaster then
			game.choose_disaster()
			roundsofdisaster = 0
		elseif game.disaster == "disease" or game.disaster == "volcano" or game.disaster == "asteroid" then
			game.disaster = nil
			roundsofdisaster = 0
		elseif roundsofdisaster == 3 then
			game.disaster = nil
			roundsofdisaster = 0
		end
		totalrounds = totalrounds + 1
	end
	if game.organisms[1] and game.organisms[2] then
		simwins = simwins + 1
		io.write(tostring(simlosses+simwins) .. "W\n")
	else
		simlosses = simlosses + 1
		io.write(tostring(simlosses+simwins) .. "L\n")
	end
end
print(simwins)

--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
--Darwin is 257x300
--Mass (3), Hair (3), Legs (3), Neck (2), Striped (2)
--Use bit or trit math, with least significant being the phenotype and other two being the alleles
game = {}
game.began = false
game.elapsed_time = 0
game.organisms = {}
function game.load()
	game.smallfont = love.graphics.newFont(20)
	game.bigfont = love.graphics.newFont(30)
	game.verybigfont = love.graphics.newFont(40)
	game.hand = love.mouse.getSystemCursor("hand")
	game.background = love.graphics.newImage("images/Environment.jpg")
	game.hotbackground = love.graphics.newImage("images/HotEnvironment.jpg")
	game.coldbackground = love.graphics.newImage("images/ColdEnvironment.jpg")
	game.asteroidbackground = love.graphics.newImage("images/AsteroidEnvironment.jpg")
	game.volcanobackground = love.graphics.newImage("images/VolcanoEnvironment.jpg")
	game.woodbackground = love.graphics.newImage("images/WoodBackground.jpg")
	game.tree = love.graphics.newImage("images/tree.png")
	game.darwin = love.graphics.newImage("images/Darwin.png")
	game.darwinmasked = love.graphics.newImage("images/DarwinMask.png")
	game.logo = love.graphics.newImage("images/SmallTIES.jpg")
	game.predator = love.graphics.newImage("images/predator.png")
	game.boldfont = love.graphics.newFont("Bold.ttf")
	game.critters = {}
	game.max_pop = 16
end
function game.cleanup()
	game.smallfont:release()
	game.bigfont:release()
	game.verybigfont:release()
	game.hand:release()
	game.background:release()
	game.hotbackground:release()
	game.coldbackground:release()
	game.asteroidbackground:release()
	game.volcanobackground:release()
	game.woodbackground:release()
	game.tree:release()
	game.darwin:release()
	game.darwinmasked:release()
	game.run_sound(nil)
	for _, critter in ipairs(game.critters) do
		critter:release()
	end
	game.critters = nil
	game.logo:release()
	game.predator:release()
	game.boldfont:release()
end
function game.load_critter(critter)
	if type(critter) == "table" then
		local string = "" .. critter.Mass % 3 .. critter.Hair % 3 .. critter.Striped % 2 .. critter.Neck % 2 .. critter.Legs % 3
		if game.critters[string] then
			return game.critters[string]
		else
			game.critters[string] = love.graphics.newImage("images/critter" .. string .. ".png")
			return game.critters[string]
		end
	elseif type(critter) == "string" then
		if game.critters[critter] then
			return game.critters[critter]
		else
			game.critters[critter] = love.graphics.newImage("images/critter" .. critter .. ".png")
			return game.critters[critter]
		end
	end
end
function game.debase(num, base)
	local z = num % base
	num = (num - z)/base
	local y = num % base
	num = (num - y)/base
	return tostring(num) .. tostring(y) .. tostring(z)
end
function game.lose()
	if game.disaster == "predator" then
		game.talking = "Bummer! Your species did not have enough camouflage or long legs to avoid those hungry predators. Would you like to try again?"
		game.run_sound("audios/Darwin_L_Predator.ogg")
	elseif game.disaster == "cold" then
		game.talking = "Too bad. Your TIES critters couldn’t stay warm enough to survive. Maybe thicker fur coats would have helped. Would you like to try again?"
		game.run_sound("audios/Darwin_L_Cold.ogg")
	elseif game.disaster == "heat" then
		game.talking = "Too bad. Your TIES critters couldn't stay cool enough to survive. Maybe a larger surface area would have helped. Would you like to try again?"
		game.run_sound("audios/Darwin_L_Heat.ogg")
	elseif game.disaster == "disease" then
		game.talking = "Oh no! Your species was wiped out by the spreading disease. Perhaps more variation would have helped. Would you like to try again?"
		game.run_sound("audios/Darwin_L_Disease.ogg")
	elseif game.disaster == "high food" then
		game.talking = "Unfortunately, your species wasn't tall enough to reach the food, so they starved. Would you like to try again?"
		game.run_sound("audios/Darwin_L_HighFood.ogg")
	elseif game.disaster == "asteroid" then
		game.talking = "Sadly, the asteroid's impact on the world's ecosystems was too severe for your TIES critters to survive. Would you like to try again?"
		game.run_sound("audios/Darwin_L_Asteroid.ogg")
	elseif game.disaster == "volcano" then
		game.talking = "Sadly, the volcano's impact on the world's ecosystems was too severe for your TIES critters to survive. Would you like to try again?"
		game.run_sound("audios/Darwin_L_Volcano.ogg")
	end
	game.arrowvisible = true
	game.ended = true
end
function game.win()
	game.displaydisaster = nil
	game.talking = "Yay!! Your species survived one million years! Hopefully, you learned something about natural selection along the way. Do you want to try again?"
	game.arrowvisible = true
	game.ended = true
	game.run_sound("audios/Darwin_Win.ogg")
end
function game.setwheel()
	game.spins = game.spins - 1
	game.wheel = {critters={}, theta=0, omega=0, clickable=true}
	local organismcount = 0
	while game.organisms[organismcount+1] do
		organismcount = organismcount + 1
	end
	if organismcount == 0 then return end
	game.wheel.chosenone = math.random(organismcount)
	local omass = game.organisms[game.wheel.chosenone].Mass % 3
	local ohair = game.organisms[game.wheel.chosenone].Hair % 3
	local ostriped = game.organisms[game.wheel.chosenone].Striped % 2
	local oneck = game.organisms[game.wheel.chosenone].Neck % 2
	local olegs = game.organisms[game.wheel.chosenone].Legs % 3
	if omass == 1 then
		game.wheel.critters[1] = 2 .. ohair .. ostriped .. oneck .. olegs
		game.wheel.critters[2] = 0 .. ohair .. ostriped .. oneck .. olegs
	elseif omass == 2 then
		game.wheel.critters[1] = 1 .. ohair .. ostriped .. oneck .. olegs
		game.wheel.critters[2] = 0 .. ohair .. ostriped .. oneck .. olegs
	elseif omass == 0 then
		game.wheel.critters[1] = 1 .. ohair .. ostriped .. oneck .. olegs
		game.wheel.critters[2] = 2 .. ohair .. ostriped .. oneck .. olegs
	end
	if ohair == 1 then
		game.wheel.critters[3] = omass .. 2 .. ostriped .. oneck .. olegs
		game.wheel.critters[4] = omass .. 0 .. ostriped .. oneck .. olegs
	elseif ohair == 2 then
		game.wheel.critters[3] = omass .. 1 .. ostriped .. oneck .. olegs
		game.wheel.critters[4] = omass .. 0 .. ostriped .. oneck .. olegs
	elseif ohair == 0 then
		game.wheel.critters[3] = omass .. 1 .. ostriped .. oneck .. olegs
		game.wheel.critters[4] = omass .. 2 .. ostriped .. oneck .. olegs
	end
	if olegs == 1 then
		game.wheel.critters[5] = omass .. ohair .. ostriped .. oneck .. 2
		game.wheel.critters[6] = omass .. ohair .. ostriped .. oneck .. 0
	elseif olegs == 2 then
		game.wheel.critters[5] = omass .. ohair .. ostriped .. oneck .. 1
		game.wheel.critters[6] = omass .. ohair .. ostriped .. oneck .. 0
	elseif olegs == 0 then
		game.wheel.critters[5] = omass .. ohair .. ostriped .. oneck .. 1
		game.wheel.critters[6] = omass .. ohair .. ostriped .. oneck .. 2
	end
	if oneck == 1 then
		game.wheel.critters[7] = omass .. ohair .. ostriped .. 0 .. olegs
	elseif oneck == 0 then
		game.wheel.critters[7] = omass .. ohair .. ostriped .. 1 .. olegs
	end
	if ostriped == 1 then
		game.wheel.critters[8] = omass .. ohair .. 0 .. oneck .. olegs
	elseif ostriped == 0 then
		game.wheel.critters[8] = omass .. ohair .. 1 .. oneck .. olegs
	end
	local rearranged_table = {}
	local i = 1
	while i <= 8 do
		local rand = math.random(9-i)
		local j = 0
		local k = 0
		while j < rand do
			k = k+1
			if not rearranged_table[k] then
				j = j+1
			end
		end
		rearranged_table[k] = game.wheel.critters[i]
		i=i+1
	end
	game.wheel.critters = rearranged_table
end
function game.walk()
	local i = 1
	while game.organisms[i] do
		local bad = true
		while bad do
			bad = false
			game.organisms[i].y = 660-math.random(3)*100+math.random(20)
			game.organisms[i].x = 10+math.random(924)
			local j = i-1
			while j >= 1 do
				if math.abs(game.organisms[i].y-game.organisms[j].y) <= 40 and math.abs(game.organisms[i].x-game.organisms[j].x) <= 90 then
					bad = true
					break
				end
				j = j-1
			end
		end
		i=i+1
	end
	table.sort(game.organisms, function(a,b) return a.y < b.y end)
end
function game.choose_susceptible_attributes()
	local attribute
	local phenotype
	local rand = math.random(5)
	if rand == 1 then
		attribute = "Mass"
	elseif rand == 2 then
		attribute = "Hair"
	elseif rand == 3 then
		attribute = "Legs"
	elseif rand == 4 then
		attribute = "Neck"
	elseif rand == 5 then
		attribute = "Striped"
	end
	if rand <= 3 then
		local list = {}
		for _,org in ipairs(game.organisms) do
			list[org[attribute]%3] = true
		end
		if list[0] and list[1] and list[2] then
			phenotype = math.random(3)-1
		elseif list[0] and list[1] then
			phenotype = math.random(2)-1
		elseif list[0] and list[2] then
			phenotype = 2*math.random(2)-2
		elseif list[1] and list[2] then
			phenotype = math.random(2)
		elseif list[0] then
			phenotype = 0
		elseif list[1] then
			phenotype = 1
		elseif list[2] then
			phenotype = 2
		end
	else
		local list = {}
		for _,org in ipairs(game.organisms) do
			list[org[attribute]%2] = true
		end
		if list[0] and list[1] then
			phenotype = math.random(2)-1
		elseif list[0] then
			phenotype = 0
		elseif list[1] then
			phenotype = 1
		end
	end
	return attribute, phenotype
end
function game.choose_disaster()
	while game.lastdisaster == game.disaster or not game.disaster do
		local rand = math.random(100)
		if rand <= 5 then
			game.disaster = "volcano"
			game.talking = "Everybody run! A volcano is erupting. There is no time to use the Wheel of Mutations. Cross your fingers that some of your TIES critters have what it takes to survive."
			game.run_sound("audios/Darwin_Volcano.ogg")
		elseif rand <= 25 then
			game.disaster = "predator"
			game.talking = "Don’t look now but hungry predators have entered the territory. Remember, you can pause the game and try your luck on the Wheel of Mutations three times during your time travel."
			game.run_sound("audios/Darwin_Predator.ogg")
		elseif rand <= 45 then
			game.disaster = "cold"
			game.talking = "Yikes, it’s cold! Some of the TIES critters may not be able to stay warm enough to survive this colder climate. Remember, you can pause the game and try your luck on the Wheel of Mutations three times during your time travel."
			game.run_sound("audios/Darwin_Cold.ogg")
		elseif rand <= 65 then
			game.disaster = "heat"
			game.talking = "It sure is hot! It appears we are entering a period of global warming. Remember, you can pause the game and try your luck on the Wheel of Mutations three times during your time travel."
			game.run_sound("audios/Darwin_Heat.ogg")
		elseif rand <= 85 then
			game.disaster = "high food"
			game.talking = "Check out the delicious fruit trees sprouting in your territory. Are your TIES critters tall enough? Remember, you can pause the game and try your luck on the Wheel of Mutations three times during your time travel."
			game.run_sound("audios/Darwin_HighFood.ogg")
		elseif rand <= 98 then
			game.disaster = "disease"
			game.primary_attribute, game.primary_phenotype = game.choose_susceptible_attributes()
			game.secondary_attribute, game.secondary_phenotype = game.choose_susceptible_attributes()
			while game.secondary_attribute == game.primary_attribute do
				game.secondary_attribute, game.secondary_phenotype = game.choose_susceptible_attributes()
			end
			game.talking = "Oh no, a deadly virus is spreading in your population. There is no time to use the Wheel of Mutations. Cross your fingers that some of your TIES critters have what it takes to survive."
			game.run_sound("audios/Darwin_Disease.ogg")
		elseif rand <= 100 then
			game.disaster = "asteroid"
			game.talking = "Mayday!! Mayday!! Your planet has been hit by an asteroid. This is what you call a cataclysmic event. There is definitely no time to use the Wheel of Mutations. Cross your fingers that some of your TIES critters have what it takes to survive."
			game.run_sound("audios/Darwin_Asteroid.ogg")
		end
	end
	game.lastdisaster = game.disaster
end
function game.kill()
	if not game.disaster then return end
	if game.disaster == "volcano" or game.disaster == "asteroid" then
		local counter = 0
		for _,__ in ipairs(game.organisms) do
			counter = counter + 1
		end
		while counter > 0 do
			if math.random(3) > 1 then
				table.remove(game.organisms, counter)
			end
			counter = counter - 1
		end
	end
	if game.disaster == "predator" then
		local counter = 0
		for _,__ in ipairs(game.organisms) do
			counter = counter + 1
		end
		while counter > 0 do
			local stripes = game.organisms[counter].Striped % 2
			local legs = game.organisms[counter].Legs % 3
			local survival = stripes + legs + 1 --Roll d4, die if > this number
			if math.random(4) > survival then
				table.remove(game.organisms, counter)
			end
			counter = counter - 1
		end
	end
	if game.disaster == "cold" then
		local counter = 0
		for _,__ in ipairs(game.organisms) do
			counter = counter + 1
		end
		while counter > 0 do
			local mass = game.organisms[counter].Mass % 3
			local hair = game.organisms[counter].Hair % 3
			local legs = game.organisms[counter].Legs % 3
			local neck = game.organisms[counter].Neck % 2
			local survival = mass + hair - legs - neck + 1 --Roll d4, die if > this number
			if math.random(4) > survival then
				table.remove(game.organisms, counter)
			end
			counter = counter - 1
		end
	end
	if game.disaster == "heat" then
		local counter = 0
		for _,__ in ipairs(game.organisms) do
			counter = counter + 1
		end
		while counter > 0 do
			local mass = game.organisms[counter].Mass % 3
			local hair = game.organisms[counter].Hair % 3
			local survival = 4 - mass - hair --Roll d4, die if > this number
			if math.random(4) > survival then
				table.remove(game.organisms, counter)
			end
			counter = counter - 1
		end
	end
	if game.disaster == "high food" then
		local counter = 0
		for _,__ in ipairs(game.organisms) do
		counter = counter + 1
		end
		while counter > 0 do
			local neck = game.organisms[counter].Neck % 2
			local survival = 2*neck + 2 --Roll d4, die if > this number
			if math.random(4) > survival then
				table.remove(game.organisms, counter)
			end
			counter = counter - 1
		end
	end
	if game.disaster == "disease" then
		local primary_mod = 3
		if game.primary_attribute == "Neck" or game.primary_attribute == "Striped" then
			primary_mod = 2
		end
		local secondary_mod = 3
		if game.secondary_attribute == "Neck" or game.secondary_attribute == "Striped" then
			secondary_mod = 2
		end
		local counter = 0
		for _,__ in ipairs(game.organisms) do
			counter = counter + 1
		end
		while counter > 0 do
			local death = 0 --Roll d4, die if <= this number
			if game.organisms[counter][game.primary_attribute] % primary_mod == game.primary_phenotype then
				death = 3
			end
			if game.organisms[counter][game.secondary_attribute] % secondary_mod == game.secondary_phenotype then
				death = death + 1
			end
			if math.random(4) <= death then
				table.remove(game.organisms, counter)
			end
			counter = counter - 1
		end
	end
	return nil
end
function game.mate(x, y, surplus)
	m1 = game.organisms[x]
	m2 = game.organisms[y]
	local i = 1
	local max = 2
	if surplus then
		max = 3
	end
	while i <= max do
		local child = {}
		local sig1 = math.random(2)
		local sig2 = math.random(2)
		local sig3
		if sig1 == 1 then
			sig1 = math.floor(m1.Mass / 9)
		else
			sig1 = math.floor(m1.Mass / 3) % 3
		end
		if sig2 == 1 then
			sig2 = math.floor(m2.Mass / 9)
		else
			sig2 = math.floor(m2.Mass / 3) % 3
		end
		if sig1 == 1 or sig2 == 1 then
			sig3 = 1
		elseif sig1 == sig2 then
			sig3 = sig1
		else
			sig3 = 1
		end
		child.Mass = 9*sig1 + 3*sig2 + sig3
		sig1 = math.random(2)
		sig2 = math.random(2)
		if sig1 == 1 then
			sig1 = math.floor(m1.Hair / 9)
		else
			sig1 = math.floor(m1.Hair / 3) % 3
		end
		if sig2 == 1 then
			sig2 = math.floor(m2.Hair / 9)
		else
			sig2 = math.floor(m2.Hair / 3) % 3
		end
		if sig1 == 1 or sig2 == 1 then
			sig3 = 1
		elseif sig1 == sig2 then
			sig3 = sig1
		else
			sig3 = 1
		end
		child.Hair = 9*sig1 + 3*sig2 + sig3
		sig1 = math.random(2)
		sig2 = math.random(2)
		if sig1 == 1 then
			sig1 = math.floor(m1.Legs / 9)
		else
			sig1 = math.floor(m1.Legs / 3) % 3
		end
		if sig2 == 1 then
			sig2 = math.floor(m2.Legs / 9)
		else
			sig2 = math.floor(m2.Legs / 3) % 3
		end
		if sig1 == 1 or sig2 == 1 then
			sig3 = 1
		elseif sig1 == sig2 then
			sig3 = sig1
		else
			sig3 = 1
		end
		child.Legs = 9*sig1 + 3*sig2 + sig3
		sig1 = math.random(2)
		sig2 = math.random(2)
		if sig1 == 1 then
			sig1 = math.floor(m1.Neck / 4)
		else
			sig1 = math.floor(m1.Neck / 2) % 2
		end
		if sig2 == 1 then
			sig2 = math.floor(m2.Neck / 4)
		else
			sig2 = math.floor(m2.Neck / 2) % 2
		end
		if sig1 == 1 and sig2 == 1 then
			sig3 = 1
		else
			sig3 = 0
		end
		child.Neck = 4*sig1 + 2*sig2 + sig3
		sig1 = math.random(2)
		sig2 = math.random(2)
		if sig1 == 1 then
			sig1 = math.floor(m1.Striped / 4)
		else
			sig1 = math.floor(m1.Striped / 2) % 2
		end
		if sig2 == 1 then
			sig2 = math.floor(m2.Striped / 4)
		else
			sig2 = math.floor(m2.Striped / 2) % 2
		end
		if sig1 == 1 and sig2 == 1 then
			sig3 = 1
		else
			sig3 = 0
		end
		child.Striped = 4*sig1 + 2*sig2 + sig3
		if i == 1 then
			game.organisms[x] = child
		elseif i == 2 then
			game.organisms[y] = child
		else
			table.insert(game.organisms, child)
		end
		i = i + 1
	end
end
function game.reproduce()
	local counter = 0
	local finished = 0
	for _,__ in ipairs(game.organisms) do
		counter = counter + 1
	end
	if counter < 2 then
		table.remove(game.organisms)
		return nil
	end
	local mated = {}
	mated[0] = true --0 always holds true, so this can be used for placeholders
	if counter % 2 == 1 then
		mated[math.random(counter)] = true
		finished = 1
	end
	local extra_offspring = 0
	local mate1 = 0
	local mate2 = 0
	while finished < counter do
		while mated[mate1] do
			mate1 = math.random(counter)
		end
		while mated[mate2] or mate2 == mate1 do
			mate2 = math.random(counter)
		end
		if counter + extra_offspring < game.max_pop then
			game.mate(mate1, mate2, true)
			extra_offspring = extra_offspring + 1
		else
			game.mate(mate1, mate2, false)
		end
		mated[mate1] = true
		mated[mate2] = true
		finished = finished + 2
	end
end
function game.generate_choices()
	game.choices = {}
	local i = 1
	while i <= 9 do
		game.choices[i] = {Mass=math.random(3)-1, Hair=math.random(3)-1, Legs=math.random(3)-1, Striped=math.random(2)-1, Neck=math.random(2)-1}
		i=i+1
	end
end
function game.make_choice(x, y)
	if x <= 200 then
		x = 0
	elseif x <= 320 then
		x = 1
	else
		x = 2
	end
	if y <= 250 then
		y = 0
	elseif y <= 350 then
		y = 1
	else
		y = 2
	end
	local z = 3*y+x+1
	game.selections = game.selections + 1
	game.organisms[game.selections] = {Mass=13*game.choices[z].Mass, Hair=13*game.choices[z].Hair, Legs=13*game.choices[z].Legs, Neck=7*game.choices[z].Neck, Striped=7*game.choices[z].Striped, x=500+100*game.selections, y=500}
end
function game.run_sound(filepath)--nil can be used to cancel audio
	if not is_muted then
		love.audio.stop()
		if game.audioSource then
			game.audioSource:release()
			game.audioSource = nil
		end
		if filepath then
			game.audioSource = love.audio.newSource(filepath, "stream")
			game.audioSource:play()
		end
	end
end
function game.draw()
	love.graphics.draw(game.woodbackground, 0, 0)
	if game.displaydisaster == "cold" then
		love.graphics.draw(game.coldbackground, 0, 60)
	elseif game.displaydisaster == "heat" then
		love.graphics.draw(game.hotbackground, 0, 60)
	elseif game.displaydisaster == "asteroid" then
		love.graphics.draw(game.asteroidbackground, 0, 60)
	elseif game.displaydisaster == "volcano" then
		love.graphics.draw(game.volcanobackground, 0, 60)
	else
		love.graphics.draw(game.background, 0, 60)
	end
	--Top Ribbon
	love.graphics.setFont(game.smallfont)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 171, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 513, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 683, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 854, 0, 170, 60, 10, 8)
	love.graphics.setColor(245/255,222/255,179/255)
	love.graphics.rectangle("fill", 342, 0, 170, 60, 10, 8)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Home", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.setColor(1, 1, 1)
	if game.displaydisaster == "volcano" or game.displaydisaster == "asteroid" then
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	if game.displaydisaster == "high food" then
		love.graphics.draw(game.tree, 200, 200)
		love.graphics.draw(game.tree, 800, 170)
	end
	if game.disaster == "predator" then
		love.graphics.draw(game.predator, 300, 200, 0, 0.5, 0.5)
		love.graphics.draw(game.predator, 600, 200, 0, 0.5, 0.5)
		love.graphics.draw(game.predator, 900, 200, 0, 0.5, 0.5)
	end
	for index, critter in ipairs(game.organisms) do
		local picture = game.load_critter(critter)
		love.graphics.draw(picture, critter.x, critter.y-picture:getHeight(), 0, 1, 1)
		if game.shimmertarget == index then
			love.graphics.setColor(1, 1, 102/255, game.shimmeralpha)
			love.graphics.rectangle("fill", critter.x, critter.y-picture:getHeight(), picture:getWidth(), picture:getHeight())
			love.graphics.setColor(1, 1, 1, 1)
		end
	end
	love.graphics.setColor(1, 1, 1)
	if game.choices then
		love.graphics.setColor(210/255, 180/255, 140/255)
		love.graphics.rectangle("fill", 50, 100, 400, 460)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("More Mutations", 50, 530, 400, "center")
		love.graphics.setColor(1, 1, 1)
		local i = 1
		while i <= 9 do
			love.graphics.draw(game.load_critter(game.choices[i]), 100+120*((i-1)%3), 25+120*math.ceil(i/3), 0, 1, 1)
			i=i+1
		end
	end
	--Bottom Ribbon
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 580, 1024, 120)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(game.logo, 0, 580)
	love.graphics.setColor(31/255, 67/255, 156/255)
	love.graphics.print("Hints", 965, 555)
	love.graphics.setColor(1, 1, 1)
	if game.disaster == "disease" then
		love.graphics.draw(game.darwinmasked, 140, 550, 0, 0.5, 0.5)
	else
		love.graphics.draw(game.darwin, 140, 550, 0, 0.5, 0.5)
	end
	if game.arrowvisible then
		love.graphics.polygon("fill", 930, 595, 930, 685, 1020, 640)
		if game.ended then
			love.graphics.setColor(0, 1, 0)
			love.graphics.print("Replay", 935, 628)
		end
	end
	if game.talking then
		love.graphics.setColor(210/255, 180/255, 140/255)
		love.graphics.polygon("fill", 250, 635, 270, 625, 270, 645)
		love.graphics.rectangle("fill", 270, 590, 650, 100, 20, 20)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf(game.talking, 285, 595, 630, "left")
	end
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 840, 90, 170, 60, 10, 8)
	love.graphics.setColor(245/255,222/255,179/255)
	love.graphics.rectangle("fill", 850, 100, 150, 40, 10, 8)
	love.graphics.setColor(31/255, 67/255, 156/255)
	love.graphics.setFont(game.boldfont)
	love.graphics.printf("YEARS:", 860, 112, 130, "left")
	love.graphics.printf(tostring(game.years), 860, 112, 130, "right")
	love.graphics.setColor(1, 1, 1)
	if game.wheel then
		love.graphics.push()
		love.graphics.translate(512, 330)
		love.graphics.circle("fill", 0, 0, 210)
		love.graphics.push()
		love.graphics.rotate(game.wheel.theta-math.pi/4)
		local i = 1
		while i <= 8 do
			love.graphics.rotate(math.pi/4)
			if i % 2 == 1 then
				love.graphics.setColor(243/255, 116/255, 47/255)
			else
				love.graphics.setColor(31/255, 67/255, 156/255)
			end
			love.graphics.arc("fill", 0, 0, 200, 0, math.pi/4)
			i = i+1
		end
		love.graphics.setColor(1, 1, 1)
		love.graphics.rotate(math.pi/8)
		i = 1
		while i <= 8 do
			local image = game.load_critter(game.wheel.critters[i])
			love.graphics.draw(image, image:getWidth()/2-10, 180, math.pi)
			love.graphics.rotate(math.pi/4)
			i = i+1
		end
		love.graphics.pop()
		love.graphics.polygon("fill", -5, 200, 5, 200, 0, 170)
		love.graphics.pop()
	elseif game.began and not game.ended then
		if not (game.disaster == "disease" or game.disaster == "asteroid" or game.disaster == "volcano") then
			local i = 1
			while i <= 8 do
				if i % 2 == 1 then
					love.graphics.setColor(243/255, 116/255, 47/255)
				else
					love.graphics.setColor(31/255, 67/255, 156/255)
				end
				love.graphics.arc("fill", 80, 120, 40, (i-1)*math.pi/4, i*math.pi/4)
				i = i+1
			end
			love.graphics.setFont(game.bigfont)
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(tostring(game.spins), 70, 105)
		end
	end
	if game.ended then
		love.graphics.setColor(243/255, 116/255, 47/255)
		love.graphics.ellipse("fill", 512, 330, 200, 100)
		love.graphics.setColor(31/255, 67/255, 156/255)
		love.graphics.setFont(game.verybigfont)
		if game.displaydisaster then
			love.graphics.printf("You lost!", 312, 310, 400, "center")
		else
			love.graphics.printf("You won!", 312, 310, 400, "center")
		end
	end
	--Final White Color Set
	love.graphics.setColor(1, 1, 1)
end
function game.update(dt)
	game.cursor_check()
	if game.shimmeralpha then
		game.shimmeralpha = game.shimmeralpha - 2*dt
		if game.shimmeralpha <= 0 then
			game.shimmeralpha = nil
			game.shimmertarget = nil
		end
	end
	--Game counter
	if game.began and not game.ended then
		if game.paused then
			if game.paused > 0 then
				game.paused = game.paused - dt
			else
				if game.arrowclicked then
					game.arrowvisible = false
					game.paused = nil
					game.talking = nil
					game.arrowclicked = false
					game.run_sound()
				else
					game.arrowvisible = true
				end
			end
		elseif game.wheel then
			if game.wheel.waittime then
				game.wheel.waittime = game.wheel.waittime - dt
				if game.wheel.waittime <= 0 then
					local n = math.ceil(4*game.wheel.theta/math.pi)
					n = (1-n) % 8
					local org = game.organisms[game.wheel.chosenone]
					local str = game.wheel.critters[n+1]
					if tostring(org.Mass % 3) ~= string.sub(str, 1, 1) then
						org.Mass = 13*tonumber(string.sub(str, 1, 1))
					elseif tostring(org.Hair % 3) ~= string.sub(str, 2, 2) then
						org.Hair = 13*tonumber(string.sub(str, 2, 2))
					elseif tostring(org.Striped % 2) ~= string.sub(str, 3, 3) then
						org.Striped = 7*tonumber(string.sub(str, 3, 3))
					elseif tostring(org.Neck % 2) ~= string.sub(str, 4, 4) then
						org.Neck = 7*tonumber(string.sub(str, 4, 4))
					elseif tostring(org.Legs % 3) ~= string.sub(str, 5, 5) then
						org.Legs = 13*tonumber(string.sub(str, 5, 5))
					end
					game.shimmertarget = game.wheel.chosenone
					game.shimmeralpha = 1
					game.wheel = nil
				end
			elseif not game.wheel.clickable then
				game.wheel.theta = (game.wheel.theta + game.wheel.omega*dt) % (2*math.pi)
				game.wheel.omega = game.wheel.omega - 2*math.random()*dt
				if game.wheel.omega <= 0 then
					game.wheel.waittime = 1.5
				end
			end
		else
			game.elapsed_time = game.elapsed_time + dt
			if game.elapsed_time > 3 then
				game.next_generation()
			end
		end
	elseif not game.began then
		game.handle_pregame(dt)
	elseif game.ended and game.arrowclicked then
		game.arrowvisible = false
		game.paused = nil
		game.talking = nil
		game.arrowclicked = false
		game.run_sound()
		game.began = nil
		game.ended = nil
		game.displaydisaster = nil
		game.disaster = nil
		game.organisms = {}
		game.update(0)
	end
end
function game.handle_pregame(dt)
	game.elapsed_time = game.elapsed_time + dt
	if game.elapsed_time < 0.5 then
		game.arrowvisible = false
		game.talking = nil
		game.generations = 0
		game.years = 0
	elseif game.elapsed_time >= 0.5 and game.elapsed_time - dt < 0.5 then
		game.talking = "Welcome to the TIES Time Machine! The game is based on the rules of natural selection. Your species will have to survive a changing, often cruel, environment."
		game.run_sound("audios/Darwin1.ogg")
	elseif game.elapsed_time >= 2 and game.elapsed_time < 100 then
		game.arrowvisible = true
		game.elapsed_time = 2
		if game.arrowclicked then
			game.arrowclicked = false
			game.arrowvisible = false
			game.talking = "Introducing the organism known as Tiesius critterus, or the TIES Critter. The population has many different traits (variation, yay!). You get to choose the traits of your starter population."
			game.elapsed_time = 100
			game.run_sound("audios/Darwin2.ogg")
		end
	elseif game.elapsed_time >= 102 and game.elapsed_time < 200 then
		game.elapsed_time = 102
		game.arrowvisible = true
		if game.arrowclicked then
			game.arrowclicked = false
			game.arrowvisible = false
			game.talking = "Be careful choosing the traits of your starter population. Hint: Variation helps. Consider the possible changing environments your TIES Critters will face."
			game.elapsed_time = 200
			game.run_sound("audios/Darwin3.ogg")
			game.generate_choices()--Creates game.choices
			game.selections = 0
		end
	elseif game.elapsed_time >= 200 and game.elapsed_time < 300 then
		game.elapsed_time = 200
		if game.selections == 3 then
			game.choices = nil
			game.arrowvisible = false
			game.talking = "Here we go. The goal of the TIES Time Machine is for your species to survive one million years. The individuals with the traits best suited to the changing environment will survive."
			game.run_sound("audios/Darwin4.ogg")
			game.selections = nil
			game.elapsed_time = 300
			local i = 1
			while i <= 3 do
				game.organisms[i+3] = {Mass=game.organisms[i].Mass, Hair=game.organisms[i].Hair, Neck=game.organisms[i].Neck, Legs=game.organisms[i].Legs, Striped=game.organisms[i].Striped}
				i=i+1
			end
			game.walk()
		end
	elseif game.elapsed_time >= 302 then
		if game.arrowclicked == true then
			game.spins = 3
			game.run_sound("audios/Darwin5.ogg")
			game.talking = "You can spin the Wheel of Mutations three times during your time travel. Be careful: You do not know what you are going to get. Mutations are random."
			game.disaster = nil
			game.paused = 2
			game.began = true
			game.elapsed_time = 0
			game.round_count = 0
			game.lastdisaster = nil
			game.arrowclicked = false
			game.arrowvisible = false
		else
			game.arrowvisible = true
		end
	end
end
function game.cursor_check()
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(game.hand)
	elseif y >= 580 and x <= 135 then
		love.mouse.setCursor(game.hand)
	elseif y >= 555 and y <= 575 and x >= 965 then
		love.mouse.setCursor(game.hand)
	elseif x >= 925 and y >= 580 and game.arrowvisible then
		love.mouse.setCursor(game.hand)
	elseif game.choices and x >= 50 and x <= 450 and y <= 560 and y >= 100 then
		if y >= 520 then
			love.mouse.setCursor(game.hand)
		elseif (x >= 100 and x <= 180) or (x >= 220 and x <= 300) or (x >= 340 and x <= 420) then
			if (y >= 145 and y <= 225) or (y >= 265 and y <= 345) or (y >= 385 and y <= 465) then
				love.mouse.setCursor(game.hand)
			else
				love.mouse.setCursor()
			end
		else
			love.mouse.setCursor()
		end
	elseif (x-80)*(x-80)+(y-120)*(y-120) <= 1600 and game.began and game.spins > 0 then
		if game.began and (not game.ended) and (not game.wheel) and not (game.disaster == "disease" or game.disaster == "asteroid" or game.disaster == "volcano") then
			if game.generations > 0 or not game.paused then
				love.mouse.setCursor(game.hand)
			else
				love.mouse.setCursor()
			end
		else
			love.mouse.setCursor()
		end
	elseif game.wheel then
		if game.wheel.clickable then
			local dx = x-512
			local dy = y-330
			if dx*dx+dy*dy <= 44100 then
				love.mouse.setCursor(game.hand)
			else
				love.mouse.setCursor()
			end
		else
			love.mouse.setCursor()
		end
	else
		love.mouse.setCursor()
	end
end
function game.next_generation()
	game.shimmeralpha = nil
	game.shimmertarget = nil
	game.displaydisaster = game.disaster
	game.generations = game.generations + 1
	if game.generations  == 18 then
		game.years = 1000000
	else
		game.years = 55555*game.generations + math.random(10000)-5000
	end
	game.round_count = game.round_count + 1
	game.elapsed_time = 0
	game.reproduce()
	game.walk()
	game.kill()
	if game.generations < 18 and not game.organisms[2] then
		game.organisms[1] = nil
	end
	if not game.organisms[1] then
		game.lose()
	elseif game.round_count == 3 then
		if not game.disaster then
			game.round_count = 0
			game.choose_disaster()
			game.displaydisaster = game.disaster
			game.paused = 1
		else
			game.round_count = 0
			game.disaster = nil
		end
	elseif game.disaster == "disease" or game.disaster == "volcano" or game.disaster == "asteroid" then
		game.round_count = 0
		game.disaster = nil
	end
	if game.organisms[1] and game.generations == 18 then
		game.win()
	end
end
function game.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if y <= 60 then
		if x < 171 then
			switch("cover")
		elseif x < 342 then
			switch("learn")
		elseif x < 513 then
			--Already here
		elseif x < 683 then
			switch("quiz")
		elseif x < 854 then
			switch("bio")
		else
			switch("glossary")
		end
		return
	elseif y >= 555 and y <= 575 and x >= 965 then
		switch("hints")
	elseif y >= 580 and x <= 135 then
		love.system.openURL("https://www.tieseducation.org")
	elseif x >= 925 and y >= 580 and game.arrowvisible then
		game.arrowclicked = true
	elseif (x-80)*(x-80)+(y-120)*(y-120) <= 1600 and game.began and game.spins > 0 then
		if game.began and (not game.ended) and (not game.wheel) and not (game.disaster == "disease" or game.disaster == "asteroid" or game.disaster == "volcano") then
			if game.generations > 0 or not game.paused then
				game.setwheel()
			end
		end
	elseif game.choices then
		if x >= 50 and x <= 450 and y <= 560 and y >= 520 then
			game.generate_choices()
		elseif (x >= 100 and x <= 180) or (x >= 220 and x <= 300) or (x >= 340 and x <= 420) then
			if (y >= 145 and y <= 225) or (y >= 265 and y <= 345) or (y >= 385 and y <= 465) then
				game.make_choice(x, y)
			end
		end
	elseif game.wheel then
		if game.wheel.clickable then
			local dx = x-512
			local dy = y-330
			if dx*dx+dy*dy <= 44100 then
				game.wheel.clickable = false
				game.wheel.omega = math.pi*(math.random()+3.5)
			end
		end
	end
end
function game.touchpressed(id, x, y, dx, dy, pressure)
	game.mousepressed(x, y, 1)
end

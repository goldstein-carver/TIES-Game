--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
--Darwin is 257x300
game = {}
game.began = false
game.elapsed_time = 0
game.organisms = {}
function game.load()
	game.smallfont = love.graphics.newFont(20)
	game.hand = love.mouse.getSystemCursor("hand")
	game.background = love.graphics.newImage("images/Environment.jpg")
	game.woodbackground = love.graphics.newImage("images/WoodBackground.jpg")
	game.darwin = love.graphics.newImage("images/Darwin.png")
	game.critters = {}
	game.max_pop = 16
end
function game.cleanup()
	game.smallfont:release()
	game.hand:release()
	game.background:release()
	game.run_sound(nil)
	for _, critter in ipairs(game.critters) do
		critter:release()
	end
	game.critters = nil
end
function game.load_critter(critter)
	local string = "" .. critter.Mass % 3 .. critter.Hair % 3 .. critter.Striped % 2 .. critter.Neck % 2 .. critter.Legs % 3
	if game.critters[string] then
		return game.critters[string]
	else
		game.critters[string] = love.graphics.newImage("images/critter" .. string .. ".png")
		return game.critters[string]
	end
end
function game.debase(num, base)
	local z = num % base
	num = (num - z)/base
	local y = num % base
	num = (num - y)/base
	return tostring(num) .. tostring(y) .. tostring(z)
end
function game.setgame()--Begins the game
	game.run_sound("audios/Darwin4.ogg")
	game.began = true
	game.talking = "Here we go. The goal of the TIES Time Machine is for your species to survive one million years. The individuals with the traits best suited to the changing environment will survive."
	local i = 1
	while i <= 3 do
		game.organisms[i+3] = {Mass=game.organisms[i].Mass, Hair=game.organisms[i].Hair, Neck=game.organisms[i].Neck, Legs=game.organisms[i].Legs, Striped=game.organisms[i].Striped}
		i=i+1
	end
	--{{Mass=13, Hair=13, Neck=7, Legs=13, Striped=7}, {Mass=0, Hair=0, Neck=0, Legs=0, Striped=0}, {Mass=26, Hair=26, Neck=7, Legs=26, Striped=0}}
	game.walk()
	game.disaster = nil
	game.elapsed_time = 0
	game.round_count = 0
	game.paused = 2
	--Mass (3), Hair (3), Legs (3), Neck (2), Striped (2)
	--Use bit or trit math, with least significant being the phenotype and other two being the alleles
end
function game.lose()

end
function game.walk()
	
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
	local rand = math.random(6)
	if rand == 1 then
		game.disaster = "volcano"
	elseif rand == 2 then
		game.disaster = "predator"
	elseif rand == 3 then
		game.disaster = "cold"
	elseif rand == 4 then
		game.disaster = "heat"
	elseif rand == 5 then
		game.disaster = "high food"
	elseif rand == 6 then
		game.disaster = "disease"
		game.primary_attribute, game.primary_phenotype = game.choose_susceptible_attributes()
		game.secondary_attribute, game.secondary_phenotype = game.choose_susceptible_attributes()
		while game.secondary_attribute == game.primary_attribute do
			game.secondary_attribute, game.secondary_phenotype = game.choose_susceptible_attributes()
		end
	end
end
function game.kill()
	if not game.disaster then return end
	if game.disaster == "volcano" then
		local original_size = 0
		for _,__ in ipairs(game.organisms) do
			original_size = original_size + 1
		end
		if original_size <= 3 then
			local i = 1
			while i <= original_size do
				table.remove(game.organisms)
				i = i+1
			end
		else
			local new_size = math.floor(original_size/4)
			while original_size > new_size do
				table.remove(game.organisms)
				original_size = original_size - 1
			end
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
	game.organisms[game.selections] = {Mass=13*game.choices[z].Mass, Hair=13*game.choices[z].Hair, Legs=13*game.choices[z].Legs, Neck=7*game.choices[z].Neck, Striped=7*game.choices[z].Striped, x=500+100*game.selections, y=100}
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
	love.graphics.draw(game.background, 0, 60)
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
	love.graphics.printf("Intro", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.setColor(1, 1, 1)
	for _, critter in ipairs(game.organisms) do
		love.graphics.draw(game.load_critter(critter), critter.x, critter.y, 0, 1, 1)
	end
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
	--[[TESTING
	message = ""
	for _,org in ipairs(game.organisms) do
		message = message .. "Mass: " .. game.debase(org.Mass,3) .. ", Hair: " .. game.debase(org.Hair,3) .. ", Legs: " .. game.debase(org.Legs,3) .. ", Neck: " .. game.debase(org.Neck,2) .. ", Striped: " .. game.debase(org.Striped,2) .. "\n"
	end
	if game.disaster then
		message = message .. "DISASTER: " .. game.disaster .. "\n"
		if game.disaster == "disease" then
			message = message .. "PRIMARY: " .. game.primary_attribute .. game.primary_phenotype .. "\n"
			message = message .. "SECONDARY: " .. game.secondary_attribute .. game.secondary_phenotype .. "\n"
		end
	end
	love.graphics.print(message, 0, 60)
	if game.elapsed_time == 0 then
		print(message)
	end
	]]
	--Bottom Ribbon
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 580, 1024, 120)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Hints", 965, 555)
	love.graphics.draw(game.darwin, 0, 550, 0, 0.5, 0.5)
	if game.arrowvisible then
		love.graphics.polygon("fill", 900, 585, 900, 695, 1010, 640)
	end
	if game.talking then
		love.graphics.setColor(210/255, 180/255, 140/255)
		love.graphics.polygon("fill", 160, 635, 180, 625, 180, 645)
		love.graphics.rectangle("fill", 180, 590, 650, 100, 20, 20)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf(game.talking, 185, 595, 640, "left")
	end
	--Final White Color Set
	love.graphics.setColor(1, 1, 1)
end
function game.update(dt)
	game.cursor_check()
	--Game counter
	if game.began and not game.ended then
		if game.paused then
			if game.paused > 0 then
				game.paused = game.paused - dt
			else
				game.arrowvisible = true
			end
		else
			game.elapsed_time = game.elapsed_time + dt
			if game.elapsed_time > 5 then
				game.next_generation()
			end
		end
	elseif not game.began then
		game.handle_pregame(dt)
	end
end
function game.handle_pregame(dt)
	game.elapsed_time = game.elapsed_time + dt
	if game.elapsed_time < 0.5 then
		game.arrowvisible = false
		game.talking = nil
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
	elseif game.elapsed_time >= 200 then
		game.elapsed_time = 200
		if game.selections == 3 then
			game.choices = nil
			game.arrowvisible = false
			game.setgame()
			game.selections = nil
		end
	end
end
function game.cursor_check()
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(game.hand)
	elseif y >= 555 and y <= 575 and x >= 965 then
		love.mouse.setCursor(game.hand)
	elseif x >= 900 and y >= 580 and game.arrowvisible then
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
	else
		love.mouse.setCursor()
	end
end
function game.next_generation()
	game.round_count = game.round_count + 1
	game.elapsed_time = 0
	game.reproduce()
	if game.round_count == 3 then
		if not game.disaster then
			game.round_count = 0
			game.choose_disaster()
		else
			game.round_count = 0
			game.disaster = nil
		end
	end
	game.kill()
	if not game.organisms[1] then game.lose() end
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
	elseif x >= 900 and y >= 580 and game.arrowvisible then
		game.arrowclicked = true
	elseif game.choices then
		if x >= 50 and x <= 450 and y <= 560 and y >= 520 then
			game.generate_choices()
		elseif (x >= 100 and x <= 180) or (x >= 220 and x <= 300) or (x >= 340 and x <= 420) then
			if (y >= 145 and y <= 225) or (y >= 265 and y <= 345) or (y >= 385 and y <= 465) then
				game.make_choice(x, y)
			end
		end
	end
end
function game.touchpressed(id, x, y, dx, dy, pressure)
	game.mousepressed(x, y, 1)
end

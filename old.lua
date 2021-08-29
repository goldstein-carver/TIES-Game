function debase(num, base)
	local z = num % base
	num = (num - z)/base
	local y = num % base
	num = (num - y)/base
	return tostring(num) .. tostring(y) .. tostring(z)
end
function love.load()
	math.randomseed(os.time())
	max_pop = 16
	organisms = {{Mass=13, Hair=13, Neck=7, Legs=13, Striped=7}, {Mass=0, Hair=0, Neck=0, Legs=0, Striped=0}, {Mass=26, Hair=26, Neck=7, Legs=26, Striped=0}}
	disaster = nil
	elapsed_time = 0
	round_count = 0
	--Mass (3), Hair (3), Legs (3), Neck (2), Striped (2)
	--Use bit or trit math, with least significant being the phenotype and other two being the alleles
	function lose()
	
	end
	function choose_susceptible_attributes()
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
			for _,org in ipairs(organisms) do
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
			for _,org in ipairs(organisms) do
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
	function choose_disaster()
		local rand = math.random(6)
		if rand == 1 then
			disaster = "volcano"
		elseif rand == 2 then
			disaster = "predator"
		elseif rand == 3 then
			disaster = "cold"
		elseif rand == 4 then
			disaster = "heat"
		elseif rand == 5 then
			disaster = "high food"
		elseif rand == 6 then
			disaster = "disease"
			primary_attribute, primary_phenotype = choose_susceptible_attributes()
			secondary_attribute, secondary_phenotype = choose_susceptible_attributes()
			while secondary_attribute == primary_attribute do
				secondary_attribute, secondary_phenotype = choose_susceptible_attributes()
			end
		end
	end
	function kill()
		if not disaster then return end
		if disaster == "volcano" then
			local original_size = 0
			for _,__ in ipairs(organisms) do
				original_size = original_size + 1
			end
			if original_size <= 3 then
				local i = 1
				while i <= original_size do
					table.remove(organisms)
					i = i+1
				end
			else
				local new_size = math.floor(original_size/4)
				while original_size > new_size do
					table.remove(organisms)
					original_size = original_size - 1
				end
			end
		end
		if disaster == "predator" then
			local counter = 0
			for _,__ in ipairs(organisms) do
				counter = counter + 1
			end
			while counter > 0 do
				local stripes = organisms[counter].Striped % 2
				local legs = organisms[counter].Legs % 3
				local survival = stripes + legs + 1 --Roll d4, die if > this number
				if math.random(4) > survival then
					table.remove(organisms, counter)
				end
				counter = counter - 1
			end
		end
		if disaster == "cold" then
			local counter = 0
			for _,__ in ipairs(organisms) do
				counter = counter + 1
			end
			while counter > 0 do
				local mass = organisms[counter].Mass % 3
				local hair = organisms[counter].Hair % 3
				local legs = organisms[counter].Legs % 3
				local neck = organisms[counter].Neck % 2
				local survival = mass + hair - legs - neck + 1 --Roll d4, die if > this number
				if math.random(4) > survival then
					table.remove(organisms, counter)
				end
				counter = counter - 1
			end
		end
		if disaster == "heat" then
			local counter = 0
			for _,__ in ipairs(organisms) do
				counter = counter + 1
			end
			while counter > 0 do
				local mass = organisms[counter].Mass % 3
				local hair = organisms[counter].Hair % 3
				local survival = 4 - mass - hair --Roll d4, die if > this number
				if math.random(4) > survival then
					table.remove(organisms, counter)
				end
				counter = counter - 1
			end
		end
		if disaster == "high food" then
			local counter = 0
			for _,__ in ipairs(organisms) do
				counter = counter + 1
			end
			while counter > 0 do
				local neck = organisms[counter].Neck % 2
				local survival = 2*neck + 2 --Roll d4, die if > this number
				if math.random(4) > survival then
					table.remove(organisms, counter)
				end
				counter = counter - 1
			end
		end
		if disaster == "disease" then
			local primary_mod = 3
			if primary_attribute == "Neck" or primary_attribute == "Striped" then
				primary_mod = 2
			end
			local secondary_mod = 3
			if secondary_attribute == "Neck" or secondary_attribute == "Striped" then
				secondary_mod = 2
			end
			local counter = 0
			for _,__ in ipairs(organisms) do
				counter = counter + 1
			end
			while counter > 0 do
				local death = 0 --Roll d4, die if <= this number
				if organisms[counter][primary_attribute] % primary_mod == primary_phenotype then
					death = 3
				end
				if organisms[counter][secondary_attribute] % secondary_mod == secondary_phenotype then
					death = death + 1
				end
				if math.random(4) <= death then
					table.remove(organisms, counter)
				end
				counter = counter - 1
			end
		end
		return nil
	end
	function mate(x, y, surplus)
		m1 = organisms[x]
		m2 = organisms[y]
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
				organisms[x] = child
			elseif i == 2 then
				organisms[y] = child
			else
				table.insert(organisms, child)
			end
			i = i + 1
		end
	end
	function reproduce()
		local counter = 0
		local finished = 0
		for _,__ in ipairs(organisms) do
			counter = counter + 1
		end
		if counter < 2 then
			table.remove(organisms)
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
			if counter + extra_offspring < max_pop then
				mate(mate1, mate2, true)
				extra_offspring = extra_offspring + 1
			else
				mate(mate1, mate2, false)
			end
			mated[mate1] = true
			mated[mate2] = true
			finished = finished + 2
		end
	end
end
function love.draw()
	message = ""
	for _,org in ipairs(organisms) do
		message = message .. "Mass: " .. debase(org.Mass,3) .. ", Hair: " .. debase(org.Hair,3) .. ", Legs: " .. debase(org.Legs,3) .. ", Neck: " .. debase(org.Neck,2) .. ", Striped: " .. debase(org.Striped,2) .. "\n"
	end
	if disaster then
		message = message .. "DISASTER: " .. disaster .. "\n"
		if disaster == "disease" then
			message = message .. "PRIMARY: " .. primary_attribute .. primary_phenotype .. "\n"
			message = message .. "SECONDARY: " .. secondary_attribute .. secondary_phenotype .. "\n"
		end
	end
	love.graphics.print(message, 0, 0)
	if elapsed_time == 0 then
		print(message)
	end
end
function love.update(dt)
	elapsed_time = elapsed_time + dt
	if elapsed_time > 5 then
		round_count = round_count + 1
		elapsed_time = 0
		reproduce()
		if round_count == 3 then
			if not disaster then
				round_count = 0
				choose_disaster()
			else
				round_count = 0
				disaster = nil
			end
		end
		kill()
		if not organisms[1] then lose() end
	end
end

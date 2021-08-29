--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
quiz = {}
quiz.number = 0
quiz.correct_answers = 0
quiz.question = nil
quiz.answers = {}
quiz.correct = nil
quiz.selected = nil
function quiz.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	quiz.background = love.graphics.newImage("images/WoodBackground.jpg")
	quiz.hand = love.mouse.getSystemCursor("hand")
	quiz.smallfont = love.graphics.newFont(20)
	quiz.bigfont = love.graphics.newFont(40)
	quiz.middlefont = love.graphics.newFont(30)
end
function quiz.reset()
	quiz.number = 0
	quiz.correct_answers = 0
	quiz.answers = {}
end
function quiz.readnext(number)
	quiz.yes = nil
	quiz.no = nil
	quiz.number = number
	quiz.selected = nil
	if number == 11 then
		quiz.question = nil
		quiz.answers = nil
		quiz.correct = nil
		quiz.winmessage = "Your score: " .. quiz.correct_answers .. "/10."
		if quiz.correct_answers >= 8 then
			quiz.winmessage = quiz.winmessage .. "\nYay! It looks like you know a thing or two about Darwin and natural selection."
		elseif quiz.correct_answers >= 6 then
			quiz.winmessage = quiz.winmessage .. "\nNot too bad but a good brain definitely helps with survival. Why don’t you review the section on natural selection and Darwin and try again?"
		else
			quiz.winmessage = quiz.winmessage .. "\nOh, bother. You can do better than that! Why don’t you review the section on natural selection and Darwin and try again?"
		end
		return
	end
	local answers --If true/false, replace with 1 (true is correct) or 2 (false is correct)
	if number == 1 then
		quiz.question = "Darwin noticed that the individuals of a population exhibited ____."
		answers = {"variation", "identical traits", "no differences", "None of the Above", 0}--0 indicates that the first one is still correct
		quiz.no = "Darwin noticed that the individuals of a population exhibited variation."
	elseif number == 2 then
		quiz.question = "Charles Darwin served as the naturalist on the HMS ____ from 1831 to 1836."
		answers = {"Beagle", "Boxer", "England", "Bugle"}
		quiz.no = "Charles Darwin served as the naturalist on the HMS Beagle from 1831-1836."
	elseif number == 3 then
		quiz.question = "For a trait to be beneficial (helpful) for a species, it must   ____."
		answers= {"be passed on from parent to offspring", "make the individuals stronger", "be found in every single member of the population", "be there from the beginning"}
		quiz.no = "For a trait to be beneficial (helpful) for a species, it must be passed on from parent to offspring."
	elseif number == 4 then
		quiz.question = "A species has lived happily for thousands of years in a moderate climate. If the environment suddenly begins to warm, which random mutation might help the species survive?"
		answers = {"Thin Fur", "Long Neck", "Long Legs", "All of the Above", 1}--1 indicates that All of the Above is correct, even though it's not first.
		quiz.no = "All of these traits will help the species survive."
	elseif number == 5 then
		quiz.question = "Darwin traveled the entire globe but he is most famous for his observations on the Galápagos Islands off the coast of ____."
		answers = {"South America", "North America", "Asia", "Australia"}
		quiz.no = "The Galápagos Islands are located off of the coast of South America."
	elseif number == 6 then
		quiz.question = "Some mutations do not help or harm the individuals who possess it. What would be an example of a neutral mutation in the TIES critters?"
		answers = {"Eye Color", "Small Size", "Thick Fur", "Stripes"}
		quiz.no = "Eye color may not be beneficial to the survival of the TIES critter species."
	elseif number == 7 then
		quiz.question = "What did Darwin call the idea that the individuals with the most beneficial (helpful) traits will survive and reproduce?"
		answers = {"Survival of the Fittest", "Survival of the Strongest", "Survival of the Fattest", "Live Long and Prosper"}
		quiz.yes = "In biology, \"fittest\" means most likely to have offspring. It’s not necessarily the strongest or fastest."
		quiz.no = "Survival of the Fittest. In biology, \"fittest\" means most likely to have offspring. It’s not necessarily the strongest or fastest."
	elseif number == 8 then
		quiz.question = "What is the name of Darwin's famous book?"
		answers = {"On the Origin of Species", "The Natural History of the World", "Natural Selection", "Cosmos"}
		quiz.no = "Darwin’s famous book is \"On the Origin of Species\"."
	elseif number == 9 then
		quiz.question = "True or False: Mutations occur because the population needs them to survive."
		answers = 2
		quiz.no = "Mutations occur randomly. If it happens to help you survive, good for you."
		quiz.yes = "Mutations occur randomly. If it happens to help you survive, good for you."
	elseif number == 10 then
		quiz.question = "True or False: A mutation that is helpful when the environment is cold might be harmful if the climate suddenly gets warmer."
		answers = 1
		quiz.no = "The same mutation can be beneficial, neutral, or harmful depending on the changing environment. Think polar bears and global warming."
	end
	if type(answers) == "number" then
		quiz.answers[1] = "True"
		quiz.answers[2] = "False"
		quiz.answers[3] = nil
		quiz.answers[4] = nil
		quiz.correct = answers
	elseif answers[5] then
		quiz.answers[4] = answers[4]
		quiz.correct = math.random(3)
		quiz.answers[quiz.correct] = answers[1]
		if quiz.correct == 1 then
			if math.random(2) == 2 then
				quiz.answers[3] = answers[2]
				quiz.answers[2] = answers[3]
			else
				quiz.answers[2] = answers[2]
				quiz.answers[3] = answers[3]
			end
		elseif quiz.correct == 2 then
			if math.random(2) == 2 then
				quiz.answers[3] = answers[2]
				quiz.answers[1] = answers[3]
			else
				quiz.answers[3] = answers[3]
				quiz.answers[1] = answers[2]
			end
		elseif quiz.correct == 3 then
			if math.random(2) == 2 then
				quiz.answers[2] = answers[2]
				quiz.answers[1] = answers[3]
			else
				quiz.answers[2] = answers[3]
				quiz.answers[1] = answers[2]
			end
		end
		if answers[5] == 1 then
			quiz.correct = 4
		end
	else
		local sorter = {}
		local x = math.random(4)
		sorter[x] = 1
		local count = 1
		while count < 4 do
			while sorter[x] do
				x = math.random(4)
			end
			count = count + 1
			sorter[x] = count
		end
		while count > 0 do
			quiz.answers[sorter[count]] = answers[count]
			count = count - 1
		end
		quiz.correct = sorter[1]
	end
end
function quiz.select(selection)
	if quiz.answers[selection] then
		quiz.selected = selection
		if quiz.correct == selection then
			quiz.correct_answers = quiz.correct_answers + 1
		end
	end
end
function quiz.draw()
	love.graphics.draw(quiz.background, 0, 0)
	love.graphics.setFont(quiz.smallfont)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 171, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 342, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 683, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 854, 0, 170, 60, 10, 8)
	love.graphics.setColor(245/255,222/255,179/255)
	love.graphics.rectangle("fill", 513, 0, 170, 60, 10, 8)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Intro", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	if quiz.number == 0 then
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("fill", 312, 600, 400, 50)
		love.graphics.setFont(quiz.bigfont)
		love.graphics.printf("Test your knowledge!", 312, 100, 400, "center")
		love.graphics.setFont(quiz.middlefont)
		love.graphics.printf("Let’s see how much you have learned playing the TIES Time Machine Game. You may want to review the section on natural selection or Charles Darwin before you begin. Good luck!", 312, 200, 400, "center")
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("Take the Quiz", 312, 600, 400, "center")
		love.graphics.setColor(1, 1, 1)
	elseif quiz.number < 11 then
		love.graphics.setFont(quiz.smallfont)
		love.graphics.setColor(1, 1, 1)
		love.graphics.rectangle("fill", 212, 80, 600, 220)
		for index, answer in ipairs(quiz.answers) do
			if quiz.selected and quiz.correct == index then
				love.graphics.setColor(0, 1, 0)
			elseif quiz.selected == index then
				love.graphics.setColor(1, 0, 0)
			else
				love.graphics.setColor(1, 1, 1)
			end
			love.graphics.rectangle("fill", 212, 275 + 50*index, 600, 25)
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(answer, 215, 278 + 50*index)
		end
		love.graphics.setFont(quiz.middlefont)
		love.graphics.printf(quiz.question, 212, 85, 600, "center")
		love.graphics.setColor(1, 1, 1)
		if quiz.selected then
			love.graphics.polygon("fill", 1000, 600, 900, 650, 900, 550)
		end
		if quiz.answers[3] then
			if quiz.selected and quiz.selected == quiz.correct and quiz.yes then
				love.graphics.rectangle("fill", 212, 550, 600, 140)
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf("Correct! " .. quiz.yes, 212, 550, 600, "center")
			elseif quiz.selected and quiz.selected ~= quiz.correct and quiz.no then
				love.graphics.rectangle("fill", 212, 550, 600, 140)
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf("Incorrect! " .. quiz.no, 212, 550, 600, "center")
			end
		else
			if quiz.selected and quiz.selected == quiz.correct and quiz.yes then
				love.graphics.rectangle("fill", 212, 450, 600, 240)
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf("Correct! " .. quiz.yes, 212, 450, 600, "center")
			elseif quiz.selected and quiz.selected ~= quiz.correct and quiz.no then
				love.graphics.rectangle("fill", 212, 450, 600, 240)
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf("Incorrect! " .. quiz.no, 212, 450, 600, "center")
			end
		end
		love.graphics.setColor(1, 1, 1)
	elseif quiz.number == 11 then
		love.graphics.setColor(1, 1, 1)
		love.graphics.setFont(quiz.bigfont)
		love.graphics.printf(quiz.winmessage, 0, 60, 1024, "center")
		love.graphics.rectangle("fill", 312, 600, 400, 75)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("Try Again", 312, 615, 400, "center")
		love.graphics.setColor(1, 1, 1)
	end
	
end
function quiz.update(dt)
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(quiz.hand)
	elseif quiz.number == 0 and x >= 312 and x <= 712 and y >= 600 and y <= 650 then
		love.mouse.setCursor(quiz.hand)
	elseif quiz.number > 0 and quiz.number < 11 and (not quiz.selected) and x >= 212 and x <= 812 and y >= 325 and y <= 500 and y % 50 >= 25 then
		if y < 425 or quiz.answers[3] then
			love.mouse.setCursor(quiz.hand)
		end
	elseif quiz.selected and x >= 900 and x <= 1000 and y >= 550 and y <= 650 then
		love.mouse.setCursor(quiz.hand)
	elseif quiz.number == 11 and x >= 312 and x <= 712 and y >= 600 and y <= 675 then
		love.mouse.setCursor(quiz.hand)
	else
		love.mouse.setCursor()
	end
end
function quiz.cleanup()
	quiz.background:release()
	quiz.hand:release()
	quiz.smallfont:release()
	quiz.bigfont:release()
	quiz.middlefont:release()
end
function quiz.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if y <= 60 then
		if x < 171 then
			switch("cover")
		elseif x < 342 then
			switch("learn")
		elseif x < 513 then
			switch("game")
		elseif x < 683 then
			--Already here
		elseif x < 854 then
			switch("bio")
		else
			switch("glossary")
		end
		return
	elseif quiz.number == 0 and x >= 312 and x <= 712 and y >= 600 and y <= 650 then
		quiz.readnext(1)
	elseif quiz.number < 11 and (not quiz.selected) and x >= 212 and x <= 812 and y >= 325 then
		if y <= 350 then
			quiz.select(1)
		elseif y <= 375 then
		elseif y <= 400 then
			quiz.select(2)
		elseif y <= 425 then
		elseif y <= 450 then
			quiz.select(3)
		elseif y <= 475 then
		elseif y <= 500 then
			quiz.select(4)
		end
	elseif quiz.selected and x >= 900 and x <= 1000 and y >= 550 and y <= 650 then
		quiz.readnext(quiz.number + 1)
	elseif quiz.number == 11 and x >= 312 and x <= 712 and y >= 600 and y <= 675 then
		quiz.reset()
	end
end
function quiz.touchpressed(id, x, y, dx, dy, pressure)
	quiz.mousepressed(x, y, 1)
end
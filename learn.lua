--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
learn = {ended=true}
function learn.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	learn.background = love.graphics.newImage("images/WoodBackground.jpg")
	learn.hand = love.mouse.getSystemCursor("hand")
	learn.smallfont = love.graphics.newFont(20)
	learn.bigfont = love.graphics.newFont(30)
	learn.logo = love.graphics.newImage("images/SmallTIES.jpg")
	learn.darwin = love.graphics.newImage("images/Darwin.png")
	if learn.ended then
		learn.talking = "Individual members of a species can have a different fur color, height, wingspan, beak depth, you name it."
		learn.time_on_slide = 0
		learn.run_sound("audios/Darwin6.ogg")
		learn.slide = 1
		learn.ended = false
	end
	learn.critter1 = love.graphics.newImage("images/critter10011.png")
	learn.critter2 = love.graphics.newImage("images/critter10100.png")
	learn.critter3 = love.graphics.newImage("images/critter22000.png")
	learn.critter4 = love.graphics.newImage("images/critter02112.png")
	learn.critter5 = love.graphics.newImage("images/critter10111.png")
	learn.critter6 = love.graphics.newImage("images/critter12011.png")
end
function learn.draw()
	love.graphics.draw(learn.background, 0, 0)
	love.graphics.setFont(learn.smallfont)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 342, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 513, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 683, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 854, 0, 170, 60, 10, 8)
	love.graphics.setColor(245/255,222/255,179/255)
	love.graphics.rectangle("fill", 171, 0, 170, 60, 10, 8)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Home", 0, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	--Bottom Ribbon
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 580, 1024, 120)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(learn.logo, 0, 580)
	love.graphics.setColor(31/255, 67/255, 156/255)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(learn.darwin, 140, 550, 0, 0.5, 0.5)
	if learn.arrowvisible then
		love.graphics.polygon("fill", 930, 595, 930, 685, 1020, 640)
	end
	if learn.talking then
		love.graphics.setColor(210/255, 180/255, 140/255)
		love.graphics.polygon("fill", 250, 635, 270, 625, 270, 645)
		love.graphics.rectangle("fill", 270, 590, 650, 100, 20, 20)
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf(learn.talking, 285, 595, 630, "left")
	end
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(learn.bigfont)
	if learn.slide == 1 then
		love.graphics.printf("Part 1: The members of a species are not all the same; they exhibit variation.", 100, 80, 824, "center")
		love.graphics.draw(learn.critter1, 340, 170)
		love.graphics.draw(learn.critter2, 340, 370)
		love.graphics.draw(learn.critter3, 684, 170)
		love.graphics.draw(learn.critter4, 684, 370)
	elseif learn.slide == 2 then
		love.graphics.printf("Part 2: Traits can be passed down from parent to offspring.", 100, 80, 824, "center")
		love.graphics.draw(learn.critter1, 340, 170)
		love.graphics.draw(learn.critter2, 340, 370)
		love.graphics.setLineWidth(5)
		if learn.time_on_slide == 0 then
		elseif learn.time_on_slide <= 1 then
			love.graphics.line(390, 220, 390+100*learn.time_on_slide, 220+100*learn.time_on_slide)
			love.graphics.line(390, 420, 390+100*learn.time_on_slide, 420-100*learn.time_on_slide)
		elseif learn.time_on_slide <= 2 then
			love.graphics.line(390, 220, 490, 320)
			love.graphics.line(390, 420, 490, 320)
			love.graphics.line(490, 320, 340+150*learn.time_on_slide, 320)
		elseif learn.time_on_slide <= 2.5 then
			love.graphics.line(390, 220, 490, 320)
			love.graphics.line(390, 420, 490, 320)
			love.graphics.line(490, 320, 640, 320)
		else
			love.graphics.line(390, 220, 490, 320)
			love.graphics.line(390, 420, 490, 320)
			love.graphics.line(490, 320, 640, 320)
			love.graphics.draw(learn.critter5, 640, 240)
		end
	elseif learn.slide == 3 then
		love.graphics.printf("Part 3: Members of a species will have to compete for resources and mates. Those with traits that help them survive will have more offspring. This is called \"survival of the fittest.\"", 100, 80, 824, "center")
		love.graphics.draw(learn.critter3, 834, 270)
		love.graphics.draw(learn.critter4, 684, 370)
		if learn.time_on_slide <= 0.7 then
			love.graphics.draw(learn.critter1, 190, 270)
		end
		if learn.time_on_slide <= 1.4 then
			love.graphics.draw(learn.critter2, 340, 370)
		end
		if learn.time_on_slide <= 2.1 then
			love.graphics.draw(learn.critter5, 512, 270)
		end
	elseif learn.slide == 4 then
		love.graphics.printf("Part 4: New traits pop up randomly in the form of a genetic mistake, mutation.", 100, 80, 824, "center")
		love.graphics.draw(learn.critter1, 340, 170)
		love.graphics.draw(learn.critter2, 340, 370)
		love.graphics.setLineWidth(5)
		if learn.time_on_slide == 0 then
		elseif learn.time_on_slide <= 1 then
			love.graphics.line(390, 220, 390+100*learn.time_on_slide, 220+100*learn.time_on_slide)
			love.graphics.line(390, 420, 390+100*learn.time_on_slide, 420-100*learn.time_on_slide)
		elseif learn.time_on_slide <= 2 then
			love.graphics.line(390, 220, 490, 320)
			love.graphics.line(390, 420, 490, 320)
			love.graphics.line(490, 320, 340+150*learn.time_on_slide, 320)
		elseif learn.time_on_slide <= 2.5 then
			love.graphics.line(390, 220, 490, 320)
			love.graphics.line(390, 420, 490, 320)
			love.graphics.line(490, 320, 640, 320)
		else
			love.graphics.line(390, 220, 490, 320)
			love.graphics.line(390, 420, 490, 320)
			love.graphics.line(490, 320, 640, 320)
			love.graphics.draw(learn.critter6, 640, 240)
		end
	end
end
function learn.update(dt)
	learn.cursor_check()
	if learn.arrowclicked then
		learn.time_on_slide = 0
		learn.arrowclicked = nil
		learn.arrowvisible = nil
		learn.slide = learn.slide + 1
		if learn.slide == 2 then
			learn.talking = "Just look at a litter of kittens. Some look like mom and some look more like dad."
			learn.run_sound("audios/Darwin7.ogg")
		elseif learn.slide == 3 then
			learn.talking = "The beneficial, or helpful, traits will become more common in the population. This changes the look of the population over time."
			learn.run_sound("audios/Darwin8.ogg")
		elseif learn.slide == 4 then
			learn.talking = "Some mutations hurt your chances of survival, some help, some are neutral. Evolution is the accumulation of beneficial mutations over time. But remember: an individual cannot just WISH for a specific mutation to occur. It’s luck."
			learn.run_sound("audios/Darwin9.ogg")
		elseif learn.slide == 5 then
			switch("game")
		end
	end
	learn.time_on_slide = learn.time_on_slide + dt
	if learn.slide == 1 and learn.time_on_slide > 1.5 then--Change this number
		learn.arrowvisible = true
	end
	if learn.slide == 2 and learn.time_on_slide > 3 then--Change this number
		learn.arrowvisible = true
	end
	if learn.slide == 3 and learn.time_on_slide > 2.5 then--Change this number
		learn.arrowvisible = true
	end
	if learn.slide == 4 and learn.time_on_slide > 1 then--Change this number
		learn.arrowvisible = true
		learn.ended = true
	end
end
function learn.cursor_check()
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(learn.hand)
	elseif y >= 580 and x <= 135 then
		love.mouse.setCursor(learn.hand)
	elseif x >= 925 and y >= 580 and learn.arrowvisible then
		love.mouse.setCursor(learn.hand)
	else
		love.mouse.setCursor()
	end
end
function learn.cleanup()
	learn.background:release()
	learn.hand:release()
	learn.smallfont:release()
	learn.bigfont:release()
	learn.logo:release()
	learn.darwin:release()
	learn.run_sound()
	learn.critter1:release()
	learn.critter2:release()
	learn.critter3:release()
	learn.critter4:release()
	learn.critter5:release()
	learn.critter6:release()
end
function learn.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if y <= 60 then
		if x < 171 then
			switch("cover")
		elseif x < 342 then
			--Already here
		elseif x < 513 then
			switch("game")
		elseif x < 683 then
			switch("quiz")
		elseif x < 854 then
			switch("bio")
		else
			switch("glossary")
		end
		return
	elseif y >= 580 and x <= 135 then
		love.system.openURL("https://www.tieseducation.org")
	elseif x >= 925 and y >= 580 and learn.arrowvisible then
		learn.arrowclicked = true
	end
end
function learn.touchpressed(id, x, y, dx, dy, pressure)
	learn.mousepressed(x, y, 1)
end
function learn.run_sound(filepath)--nil can be used to cancel audio
	if not is_muted then
		love.audio.stop()
		if learn.audioSource then
			learn.audioSource:release()
			learn.audioSource = nil
		end
		if filepath then
			learn.audioSource = love.audio.newSource(filepath, "stream")
			learn.audioSource:play()
		end
	end
end

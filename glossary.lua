--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
glossary = {}
glossary.leftwriting = "Evolution: An overall change of a population's gene pool over time through processes such as mutation and natural selection.\nNatural Selection: A process that explains how organisms with traits and genetic characteristics that are beneficial to survive in their environment are passed down to future generations while those less adapted dwindle in population.\nTrait: A genetic characteristic among similar organisms in a species."
glossary.rightwriting = "Species: The basic classification in biology that describes a group of organisms that resemble one another and are able to reproduce among themselves.\nVariation: In biology, a difference in a characteristic or trait from one organism in a species to another in the same species.\nReproduction: The process that enables organisms to generate new organisms to ensure continuation of the species.\nOffspring: The children of a parent; a descendant."
function glossary.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	glossary.background = love.graphics.newImage("images/WoodBackground.jpg")
	glossary.hand = love.mouse.getSystemCursor("hand")
	glossary.smallfont = love.graphics.newFont(20)
	glossary.middlefont = love.graphics.newFont(25)
end
function glossary.draw()
	love.graphics.draw(glossary.background, 0, 0)
	love.graphics.setFont(glossary.smallfont)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 171, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 342, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 513, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 683, 0, 170, 60, 10, 8)
	love.graphics.setColor(245/255,222/255,179/255)
	love.graphics.rectangle("fill", 854, 0, 170, 60, 10, 8)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Intro", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle("fill", 50, 100, 924, 550)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(glossary.middlefont)
	love.graphics.printf(glossary.leftwriting, 100, 100, 362, "left")
	love.graphics.printf(glossary.rightwriting, 562, 100, 362, "right")
	love.graphics.setColor(1, 1, 1)
end
function glossary.update(dt)
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(glossary.hand)
	else
		love.mouse.setCursor()
	end
end
function glossary.cleanup()
	glossary.background:release()
	glossary.hand:release()
	glossary.smallfont:release()
	glossary.middlefont:release()
end
function glossary.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if y <= 60 then
		if x < 171 then
			switch("cover")
		elseif x < 342 then
			switch("learn")
		elseif x < 513 then
			switch("game")
		elseif x < 683 then
			switch("quiz")
		elseif x < 854 then
			switch("bio")
		else
			--Already here
		end
		return
	end
end
function glossary.touchpressed(id, x, y, dx, dy, pressure)
	glossary.mousepressed(x, y, 1)
end

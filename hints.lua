--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
hints = {}
function hints.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	hints.background = love.graphics.newImage("images/WoodBackground.jpg")
	hints.hand = love.mouse.getSystemCursor("hand")
	hints.smallfont = love.graphics.newFont(20)
	hints.book = love.graphics.newImage("images/Book.png")
	hints.logo = love.graphics.newImage("images/SmallTIES.jpg")
end
function hints.draw()
	love.graphics.draw(hints.background, 0, 0)
	love.graphics.draw(hints.book, 0, 60)
	love.graphics.draw(hints.logo, 0, 628, 0, 0.6, 0.6)
	love.graphics.setFont(hints.smallfont)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 171, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 342, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 513, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 683, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 854, 0, 170, 60, 10, 8)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Home", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(1, 1, 1)
end
function hints.update(dt)
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(hints.hand)
	elseif x <= 81 and y >= 628 then
		love.mouse.setCursor(hints.hand)
	else
		love.mouse.setCursor()
	end
end
function hints.cleanup()
	hints.background:release()
	hints.hand:release()
	hints.smallfont:release()
	hints.book:release()
	hints.logo:release()
end
function hints.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if x <= 81 and y >= 628 then
		love.system.openURL("https://www.tieseducation.org")
	elseif y <= 60 then
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
			switch("glossary")
		end
		return
	end
end
function hints.touchpressed(id, x, y, dx, dy, pressure)
	hints.mousepressed(x, y, 1)
end

--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
bio = {}
function bio.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	bio.background = love.graphics.newImage("images/WoodBackground.jpg")
	bio.hand = love.mouse.getSystemCursor("hand")
	bio.smallfont = love.graphics.newFont(20)
	bio.bigfont = love.graphics.newFont(30)
	bio.book = love.graphics.newImage("images/Book.png")--257x300
	bio.darwin = love.graphics.newImage("images/Darwin.png")
	bio.logo = love.graphics.newImage("images/SmallTIES.jpg")
end
function bio.draw()
	love.graphics.draw(bio.background, 0, 0)
	love.graphics.draw(bio.book, 0, 60)
	love.graphics.draw(bio.darwin, 100, 80, 0, 0.5, 0.5)
	love.graphics.setFont(bio.smallfont)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 0, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 171, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 342, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 513, 0, 170, 60, 10, 8)
	love.graphics.rectangle("fill", 854, 0, 170, 60, 10, 8)
	love.graphics.setColor(245/255,222/255,179/255)
	love.graphics.rectangle("fill", 683, 0, 170, 60, 10, 8)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(bio.logo, 0, 628, 0, 0.6, 0.6)
	love.graphics.printf("Home", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.setFont(bio.bigfont)
	love.graphics.print("Charles Darwin", 230, 80)
	love.graphics.setColor(1, 1, 1)
end
function bio.update(dt)
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(bio.hand)
	elseif x <= 81 and y >= 628 then
		love.mouse.setCursor(bio.hand)
	else
		love.mouse.setCursor()
	end
end
function bio.cleanup()
	bio.background:release()
	bio.hand:release()
	bio.smallfont:release()
	bio.book:release()
	bio.darwin:release()
	bio.bigfont:release()
	bio.logo:release()
end
function bio.mousepressed(x, y, button, istouch, presses)
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
			--Already here
		else
			switch("glossary")
		end
		return
	end
end
function bio.touchpressed(id, x, y, dx, dy, pressure)
	bio.mousepressed(x, y, 1)
end

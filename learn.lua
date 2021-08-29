--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
learn = {}
function learn.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	learn.background = love.graphics.newImage("images/WoodBackground.jpg")
	learn.hand = love.mouse.getSystemCursor("hand")
	learn.smallfont = love.graphics.newFont(20)
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
	love.graphics.printf("Intro", 0, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.setColor(1, 1, 1)
end
function learn.update(dt)
	local x,y = love.mouse.getPosition()
	if y <= 60 then
		love.mouse.setCursor(learn.hand)
	else
		love.mouse.setCursor()
	end
end
function learn.cleanup()
	learn.background:release()
	learn.hand:release()
	learn.smallfont:release()
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
	end
end
function learn.touchpressed(id, x, y, dx, dy, pressure)
	learn.mousepressed(x, y, 1)
end

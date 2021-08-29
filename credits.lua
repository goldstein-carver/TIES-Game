--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
credits = {}
credits.string = "Who Wants to Live a Million Years?\nThe Darwin Evolution Game\n"
function credits.load()
	credits.background = love.graphics.newImage("images/WoodBackground.jpg")
	credits.hand = love.mouse.getSystemCursor("hand")
	credits.middlefont = love.graphics.newFont(30)
end
function credits.cleanup()
	credits.middlefont:release()
	credits.hand:release()
	credits.background:release()
end
function credits.update(dt)
	local x,y = love.mouse.getPosition()
	if x <= 100 and y >= 670 then
		love.mouse.setCursor(credits.hand)
	else
		love.mouse.setCursor()
	end
end
function credits.draw(dt)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(credits.background, 0, 0)
	love.graphics.printf(credits.string, 100, 0, 824, "center")
	love.graphics.print("Go back", 0, 670)
end
function credits.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if x <= 100 and y >= 670 then
		switch("cover")
	end
end
function credits.touchpressed(id, x, y, dx, dy, pressure)
	credits.mousepressed(x, y, 1)
end
--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
credits = {}
credits.string = "The TIES Time Machine Game\n\nBrought to you by The Teacher Institute for Evolutionary Science\n\nProgramming by Carver Goldstein\n\nGame Art by Keystone Canyon Press\n\nGalápagos Island Map from https://www.freeworldmaps.net/southamerica/galapagos/map.html\n\nLandscapes courtesy of tallhawaiianshirtenby"
function credits.load()
	credits.background = love.graphics.newImage("images/WoodBackground.jpg")
	credits.hand = love.mouse.getSystemCursor("hand")
	credits.middlefont = love.graphics.newFont(30)
	credits.logo = love.graphics.newImage("images/SmallTIES.jpg")
end
function credits.cleanup()
	credits.middlefont:release()
	credits.hand:release()
	credits.background:release()
	credits.logo:release()
end
function credits.update(dt)
	local x,y = love.mouse.getPosition()
	if x >= 904 and y >= 670 then
		love.mouse.setCursor(credits.hand)
	elseif x <= 135 and y >= 580 then
		love.mouse.setCursor(credits.hand)
	else
		love.mouse.setCursor()
	end
end
function credits.draw(dt)
	love.graphics.setFont(credits.middlefont)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(credits.background, 0, 0)
	love.graphics.draw(credits.logo, 0, 580)--Logo
	love.graphics.printf(credits.string, 100, 0, 824, "center")
	love.graphics.setColor(31/255, 67/255, 156/255)
	love.graphics.print("Go back", 904, 670)
end
function credits.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if x >= 904 and y >= 670 then
		switch("cover")
	elseif x <= 135 and y >= 580 then
		love.system.openURL("https://tieseducation.org")
	end
end
function credits.touchpressed(id, x, y, dx, dy, pressure)
	credits.mousepressed(x, y, 1)
end

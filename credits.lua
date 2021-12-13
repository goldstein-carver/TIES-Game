--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein

"Who Wants to Live a Million Years?" is software released under the CC-BY-NC-ND 4.0 license: <https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode>. Furthermore, this file is licensed under the GNU General Public License version 3.0. You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]
credits = {}
credits.string = "The TIES Time Machine Game\n\nBrought to you by The Teacher Institute for Evolutionary Science\n\nBuilt using LÖVE (https://www.love2d.org)\n\nProgrammed by Carver Goldstein\n\nGame Art by Keystone Canyon Press (https://www.keystonecanyon.com)\n\nGalápagos Island Map from https://www.freeworldmaps.net/southamerica/galapagos/map.html\n\nLandscapes courtesy of tallhawaiianshirtenby\n\nAudio by Nicholas Little"
function credits.load()
	credits.background = love.graphics.newImage("images/WoodBackground.jpg")
	credits.hand = love.mouse.getSystemCursor("hand")
	credits.middlefont = love.graphics.newFont(30)
	credits.smallfont = love.graphics.newFont(25)
	credits.logo = love.graphics.newImage("images/SmallTIES.jpg")
end
function credits.cleanup()
	credits.middlefont:release()
	credits.smallfont:release()
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
	elseif x >= 530 and x <= 950 and y >= 240 and y <= 260 then
		love.mouse.setCursor(credits.hand)
	elseif x >= 475 and x <= 765 and y >= 125 and y <= 145 then
		love.mouse.setCursor(credits.hand)
	elseif x >= 97 and x <= 927 and y >= 327 and y <= 347 then
		love.mouse.setCursor(credits.hand)
	else
		love.mouse.setCursor()
	end
end
function credits.draw(dt)
	love.graphics.setFont(credits.smallfont)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(credits.background, 0, 0)
	love.graphics.draw(credits.logo, 0, 580)--Logo
	love.graphics.printf(credits.string, 0, 0, 1024, "center")
	love.graphics.setColor(31/255, 67/255, 156/255)
	love.graphics.setFont(credits.middlefont)
	love.graphics.print("Go back", 904, 670)
	love.graphics.setColor(1, 1, 1)
end
function credits.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if x >= 904 and y >= 670 then
		switch("cover")
	elseif x <= 135 and y >= 580 then
		love.system.openURL("https://tieseducation.org")
	elseif x >= 530 and x <= 950 and y >= 240 and y <= 260 then
		love.system.openURL("https://www.keystonecanyon.com")
	elseif x >= 475 and x <= 765 and y >= 125 and y <= 145 then
		love.system.openURL("https://www.love2d.org")
	elseif x >= 97 and x <= 927 and y >= 327 and y <= 347 then
		love.system.openURL("https://www.freeworldmaps.net/southamerica/galapagos/map.html")
	end
end
function credits.touchpressed(id, x, y, dx, dy, pressure)
	credits.mousepressed(x, y, 1)
end

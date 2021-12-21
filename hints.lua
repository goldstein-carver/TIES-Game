--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein

"Who Wants to Live a Million Years?" is software released under the CC-BY-NC-ND 4.0 license: <https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode>. Furthermore, this file is licensed under the GNU General Public License version 3.0. You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]
hints = {}
function hints.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	hints.background = love.graphics.newImage("images/WoodBackground.jpg")
	if love.mouse.isCursorSupported() then hints.hand = love.mouse.getSystemCursor("hand") end
	hints.smallfont = love.graphics.newFont(20)
	hints.book = love.graphics.newImage("images/Book.png")
	hints.logo = love.graphics.newImage("images/SmallTIES.jpg")
	hints.large = love.graphics.newImage("images/critter21001.png")
	hints.small = love.graphics.newImage("images/critter01001.png")
	hints.furry = love.graphics.newImage("images/critter12001.png")
	hints.hairless = love.graphics.newImage("images/critter10001.png")
	hints.striped = love.graphics.newImage("images/critter11101.png")
	hints.longneck = love.graphics.newImage("images/critter11011.png")
	hints.shortlegs = love.graphics.newImage("images/critter11000.png")
	hints.longlegs = love.graphics.newImage("images/critter11002.png")
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
	love.graphics.setColor(31/255, 67/255, 156/255)
	love.graphics.printf("Bulky\nProduces more heat\nGood in cold climates\nBad in hot climates", 180, 100, 760, "left")
	love.graphics.printf("Thin\nProduces less heat\nGood in hot climates\nBad in cold climates", 180, 250, 760, "left")
	love.graphics.printf("Furry\nHolds heat better\nGood in cold climates\nBad in hot climates", 180, 400, 760, "left")
	love.graphics.printf("Hairless\nLoses heat better\nGood in hot climates\nBad in cold climates", 180, 550, 760, "left")
	love.graphics.printf("Short-Legged\nConserves heat but runs slower\nGood in cold climates\nBad against predators\nBad in hot climates", 0, 100, 860, "right")
	love.graphics.printf("Long-Legged\nLoses heat but runs faster\nGood against predators\nGood in hot climates\nBad in cold climates", 0, 250, 860, "right")
	love.graphics.printf("Striped\nBlends in with surroundings\nGood against predators", 0, 400, 860, "right")
	love.graphics.printf("Long-Necked\nLoses heat but reaches higher\nGood for eating tall food\nGood in hot climates\nBad in cold climates", 0, 550, 860, "right")
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Go back", 944, 670)
	love.graphics.draw(hints.large, 100, 100)
	love.graphics.draw(hints.small, 100, 250)
	love.graphics.draw(hints.furry, 100, 400)
	love.graphics.draw(hints.hairless, 100, 550)
	love.graphics.draw(hints.shortlegs, 860, 100)
	love.graphics.draw(hints.longlegs, 860, 250)
	love.graphics.draw(hints.striped, 860, 400)
	love.graphics.draw(hints.longneck, 860, 550)
end
function hints.update(dt)
	if love.mouse.isCursorSupported() then
		local x,y = love.mouse.getPosition()
		if y <= 60 then
			love.mouse.setCursor(hints.hand)
		elseif x >= 944 and y >= 670 then
			love.mouse.setCursor(hints.hand)
		elseif x <= 81 and y >= 628 then
			love.mouse.setCursor(hints.hand)
		else
			love.mouse.setCursor()
		end
	end
end
function hints.cleanup()
	hints.background:release()
	if hints.hand then hints.hand:release() end
	hints.smallfont:release()
	hints.book:release()
	hints.logo:release()
	hints.large:release()
	hints.small:release()
	hints.furry:release()
	hints.hairless:release()
	hints.striped:release()
	hints.longneck:release()
	hints.shortlegs:release()
	hints.longlegs:release()
end
function hints.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if x >= 944 and y >= 670 then
		switch("game")
	elseif x <= 81 and y >= 628 then
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

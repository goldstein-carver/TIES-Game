--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein

"Who Wants to Live a Million Years?" is software released under the CC-BY-NC-ND 4.0 license: <https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode>. Furthermore, this file is licensed under the GNU General Public License version 3.0. You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]
glossary = {}
glossary.leftwriting = "Evolution: The unifying theme of the life sciences. Evolution explains how all living things on this planet are related and how we all descend from common ancestors. It explains how this vast, beautiful array of millions and millions of species got here in the first place.\n\nNatural Selection: One of the driving mechanisms of evolution. Simply stated, natural selection means that random genetic mutations arise in a population of living things. Some of these mutations are harmful and will hurt the individual’s chances of surviving. Other mutations are neutral, they do not help or hurt the individual.  Sometimes, a mutation can be beneficial, helping the individual survive better than its companions. If this mutation is passed on to its offspring, the entire population can change over time, with more and more individuals exhibiting the desirable characteristic."
glossary.rightwriting = "Trait: A physical characteristic found in a species, for example eye color or height. Traits are controlled by genetic factors.\n\nSpecies: Loosely stated, a group of living things who can reproduce together, producing offspring who can reproduce together. (A horse and a donkey can produce a mule, but a mule cannot reproduce. So horses and donkeys are considered two separate species.\n\nHypothesis: A testable statement.\n\nTheory: A broad explanation of a natural phenomena based on facts, repeatedly-tested hypotheses, and laws. The Theory of Gravitational Attraction explains why we have gravity. The Heliocentric Theory explains how the sun is the center of our Solar System.\n\nVariation: The different “flavors” of a trait. For example, eye color is the trait, brown, blue, green, and hazel eyes are the possible variations of that trait."
function glossary.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	glossary.background = love.graphics.newImage("images/WoodBackground.jpg")
	glossary.book = love.graphics.newImage("images/Book.png")
	if love.mouse.isCursorSupported() then glossary.hand = love.mouse.getSystemCursor("hand") end
	glossary.smallfont = love.graphics.newFont(20)
	glossary.tinyfont = love.graphics.newFont(17)
	glossary.logo = love.graphics.newImage("images/SmallTIES.jpg")
end
function glossary.draw()
	love.graphics.draw(glossary.background, 0, 0)
	love.graphics.draw(glossary.book, 0, 60)
	love.graphics.draw(glossary.logo, 0, 628, 0, 0.6, 0.6)
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
	love.graphics.printf("Home", 0, 5, 171, "center")
	love.graphics.printf("Natural Selection", 171, 5, 171, "center")
	love.graphics.printf("Time Machine Game", 342, 5, 171, "center")
	love.graphics.printf("Quiz", 513, 5, 171, "center")
	love.graphics.printf("Darwin's Bio", 683, 5, 171, "center")
	love.graphics.setColor(0, 0, 0)
	love.graphics.printf("Glossary", 854, 5, 171, "center")
	love.graphics.setFont(glossary.tinyfont)
	love.graphics.printf(glossary.leftwriting, 120, 85, 352, "left")
	love.graphics.printf(glossary.rightwriting, 572, 85, 342, "left")
	love.graphics.setColor(1, 1, 1)
end
function glossary.update(dt)
	if love.mouse.isCursorSupported() then
		local x,y = love.mouse.getPosition()
		if y <= 60 then
			love.mouse.setCursor(glossary.hand)
		elseif x <= 81 and y >= 628 then
			love.mouse.setCursor(glossary.hand)
		else
			love.mouse.setCursor()
		end
	end
end
function glossary.cleanup()
	glossary.background:release()
	if glossary.hand then glossary.hand:release() end
	glossary.smallfont:release()
	glossary.book:release()
	glossary.tinyfont:release()
	glossary.logo:release()
end
function glossary.mousepressed(x, y, button, istouch, presses)
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
			--Already here
		end
		return
	end
end

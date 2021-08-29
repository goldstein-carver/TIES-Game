--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
cover = {}
cover.finished_audio = false
function cover.load()
	love.graphics.setBackgroundColor(205/255, 133/255, 63/255)
	cover.background = love.graphics.newImage("images/WoodBackground.jpg")
	cover.darwin = love.graphics.newImage("images/Darwin.png")
	cover.hand = love.mouse.getSystemCursor("hand")
	cover.smallfont = love.graphics.newFont(25)
	cover.middlefont = love.graphics.newFont(30)
	cover.bigfont = love.graphics.newFont(35)
	cover.voice = love.audio.newSource("audios/DarwinOpening.ogg", "stream")
	cover.mute = love.graphics.newImage("images/AudioButton.png")--100x100
	cover.unmute = love.graphics.newImage("images/NonAudioButton.png")--110x110
	if (not is_muted) and (not cover.finished_audio) then
		cover.voice:play()
	end
end
function cover.mute_unmute()
	is_muted = not is_muted
	if is_muted then
		cover.voice:stop()
	else
		if not cover.finished_audio then
			cover.voice:play()
		end
	end
end
function cover.draw()
	love.graphics.draw(cover.background, 0, 0)
	love.graphics.setFont(cover.middlefont)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(cover.darwin, 100, 190, 0, 1.25, 1.25)
	if is_muted then
		love.graphics.draw(cover.unmute, 919, -5)
	else
		love.graphics.draw(cover.mute, 924, 0)
	end
	love.graphics.setColor(210/255, 180/255, 140/255)
	love.graphics.polygon("fill", 482, 385, 512, 375, 512, 395)
	love.graphics.rectangle("fill", 512, 220, 462, 380, 20, 20)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.rectangle("fill", 140, 70, 300, 85, 10, 10)
	love.graphics.rectangle("fill", 584, 70, 315, 85, 10, 10)
	love.graphics.rectangle("fill", 320, 640, 480, 55, 10, 3)
	love.graphics.rectangle("fill", 10, 640, 295, 55, 10, 3)
	love.graphics.rectangle("fill", 820, 640, 194, 55, 10, 3)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Glossary", 855, 650)
	love.graphics.print("More about Darwin", 15, 650)
	love.graphics.print("Take the Natural Selection Quiz", 325, 650)
	love.graphics.print("So what's", 215, 78)
	love.graphics.print("Natural Selection?", 155, 112)
	love.graphics.print("Play the TIES", 645, 78)
	love.graphics.print("Time Machine Game", 590, 112)
	love.graphics.setColor(139/255, 69/255, 19/255)
	love.graphics.setFont(cover.smallfont)
	love.graphics.printf("Almost 200 years ago, I sailed the world studying nature. I discovered the process of natural selection, which is the main way evolution happens.\n\nChoose a panel above to learn how species evolve.", 520, 340, 440, "center")
	love.graphics.setFont(cover.bigfont)
	love.graphics.printf("Well, hello, I am\nCharles Darwin. ", 520, 230, 440, "center")
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(cover.smallfont)
	love.graphics.print("Credits", 0, 0)
end
function cover.update(dt)
	local x,y = love.mouse.getPosition()
	local bool = false
	if x >= 924 and y <= 100 then
		bool = true
	end
	if x <= 95 and y <= 30 then
		bool = true
	end
	if y>=70 and y<=155 then
		if x>=140 and x<=440 then
			bool=true
		elseif x>=584 and x<=899 then
			bool=true
		end
	elseif y>=640 and y<=695 then
		if x>=10 and x<=305 then
			bool=true
		elseif x>=320 and x<=800 then
			bool=true
		elseif x>=820 and x<=1014 then
			bool=true
		end
	end
	if bool then
		love.mouse.setCursor(cover.hand)
	else 
		love.mouse.setCursor()
	end
	if (not is_muted) and (not cover.finished_audio) then
		if not cover.voice:isPlaying() then
			cover.finished_audio = true
		end
	end
end
function cover.cleanup()
	love.mouse.setCursor()
	cover.background:release()
	cover.darwin:release()
	cover.hand:release()
	cover.smallfont:release()
	cover.middlefont:release()
	cover.bigfont:release()
	cover.mute:release()
	cover.voice:stop()
	cover.voice:release()
end
function cover.mousepressed(x, y, button, istouch, presses)
	if button ~= 1 then return end
	if x >= 924 and y <= 100 then
		cover.mute_unmute()
		return
	end
	if x <= 95 and y <= 30 then
		switch("credits")
		return
	end
	if y>=70 and y<=155 then
		if x>=140 and x<=440 then
			switch("learn")
		elseif x>=584 and x<=899 then
			switch("game")
		end
	elseif y>=640 and y<=695 then
		if x>=10 and x<=305 then
			switch("bio")
		elseif x>=320 and x<=800 then
			switch("quiz")
		elseif x>=820 and x<=1014 then
			switch("glossary")
		end
	end
end
function cover.touchpressed(id, x, y, dx, dy, pressure)
	cover.mousepressed(x, y, 1)
end

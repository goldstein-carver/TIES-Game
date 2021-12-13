--[[
This file is part of "The TIES Time Machine Game"
Copyright (C) 2021 Carver Goldstein, Syarra Goldstein

"Who Wants to Live a Million Years?" is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
function love.conf(t)
	t.window.title = "TIES Time Machine Game"
	t.window.width = 1024
	t.window.height = 700
	t.window.resizable = false
	t.modules.data = false
	t.modules.joystick = false
	t.modules.math = false
	t.modules.physics = false
	t.modules.thread = false
	t.modules.video = false
end

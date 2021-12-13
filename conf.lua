--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein

"Who Wants to Live a Million Years?" is software released under the CC-BY-NC-ND 4.0 license: <https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode>. Furthermore, this file is licensed under the GNU General Public License version 3.0. You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
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

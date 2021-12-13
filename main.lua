--[[
This file is part of "Who Wants to Live a Million Years?"
Copyright (C) 2021 Carver Goldstein

"Who Wants to Live a Million Years?" is software released under the CC-BY-NC-ND 4.0 license: <https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode>. Furthermore, this file is licensed under the GNU General Public License version 3.0. You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
]]
function love.load()
	require("muted")
	math.randomseed(os.time())
	function cleanup() return end
	function switch(filename)
		if not _G[filename] then
			require(filename)
		end
		cleanup()
		cleanup = _G[filename].cleanup
		love.touchpressed = _G[filename].touchpressed
		love.mousepressed = _G[filename].mousepressed
		love.draw = _G[filename].draw
		love.update = _G[filename].update
		_G[filename].load()
		--Any other callbacks used must be handled here, and a callback in any file must appear in all, even if empty
	end
	switch("cover")
end


-- client bypass (not for serversided movement checks)
local script_context = game:GetService("ScriptContext")
local connections = getconnections(script_context.Error)

for _, c in connections do
	local func = c.Function
	if func then
		local src = getinfo(func).short_src
		if string.find(src, "LocalScript") then
			replaceclosure(func, function()
				return print("WE SO UD RNN 🔥")
			end)
			c:Disable()
			warn("ULTRA DETECTED BYPASS LOADED 🥶")
		end
	end
end

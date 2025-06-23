--[[

    ? Adonis Bypass ?
    - @_color3 | Main Bypass   
    - @upio    | Custom Console

    Created for public research, use at own risk.

--]]

-- Custom Console
getgenv().log = function(text, color)
	if not getgenv().lib then
		getgenv().lib =
			loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/Scripts/main/utils/console/main.lua"))()
	end
	lib.custom_print({
		message = tostring(text),
		color = color or Color3.fromRGB(255, 255, 255),
	})
end

-- Main Bypass
local gc = getgc(true)
if logged then
	log("[i] Reloading bypass..", nil)
end
log("[✓] Bypass loaded!", Color3.fromRGB(88, 137, 184))
for i, v in getreg() do
	if typeof(v) == "thread" then
		local src = debug.info(v, 1, "s")
		if src == ".Core.Anti" then
			for i, v in gc do
				if typeof(v) == "table" then
					local func = rawget(v, "Detected")
					if typeof(func) == "function" then
						if isfunctionhooked(func) then
							restorefunction(func)
						end
						hookfunction(func, function(a, b, c)
							log("[!] Blocked call.", Color3.fromRGB(232, 211, 142))
							return task.wait(9e9)
						end)
						if isfunctionhooked(func) then
							getgenv().logged = true
						end
					end
				end
			end
		end
	end
end

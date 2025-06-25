--[[

  Recently ive seen alot of scripts using this shitty auth called 'Panda Auth', its been pretty popular on youtube so I decided to make a patch for it.
  Run the script you want t bypass, then run this, this will hook the auth function so when you press the submit key button it will always work, no need for a valid key.
  
  Nice auth 👍

]]

for i, v in getgc(true) do
	if typeof(v) == "function" then
		local info = getinfo(v)
		if string.find(info.name, "ValidateKey") then
			replaceclosure(v, function(...)
				return true
			end)
		end
	end
end

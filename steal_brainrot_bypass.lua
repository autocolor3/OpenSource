-- nice anticheat 🥰
replaceclosure(wait, function(duration)
	if not checkcaller() then
		warn(duration)
		task.wait(9e9)
	end
	task.wait(duration)
end)

-- Storing frequently used functions in variables
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
local string_lower = string.lower
local string_format = string.format
local table_insert = table.insert



-- Player attempts to connect, don't let them
local join_prevention = AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
	CancelEvent()
	setKickReason("The server is still starting up, please wait!")
end)



-- Main thread
CreateThread(function()

	-- Getting current resource path and filename
	local filepath = GetResourcePath(GetCurrentResourceName())
	local filename = "/config.cfg"

	-- Iterate config.cfg
	for line in io.lines(filepath..filename) do

		-- If line isn't empty
		if string_len(line) > 0 then

			-- Skip line if commented out
			if string_sub(line, 1, 1) ~= "#" then

				-- Separate arguments
				local arg1 = string_lower(string_sub(line, 1, string_find(line, " ") - 1))
				local arg2 = string_sub(line, string_find(line, " ") + 1)

				-- Remove trailing comments if any
				if string_find(arg2, "#") then
					arg2 = string_sub(arg2, 1, string_find(arg2, "#") - 1)
				end

				-- Remove trailing spaces if any
				if string_find(arg2, " ") then
					arg2 = string_sub(arg2, 1, string_find(arg2, " ") - 1)
				end

				-- If arg1 is start or ensure
				if arg1 == "start" or arg1 == "ensure" then

					-- Resource doesn't exist, eg. wrong name
					local resource_state = GetResourceState(arg2)
					if resource_state == "missing" then
						print(string_format("Resource '^1%s^7' doesn't exist but is in config.", arg2))

					-- Resource is running already
					elseif resource_state == "started" or resource_state == "starting" then
						print(string_format("Resource '^1%s^7' is already running, skipping it.", arg2))

					-- Resource is stopping (possibly due to crashing or being stopped manually)
					elseif resource_state == "stopping" then
						print(string_format("Resource '^1%s^7' is currently stopping, did it crash? Skipping it.", arg2))

					-- Unknown resource state
					elseif resource_state == "unknown" then
						print(string_format("Resource '^1%s^7' has an unknown resource state, skipping it.", arg2))

					-- Uninitialized - I think this might currently be unused? Still have it here though, just in case.
					elseif resource_state == "uninitialized" then
						print(string_format("Resource '^1%s^7' is uninitialized, skipping it.", arg2))

					-- Resource is stopped
					elseif resource_state == "stopped" then

						-- Starting the resource
						local _ = StartResource(arg2)

						-- Checking whether it's running or not, continue once it is
						local new_resource_state = "stopped"
						while new_resource_state ~= "started" do
							new_resource_state = GetResourceState(arg2)
							Wait(100) -- You can decrease/increase this if you want.
						end
					end

				-- arg1 is wait
				elseif arg1 == "wait" then

					-- Convert arg2 to a number or use default 1000ms
					arg2 = tonumber(arg2) or 1000

					-- Wait specified amount of ms
					Wait(arg2)
				end
			end
		end
	end

	-- Done with the config file, remove the event handler and let players join
	RemoveEventHandler(join_prevention)
	print(string_format("^2Players now allowed to join the server!^7"))
end)
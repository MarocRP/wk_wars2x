--[[---------------------------------------------------------------------------------------

	Wraith ARS 2X
	Created by WolfKnight

	For discussions, information on future updates, and more, join
	my Discord: https://discord.gg/fD4e6WD

	MIT License

	Copyright (c) 2020-2021 WolfKnight

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

---------------------------------------------------------------------------------------]] --

local GetEntityCoords = GetEntityCoords
local StartShapeTestCapsule = StartShapeTestCapsule
local GetShapeTestResult = GetShapeTestResult
local GetVehicleMaxNumberOfPassengers = GetVehicleMaxNumberOfPassengers
local GetPedInVehicleSeat = GetPedInVehicleSeat
local DoesEntityExist = DoesEntityExist
local IsPedAPlayer = IsPedAPlayer
local SetNotificationTextEntry = SetNotificationTextEntry
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local DrawNotification = DrawNotification
local SetTextFont = SetTextFont
local SetTextProportional = SetTextProportional
local SetTextScale = SetTextScale
local SetTextColour = SetTextColour
local SetTextDropShadow = SetTextDropShadow
local SetTextEdge = SetTextEdge
local SetTextCentre = SetTextCentre
local SetTextOutline = SetTextOutline
local SetTextEntry = SetTextEntry
local AddTextComponentString = AddTextComponentString
local DrawText = DrawText

local tonumber = tonumber
local tostring = tostring
local string = string
local pairs = pairs
local math = math

local utils = {}

-- Returns a number to a set number of decimal places
function utils.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- The custom font used for the digital displays have the ¦ symbol as an empty character, this function
-- takes a speed and returns a formatted speed that can be displayed on the radar
function utils.formatSpeed(speed)
	-- Return "Err" (Error) if the given speed is outside the 0-999 range
	if (speed < 0 or speed > 999) then return "Err" end


	-- Convert the speed to a string
	local text = tostring(speed)
	local pipes = ""

	-- Create a string of pipes (¦) for the number of spaces
	for _ = 1, 3 - string.len(text) do
		pipes = pipes .. "¦"
	end

	-- Return the formatted speed
	return pipes .. text
end

-- Returns a clamped numerical value based on the given parameters
function utils.clamp(val, min, max)
	-- Return the min value if the given value is less than the min
	if (val < min) then
		return min
		-- Return the max value if the given value is larger than the max
	elseif (val > max) then
		return max
	end

	-- Return the given value if it's between the min and max
	return val
end

-- Returns if the given table is empty, includes numerical and non-numerical key values
function utils.isTableEmpty(t)
	local c = 0


	for _ in pairs(t) do c = c + 1 end

	return c == 0
end

-- Credit to Deltanic for this function
function utils.values(xs)
	local i = 0


	return function()
		i = i + 1
		return xs[i]
	end
end

function utils.enumerateVehicles()
	local coords = GetEntityCoords(cache.ped)
	local vehicles = lib.getNearbyVehicles(coords, 100, false)

	return vehicles
end

-- Old ray trace function for getting a vehicle in a specific direction from a start point
function utils.getVehicleInDirection(entFrom, coordFrom, coordTo)
	local rayHandle = StartShapeTestCapsule(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0,
		10, entFrom, 7)

	local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
	return vehicle
end

-- Returns if a target vehicle is coming towards or going away from the patrol vehicle, it has a range
-- so if a vehicle is sideways compared to the patrol vehicle, the directional arrows won't light up
function utils.getEntityRelativeDirection(myAng, tarAng)
	local angleDiff = math.abs((myAng - tarAng + 180) % 360 - 180)


	if (angleDiff < 45) then
		return 1
	elseif (angleDiff > 135) then
		return 2
	end

	return 0
end

-- Returns if there is a player in the given vehicle
function utils.isPlayerInVeh(veh)
	for i = -1, GetVehicleMaxNumberOfPassengers(veh) + 1, 1 do
		local ped = GetPedInVehicleSeat(veh, i)


		if (DoesEntityExist(ped) and IsPedAPlayer(ped)) then
			return true
		end
	end


	return false
end

-- Your everyday GTA notification function
function utils.notify(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, true)
end

-- Prints the given message to the client console
function utils.log(msg)
	print("[Wraith ARS 2X]: " .. msg)
end

-- Used to draw text to the screen, helpful for debugging issues
function utils.drawDebugText(x, y, scale, centre, text)
	SetTextFont(4)
	SetTextProportional(false)
	SetTextScale(scale, scale)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow()
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextCentre(centre)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

-- Returns if the current resource name is valid
function utils.isResourceNameValid()
	return cache.resource == "wk_wars2x"
end

--[[The MIT License (MIT)


	Copyright (c) 2017 IllidanS4

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.

	The below code can be found at: https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2
]]

return utils

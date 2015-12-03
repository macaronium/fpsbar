if SERVER then
	AddCSLuaFile("fpsbar/client/fpsbar.lua");
else
	include("fpsbar/client/fpsbar.lua");
end
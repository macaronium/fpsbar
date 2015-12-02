print('fps bar init...');

local fpsbar_show_cv = CreateConVar("fpsbar_show", 1, {FCVAR_ARCHIVE});
local fpsbar_show_ping_cv = CreateConVar("fpsbar_show_ping", 1, {FCVAR_ARCHIVE});
local fpsbar_indent_x_cv = CreateConVar("fpsbar_indent_x", 5, {FCVAR_ARCHIVE});
local fpsbar_indent_y_cv = CreateConVar("fpsbar_indent_y", 5, {FCVAR_ARCHIVE});

surface.CreateFont("fpsbar_font", {
	font = "Tahoma",
	size = 16,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});

local function draw_hook()
	local player = LocalPlayer();
	if(player == NULL) then
		print("player is NULL");
		return;
	end
	
	if(fpsbar_show_cv:GetInt() < 1) then
		return;
	end
	
	if(fpsbar_show_ping_cv:GetInt() > 0) then
		local ping = tostring(math.floor(player:Ping()));
		framesPerSecond = tostring(math.floor(1 / FrameTime())) .. " / " .. ping;
		draw.DrawText(framesPerSecond, "fpsbar_font",
					  fpsbar_indent_x_cv:GetInt(),
				      fpsbar_indent_y_cv:GetInt(),
				      Color(255, 255, 255, 255),
				      TEXT_ALIGN_LEFT);
	else
		framesPerSecond = tostring(math.floor(1 / FrameTime()));
		draw.DrawText(framesPerSecond, "fpsbar_font",
				      fpsbar_indent_x_cv:GetInt(),
				      fpsbar_indent_y_cv:GetInt(),
				      Color(255, 255, 255, 255),
				      TEXT_ALIGN_LEFT);
	end
end
hook.Add("HUDPaint", "fpsbar_draw_hook", draw_hook);






print('fps bar init...');

local fpsbar_show_cv = CreateConVar("fpsbar_show", 1, {FCVAR_ARCHIVE});
local fpsbar_show_ping_cv = CreateConVar("fpsbar_show_ping", 1, {FCVAR_ARCHIVE});
local fpsbar_indent_x_cv = CreateConVar("fpsbar_indent_x", 5, {FCVAR_ARCHIVE});
local fpsbar_indent_y_cv = CreateConVar("fpsbar_indent_y", 5, {FCVAR_ARCHIVE});
local fpsbar_font_size_cv = CreateConVar("fpsbar_font_size",
                                         16,
                                         {FCVAR_ARCHIVE},
                                         "Works only after restart.");
local fpsbar_refresh_rate_cv = CreateConVar("fpsbar_refresh_rate",
                                            500,
                                            {FCVAR_ARCHIVE},
                                            "fps bar refresh rate (milliseconds)");

surface.CreateFont("fpsbar_font", {
	font = "Tahoma",
	size = fpsbar_font_size_cv:GetInt() or 16,
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

local time_prev = 0;

local cur_fps = "0";
local cur_ping = "0";

local result_text = "";

local function updateFrameInfo(player)
    cur_fps = tostring(math.floor(1 / RealFrameTime()));
    cur_ping = tostring(math.floor(player:Ping()))

    if(fpsbar_show_ping_cv:GetInt() > 0) then
        result_text = cur_fps .. " / " .. cur_ping;
    else
        result_text = cur_fps;
    end

end

local function draw_hook()
    if(fpsbar_show_cv:GetInt() < 1) then
		return;
	end

	local player = LocalPlayer();
	if(player == NULL) then
		print("player is NULL");
		return;
	end

    local deltaTime = SysTime() - time_prev;
    if(deltaTime > (0.001 * fpsbar_refresh_rate_cv:GetInt())) then
        updateFrameInfo(player);
        time_prev = SysTime();
    end


    draw.DrawText(result_text,
                  "fpsbar_font",
                  fpsbar_indent_x_cv:GetInt(),
                  fpsbar_indent_y_cv:GetInt(),
                  Color(255, 255, 255, 255),
                  TEXT_ALIGN_LEFT);


end
hook.Add("HUDPaint", "fpsbar_draw_hook", draw_hook);

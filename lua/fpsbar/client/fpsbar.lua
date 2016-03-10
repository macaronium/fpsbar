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
                                            0.5,
                                            {FCVAR_ARCHIVE},
                                            "fps bar refresh rate (in seconds)");

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
    cur_ping = tostring(math.floor(player:Ping()));

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

	local refreshrate = fpsbar_refresh_rate_cv:GetFloat();
	
    local deltaTime = SysTime() - time_prev;
    if(deltaTime > refreshrate) then
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

function drawFPSBarOptions(Panel) 
	Panel:CheckBox('enable FPS bar', 'fpsbar_show', '0', '1');
	Panel:CheckBox('Show ping', 'fpsbar_show_ping', '0', '1');
	local xslider = Panel:NumSlider('Indent X', 'fpsbar_indent_x', '0', ScrW());
	xslider:SetDecimals(0);
	xslider:SetValue(fpsbar_indent_x_cv:GetInt());

	local yslider = Panel:NumSlider('Indent Y', 'fpsbar_indent_y', '0', ScrH());
	yslider:SetDecimals(0);
	yslider:SetValue(fpsbar_indent_y_cv:GetInt());
	
	local fontsize = Panel:ComboBox('Font size', 'fpsbar_font_size');
	
	addFontChoices(fontsize);
	
	local refreshrate = Panel:NumSlider('Refresh rate (sec)', 'fpsbar_refresh_rate', '0.1', '60');
	refreshrate:SetDecimals(1);
	refreshrate:SetValue(fpsbar_refresh_rate_cv:GetInt());
end

function initFPSBarMenu()
	spawnmenu.AddToolMenuOption('Options',
								'FPS bar',
								'FPS bar options',
								'FPS bar options',
								'',
								'',
								drawFPSBarOptions);
end

hook.Add("PopulateToolMenu", "fpsbar_options_fn", initFPSBarMenu);

function addFontChoices(combobox)
	combobox:AddChoice('10');
	combobox:AddChoice('11');
	combobox:AddChoice('12');
	combobox:AddChoice('14');
	combobox:AddChoice('16');
	combobox:AddChoice('18');
	combobox:AddChoice('20');
	combobox:AddChoice('22');
	combobox:AddChoice('24');
	combobox:AddChoice('26');
	combobox:AddChoice('28');
	combobox:AddChoice('36');
	combobox:AddChoice('48');
	combobox:AddChoice('72');
	
end

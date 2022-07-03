
local tabPanel
local tabMenu

local background_color = Color(100, 100, 100, 150)
local player_container_color = Color(160, 160, 160, 250)
local player_row_color = Color(80, 80, 80)

surface.CreateFont("Awulf_SCR_Hostname", 
{
    font = "Roboto Mono",
    size = 40,
    weight = 400,
    shadow = true,
    antialias = true,
    extended = true
})

surface.CreateFont("Awulf_SCR_Text", 
{
    font = "Roboto Mono",
    size = 20,
    weight = 100,
    shadow = true,
    antialias = true,
    extended = true
})

local function scoreboardShow()
    local w, h = ScrW(), ScrH()

    tabPanel = vgui.Create("DPanel")
    tabPanel:SetSize(w / 1.2, h / 1.2)
    tabPanel:Center()
    tabPanel:MakePopup()
    
    function tabPanel:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, background_color)
    end

    local hostname = vgui.Create("DLabel", tabPanel)
    hostname:Dock(TOP)
    hostname:SetTall(50)
    hostname:DockMargin(10, 10, 10, 10)
    hostname:SetFont("Awulf_SCR_Hostname")
    hostname:SetContentAlignment(5)
    hostname:SetTextColor(color_white)
    hostname:SetText(GetHostName())

    local player_container = vgui.Create("DPanel", tabPanel)
    player_container:Dock(FILL)
    player_container:DockMargin(10, 0, 10, 10)

    function player_container:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, player_container_color)
    end

    for k,v in ipairs(player.GetAll()) do
        local player_row = vgui.Create("DButton", player_container)
        player_row:Dock(TOP)
        player_row:DockMargin(10, 10, 10, -4)
        player_row:SetTall(50)
        player_row:SetText("")

        function player_row:Paint(w, h)
            if not IsValid(v) then return end
            
            local team_color = team.GetColor(v:Team())

            draw.RoundedBox(3, 0, 0, w, h, team_color)
            draw.RoundedBox(3, 2, 2, w - 4, h - 4, player_row_color)
        end

        function player_row:DoClick()
            tabMenu = DermaMenu()

            tabMenu:AddOption("Скопировать ник", function()
                SetClipboardText(v:Name())
            end)

            tabMenu:AddOption("Скопировать SteamID", function()
                SetClipboardText(v:SteamID())
            end)

            tabMenu:Open()
        end

        local avatar_player = vgui.Create("AvatarImage", player_row)
        avatar_player:Dock(LEFT)
        avatar_player:DockMargin(6, 6, 0, 6)
        avatar_player:SetWide(40)
        avatar_player:SetPlayer(v, 128)

        local nick_player = vgui.Create("DLabel", player_row)
        nick_player:Dock(LEFT)
        nick_player:DockMargin(8, 6, 6, 6)
        nick_player:SetFont("Awulf_SCR_Text")
        nick_player:SetTextColor(color_white)
        nick_player:SetText("")
        nick_player:SizeToContents()

        local team_player = vgui.Create("DLabel", player_row)
        team_player:Dock(LEFT)
        team_player:DockMargin(6, 6, 0, 6)
        team_player:SetFont("Awulf_SCR_Text")
        team_player:SetTextColor(color_white)
        team_player:SetText(team.GetName(v:Team()))
        team_player:SizeToContents()

        local ping_player = vgui.Create("DLabel", player_row)
        ping_player:Dock(RIGHT)
        ping_player:DockMargin(6, 6, 12, 6)
        ping_player:SetFont("Awulf_SCR_Text")
        ping_player:SetTextColor(color_white)
        ping_player:SetText("Пинг: " .. v:Ping())
        ping_player:SizeToContents()

        local frags_player = vgui.Create("DLabel", player_row)
        frags_player:Dock(RIGHT)
        frags_player:DockMargin(6, 6, 12, 6)
        frags_player:SetFont("Awulf_SCR_Text")
        frags_player:SetTextColor(color_white)
        frags_player:SetText("Убийств: " .. v:Frags())
        frags_player:SizeToContents()

        local deaths_player = vgui.Create("DLabel", player_row)
        deaths_player:Dock(RIGHT)
        deaths_player:DockMargin(6, 6, 12, 6)
        deaths_player:SetFont("Awulf_SCR_Text")
        deaths_player:SetTextColor(color_white)
        deaths_player:SetText("Смертей: " .. v:Deaths())
        deaths_player:SizeToContents()

        -- marginLeft, marginTop, marginRight, marginBottom 

        function player_row:Think()
            if not IsValid(v) then return end

            nick_player:SetText(v:Nick())
            nick_player:SizeToContents()

            team_player:SetText(team.GetName(v:Team()))
            team_player:SizeToContents()

            ping_player:SetText("Пинг: " .. v:Ping())
            ping_player:SizeToContents()

            frags_player:SetText("Убийств: " .. v:Frags())
            frags_player:SizeToContents()

            deaths_player:SetText("Смертей: " .. v:Deaths())
            deaths_player:SizeToContents()
        end
    end

    return false
end

hook.Add("ScoreboardShow", "Awulf_Scoreboard", scoreboardShow)

hook.Add("ScoreboardHide", "Awulf_Scoreboard", function()
    if IsValid(tabPanel) then
        tabPanel:Remove()
    end

    if IsValid(tabMenu) then
        tabMenu:Remove()
    end
end)

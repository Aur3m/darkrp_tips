include("deadman_astuce_config.lua")

if not file.Exists( "deadman_astuce", "DATA" ) then
	file.CreateDir( "deadman_astuce" )
end

local function DeadmanAstuceSeeTutorial()
	local mainPanel = vgui.Create("DFrame")
	mainPanel:MakePopup()
	mainPanel:SetDraggable(false)
	mainPanel:ShowCloseButton(false)
	mainPanel:SetSize(ScrW(), ScrH())
	mainPanel:SetTitle("")
	mainPanel:Center()
	mainPanel.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ))
	end

	local mainText = vgui.Create( "RichText", mainPanel)
	mainText:SetPos( 3, 30)
	mainText:SetSize( ScrW()/2.5, ScrH()/4 )
	function mainText:PerformLayout()
		self:SetFontInternal( "ChatFont" )
	end

	local plyTeam = team.GetName(LocalPlayer():Team())
	if DeadmanAstuce.JobTable[plyTeam] then
		mainText:AppendText( DeadmanAstuce.JobTable[plyTeam] )
	else
		mainText:AppendText( "Aucun tutoriel n'est disponible pour ce métier !" )
	end

	mainText:SetVerticalScrollbarEnabled(false)
	mainText.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 40, 40, 255))
    end
    mainText:CenterHorizontal(0.5)
    mainText:CenterVertical(0.5)

    local skipTutorial = vgui.Create( "Button", mainPanel )
	skipTutorial:SetSize( ScrW()/14, ScrH()/36 )
	skipTutorial:Center()
	skipTutorial:SetVisible( true )
	skipTutorial:SetText( "Fermer" )
	skipTutorial:SetTextColor( Color( 255, 255, 255 ) )
	function skipTutorial:OnMousePressed()
		mainPanel:Remove()
	end
	skipTutorial.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color(255, 40, 40, 255))
	end
	skipTutorial:CenterHorizontal(0.5)
    skipTutorial:CenterVertical(0.65)

end





local function DeadmanAstuceMenu()
	local mainPanel = vgui.Create("DFrame")
    mainPanel:MakePopup()
    mainPanel:SetDraggable(false)
    mainPanel:ShowCloseButton(false)
    mainPanel:SetSize(ScrW(), ScrH())
    mainPanel:SetTitle("")
    mainPanel:Center()
    mainPanel.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ))
    end
	
	local imageAstuces = vgui.Create( "DImage", mainPanel )
    imageAstuces:SetPos( 500 , 367 )
    imageAstuces:SetSize( 1005, 357.5 )
    imageAstuces:SetImage( "astucesconfrerie/astuces.jpg", "vgui/avatar_default" )
	
    local seeTutorial = vgui.Create( "Button", mainPanel )
	seeTutorial:SetSize( ScrW()/14, ScrH()/36 )
	seeTutorial:Center()
	seeTutorial:SetVisible( true )
	seeTutorial:SetText( "Regarder le tutoriel" )
	seeTutorial:SetTextColor( Color( 255, 255, 255 ) )
	function seeTutorial:OnMousePressed()
		local plyTeam = team.GetName(LocalPlayer():Team())
		gui.OpenURL( DeadmanAstuce.JobTable[plyTeam] )
		mainPanel:Remove()
	end
	seeTutorial.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color(255, 40, 40, 255))
	end
	seeTutorial:CenterHorizontal(0.35)
    seeTutorial:CenterVertical(0.65)

    local skipTutorial = vgui.Create( "Button", mainPanel )
	skipTutorial:SetSize( ScrW()/14, ScrH()/36 )
	skipTutorial:Center()
	skipTutorial:SetVisible( true )
	skipTutorial:SetText( "Passer le tutoriel" )
	skipTutorial:SetTextColor( Color( 255, 255, 255 ) )
	function skipTutorial:OnMousePressed()
		mainPanel:Remove()
	end
	skipTutorial.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color(255, 40, 40, 255))
	end
	skipTutorial:CenterHorizontal(0.5)
    skipTutorial:CenterVertical(0.65)

    local neverShow = vgui.Create( "Button", mainPanel )
	neverShow:SetSize( ScrW()/14, ScrH()/36 )
	neverShow:Center()
	neverShow:SetVisible( true )
	neverShow:SetText( "Ne jamais voir" )
	neverShow:SetTextColor( Color( 255, 255, 255 ) )
	function neverShow:OnMousePressed()
		file.Write("deadman_astuce/"..string.lower(team.GetName(LocalPlayer():Team()))..".txt", "neverShow")
		mainPanel:Remove()
	end
	neverShow.Paint = function( self, w, h )
	    draw.RoundedBox( 0, 0, 0, w, h, Color(255, 40, 40, 255))
	end
	neverShow:CenterHorizontal(0.65)
    neverShow:CenterVertical(0.65)
end 







net.Receive("DeadmanAstuce::SendClient", function()
	local plyTeam = string.lower(team.GetName(LocalPlayer():Team()))
	if DeadmanAstuce.JobTable[team.GetName(LocalPlayer():Team())] == false then return end
	if file.Exists("deadman_astuce/"..plyTeam..".txt", "DATA") then
		if file.Read("deadman_astuce/"..plyTeam..".txt", "DATA") == "neverShow" then return end
		DeadmanAstuceMenu()
	else
		DeadmanAstuceMenu()
	end
end)
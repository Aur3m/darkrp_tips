util.AddNetworkString("DeadmanAstuce::SendClient")

hook.Add("OnPlayerChangedTeam", "DeadmanAstuce::PlayerChangeTeam", function(ply, oldTeam, newTeam)
	net.Start("DeadmanAstuce::SendClient")
	net.Send(ply)
end)

resource.AddFile( "materials/astucesconfrerie/astuces.jpg" )
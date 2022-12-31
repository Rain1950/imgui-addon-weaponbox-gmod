TOOL.Category = "Rain's Tools"
TOOL.Name = "Weapon box"

if CLIENT then
	language.Add("Tool.weaponboxtool.name","Weapon Box tool")
	language.Add("Tool.weaponboxtool.desc","For spawning weapon boxes")
	language.Add("Tool.weaponboxtool.left", "Left Click: Spawn")
	language.Add("Tool.weaponboxtool.0","Left Click: Spawn")
end





function TOOL:LeftClick( trace )
	
	if ( trace.HitSky or !trace.HitPos or trace.HitNormal.z < 0.7 ) then return false end
	if ( IsValid( trace.Entity ) and ( trace.Entity:GetClass() == "item_ammo_crate" or trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then return false end
	if ( CLIENT ) then return true end
    local ply = self:GetOwner()
	local ang = trace.HitNormal:Angle()
	ang.p = ang.p - 270

	if ( trace.HitNormal.z > 0.9999 ) then ang.y = ply:GetAngles().y + 180 end

	weaponbox =  ents.Create("rain's weaponbox")
	weaponbox:SetPos(trace.HitPos)
	weaponbox:SetPos(weaponbox:LocalToWorld(Vector(0,0,15)))
	weaponbox:SetAngles(ang)
	weaponbox:Spawn()
	

	undo.Create( "Rain's Weapon Box" )
		undo.AddEntity( weaponbox )
		undo.SetPlayer( ply )
	undo.Finish()

	DoPropSpawnedEffect(weaponbox)
    return true 
	
end



if ( SERVER ) then return end




function TOOL.BuildCPanel( panel )
	-- panel:AddControl( "combobox", { Label = "#tool.item_ammo_crate.type", Options = list.Get( "AmmoCrateType" ), Height = 204 } )
	dlist = vgui.Create("DListView",panel)
	dlist:SetPos(0,0)
	dlist:SetSize(400,500)
	column1 = dlist:AddColumn( "Index" )
	dlist:AddColumn( "Size" )
 

    weaponsList = weapons.GetList()
    for k, v in pairs(weaponsList) do
		dlist:AddLine(k,v.ClassName)
 
	end
    column1:ResizeColumn(-200)
    

	checkbox = vgui.Create("DCheckBoxLabel",panel)
	checkbox:SetPos(15,380)
	checkbox:SetText("Limited Supply")
	checkbox:SetTextColor(Color(0,0,0))
	checkbox:SetSize(300,300)
end




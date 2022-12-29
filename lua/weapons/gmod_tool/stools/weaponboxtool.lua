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
    weaponbox:SetParent(weaponbox)
	weaponbox:SetLocalPos(Vector(0,0,10))
	weaponbox:SetAngles(ang)
	weaponbox:Spawn()
	

	undo.Create( "Rain's Weapon Box" )
		undo.AddEntity( weaponbox )
		undo.SetPlayer( ply )
	undo.Finish()
	DoPropSpawnedEffect(weaponbox)

	
end



list.Set( "AmmoCrateTy", "#Pistol_ammo", { item_ammo_crate_type = "0" } )
list.Set( "AmmoCrateType", "#Buckshot_ammo", { item_ammo_crate_type = "4" } )
list.Set( "AmmoCrateType", "#SMG1_grenade_ammo", { item_ammo_crate_type = "9" } )
list.Set( "AmmoCrateType", "#SMG1_ammo", { item_ammo_crate_type = "1" } )
list.Set( "AmmoCrateType", "#AR2_ammo", { item_ammo_crate_type = "2" } )
list.Set( "AmmoCrateType", "#RPG_round_ammo", { item_ammo_crate_type = "3" } )
list.Set( "AmmoCrateType", "#Buckshot_ammo", { item_ammo_crate_type = "4" } )
list.Set( "AmmoCrateType", "#Grenade_ammo", { item_ammo_crate_type = "5" } )
list.Set( "AmmoCrateType", "#357_ammo", { item_ammo_crate_type = "6" } )
list.Set( "AmmoCrateType", "#XBowBolt_ammo", { item_ammo_crate_type = "7" } )
list.Set( "AmmoCrateType", "#AR2AltFire_ammo", { item_ammo_crate_type = "8" } )
list.Set( "AmmoCrateType", "#SMG1_grenade_ammo", { item_ammo_crate_type = "9" } )
list.Set( "AmmoCrateType", "#tool.item_ammo_crate.random", { item_ammo_crate_type = "10" } )

if ( SERVER ) then return end




function TOOL.BuildCPanel( panel )
	panel:AddControl( "combobox", { Label = "#tool.item_ammo_crate.type", Options = list.Get( "AmmoCrateType" ), Height = 204 } )
    panel:Button("sex","sex")

    


end


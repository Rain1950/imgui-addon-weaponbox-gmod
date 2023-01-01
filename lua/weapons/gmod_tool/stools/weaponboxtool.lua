TOOL.Category = "Rain's Tools"
TOOL.Name = "Weapon box"



if CLIENT then
	language.Add("Tool.weaponboxtool.name","Weapon Box tool")
	language.Add("Tool.weaponboxtool.desc","For spawning weapon boxes")
	language.Add("Tool.weaponboxtool.left", "Left Click: Spawn")
	language.Add("Tool.weaponboxtool.0","Left Click: Spawn")
end



uncheckedColor = Color(104,101,101)
checkedColor = Color(0,0,0)




selectedWeapons = {}


local function has_value (tab, val)

	if tab != nil then
		for index, value in ipairs(tab) do
			if value == val then
				return true
			end
		end
	end

	return false
end


function TOOL.BuildCPanel( panel )
	-- panel:AddControl( "combobox", { Label = "#tool.item_ammo_crate.type", Options = list.Get( "AmmoCrateType" ), Height = 204 } )
	dlist = vgui.Create("DListView",panel)
	dlist:SetPos(0,0)
	dlist:SetSize(400,500)
	column1 = dlist:AddColumn( "Index" )
	dlist:AddColumn( "Size" )
 

    allWeaponsTable = weapons.GetList()
    for k, v in pairs(allWeaponsTable) do
		dlist:AddLine(k,v.ClassName)
	end
    column1:ResizeColumn(-200)

    supplyAmount = vgui.Create("DTextEntry",panel)
	supplyAmount:SetNumeric(true)
	supplyAmount:SetPos(110,514)

	LSCheckbox = vgui.Create("DLSCheckboxLabel",panel)  // LSCheckBox - Limited Supply CheckBox
	LSCheckbox:SetPos(10,500)
	LSCheckbox:SetText("Limited Supply")
	LSCheckbox:SetTextColor(Color(0,0,0))
	LSCheckbox:SetSize(100,50)

	RSCheckBox = vgui.Create("DLSCheckboxLabel",panel)  // RSCheckBox - Random  Supply CheckBox
	RSCheckBox:SetPos(10,550)
	RSCheckBox:SetText("Random selection mode")
	RSCheckBox:SetTextColor(Color(0,0,0))
	RSCheckBox:SetSize(100,50)
		

	function dlist:OnRowSelected(rowIndex,row)
		if IsValid(dlist) then
			selectedWeapons = {}
			for k, v in ipairs(dlist:GetSelected()) do
				if has_value(selectedWeapons,v:GetColumnText(2)) == false  then
					table.insert(selectedWeapons,v:GetColumnText(2))
				end
			end
		
			net.Start("selectedWeaponsTable")
			net.WriteTable(selectedWeapons)
			net.SendToServer()
		end
    end


	if (!LSCheckbox:GetChecked()) then

		supplyAmount:SetEnabled(false)
		supplyAmount:SetTextColor(uncheckedColor)
		LSCheckbox:SetTextColor(uncheckedColor)
					
	else
		supplyAmount:SetEnabled(true )
		supplyAmount:SetTextColor(checkedColor)
		LSCheckbox:SetTextColor(checkedColor)
			
	end
	function LSCheckbox:OnChange(val)
		if(!val) then
			supplyAmount:SetEnabled(false)
			supplyAmount:SetTextColor(uncheckedColor)
			LSCheckbox:SetTextColor(uncheckedColor)
	
			
		else
			supplyAmount:SetEnabled(true )
			supplyAmount:SetTextColor(checkedColor)
			LSCheckbox:SetTextColor(checkedColor)
	
		end
	end

end


net.Receive("selectedWeaponsTable",function ()
	selectedWeapons = net.ReadTable()
end)

function TOOL:LeftClick( trace )
	if(#selectedWeapons < 1) then return false end
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
	weaponbox:SetWeaponsTable(selectedWeapons)
	
	weaponbox:Spawn()
	

	undo.Create( "Rain's Weapon Box" )
		undo.AddEntity( weaponbox )
		undo.SetPlayer( ply )
	undo.Finish()

	DoPropSpawnedEffect(weaponbox)
    return true 

    
	
end




hook.Add("Think","ClampSupplyAmount",function ()
	if IsValid(supplyAmount) && tonumber(supplyAmount:GetValue()) != nil   then
		if(tonumber(supplyAmount:GetValue()) > 999 || tonumber(supplyAmount:GetValue()) < 1 ) then
			supplyAmount:SetValue(999)   //clamp supplyamount to 999
		end
	end 
end)





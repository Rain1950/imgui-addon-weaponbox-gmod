AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")
include("shared.lua")

resource.AddFile("arrow(1).png")
resource.AddFile("arrow(2).png")   //navigation arrows

util.AddNetworkString("ChangeColor") 
util.AddNetworkString("isHovering") 
util.AddNetworkString("selectedWeaponsTable") 
util.AddNetworkString("selectedWeaponsTableClient") 
util.AddNetworkString("RandomSupplyBool")
util.AddNetworkString("LimitedSupplyAm")
util.AddNetworkString("LimitedSupplyBool")
util.AddNetworkString("SetNextSelection")
util.AddNetworkString("DecreaseWeaponNumber")
util.AddNetworkString("ReturnWeaponNumberDecreased")
util.AddNetworkString("GetWeaponNumber")
util.AddNetworkString("ReturnWeaponNumber")
util.AddNetworkString("UpdateWeaponAmount")


function ENT:SetWeaponsTable(weaponTable,ply)
    self.weapons = weaponTable
    net.Start("selectedWeaponsTableClient")
    net.WriteEntity(self)
    net.WriteTable(weaponTable)
    net.Send(ply)
end



function ENT:SetLimitedSupplyBool(LimitedSupply)
    self.LimitedSupply = LimitedSupply
  
end


function ENT:DecreaseWeaponAmount(weaponIndex,player)
    
    if(self.InvertedWeaponTable[self.weapons[weaponIndex]] >=  1) then
        self.InvertedWeaponTable[self.weapons[weaponIndex]] = self.InvertedWeaponTable[self.weapons[weaponIndex]] -1 
    end
    print(self.InvertedWeaponTable[self.weapons[weaponIndex]])

    net.Start("UpdateWeaponAmount")
    net.WriteEntity(self)
    net.WriteInt(self.InvertedWeaponTable[self.weapons[weaponIndex]],32)
    net.Send(player)


end




function ENT:GetWeaponAmount(weaponIndex)
    return  self.InvertedWeaponTable[self.weapons[weaponIndex]] 
end


net.Receive("GetWeaponNumber",function (len,ply)
    local ent = net.ReadEntity()
    local weaponIndex = net.ReadInt(32)
    local weaponAmount = ent:GetWeaponAmount(weaponIndex)
    net.Start("ReturnWeaponNumber")
    net.WriteInt(weaponAmount,32)
    net.WriteEntity(ent)
    net.Send(ply)
end)






function ENT:SetNextSelection(right)
    if right then
        if(self.CurrentlySelected == #self.weapons) then       //if selected weapon is last weapon, next in the right should be first from weapons table
            self.CurrentlySelected = 1
        else                                                    
            self.CurrentlySelected= self.CurrentlySelected+1      
        end
    else
        if(self.CurrentlySelected == 1) then
            self.CurrentlySelected = #self.weapons
        else
            self.CurrentlySelected=self.CurrentlySelected-1
        end
    end
    self:SetSelectedIndex(self.CurrentlySelected)
end

    



local initialColor = nil //declare initial color
function ENT:Initialize()
    self:SetModel("models/items/ammocrate_smg1.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)  // make crate static 
    self:DrawShadow(false )  //remove shadow from crate
    intialColor = self:GetColor()  //set initialColor to default color of the entity
    self.CurrentlySelected = 1
    self:SetCanUse(true)
    self:SetSelectedIndex(1)

    self.InvertedWeaponTable = {}   // table used for retrieving amount of choosen weapon type left.
    for k,v in pairs(self.weapons) do
        self.InvertedWeaponTable[v]=self:GetLimitedSupplyAmount() 
    end

end




    


local isHovering = false 

net.Receive("isHovering",function ()
    isHovering = net.ReadBool()
end)



local canUse = true
 
function ENT:Use(caller,activator)
    if self:GetCanUse() && IsValid(self) && !isHovering  then

       
     
        self:SetColor(Color(218,26,26,10))   //interaction color
        self:SetCanUse(false)  //simple bool to limit rate at which player can use weapon box
        timer.Simple(1,function ()
            if IsValid(self)    then
                if self:GetRandomSupply()  then
                    weapon = ents.Create(self.weapons[math.random(1,#self.weapons)]) //set weapon class to random from weaponsTable
                    weapon:SetPos(self:LocalToWorld(Vector(0,0,30)))  //set weapon position 30 units up relative to weapon box
                    weapon:SetMoveType(MOVETYPE_NONE) // make weapon also static
                    weapon:SetParent(self)  // parent weapon to weapon box (so it will move with it)
                    weapon:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)) )   // set rotation of weapon to match weaponbox and rotate it by 90 on yaw axis
                    weapon:Spawn() 
                    sound.Play( "buttons/combine_button5.wav", self:GetPos() ) 
                    self:SetColor(intialColor) //set weaponbox color to itself


                else // if selection mode 
                    if (self:GetWeaponAmount(weaponbox.CurrentlySelected) > 0 ) then
                        weapon = ents.Create(self.weapons[weaponbox.CurrentlySelected]) //set weapon class to choosen from weaponsTable
                        weapon:SetPos(self:LocalToWorld(Vector(0,0,30)))  //set weapon position 30 units up relative to weapon box
                        weapon:SetMoveType(MOVETYPE_NONE) // make weapon also static
                        weapon:SetParent(self)  // parent weapon to weapon box (so it will move with it)
                        weapon:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)) )   // set rotation of weapon to match weaponbox and rotate it by 90 on yaw axis
                        weapon:Spawn() 
                        sound.Play( "buttons/combine_button5.wav", self:GetPos() ) 
                        self:SetColor(intialColor) //set weaponbox color to itself

                    else
                        sound.Play( "buttons/combine_button_locked.wav", self:GetPos() )
                        self:SetColor(intialColor)
                    end
                    self:DecreaseWeaponAmount(weaponbox.CurrentlySelected,activator)
                    
                end


            end

            self:SetCanUse(true )

        end)

    end
   
end

net.Receive("SetNextSelection",function ()
    ent = net.ReadEntity()
    nextSelection = net.ReadBool()
    ent:SetNextSelection(nextSelection)
end)

function ENT:Think()

   
end


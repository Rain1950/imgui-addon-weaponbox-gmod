AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")
include("shared.lua")


util.AddNetworkString("ChangeColor") 
util.AddNetworkString("isHovering") 
util.AddNetworkString("selectedWeaponsTable") 
util.AddNetworkString("RandomSupplyBool")
util.AddNetworkString("LimitedSupplyAmount")
util.AddNetworkString("LimitedSupplyBool")

function  ENT:SetRandomSupply(RandomSupply)
    self.RandomSupply = RandomSupply
end

function ENT:SetWeaponsTable(weaponTable)
    self.weapons = weaponTable
end

function ENT:SetLimitedSupply(LimitedSupply)
    self.LimitedSupply = LimitedSupply
  
end

function ENT:SetLimitedSupplyAmount(amount)
    self.LimitedSupplyAmount = amount

end




local initialColor = nil //declare initial color
function ENT:Initialize()
    self:SetModel("models/items/ammocrate_smg1.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)  // make crate static 
    self:DrawShadow(false )  //remove shadow from crate
    intialColor = self:GetColor()  //set initialColor to default color of the entity
    
end




    


local isHovering = false 

net.Receive("isHovering",function ()
    isHovering = net.ReadBool()
end)


local canUse = true
 
function ENT:Use(caller,activator)
    if canUse && IsValid(self) && !isHovering  then

        self:SetColor(Color(218,26,26,10))   //interaction color
        canUse = false  //simple bool to limit rate at which player can use weapon box
        net.Start("ChangeColor")
        net.WriteColor(Color(255,255,255,255),true )
        net.Broadcast()
        timer.Simple(1,function ()
            if IsValid(self) then
                weapon = ents.Create(self.weapons[math.random(1,#self.weapons)]) //set weapon class to random from weaponsTable
                weapon:SetPos(self:LocalToWorld(Vector(0,0,30)))  //set weapon position 30 units up relative to weapon box
                weapon:SetMoveType(MOVETYPE_NONE) // make weapon also static
                weapon:SetParent(self)  // parent weapon to weapon box (so it will move with it)
                weapon:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)) )   // set rotation of weapon to match weaponbox and rotate it by 90 on yaw axis
                weapon:Spawn() 
                sound.Play( "buttons/combine_button5.wav", self:GetPos() ) 
                self:SetColor(intialColor) //set weaponbox color to itself
            end
            canUse = true
        end)

    end
   
end


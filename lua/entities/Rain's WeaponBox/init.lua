AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

 
local initialColor = nil //declare initial color
function ENT:Initialize()
    self:SetModel("models/items/ammocrate_smg1.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)  // make crate static 
    self:DrawShadow(false )  //remove shadow from crate
    intialColor = self:GetColor()  //set initialColor to default color of the entity
end


weaponsTable = {
    "weapon_357",
    "weapon_pistol",
    "weapon_bugbait",
    "weapon_crossbow",
    "weapon_crowbar",        //table of weapons to choose from
    "weapon_frag",
    "weapon_ar2",
    "weapon_rpg",
    "weapon_shotgun",
    "weapon_smg1",
}



local canUse = true  
function ENT:Use(caller,activator)
    if canUse then
        self:SetColor(Color(218,26,26,10))   //interaction color
        canUse = false  //simple bool to limit rate at which player can use weapon box
        timer.Simple(1,function ()
            weapon = ents.Create(weaponsTable[math.random(1,#weaponsTable)]) //set weapon class to random from weaponsTable
            weapon:SetPos(self:LocalToWorld(Vector(0,0,30)))  //set weapon position 30 units up relative to weapon box
            weapon:SetMoveType(MOVETYPE_NONE) // make weapon also static
            weapon:SetParent(self)  // parent weapon to weapon box (so it will move with it)
            weapon:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)) )   // set rotation of weapon to match weaponbox and rotate it by 90 on yaw axis
            weapon:Spawn() 
            sound.Play( "buttons/combine_button5.wav", self:GetPos() ) 
            self:SetColor(intialColor) //set weaponbox color to itself
            canUse = true
        end)
    end
   
end


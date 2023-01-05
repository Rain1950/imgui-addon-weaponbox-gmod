AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")
include("shared.lua")

resource.AddFile("arrow(1).png")
resource.AddFile("arrow(2).png")   //navigation arrows

util.AddNetworkString("ChangeColor") 
util.AddNetworkString("isHovering") 
util.AddNetworkString("selectedWeaponsTable") 
util.AddNetworkString("RandomSupplyBool")
util.AddNetworkString("LimitedSupplyAmount")
util.AddNetworkString("LimitedSupplyBool")
util.AddNetworkString("SetNextSelection")



function ENT:SetWeaponsTable(weaponTable)
    self.weapons = weaponTable
end

function ENT:SetLimitedSupply(LimitedSupply)
    self.LimitedSupply = LimitedSupply
  
end

function ENT:SetLimitedSupplyAmount(amount)
    self.LimitedSupplyAmount = amount

end





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
            if IsValid(self)  then
                if self:GetRandomSupply()  then
                    weapon = ents.Create(self.weapons[math.random(1,#self.weapons)]) //set weapon class to random from weaponsTable
                else
                    weapon = ents.Create(self.weapons[weaponbox.CurrentlySelected]) //set weapon class to random from weaponsTable
                end
                weapon:SetPos(self:LocalToWorld(Vector(0,0,30)))  //set weapon position 30 units up relative to weapon box
                weapon:SetMoveType(MOVETYPE_NONE) // make weapon also static
                weapon:SetParent(self)  // parent weapon to weapon box (so it will move with it)
                weapon:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)) )   // set rotation of weapon to match weaponbox and rotate it by 90 on yaw axis
                weapon:Spawn() 
                sound.Play( "buttons/combine_button5.wav", self:GetPos() ) 
                self:SetColor(intialColor) //set weaponbox color to itself
            end
            self:SetCanUse(true )
        end)

    end
   
end

function ENT:Think()
    net.Receive("SetNextSelection",function ()
        nextSelection = net.ReadBool()
        print(nextSelection)
        self:SetNextSelection(nextSelection)
    end)
end


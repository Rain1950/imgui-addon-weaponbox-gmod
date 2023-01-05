ENT.Author = "Rain"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Rain's Weapon Box"                    //basic ENT setup
ENT.Instructions = "Use it to acquire  choosen weapon"
ENT.Spawnable = true
ENT.Type = "anim"




function ENT:SetupDataTables()

    self:NetworkVar("Bool",0,"RandomSupply")
    self:NetworkVar("Bool",1,"CanUse")
end


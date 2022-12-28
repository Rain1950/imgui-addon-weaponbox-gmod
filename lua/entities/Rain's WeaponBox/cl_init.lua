
include("shared.lua")
AddCSLuaFile("imgui.lua")
local imgui = include("imgui.lua")

local mat = Material("label.png")

local color = Color(255,0,0,1) 

net.Receive("ChangeColor",function ()
    color = net.ReadColor()
    timer.Simple(1,function ()
        color = Color(255,0,0,1) 
    end)
end)



function ENT:Draw()
    self:DrawModel()     

    if imgui.Entity3D2D(self,Vector(25,-4,10) , Angle(0,90,90),0.1) then
        surface.SetMaterial(mat)
        surface.SetDrawColor(color) 
        surface.DrawTexturedRect(50, 50, 128, 128)
        imgui.End3D2D()
    end
end

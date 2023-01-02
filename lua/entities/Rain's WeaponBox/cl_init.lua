
include("shared.lua")
AddCSLuaFile("imgui.lua")
local imgui = include("imgui.lua")

local BackGroundColor = Color(187,187,187,100) 

net.Receive("ChangeColor",function ()
    BackGroundColor = net.ReadColor()
    timer.Simple(1,function ()
        BackGroundColor = Color(187,187,187,100) 
    end)
end)


local nextButton = {}
nextButton.DefaultColor = Color(170,170,170)
nextButton.HoverColor = Color(102,105,102)
nextButton.pressColor = Color(20,20,20,255)



 
local previousState = false   
local test = true

function ENT:Draw()
    self:DrawModel()     
    
    if imgui.Entity3D2D(self,Vector(17,-11.5,12) , Angle(0,90,90),0.1) then
        surface.SetDrawColor(BackGroundColor) 
        draw.RoundedBox(15,-35,75,300,60,BackGroundColor)
        if(selectedWeapons[1]:len() < 15) then
            draw.DrawText(selectedWeapons[1],imgui.xFont("!Arial Rounded MT Bold@30"),110,85,nil,TEXT_ALIGN_CENTER)
        else
            draw.DrawText(selectedWeapons[1],imgui.xFont("!Arial Rounded MT Bold@24"),110,85,nil,TEXT_ALIGN_CENTER)
        end
        
        -- draw.SimpleText(selectedWeapons[1],imgui.xFont("!Arial Rounded MT Bold@30"),19,85,nil,nil,1)
        if imgui.xButton(275,82,50,50,50,nextButton.DefaultColor,nextButton.HoverColor, nextButton.pressColor) then   //right button
            print("rat")
        end
        local hovering = imgui.IsHovering(-500, 0, 1000, 1000)

    
        if hovering ~= nil then
            if hovering != previousState then
                net.Start("isHovering",true )
                net.WriteBool(hovering)
                net.SendToServer()  
                previousState = hovering
            end
        end
            
        
      
        if imgui.xButton(-96,82,50,50,50,nextButton.DefaultColor,nextButton.HoverColor, nextButton.pressColor) then   //left button
            print("rat")
           
        end

        
        draw.SimpleText("Weapon Box",imgui.xFont("!Arial Rounded MT Bold@60"),-35,-65)
        imgui.End3D2D()
    end

    if imgui.Entity3D2D(self,Vector(17,-11.7,12) , Angle(0,90,90),0.1) then
        draw.RoundedBox(15,-70,-60,380,60,Color(134,134,134,91))
        imgui.End3D2D()
    end
  

end

function ENT:Think()
end

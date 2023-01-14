
include("shared.lua")
AddCSLuaFile("imgui.lua")
local imgui = include("imgui.lua")

local BackGroundColor = Color(187,187,187,100) 





local nextButton = {}
nextButton.DefaultColor = Color(170,170,170)
nextButton.HoverColor = Color(102,105,102)
nextButton.pressColor = Color(20,20,20,255)
currentlySelected = 1
local previousState = false   



local RightArrowMat = Material("arrow1.png")
local LeftArrowMat = Material("arrow2.png")   // materials for navigation arrows


local CanPress  = true



function  DecreaseWeaponNumber(weaponIndex,ent)
    net.Start("DecreaseWeaponNumber")
    net.WriteEntity(ent)
    net.WriteInt(weaponIndex,32)
    net.SendToServer()
end



function GetWeaponNumber(weaponIndex,ent)
    net.Start("GetWeaponNumber")
    net.WriteEntity(ent)
    net.WriteInt(weaponIndex,32)
    net.SendToServer()
end



net.Receive("ReturnWeaponNumber",function ()
    local number = net.ReadInt(32)
    local ent = net.ReadEntity()
    ent.weaponNumber = number
end)


net.Receive("selectedWeaponsTableClient",function ()
    local ent = net.ReadEntity()
    local table = net.ReadTable()
    ent.weapons = table
    
end)


function ENT:Draw()
    self:DrawModel()     
    if imgui.Entity3D2D(self,Vector(17,-11.5,12) , Angle(0,90,90),0.1) then
        

        if(self:GetLimitedSupply()) then
            local amount = self.weaponNumber 
            if(self.weaponNumber != nil ) then
                if amount < 10 then
                    draw.RoundedBox(15,86,17,50,50,BackGroundColor)
                    draw.SimpleText(self.weaponNumber,imgui.xFont("!Arial Rounded MT Bold@60"),95,10)
    
                elseif (amount < 100 ) then
                    draw.RoundedBox(15,75,17,80,50,BackGroundColor)
                    draw.SimpleText(self.weaponNumber,imgui.xFont("!Arial Rounded MT Bold@60"),86,10)
                    
                elseif (amount < 1000) then
                    draw.SimpleText(self.weaponNumber,imgui.xFont("!Arial Rounded MT Bold@60"),60,10)
                    draw.RoundedBox(15,35,17,150,50,BackGroundColor)
                end
            end
                
            
        end


        if self:GetRandomSupply() == true  then
            draw.SimpleText("Weapon Box",imgui.xFont("!Arial Rounded MT Bold@60"),-35,-65)
            imgui.End3D2D()
        else
           
    

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(RightArrowMat)    //right arrow
            surface.DrawTexturedRect(263,68,75,75)
            draw.SimpleText("Weapon Box",imgui.xFont("!Arial Rounded MT Bold@60"),-35,-65)

            surface.SetMaterial(LeftArrowMat)    //right arrow
            surface.DrawTexturedRect(-110,68,75,75)

            surface.SetDrawColor(BackGroundColor) 
            draw.RoundedBox(15,-35,75,300,60,BackGroundColor)
            if(self.weapons[self:GetSelectedIndex()]:len() < 15) then
                draw.DrawText(self.weapons[self:GetSelectedIndex()],imgui.xFont("!Arial Rounded MT Bold@30"),110,85,nil,TEXT_ALIGN_CENTER)
            else
                draw.DrawText(self.weapons[self:GetSelectedIndex()],imgui.xFont("!Arial Rounded MT Bold@24"),110,85,nil,TEXT_ALIGN_CENTER)
            end
        
            if imgui.xButton(275,82,50,50,5,nextButton.DefaultColor,nextButton.HoverColor, nextButton.pressColor) then   //right button
                if CanPress then
                    GetWeaponNumber(self:GetSelectedIndex(),self)
                    print(self:GetSelectedIndex())
                    CanPress = false 
                    sound.Play( "buttons/button15.wav", self:GetPos() ) 
                    net.Start("SetNextSelection",true)
                    net.WriteEntity(self)
                    net.WriteBool(true)
                    net.SendToServer()
                    timer.Simple(0.2,function ()
                        CanPress = true
                    end)
                end
            
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
            
        
      
            if imgui.xButton(-96,82,50,50,5,nextButton.DefaultColor,nextButton.HoverColor, nextButton.pressColor) then   //left button
                if CanPress then
                    GetWeaponNumber(self:GetSelectedIndex(),self)
                    CanPress = false
                    sound.Play( "buttons/button15.wav", self:GetPos() ) 
                    net.Start("SetNextSelection",true)
                    net.WriteBool(false)
                    net.SendToServer()
    
                    timer.Simple(0.2,function ()
                        CanPress = true 
                    end)
                end
           
            end

        
            imgui.End3D2D()
        end
        
    end

    if imgui.Entity3D2D(self,Vector(17,-11.7,12) , Angle(0,90,90),0.1) then
        draw.RoundedBox(15,-70,-60,380,60,Color(134,134,134,91))
        imgui.End3D2D()
    end
  

end


function ENT:Think()

end

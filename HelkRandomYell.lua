local _, HelkRandomYell = ...
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" and addon == "HelkRandomYell" then
        
        -- check if we already made the button, if not make it now
        if not RandomYellButton then
            RandomYellButton = CreateFrame("Button", "RandomYellButton", UIParent, "UIPanelButtonTemplate")
            RandomYellButton:SetSize(100, 30)
            RandomYellButton:SetText("Yell Stuff!")
            RandomYellButton:SetScript("OnClick", RandomYell_OnClick())
        end

        -- the actual onclick function that picks a random quote from the global HRYells variable
        function RandomYell_OnClick()
          if #HelkRandomYell.HRYells > 0 then
            local randIndex = math.random(#HelkRandomYell.HRYells)
            SendChatMessage(HelkRandomYell.HRYells[randIndex], "Yell")
          end
        end
        
        -- make it moveable on left click
        RandomYellButton:SetMovable(true)
        RandomYellButton:EnableMouse(true)
        RandomYellButton:RegisterForDrag("LeftButton")
        RandomYellButton:SetScript("OnDragStart", RandomYellButton.StartMoving)
        RandomYellButton:SetScript("OnDragStop", RandomYellButton.StopMovingOrSizing)
        
        -- if we moved it previously, we load the position here
        if HRYButtonPosition.point then
            RandomYellButton:ClearAllPoints()
            RandomYellButton:SetPoint(HRYButtonPosition.point, UIParent, HRYButtonPosition.relPoint, HRYButtonPosition.ofsx, HRYButtonPosition.ofsy)
        else
            RandomYellButton:SetPoint("TOPLEFT", UIParent, 50, 150)
        end
        
        self:UnregisterEvent("ADDON_LOADED")

    elseif event == "PLAYER_LOGOUT" then --get the local position and save it to the global variable on logout
        if RandomYellButton then
            local point, relPoint, ofsx, ofsy = RandomYellButton:GetPoint(1)
            HRYButtonPosition.point, HRYButtonPosition.relPoint, HRYButtonPosition.ofsx, HRYButtonPosition.ofsy = point, relPoint, ofsx, ofsy
        end
    end
end)
f:RegisterEvent("PLAYER_LOGOUT")
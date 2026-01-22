local _, HelkRandomYell = ...
HRYButtonPosition = HRYButtonPosition or {}
HRYQuoteDB = HRYQuoteDB or {}
local activeQuotes

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
    if event == "ADDON_LOADED" and addon == "HelkRandomYell" then
        local lastYellTime = 0
        local yellCooldown = 1        
        
        -- check if we already made the button, if not make it now
        if not RandomYellButton then
            RandomYellButton = CreateFrame("Button", "RandomYellButton", UIParent, "UIPanelButtonTemplate")
            RandomYellButton:SetSize(100, 30)
            RandomYellButton:SetText("Yell Stuff!")
            RandomYellButton:SetScript("OnClick", RandomYell_OnClick)
        end

        -- check if we have quotes saved in SavedVars or if we use default
        if HRYQuoteDB.quotes and #HRYQuoteDB.quotes > 0 then
            activeQuotes = HRYQuoteDB.quotes
        else
            activeQuotes = HelkRandomYell.defaultQuotes
        end

        -- the actual onclick function that picks a random quote to yell
        function RandomYell_OnClick()
          local now = GetTime()  
          if now - lastYellTime < yellCooldown then
            print("Yell on cooldown")
            return
          end
          
          local randIndex
          if #activeQuotes > 0 then
            local randIndex
            repeat
              randIndex = math.random(1, #activeQuotes)
            until randIndex ~= lastYellIndex or lastYellIndex == 0
            SendChatMessage(activeQuotes[randIndex], "YELL", nil, nil)
            lastYellIndex = randIndex
            lastYellTime = now
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

    elseif event == "PLAYER_LOGOUT" then --save quotes and button positionto SavedVars
        if RandomYellButton then
            local point, relPoint, ofsx, ofsy = RandomYellButton:GetPoint(1)
            HRYButtonPosition.point, HRYButtonPosition.relPoint, HRYButtonPosition.ofsx, HRYButtonPosition.ofsy = point, relPoint, ofsx, ofsy
        end

        if activeQuotes then --save latest quote list into SavedVars
            HRYQuoteDB.quotes = activeQuotes
            print("Quotes saved")
        end
    end
end)
f:RegisterEvent("PLAYER_LOGOUT")

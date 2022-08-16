local addonName = ...

ClamBake = LibStub("AceAddon-3.0"):NewAddon(addonName)

local AceDB = LibStub("AceDB-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


local eventHandlers = {
    ["BAG_UPDATE"] = function(...)
        ClamBake:Debug("Bag updated")

        local bag = select(1, ...)

        if not bag then
            return
        end

        -- If this even fires for the default backpack, it fires with the bag id of -2
        if bag == -2 then
            bag = 0
        end

        ClamBake:Debug("Bag identified as " .. bag)
        ClamBake:OpenAllClams(bag)
    end
}


function ClamBake:Debug(string, r, g, b)
    if self.database.profile.settings.debug == false then
        return
    end

    if not string then
        string = "(nil)"
    end

    if not r then
        r = 1
    end

    if not g then
        g = 0
    end

    if not b then
        b = 0
    end

    self:Print(string, r, g, b)
end


function ClamBake:Print(string, r, g, b)
    DEFAULT_CHAT_FRAME:AddMessage("[" .. addonName .. "] " .. string, r, g, b)
end


function ClamBake:OpenAllClams(bag)
    ClamBake:Debug("Starting search for clams in bag " .. bag)

    if MerchantFrame and MerchantFrame:IsShown() then
        ClamBake:Debug("Merchant frame is open. Trying to open a clam here would sell it. Aborting.")
        return
    end

    -- If this even fires for the default backpack, it fires with a bag id of -2
    if bag == -2 then
        bag = 0
    end

    for bagSlot = 1, GetContainerNumSlots(bag) do
        local bagItemId = GetContainerItemID(bag, bagSlot)

        if bagItemId then
            local itemName = select(1, GetItemInfo(bagItemId))
            local isClam = self:isClam(bagItemId)

            if isClam == true then
                self:Debug("Found a clam in bag " .. bag .. " slot " .. bagSlot, 0, 1, 0)
                self:Print(L["Opening a "] .. itemName .. L[" found in bag "] .. bag .. L[" slot "] .. bagSlot)

                UseContainerItem(bag, bagSlot)
            end
        end
    end
end


function ClamBake:OpenAllClamsInAllBags()
    for bag = 0, 4 do
        self:OpenAllClams(bag)
    end
end


function ClamBake:isClam(identifier)
    local clams = {
        [7973] = select(1, GetItemInfo(7973)), -- Big-mouth Clam
        [24476] = select(1, GetItemInfo(24476)), -- Jaggal Clam
        [5523] = select(1, GetItemInfo(5523)), -- Small Barnacled Clam
        [15874] = select(1, GetItemInfo(15874)), -- Soft-shelled Clam
        [5524] = select(1, GetItemInfo(5524)), -- Thick-shelled Clam
    }

    local result = clams[identifier] ~= nil

    if result == true then
        return true
    end

    for _, value in pairs(clams) do
        if value == identifier then
            return true
        end
    end

    return false
end


function ClamBake:OnSettingToggled(info, input)
    local status = (input == true) and L["On"] or L["Off"]
    self:Print(tostring(info["option"].name) .. " " .. status)
end


function ClamBake:Status()
    local status

    if self.database.profile.settings.enable == true then
        status = L["On"]
    else
        status = L["Off"]
    end

    self:Print(tostring(addonName .. L[" is"] .. ": " .. status))
end


-- Creates and registers the options window
function ClamBake:RegisterOptions()
    AceConfig:RegisterOptionsTable(addonName, ClamBake_Options, {"clambake", "cb"})
    AceConfigDialog:AddToBlizOptions(addonName, addonName)
end


-- Register for all the events this addon listens for
function ClamBake:RegisterEvents()
    local EventFrame = CreateFrame("Frame", "ClamBake_EventFrame")

    for event, _ in pairs(eventHandlers) do
        EventFrame:RegisterEvent(event)
    end

    EventFrame:SetScript("OnEvent", function(self, event, ...)
        local eventHandler = eventHandlers[event]

        if eventHandler then
            eventHandler(...)
        end
    end)
end


function ClamBake:InitializeDatabase()
    self.database = AceDB:New("ClamBakeDatabase", ClamBake_Database)
end


function ClamBake:OnInitialize()
    self:InitializeDatabase()
    self:RegisterOptions()
    self:RegisterEvents()
end

local addonName = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

ClamBake_Options = {
    name = addonName,
    type = "group",
    args = {
        enable = {
            name = L["Enable"],
            desc = L["Enable/disable auto-opening clams"],
            type = "toggle",
            set = function(info, input)
                ClamBake.database.profile.settings.enable = input
                ClamBake:OnSettingToggled(info, input)
            end,
            get = function(info)
                return ClamBake.database.profile.settings.enable
            end
        },
        debug = {
            name = L["Debug"],
            desc = L["Enables debug messages in chat"],
            type = "toggle",
            set = function(info, input)
                ClamBake.database.profile.settings.debug = input
                ClamBake:OnSettingToggled(info, input)
            end,
            get = function(info)
                return ClamBake.database.profile.settings.debug
            end
        },
        status = {
            name = L["Display whether clam opening is enabled or disabled"],
            type = "execute",
            guiHidden = true,
            func = function ()
                ClamBake:Status()
            end
        },
    }
}

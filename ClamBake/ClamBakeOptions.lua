ClamBake_Options = {
    name = "ClamBake",
    type = "group",
    args = {
        enable = {
            name = "Enable",
            desc = "Enable/disable auto-opening clams",
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
            name = "Debug",
            desc = "Enables debug messages in chat",
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
            name = "Display whether clam opening is enabled or disabled",
            type = "execute",
            guiHidden = true,
            func = function ()
                ClamBake:Status()
            end
        },
    }
}

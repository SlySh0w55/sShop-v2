--@author: Slyy#0999
--@Copyright

fx_version "adamant"

game "gta5"

client_scripts {
    -- RAGEUI
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    --
    "client/*.lua"
}

server_scripts {
    "@async/async.lua",
    "@mysql-async/lib/MySQL.lua",
    --
    "server/*.lua"
}

shared_scripts {
    "shared/*.lua"
}
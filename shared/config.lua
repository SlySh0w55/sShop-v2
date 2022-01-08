--@author: Slyy#0999
--@Copyright

Config = {}
Config.EsxGetter = "esx:getSharedObject"
Config.KickOption = function(playerId) -- playerId is source of cheater
    DropPlayer(playerId, "La triche est strictement interdite.")
end
Config.ShopList = {
    ["premier_shop"] = {
        Name = "Mon premier shop",
        Desc = "Bienvenue dans mon premier shop !", -- Non obligatoire
        NotifPrefix = "Mon premier shop", -- Non obligatoire
        Position = vector3(-1383.247, -187.5797, 46.8855),
        Marker = {
            HelpNotification = "Appuyez sur ~INPUT_CONTEXT~ pour intéragir avec mon premier shop", -- Non obligatoire
            Id = 2,
            Scale = {x = 0.55, y = 0.55, z = 0.55},
            Color = {r = 0, g = 0, b = 255, a = 255}, -- Non obligatoire
            Parms = { -- Paramètres non obligatoire (possibilité de ne pas utilisé tout)
                BobUpAndDown = true,
                FaceCamera = true,
                Rotate = true,
                DrawOnEnts = true
            }
        },
        Blips = { -- Blips non obligatoire (possibilité de ne pas utilisé tout)
            Id = 303,
            Scale = 0.7,
            Color = 1,
            Name = "Shop"
        },
        Items = {
            ["Nourriture"] = {
                {Label = "Pain", Name = "bread", Price = 100},
                {Label = "Burger", Name = "burger", Price = 500},
                {Label = "Poisson", Name = "fish", Price = 500},
                {Label = "Viande", Name = "meet", Price = 1500},

            },
            ["Boissons"] = {
                {Label = "Eau", Name = "water", Price = 50},
                {Label = "Bière", Name = "beer", Price = 500},
                {Label = "Coca", Name = "coca", Price = 500},
                {Label = "Cola", Name = "cola", Price = 500},
                {Label = "Glaçon", Name = "ice", Price = 10},
                {Label = "Jus de coca", Name = "jus_coca", Price = 200},
                {Label = "Jus de raison", Name = "jus_raisin", Price = 200},
                {Label = "Jus de fruit", Name = "jusfruit", Price = 200},
            },
            ["Autres item"] = {
                {Label = "Cuivre", Name = "copper", Price = 50}, 
                {Label = "Diamant", Name = "diamond", Price = 50},
                {Label = "Vêtement", Name = "clothe", Price = 50}, 
            },
        }
    }
}

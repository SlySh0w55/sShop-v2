--@author: Slyy#0999
--@Copyright

ESX = nil

TriggerEvent(Config.EsxGetter, function(obj) 
    ESX = obj 
end)

RegisterNetEvent("sShops:PayNow")
AddEventHandler("sShops:PayNow", function(shopName, payementType, item, count, finalPrice)
    local _source = source

    if #(GetEntityCoords(GetPlayerPed(_source)) - Config.ShopList[shopName].Position) < 3 and type(payementType) == "number" and payementType <= 2 then
        local xPlayer = ESX.GetPlayerFromId(_source)
        local account = payementType == 1 and "bank" or "money"

        if xPlayer.getAccount(account).money >= finalPrice then 
            xPlayer.removeAccountMoney(account, finalPrice)
            xPlayer.addInventoryItem(item, count)
            xPlayer.showNotification(("~g~%s~s~\nVous avez payer %s$ pour ~o~%s %s~s~."):format(Config.ShopList[shopName].NotifPrefix or "Shop", finalPrice, ESX.GetItemLabel(item), count))
            TriggerClientEvent("sShops:PaySucess", _source, "item", item)
        else 
            xPlayer.showNotification(("~g~%s~s~\nVous n'avez pas l'argent nécessaire (manque %s$)."):format(Config.ShopList[shopName].NotifPrefix or "Shop", finalPrice-xPlayer.getAccount(account).money))
        end
    else 
        Config.KickOption(_source)
    end
end)

RegisterNetEvent("sShops:PayBasket")
AddEventHandler("sShops:PayBasket", function(shopName, payementType, finalPrice, basket, basketCount)
    local _source = source

    if #(GetEntityCoords(GetPlayerPed(_source)) - Config.ShopList[shopName].Position) < 3 and type(payementType) == "number" and payementType <= 2 then
        local xPlayer = ESX.GetPlayerFromId(_source)
        local account = payementType == 1 and "bank" or "money"

        if xPlayer.getAccount(account).money >= finalPrice then 
            xPlayer.removeAccountMoney(account, finalPrice)
            print(json.encode(basket))
            for k,v in pairs(basket) do 
                xPlayer.addInventoryItem(v.Name, v.Count)
            end
            xPlayer.showNotification(("~g~%s~s~\nVous avez payer %s$ pour ~o~%s article(s)~s~."):format(Config.ShopList[shopName].NotifPrefix or "Shop", finalPrice, basketCount))
            TriggerClientEvent("sShops:PaySucess", _source, "basket", item)
        else 
            xPlayer.showNotification(("~g~%s~s~\nVous n'avez pas l'argent nécessaire (manque %s$)."):format(Config.ShopList[shopName].NotifPrefix or "Shop", finalPrice-xPlayer.getAccount(account).money))
        end
    else 
        Config.KickOption(_source)
    end
end)
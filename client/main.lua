--@author: Slyy#0999
--@Copyright

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.EsxGetter, function(obj) ESX = obj end)
        Wait(1)
    end
end)

Citizen.CreateThread(function()

    for _,v in pairs(Config.ShopList) do 
        local blip = AddBlipForCoord(v.Position)

        SetBlipSprite(blip, v.Blips.Id or 59)
        SetBlipScale(blip, v.Blips.Scale or 0.7)
        SetBlipColour(blip, v.Blips.Color or 37)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.Blips.Name or "Shop")
        EndTextCommandSetBlipName(blip)
    end

    while true do
        local isProche = false
        for k,v in pairs(Config.ShopList) do 
            local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), v.Position)
            if dist < 100 then
                isProche = true
                DrawMarker(v.Marker.Id, v.Position, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.Scale.x, v.Marker.Scale.y, v.Marker.Scale.z, v.Marker.Color.r or 255, v.Marker.Color.g or 255, v.Marker.Color.b or 255, v.Marker.Color.a or 255, v.Marker.Parms.BobUpAndDown or false, v.Marker.Parms.FaceCamera or false, 2, v.Marker.Parms.Rotate or false, nil, v.Marker.Parms.DrawOnEnts or false)
            end
            if dist < 3 then
                ESX.ShowHelpNotification(v.Marker.HelpNotification or "Appuyez sur ~INPUT_CONTEXT~ pour intéragir.")
                if IsControlJustPressed(1, 51) then
                    OpenShopMenu(k)
                end
            end
    
            if isProche then
                Wait(0)
            else
                Wait(500)
            end
        end
	end
end)

function GetNumberArticleOfBasket(basket)
    local count = 0
    for k,v in pairs(basket) do 
        count = count + v.Count
    end
    return count
end

function GetPriceBasket(basket)
    local price = 0
    for k,v in pairs(basket) do 
        price = price + v.FinalPrice
    end
    return price
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function CheckQuantity(number)
    number = tonumber(number)
  
    if type(number) == 'number' then
        number = ESX.Math.Round(number)
        if number > 0 then
            return true, number
        end
    end
  
    return false, number
end

RegisterCommand("pos", function()
    print(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
end, false)
--@author: Slyy#0999
--@Copyright

local QtyList = {}
for i=1, 100 do 
    table.insert(QtyList, i)
end

local basket = {}

function OpenShopMenu(shopName)
    if not shopName then return end
    if not Config.ShopList[shopName] then return end

    local shop = Config.ShopList[shopName]
    local catSelected = nil
    local qtyIndex = {}
    local basketIndex = 1
    local payNowItem = nil
    local payementTypeIndex = 1
    local showPanierContent = false

    local mainMenu = RageUI.CreateMenu(shop.Name, shop.Desc or "Bienvenue")
    local catMenu = RageUI.CreateSubMenu(mainMenu, "Catégorie", "Que désirez-vous ?")
    local basketMenu = RageUI.CreateSubMenu(mainMenu, "Mon panier", "Contenu de votre panier")
    local payNowMenu = RageUI.CreateSubMenu(basketMenu, "Payer maintenant", "Payer individuellement cet article")
    local payMenu = RageUI.CreateSubMenu(basketMenu, "Payer", "Payer le total de votre panier")
    
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))


    while mainMenu and #(GetEntityCoords(PlayerPedId()) - shop.Position) < 3 do
        Wait(0)

        RageUI.IsVisible(mainMenu, function()

            RageUI.Separator("Vous avez ~b~"..GetNumberArticleOfBasket(basket).." article(s) ~s~ dans votre panier.")
            RageUI.Separator("Prix de votre panier : ~b~"..GetPriceBasket(basket).."$")
            RageUI.Button("Voir mon panier", nil, { RightLabel = "→→→" }, true, {}, basketMenu)
            for k,v in pairs(shop.Items) do 
                RageUI.Button(k, nil, { RightLabel = "→→→" }, true, {
                    onSelected = function()
                        catSelected = k
                    end
                }, catMenu)
            end

        end, function()
        end)

        RageUI.IsVisible(basketMenu, function()

            RageUI.Separator("Coût total du panier : ~b~"..GetPriceBasket(basket).."$")
            RageUI.Button("Payer le panier", nil, { RightLabel = "→→→" }, true, {}, payMenu)
            for k,v in pairs(basket) do 
                RageUI.List(v.Label, {
                    {Name = "Supprimer", Value = 1},
                    {Name = "Modifier la quantitée", Value = 2},
                    {Name = "Payer individuellement", Value = 3},
                }, basketIndex, "Quantitée : ~o~"..v.Count.."~s~.\nPrix unitaire : ~o~"..v.Price.."$~s~.\nPrix final : ~o~"..v.FinalPrice.."$~s~.", {}, true, {
                    onListChange = function(Index, Item)
                        basketIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        if basketIndex == 1 then 
                            basket[k] = nil
                            ESX.ShowNotification(("~g~%s~s~\nVous avez supprimer ~o~%s %s~s~ de votre panier."):format(shop.NotifPrefix or "Shop", v.Count, v.Label))
                        elseif basketIndex == 2 then 
                            local result = KeyboardInput("Combien voulez-vous de "..v.Label..". (maximum 100)", "Combien voulez-vous de "..v.Label..". (maximum 100)", '', 10)
                            local isAvailable, number = CheckQuantity(result)
                            if isAvailable then 
                                if number <= 100 then
                                    basket[k].FinalPrice = v.Price*number
                                    basket[k].Count = number
                                    ESX.ShowNotification(("~g~%s~s~\nVous avez changer la quantité de vos/votre ~o~%s~s~ en ~o~%s~s~."):format(shop.NotifPrefix or "Shop", v.Label, number))
                                else 
                                    ESX.ShowNotification(("~r~%s~s~\nVous pouvez prendre que 100 maximum."):format(shop.NotifPrefix or "Shop"))
                                end
                            else
                                ESX.ShowNotification(("~r~%s~s~\nVous avez mal renseignez ce champs."):format(shop.NotifPrefix or "Shop"))
                            end
                        elseif basketIndex == 3 then 
                            Wait(100)
                            payNowItem = v
                            RageUI.Visible(payNowMenu, not RageUI.Visible(payNowMenu))
                        end
                    end
                })
            end

        end, function()
        end)

        RageUI.IsVisible(catMenu, function()
            
            RageUI.Separator("Catégorie ~b~"..catSelected.."~s~ :")
            for k,v in pairs(shop.Items[catSelected]) do 
                local count = qtyIndex[v.Name] or 1
                RageUI.List(v.Label, QtyList, count, "Prix final : ~o~"..v.Price*count.."$~s~.", {}, true, {
                    onListChange = function(Index, Item)
                        qtyIndex[v.Name] = Index;
                    end,
                    onSelected = function(Index, Item)
                        if not basket[v.Name] then 
                            basket[v.Name] = {}
                            basket[v.Name].Label = v.Label
                            basket[v.Name].Name = v.Name
                            basket[v.Name].FinalPrice = v.Price*count
                            basket[v.Name].Price = v.Price
                            basket[v.Name].Count = count
                            ESX.ShowNotification(("~g~%s~s~\nVous avez ajouté(e) à votre panier ~o~%s %s~s~."):format(shop.NotifPrefix or "Shop", count, v.Label))
                        else 
                            if (basket[v.Name].Count + count) <= 100 then
                                basket[v.Name].FinalPrice = basket[v.Name].FinalPrice + v.Price*count
                                basket[v.Name].Count = basket[v.Name].Count + count
                                ESX.ShowNotification(("~g~%s~s~\n~o~%s %s~s~ on été ajouté(es)."):format(shop.NotifPrefix or "Shop", count, v.Label))
                            else 
                                ESX.ShowNotification(("~g~%s~s~\nVous ne pouvez mettre que 100 %s."):format(shop.NotifPrefix or "Shop", v.Label))
                            end
                        end
                    end
                })
            end

        end, function()
        end)

        RageUI.IsVisible(payNowMenu, function()
            
            if payNowItem ~= nil then
                RageUI.Separator("Article ~b~: "..payNowItem.Label)
                RageUI.Separator("Quantitée ~b~: "..payNowItem.Count)
                RageUI.Separator("Prix unitaire ~b~: "..payNowItem.Price.."$")
                RageUI.Separator("Prix final ~b~: "..payNowItem.FinalPrice.."$")
                RageUI.List("Payer par", {
                    {Name = "Carte bancaire", Value = 1},
                    {Name = "Liquide", Value = 2}
                }, payementTypeIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        payementTypeIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("sShops:PayNow", shopName, payementTypeIndex, payNowItem.Name, payNowItem.Count, payNowItem.FinalPrice)   
                    end
                })
            end

        end, function()
        end)

        RageUI.IsVisible(payMenu, function()
        
            RageUI.Separator("Article total ~b~: "..GetNumberArticleOfBasket(basket))
            RageUI.Separator("Prix : ~b~"..GetPriceBasket(basket).."$")

            if not showPanierContent then 
                RageUI.Button("Voir le contenue", nil, { RightLabel = "→→→" }, true, {
                    onSelected = function()
                        showPanierContent = true
                    end
                })
            else 
                RageUI.Button("Maquer le contenue", nil, { RightLabel = "→→→" }, true, {
                    onSelected = function()
                        showPanierContent = false
                    end
                })
                RageUI.Separator("↓ ~o~Contenu du panier~s~ ↓")
                for k,v in pairs(basket) do 
                    RageUI.Button(v.Label, "Quantitée : ~o~"..v.Count.."~s~.\nPrix unitaire : ~o~"..v.Price.."$~s~.\nPrix final : ~o~"..v.FinalPrice.."$~s~.", {}, true, {})
                end
                RageUI.Separator("")
            end
            RageUI.List("Payer par", {
                {Name = "Carte bancaire", Value = 1},
                {Name = "Liquide", Value = 2}
            }, payementTypeIndex, nil, {}, true, {
                onListChange = function(Index, Item)
                    payementTypeIndex = Index;
                end,
                onSelected = function(Index, Item)
                    TriggerServerEvent("sShops:PayBasket", shopName, payementTypeIndex, GetPriceBasket(basket), basket, GetNumberArticleOfBasket(basket))   
                end
            })

        end, function()
        end)

        if not RageUI.Visible(mainMenu) and not RageUI.Visible(catMenu) and not RageUI.Visible(basketMenu) and not RageUI.Visible(payNowMenu) and not RageUI.Visible(payMenu) then
            mainMenu = RMenu:DeleteType('mainMenu', true)
            catMenu = RMenu:DeleteType('catMenu', true)
            basketMenu = RMenu:DeleteType('basketMenu', true)
            payNowMenu = RMenu:DeleteType('payNowMenu', true)
            payMenu = RMenu:DeleteType('payMenu', true)
            basket = {}
        end
    end
end

RegisterNetEvent("sShops:PaySucess")
AddEventHandler("sShops:PaySucess", function(type, item)
    if type == "item" then 
        basket[item] = nil
        RageUI.GoBack()
    elseif type == "basket" then 
        basket = {}
        RageUI.GoBack()
    end
end)
local G = GLOBAL
local threshold = GetModConfigData("Threshold")
local notify = GetModConfigData("Notify")

G.REFILLABLE = {
     molehat = true,
     eyebrellahat = true,
     raincoat = true,
     beefalohat = true,
     walrushat = true,
     deserthat = true,
     featherhat = true,
     beargervest = true,
     reflectivevest = true,
     yellowamulet = true,
     orangeamulet = true,
     eyemaskhat = true,
     shieldofterror = true,
     dreadstonehat = true,
     armordreadstone = true,
     -- 三合一
     bathat = true,
     candlehat = true,
     tarlamp = true,
     double_umbrellahat = true, 
     gasmaskhat = true,
     pithhat = true,
     -- 棱镜
     hat_cowboy = true,
     hat_elepheetle = true,
     armor_elepheetle = true,
     fimbul_axe = true,
     -- 神话
     cassock = true,
     kam_Lan_cassock = true,
}

local function Unequip (inst)
	if inst.replica.equippable:IsEquipped() then
		G.ThePlayer.replica.inventory:ControllerUseItemOnSelfFromInvTile(inst)
	end

	if not inst.replica.equippable:IsEquipped() and inst.unequiptask ~= nil then
		inst.unequiptask:Cancel()
		inst.unequiptask = nil
	end
end

local function AutoUnequip (inst)
     local item = inst.entity:GetParent()
     
     if (not item.replica.inventoryitem:IsHeldBy(G.ThePlayer)) or 
          (not item.replica.equippable:IsEquipped()) or 
          (not G.REFILLABLE[item.prefab]) or 
          (inst.percentused:value() > threshold)
     then return end

     item.unequiptask = item:DoPeriodicTask(0, function () Unequip(item) end)
     Unequip(item)

     if notify and G.ThePlayer.components.talker then
          G.ThePlayer.components.talker:Say(item.name.." is running out!")
	end
end

local function PostInit (inst)
     local item = inst.entity:GetParent()

     if item == nil or item.replica.equippable == nil then return end

     inst:ListenForEvent("percentuseddirty", function () AutoUnequip(inst) end)
end

AddPrefabPostInit('inventoryitem_classified', function (inst)
	if not G.TheNet:IsDedicated() then
		inst:DoTaskInTime(0, function () PostInit(inst) end)
	end
end)
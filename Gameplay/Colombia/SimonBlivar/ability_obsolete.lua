-- =====================================================================================================================================
-- 大哥伦比亚
-- 建立首都随机获得 1 位总指挥（Comandante General）的函数
local ComandanteGeneralClass = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_COMANDANTE_GENERAL"].Index;
local ComandanteGeneralListTag = "INF_ComandanteGeneralList_TAG";
local ComandanteGeneralNumTag = "INF_ComandanteGeneralNum_TAG";
-- 获取总指挥列表
function GetComandanteGeneralList()
	local comandanteGeneralList = {};
	for row in GameInfo.GreatPersonIndividuals() do
		if row.GreatPersonClassType == "GREAT_PERSON_CLASS_COMANDANTE_GENERAL" then
			table.insert(comandanteGeneralList, row.Index);
		end
	end
	return comandanteGeneralList;
end
-- 首都获取一个总指挥
function GetComandanteGeneral(playerId)
    local player = Players[playerId];
	local comandanteGeneralList = player:GetProperty(ComandanteGeneralListTag);
    if comandanteGeneralList == nil then
		-- print("武老秦招募客卿 初始化客卿列表")
		comandanteGeneralList = GetComandanteGeneralList()
	end

    if #comandanteGeneralList < 1 then
		return; 
    else
		-- print("武老秦招募客卿 剩余可招募客卿数量", #keqingList)
		local alreadyNum = player:GetProperty(ComandanteGeneralNumTag) or 0;
		player:SetProperty(ComandanteGeneralNumTag, alreadyNum + 1)
		local randomIndex = Game.GetRandNum(#comandanteGeneralList, "Random Comandante General for Player " .. playerId) + 1
		local era = Game.GetEras():GetCurrentEra();
		Game.GetGreatPeople():GrantPerson(comandanteGeneralList[randomIndex], ComandanteGeneralClass, era, 0, playerId, false);
		table.remove(comandanteGeneralList, randomIndex);
		player:SetProperty(ComandanteGeneralListTag, comandanteGeneralList);
	end
end
-- 创建城市的回调函数
function ColombiaOnCityAdded(playerId, cityId, x, y)
	-- if LeaderHasTrait(playerId, 'TRAIT_LEADER_CAMPANA_ADMIRABLE') then
	-- 	local player = Players[playerId]
	-- 	GetComandanteGeneral(playerId);
	-- end

    GetComandanteGeneral(playerId);
end


--------------------------------------------------------------
-- Initialize
function initialize()
	Events.CityAddedToMap.Add(ColombiaOnCityAdded);
end
Events.LoadGameViewStateDone.Add(initialize);
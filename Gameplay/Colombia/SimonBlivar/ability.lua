-- =====================================================================================================================================
-- 大哥伦比亚：建立首都/城市随机获得 1 位总指挥（Comandante General）
-- =====================================================================================================================================

local ComandanteGeneralClassIndex = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_COMANDANTE_GENERAL"].Index;
local ComandanteGeneralCountTag = "INF_ComandanteGeneralCount_TAG";

-- 动态获取当前所有“未被招募、可用的总指挥”列表
function GetAvailableComandanteGenerals()
    local availableList = {};
    local greatPeople = Game.GetGreatPeople();
    
    if not greatPeople then return availableList; end

    for row in GameInfo.GreatPersonIndividuals() do
        if row.GreatPersonClassType == "GREAT_PERSON_CLASS_COMANDANTE_GENERAL" then
            local individualIndex = row.Index;
            -- 检查该总指挥的状态（0 代表 Available / 可招募）
            local recruitState = greatPeople:GetRecruitState(individualIndex);
            if recruitState == 0 then
                table.insert(availableList, individualIndex);
            end
        end
    end
    
    return availableList;
end

-- 首都/城市获取一个总指挥
function GetComandanteGeneral(playerId)
    local player = Players[playerId];
    if not player then return; end

    -- 实时获取当前还能招募的总指挥池
    local comandanteGeneralList = GetAvailableComandanteGenerals();

    if #comandanteGeneralList < 1 then
        print("[Colombia Mod] 提示：当前池子中已经没有可用的总指挥了！");
        return;
    else
        -- 记录已获得总指挥的数量
        local alreadyNum = player:GetProperty(ComandanteGeneralCountTag) or 0;
        player:SetProperty(ComandanteGeneralCountTag, alreadyNum + 1);

        -- 使用文明6安全的随机数生成方法
        local randomIndex = TerrainBuilder.GetRandomNumber(#comandanteGeneralList, "Random Comandante General") + 1;
        local selectedGeneralIndex = comandanteGeneralList[randomIndex];
        
        local era = Game.GetEras():GetCurrentEra();
        
        -- 强行派发给玩家
        Game.GetGreatPeople():GrantPerson(selectedGeneralIndex, ComandanteGeneralClassIndex, era, 0, playerId, false);
        print("[Colombia Mod] 成功为玩家 " .. tostring(playerId) .. " 随机召唤了一位总指挥！");
    end
end

-- 创建城市的回调函数
function ColombiaOnCityAdded(playerId, cityId, x, y)
    print("[Colombia Mod] 监听到城市建立: PlayerID = " .. tostring(playerId));

    -- 如果你要限定只有西蒙·玻利瓦尔（领袖特性）才触发，可以解开下面这几行的注释：
    -- if LeaderHasTrait(playerId, 'TRAIT_LEADER_CAMPANA_ADMIRABLE') then
    --     GetComandanteGeneral(playerId);
    -- end

    -- 目前测试阶段无条件触发：
    GetComandanteGeneral(playerId);
end

--------------------------------------------------------------
-- Initialize 注册监听
function initialize()
    print("[Colombia Mod] 初始化：成功注册 CityAddedToMap 事件监听器");
    Events.CityAddedToMap.Add(ColombiaOnCityAdded);
end

Events.LoadGameViewStateDone.Add(initialize);
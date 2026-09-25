-- ===========================================================================
-- 阿兹特克 28 种指定奢侈品战力文本 —— 全局 API 拦截注入补丁 (最终方案)
-- ===========================================================================

print("Aztec Combat UI Hook (API Level): Initializing...");

-- 1. 定义修改器净化与聚合的核心逻辑
local function MergeAztecDataInTable(modifierTable)
    if not modifierTable or #modifierTable == 0 then return modifierTable end

    local cleanTable = {};
    local aztecTotalBonus = 0;
    local aztecEntry = nil;
    
    -- 阿兹特克专属的本地化字符串键值与中文匹配关键词
    local aztecTargetTextKey = "LOC_ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY_DESCRIPTION";
    local aztecLocalizedText = Locale.Lookup(aztecTargetTextKey);

    for _, modifier in ipairs(modifierTable) do
        local isAztec = false;
        
        -- 多维度精准扫描：判定是否属于阿兹特克奢侈品带来的 +1
        if modifier.Text then
            if modifier.Text == aztecTargetTextKey or modifier.Text == aztecLocalizedText then
                isAztec = true;
            elseif string.find(modifier.Text, "MONTEZUMA_COMBAT_BONUS_PER_LUXURY") then
                isAztec = true;
            elseif string.find(modifier.Text, "特色奢侈品") or string.find(modifier.Text, "特色奢饰品") then
                isAztec = true;
            end
        end
        
        -- 如果它的修饰符 ID (如果有) 带有阿兹特克 SQL 前缀
        if modifier.ModifierId and string.find(modifier.ModifierId, "MONTEZUMA_LUX_MOD_") then
            isAztec = true;
        end

        if isAztec then
            -- 累计所有的 +1 战斗力
            local val = tonumber(modifier.Value) or tonumber(modifier.ModifierValue) or tonumber(modifier.Amount) or 1;
            aztecTotalBonus = aztecTotalBonus + val;
            
            -- 创建单行融合模板
            if not aztecEntry then
                aztecEntry = {};
                for k, v in pairs(modifier) do
                    aztecEntry[k] = v; -- 深拷贝
                end
            end
        else
            -- 其他国家的正常加成，放行
            table.insert(cleanTable, modifier);
        end
    end

    -- 如果检测到阿兹特克奢侈品加成触发，将合并后的单行塞回列表中
    if aztecTotalBonus > 0 and aztecEntry then
        local finalValueStr = "+" .. tostring(aztecTotalBonus);
        
        -- 对可能被 UI 读取的所有潜在“数值字段”强制赋予合并后的总和
        aztecEntry.Value = finalValueStr;
        aztecEntry.Amount = aztecTotalBonus;
        aztecEntry.ModifierValue = finalValueStr;
        aztecEntry.ModifierValueInt = aztecTotalBonus;
        
        -- 强制还原文本，并防止因为多行剔除导致丢失
        aztecEntry.Text = aztecLocalizedText; 

        table.insert(cleanTable, aztecEntry);
        print("Aztec UI Hook (API): Merged successfully! Total: " .. finalValueStr);
    end

    return cleanTable;
end

-- ===========================================================================
-- 2. API 层劫持注入：直接重写游戏核心战斗预测函数
-- ===========================================================================
if CombatManager and CombatManager.GetCombatPreviewInfo then
    -- 备份游戏原版 C++ 导出的核心 API
    local base_GetCombatPreviewInfo = CombatManager.GetCombatPreviewInfo;
    
    -- 重新定义该全局方法
    CombatManager.GetCombatPreviewInfo = function(attacker, defender)
        -- 1. 运行原版逻辑获取完整的战斗预测大数据包
        local previewInfo = base_GetCombatPreviewInfo(attacker, defender);
        
        -- 2. 健壮性检查，防止在没有战斗时报错
        if previewInfo then
            -- 检查攻击方修饰符列表 (CombatResultParameters.ATTACKER_MODIFIERS 对应攻击方)
            if previewInfo[CombatResultParameters.ATTACKER_MODIFIERS] then
                previewInfo[CombatResultParameters.ATTACKER_MODIFIERS] = MergeAztecDataInTable(previewInfo[CombatResultParameters.ATTACKER_MODIFIERS]);
            end
            
            -- 检查防守方修饰符列表 (CombatResultParameters.DEFENDER_MODIFIERS 对应防守方)
            if previewInfo[CombatResultParameters.DEFENDER_MODIFIERS] then
                previewInfo[CombatResultParameters.DEFENDER_MODIFIERS] = MergeAztecDataInTable(previewInfo[CombatResultParameters.DEFENDER_MODIFIERS]);
            end
        end
        
        -- 3. 返回已经被洗干净、合并成一行的伪造战力包给 UI 渲染器
        return previewInfo;
    end
    -- print("Aztec Combat UI Hook: Global API CombatManager.GetCombatPreviewInfo successfully hooked!");
else
    -- print("Aztec Combat UI Hook Error: Critical API CombatManager.GetCombatPreviewInfo not found!");
end

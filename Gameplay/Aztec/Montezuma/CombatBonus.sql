-- ===========================================================================
-- 阿兹特克 28 种指定奢侈品：专属图标与名称独立行显示补丁
-- ===========================================================================

-- 1. 归零原版旧修改器
UPDATE ModifierArguments 
SET Value = '0' 
WHERE ModifierId = 'MONTEZUMA_COMBAT_BONUS_PER_LUXURY' AND Name = 'Amount';

-- 2. 建立临时表存放 28 种奢侈品
CREATE TEMP TABLE AztecTargetLuxuries (ResourceType TEXT PRIMARY KEY, IconKey TEXT);

INSERT INTO AztecTargetLuxuries (ResourceType, IconKey) VALUES 
('RESOURCE_GYPSUM', 'GYPSUM'), ('RESOURCE_MARBLE', 'MARBLE'), ('RESOURCE_AMBER', 'AMBER'), ('RESOURCE_DIAMONDS', 'DIAMONDS'), 
('RESOURCE_MERCURY', 'MERCURY'), ('RESOURCE_JADE', 'JADE'), ('RESOURCE_SALT', 'SALT'), ('RESOURCE_SILVER', 'SILVER'), 
('RESOURCE_FURS', 'FURS'), ('RESOURCE_IVORY', 'IVORY'), ('RESOURCE_HONEY', 'HONEY'), ('RESOURCE_TRUFFLES', 'TRUFFLES'), 
('RESOURCE_CITRUS', 'CITRUS'), ('RESOURCE_COCOA', 'COCOA'), ('RESOURCE_COFFEE', 'COFFEE'), ('RESOURCE_COTTON', 'COTTON'), 
('RESOURCE_DYES', 'DYES'), ('RESOURCE_INCENSE', 'INCENSE'), ('RESOURCE_OLIVES', 'OLIVES'), ('RESOURCE_SILK', 'SILK'), 
('RESOURCE_SPICES', 'SPICES'), ('RESOURCE_SUGAR', 'SUGAR'), ('RESOURCE_TEA', 'TEA'), ('RESOURCE_TOBACCO', 'TOBACCO'), 
('RESOURCE_WINE', 'WINE'), ('RESOURCE_WHALES', 'WHALES'), ('RESOURCE_PEARLS', 'PEARLS'), ('RESOURCE_TURTLES', 'TURTLES');

-- 3. 针对每种资源生成独立的攻防修改器
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
SELECT 'MONTEZUMA_LUX_ICON_' || ResourceType, 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'REQSET_AZTEC_HAS_' || ResourceType
FROM AztecTargetLuxuries;

-- 4. 设定战力数值为 +1
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT 'MONTEZUMA_LUX_ICON_' || ResourceType, 'Amount', '1'
FROM AztecTargetLuxuries;

-- 5. 【核心联动】让每个修改器的预览文本精准指向其对应的多语言标签
-- 这样 UI 悬浮窗就会把拥有的每一个奢侈品单独列出一行，并带上各自的图标和名字！
INSERT OR IGNORE INTO ModifierStrings (ModifierId, Context, Text)
SELECT 'MONTEZUMA_LUX_ICON_' || ResourceType, 'Preview', 'LOC_MONTEZUMA_LUX_BONUS_' || ResourceType
FROM AztecTargetLuxuries;

-- 6. 创建对应的条件集与拥有资源判定项
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQSET_AZTEC_HAS_' || ResourceType, 'REQUIREMENTSET_TEST_ALL'
FROM AztecTargetLuxuries;

INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_AZTEC_OWN_' || ResourceType, 'REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED'
FROM AztecTargetLuxuries;

INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_AZTEC_OWN_' || ResourceType, 'ResourceType', ResourceType
FROM AztecTargetLuxuries;

INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQSET_AZTEC_HAS_' || ResourceType, 'REQ_AZTEC_OWN_' || ResourceType
FROM AztecTargetLuxuries;

-- 7. 挂载到阿兹特克单位能力上
INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
SELECT 'ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY', 'MONTEZUMA_LUX_ICON_' || ResourceType
FROM AztecTargetLuxuries;

-- 8. 清理临时表
DROP TABLE AztecTargetLuxuries;
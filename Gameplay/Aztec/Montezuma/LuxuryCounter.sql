-- ===========================================================================
-- 阿兹特克 28 种指定奢侈品攻防补丁（纯SQL精准对应、单行合并显示）
-- ===========================================================================

-- 1. 将原版仅限攻击的旧修改器数值归零，防止双重计算冲突
UPDATE ModifierArguments 
SET Value = '0' 
WHERE ModifierId = 'MONTEZUMA_COMBAT_BONUS_PER_LUXURY' AND Name = 'Amount';

-- 2. 创建一个临时表，精准写入你指定的 28 种常规奢侈品英文代码
CREATE TABLE IF NOT EXISTS AztecTargetLuxuries (ResourceType TEXT PRIMARY KEY);

DELETE FROM AztecTargetLuxuries; -- 防止重复加载

INSERT INTO AztecTargetLuxuries (ResourceType) VALUES 
('RESOURCE_GYPSUM'),       -- 石膏
('RESOURCE_MARBLE'),       -- 大理石
('RESOURCE_AMBER'),        -- 琥珀
('RESOURCE_DIAMONDS'),     -- 钻石
('RESOURCE_MERCURY'),      -- 水银
('RESOURCE_JADE'),         -- 玉石
('RESOURCE_SALT'),         -- 盐
('RESOURCE_SILVER'),       -- 白银
('RESOURCE_FURS'),         -- 皮草
('RESOURCE_IVORY'),        -- 象牙
('RESOURCE_HONEY'),        -- 蜂蜜
('RESOURCE_TRUFFLES'),     -- 松露
('RESOURCE_CITRUS'),       -- 柑橘
('RESOURCE_COCOA'),        -- 可可豆
('RESOURCE_COFFEE'),       -- 咖啡
('RESOURCE_COTTON'),       -- 棉花
('RESOURCE_DYES'),         -- 染料
('RESOURCE_INCENSE'),      -- 熏香
('RESOURCE_OLIVES'),       -- 橄榄
('RESOURCE_SILK'),         -- 丝绸
('RESOURCE_SPICES'),       -- 香料
('RESOURCE_SUGAR'),        -- 糖
('RESOURCE_TEA'),          -- 茶叶
('RESOURCE_TOBACCO'),      -- 烟草
('RESOURCE_WINE'),         -- 葡萄酒
('RESOURCE_WHALES'),       -- 鲸鱼
('RESOURCE_PEARLS'),       -- 珍珠
('RESOURCE_TURTLES');      -- 海龟

-- 3. 针对这 28 种资源中的每一种，分别动态生成一个独立的修改器
-- 命名规则如：MONTEZUMA_LUX_MOD_RESOURCE_GYPSUM
INSERT OR IGNORE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
SELECT 'MONTEZUMA_LUX_MOD_' || ResourceType, 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH', 'REQSET_AZTEC_HAS_' || ResourceType
FROM AztecTargetLuxuries;

-- 4. 将每一个专属修改器的战力加成数值设为 +1
INSERT OR IGNORE INTO ModifierArguments (ModifierId, Name, Value)
SELECT 'MONTEZUMA_LUX_MOD_' || ResourceType, 'Amount', '1'
FROM AztecTargetLuxuries;

-- 5. 关键核心：将这 28 个修改器的预览文本全部绑定到原版描述！
-- 这样引擎在渲染 UI 时，会自动把它们触发的所有 +1 融合成“整整一行”展示
INSERT OR IGNORE INTO ModifierStrings (ModifierId, Context, Text)
SELECT 'MONTEZUMA_LUX_MOD_' || ResourceType, 'Preview', 'LOC_ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY_DESCRIPTION'
FROM AztecTargetLuxuries;

-- 6. 为每种资源创建对应的独立条件集（采用玩家拥有该资源判定）
INSERT OR IGNORE INTO RequirementSets (RequirementSetId, RequirementSetType)
SELECT 'REQSET_AZTEC_HAS_' || ResourceType, 'REQUIREMENTSET_TEST_ALL'
FROM AztecTargetLuxuries;

-- 7. 创建具体的拥有资源判定项
INSERT OR IGNORE INTO Requirements (RequirementId, RequirementType)
SELECT 'REQ_AZTEC_OWN_' || ResourceType, 'REQUIREMENT_PLAYER_HAS_RESOURCE_OWNED'
FROM AztecTargetLuxuries;

-- 8. 将判定项参数绑定到对应的 ResourceType
INSERT OR IGNORE INTO RequirementArguments (RequirementId, Name, Value)
SELECT 'REQ_AZTEC_OWN_' || ResourceType, 'ResourceType', ResourceType
FROM AztecTargetLuxuries;

-- 9. 把判定项挂载到对应的条件集上
INSERT OR IGNORE INTO RequirementSetRequirements (RequirementSetId, RequirementId)
SELECT 'REQSET_AZTEC_HAS_' || ResourceType, 'REQ_AZTEC_OWN_' || ResourceType
FROM AztecTargetLuxuries;

-- 10. 将这 28 个专属修改器全部挂载到阿兹特克全军能力上
INSERT OR IGNORE INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
SELECT 'ABILITY_MONTEZUMA_COMBAT_BONUS_PER_LUXURY', 'MONTEZUMA_LUX_MOD_' || ResourceType
FROM AztecTargetLuxuries;

-- 11. 清理临时表，保持数据库干净
DROP TABLE AztecTargetLuxuries;
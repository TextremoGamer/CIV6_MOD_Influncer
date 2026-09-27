-- -- 1. 定义修改器：在首都直接给予2个大将军（总指挥）
-- INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES 
-- ('SIMON_BOLIVAR_START_TWO_GENERALS', 'MODIFIER_PLAYER_GRANT_GREAT_PERSON_CLASS_IN_CAPITAL', 1, 1);

-- -- 2. 设置参数：指定是大将军，数量为 2
-- INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES 
-- ('SIMON_BOLIVAR_START_TWO_GENERALS', 'GreatPersonClassType', 'GREAT_PERSON_CLASS_ADMIRAL'),
-- ('SIMON_BOLIVAR_START_TWO_GENERALS', 'Amount', '2');

-- -- 3. 挂载到西蒙·玻利瓦尔的领袖特性
-- INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES 
-- ('TRAIT_LEADER_CAMPANA_ADMIRABLE', 'SIMON_BOLIVAR_START_TWO_GENERALS');
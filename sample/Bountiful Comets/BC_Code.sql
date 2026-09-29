-- BC_Code
-- Author: Inquistive Otter
-- DateCreated: 10/14/2021 8:59:07 PM
--------------------------------------------------------------
-------------------------------------------------------------
-- Change the frequency of every random event down to zero --
-------------------------------------------------------------
UPDATE RandomEvent_Frequencies 
SET OccurrencesPerGame = 0
WHERE RealismSettingType = 'REALISM_SETTING_APOCALYPSE';


UPDATE RandomEvent_Frequencies 
SET OccurrencesPerGame = 0
WHERE RealismSettingType = 'REALISM_SETTING_MEGADISASTERS';

------------------------------------
-- Update the comet strike values --
------------------------------------
INSERT OR REPLACE INTO RandomEvent_Frequencies
		(RandomEventType,						RealismSettingType,					OccurrencesPerGame)
VALUES	('RANDOM_EVENT_COMET_STRIKE',			'REALISM_SETTING_MEGADISASTERS',	120),
		('RANDOM_EVENT_COMET_STRIKE',			'REALISM_SETTING_APOCALYPSE',		200),
		('RANDOM_EVENT_COMET_STRIKE_TARGETED',	'REALISM_SETTING_MEGADISASTERS',	5),
		('RANDOM_EVENT_COMET_STRIKE_TARGETED',	'REALISM_SETTING_APOCALYPSE',		50);



UPDATE Features
SET Appeal = 3
WHERE FeatureType LIKE '%FEATURE_COMET_LAKE%'
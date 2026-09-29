/*

	Using Modifiers - Chapter 1: Creating and attaching modifiers
	By NycholusV
	
	http://nycholusv.com/civilization-6-modding/using-modifiers/guides/chapter-1

*/

-- Entity-Modifier Tables

INSERT INTO BuildingModifiers
(	BuildingType,				ModifierId									)	VALUES
(	'BUILDING_STAVE_CHURCH', 	'STAVE_CHURCH_GRANT_MISSIONARY'	);

INSERT INTO TraitModifiers
(	TraitType,						ModifierId									)	VALUES
(	'TRAIT_LEADER_PAX_BRITANNICA',	'TRAIT_BOOST_PRODUCTION_NON_HOME_CONTINENT'	);

INSERT INTO GameModifiers
(	ModifierId									)	VALUES
(	'GAME_INCREASED_CULTURE_BORDER_EXPANSION'	);

-- The Modifiers Table

INSERT INTO Modifiers
(	ModifierId,										ModifierType,											RunOnce,	Permanent,	SubjectRequirementSetId							)	VALUES
(	'STAVE_CHURCH_GRANT_MISSIONARY',				'MODIFIER_SINGLE_CITY_GRANT_UNIT_IN_CITY',				'1',		'1',		NULL											),
(	'TRAIT_BOOST_PRODUCTION_NON_HOME_CONTINENT',	'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_MODIFIER',	'0',		'0',		'CITY_NOT_OWNER_CAPITAL_CONTINENT_REQUIREMENTS'	),
(	'GAME_INCREASED_CULTURE_BORDER_EXPANSION',		'MODIFIER_ALL_CITIES_CULTURE_BORDER_EXPANSION',			'0',		'0',		NULL											);

-- Modifier Arguments

INSERT INTO ModifierArguments
(	ModifierId,										Name,			Value				)	VALUES
(	'STAVE_CHURCH_GRANT_MISSIONARY',				'UnitType',		'UNIT_MISSIONARY'	),
(	'STAVE_CHURCH_GRANT_MISSIONARY',				'Amount',		'1'					),
(	'TRAIT_BOOST_PRODUCTION_NON_HOME_CONTINENT',	'YieldType',	'YIELD_PRODUCTION'	),
(	'TRAIT_BOOST_PRODUCTION_NON_HOME_CONTINENT',	'Amount',		'10'				),
(	'GAME_INCREASED_CULTURE_BORDER_EXPANSION',		'Amount',		'50'				);
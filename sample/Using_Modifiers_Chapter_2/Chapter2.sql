/*

	Using Modifiers - Chapter 1: Creating and attaching modifiers
	By NycholusV
	
	http://nycholusv.com/civilization-6-modding/guides/using-modifiers/chapter-1

*/

-- Entity-Modifier Tables

INSERT INTO TraitModifiers
(	TraitType,								ModifierId									)	VALUES
(	'TRAIT_CIVILIZATION_FOUNDING_FATHERS', 'TRAIT_INCREASED_CULTURE_BORDER_EXPANSION'	);

INSERT INTO GreatPersonIndividualActionModifiers
(	GreatPersonIndividualType,				ModifierId,						AttachmentTargetType										)	VALUES
(	'GREAT_PERSON_INDIVIDUAL_MIMAR_SINAN',	'GREATPERSON_CITY_POPULATION',	'GREAT_PERSON_ACTION_ATTACHMENT_TARGET_DISTRICT_IN_TILE'	);

-- The DynamicModifiers Table

INSERT INTO DynamicModifiers
(	ModifierType,										CollectionType,				EffectType										)	VALUES
(	'MODIFIER_PLAYER_CITIES_CULTURE_BORDER_EXPANSION',	'COLLECTION_PLAYER_CITIES',	'EFFECT_ADJUST_CITY_CULTURE_BORDER_EXPANSION'	),
(	'MODIFIER_SINGLE_CITY_ADJUST_POPULATION',			'COLLECTION_OWNER',			'EFFECT_ADJUST_CITY_POPULATION'					);

-- The Types Table

INSERT INTO Types
(	Type,												Kind			)	VALUES
(	'MODIFIER_PLAYER_CITIES_CULTURE_BORDER_EXPANSION',	'KIND_MODIFIER'	),
(	'MODIFIER_SINGLE_CITY_ADJUST_POPULATION',			'KIND_MODIFIER'	);

-- The Modifiers Table

INSERT INTO Modifiers
(	ModifierId,									ModifierType,										RunOnce,	Permanent,	)	VALUES
(	'TRAIT_INCREASED_CULTURE_BORDER_EXPANSION',	'MODIFIER_PLAYER_CITIES_CULTURE_BORDER_EXPANSION',	'0',		'0',		),
(	'GREATPERSON_CITY_POPULATION',				'MODIFIER_SINGLE_CITY_ADJUST_POPULATION',			'1',		'1',		);

-- Modifier Arguments

INSERT INTO ModifierArguments
(	ModifierId,									Name,		Value	)	VALUES
(	'TRAIT_INCREASED_CULTURE_BORDER_EXPANSION',	'Amount',	'20'	),
(	'GREATPERSON_CITY_POPULATION',				'Amount',	'4'		);
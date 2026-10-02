# CIV6 MOD Influencer
文明6风云人物包：增强已有领袖和文明，添加更多文明和领袖。

## Civlizations
* 巴比伦<br>
    游戏初期解锁火药。建立或占领城市获得一个当前最强的近战单位。
* 拜占庭<br>
    游戏初期便解锁“占星术”。天授规矩的战斗力加成从3提升到8。
* 中国<br>
    法家主义（原朝代更替）：<br>
    军队可以捕获非蛮族单位成为工人或杀死单位传播宗教。近战和抗骑兵单位可以归顺蛮族，初始次数为1，获得圣索菲亚大教堂后变为2次，次数耗尽则单位消失。解锁货币后解锁并免费获得1名间谍（并增加1个间谍容量），间谍可以自由选择升级。<br>
城市减少50%生产力、科技值和文化值，尤里卡和鼓舞不再提供科技与市政。游戏初期便解锁“占星术”和“造船术”，解锁“砌砖”科技的同时也解锁“运河”。创建或攻占的城市自动拥有贸易站且自动创建一条通向首都的路（如果位于首都贸易路线范围内）。宫殿拥有6个巨作槽位，雕塑、肖像、风景、宗教巨作、文物、著作、音乐、遗物、英雄遗物（限英雄模式）+2食物。建造奇观或区域时，可以使用建造者推进25%的进度。<br>
* 蒙古<br>
    初期解锁马镫，加成描述改为情报战斗力。
* 印度<br>
    游戏初期便解锁“占星术”。
* 日本<br>
    游戏初期便解锁“占星术”。
* 西班牙<br>
    游戏初期便解锁“占星术”。

## Leaders
* 亚历山大<br>
    攻占城市所有单位恢复全部体力值（不需要占领的城市有奇观）。
* 旃陀罗笈多<br>
    解锁法典市政后可宣布领土扩张战争。
* 蒙特祖玛<br>
    奢饰品提供的战斗力加成在进攻和防守都生效。肉桂、丁香、化妆品、牛仔裤、香水、玩具不提供战斗力加成。
* 吉尔伽美什<br>
    * 英雄模式<br>
        恩奇都奇遇（原恩奇都遗产）：<br>
            可以向正在与其盟友交战的文明宣战，而不获得好战程度。与同一个敌人交战时，如果他们与其盟友位于5个单元格以内，则共享掠夺奖励和战斗经验值。其同盟针对同一个敌人作战可获得同盟点数。与本方及本方盟友的交战方作战时+5战斗力。
* 秦始皇（大一统）<br>
    军功二十等爵位制（原三十六计）：<br>
    获得双倍厌战情绪，发动突袭战争、领土扩张战争、解放战争或被宣战时10回合+2移动力。每种政体具有额外的军事政策槽位，每个军事政策槽位每回合提供+1战斗力和+5外交支持。陆地单位击杀单位时获得战斗力50%的文化值，如果被击杀的是非蛮族单位额外获得战斗力25%的大将军点数。

## Education
### 技能描述
- `Base\Assets\Text\en_US\*` 英文
- `Base\Assets\Text\Vanilla_zh_Hans_CN.xml` 中文
### 天启模式
* `DLC\GranColombia_Maya\Data\GranColombia_Maya_RandomEvents_MODE.xml`
* `DLC\GranColombia_Maya\Data\GranColombia_Maya_RandomEvents_Vikings_MODE.xml`
* `DLC\GranColombia_Maya\Data\GranColombia_Maya_UnitOperations_MODE.xml`
* `DLC\GranColombia_Maya\Data\GranColombia_Maya_UnitPromotions_MODE.xml`
* `DLC\GranColombia_Maya\Data\GranColombia_Maya_Units_MODE.xml`
* `DLC\Expansion2\Data\Expansion2_RandomEvents.xml`: 随机事件类型 & 名字
* `DLC\Expansion2\Data\Expansion2_Civilizations.xml`: 搜索`TRAIT_AVOID_MODERATE_FLOOD`可以免疫天灾

### 代码实例
* 厌战情绪<br>
    亚历山大城市不会产生厌战情绪（DLC\Macedonia_Persia\Data\Macedonia_Persia_GameplayData.xml）
    ```sh
    <Modifiers>
        <Row>
			<ModifierId>TRAIT_TOWORLDSEND_NO_WAR_WEARINESS</ModifierId>
			<ModifierType>MODIFIER_PLAYER_ADJUST_WAR_WEARINESS</ModifierType>
		</Row>
    </Modifiers>
    <ModifierArguments>
        <Row>
			<ModifierId>TRAIT_TOWORLDSEND_NO_WAR_WEARINESS</ModifierId>
			<Name>Amount</Name>
			<Value>-100</Value>
		</Row>
		<Row>
			<ModifierId>TRAIT_TOWORLDSEND_NO_WAR_WEARINESS</ModifierId>
			<Name>Overall</Name>
			<Value>true</Value>
		</Row>
    </ModifierArguments>
    ```
    甘地让敌人获得双倍厌战情绪（Base\Assets\Gameplay\Data\Leaders.xml）
    ```sh
    <Modifiers>
        <Row>
			<ModifierId>TRAIT_INCREASE_ENEMY_WAR_WEARINESS</ModifierId>
			<ModifierType>MODIFIER_PLAYER_ADJUST_WAR_WEARINESS</ModifierType>
		</Row>
    </Modifiers>
    <ModifierArguments>
        <Row>
            <ModifierId>TRAIT_INCREASE_ENEMY_WAR_WEARINESS</ModifierId>
            <Name>Amount</Name>
            <Value>100</Value>
        </Row>
        <Row>
            <ModifierId>TRAIT_INCREASE_ENEMY_WAR_WEARINESS</ModifierId>
            <Name>Enemy</Name>
            <Value>true</Value>
        </Row>
    </ModifierArguments>
    ```
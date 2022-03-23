
global function InitS2SDialogue
global function ShSpS2SCommonInit
global function GetMsgID
global function GetMsgFromID
global const TITAN_VIPER_SCRIPTED_MODEL = $"models/titans/light/titan_northstar_scripted_version.mdl"

global const int SHIPTITLES_NOTRINITY 	= 0
global const int SHIPTITLES_NOBARKER 	= 1
global const int SHIPTITLES_NOMALTA 	= 2
global const int SHIPTITLES_NODRACONIS 	= 3
global const int SHIPTITLES_EVERYTHING 	= 4
global const int SHIPTITLES_NONE 		= 5

global const int SHIPSTREAMING_DEFAULT 	= 0
global const int SHIPSTREAMING_TRINITY 	= 1
global const int SHIPSTREAMING_GIBRALTAR = 2
global const int SHIPSTREAMING_BARKER 	= 3
global const int SHIPSTREAMING_MALTA 	= 4
global const int SHIPSTREAMING_DRACONIS = 5 //always last

global struct StreamingData
{
	entity template
	vector origin
	vector angles
}

struct
{
	table<string,int> _stringToIndex = {}
	table<int,string> _indexToString = {}
	int _currentStringIndex = 0
} file


void function ShSpS2SCommonInit()
{
	SP_S2S_AutoPrecache()

	// Precaching these weapons because they exist in the previous level, so you can carry them to this level
	PrecacheWeapon( "mp_weapon_alternator_smg" )
	PrecacheWeapon( "mp_weapon_arc_launcher" )
	PrecacheWeapon( "mp_weapon_car" )
	PrecacheWeapon( "mp_weapon_frag_grenade" )
	PrecacheWeapon( "mp_weapon_grenade_emp" )
	PrecacheWeapon( "mp_weapon_mgl" )
	PrecacheWeapon( "mp_weapon_rspn101" )
	PrecacheWeapon( "mp_weapon_satchel" )
	PrecacheWeapon( "mp_weapon_shotgun" )
	PrecacheWeapon( "mp_weapon_sniper" )

	PrecacheWeapon( "mp_weapon_dmr" )
	PrecacheWeapon( "mp_weapon_doubletake" )
	PrecacheWeapon( "mp_weapon_lmg" )
	PrecacheWeapon( "mp_weapon_lstar" )
	PrecacheWeapon( "mp_weapon_mastiff" )
	PrecacheWeapon( "mp_weapon_mega_turret_s2s" )
	PrecacheWeapon( "mp_weapon_rocket_launcher" )
	PrecacheWeapon( "mp_weapon_semipistol" )
	PrecacheWeapon( "mp_weapon_smr" )
	PrecacheWeapon( "mp_weapon_r97" ) // stumbleDummy has his own unique weapon?
	PrecacheWeapon( "sp_weapon_swarm_rockets_s2s" )
	PrecacheWeapon( "sp_weapon_ViperBossRockets_s2s" )

	RegisterOnscreenHint( "disembark_hint", "#SEWERS_HINT_DISEMBARK" )
}

void function RegisterMsg( string thestring )
{
	int index = file._currentStringIndex

	file._stringToIndex[thestring] <- index
	file._indexToString[index] <- thestring

	file._currentStringIndex++
}

int function GetMsgID( string thestring )
{
	Assert( thestring in file._stringToIndex, "String \"" + thestring + "\" has not been registered" )

	return file._stringToIndex[thestring]
}

string function GetMsgFromID( int index )
{
	Assert( index in file._indexToString )

	return file._indexToString[index]
}

void function InitS2SDialogue()
{
/************************************************************************************************\

██╗     ███████╗██╗   ██╗███████╗██╗         ███████╗████████╗ █████╗ ██████╗ ████████╗
██║     ██╔════╝██║   ██║██╔════╝██║         ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
██║     █████╗  ██║   ██║█████╗  ██║         ███████╗   ██║   ███████║██████╔╝   ██║
██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║         ╚════██║   ██║   ██╔══██║██╔══██╗   ██║
███████╗███████╗ ╚████╔╝ ███████╗███████╗    ███████║   ██║   ██║  ██║██║  ██║   ██║
╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝

\************************************************************************************************/
	//This is Commander Briggs! We have to recover the Ark! The IMC are taking it to the Fold Weapon on board the Draconis! All ships - Flank speed! We have to hit them hard and fast! Briggs out!
	RegisterRadioDialogue( "diag_sp_intro_STS101_03_01_mcor_sarah", "diag_sp_intro_STS101_03_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//Copy that! 6-4 en route!
	RegisterRadioDialogue( "diag_sp_intro_STS101_07_01_mcor_droz", "diag_sp_intro_STS101_07_01_mcor_droz", PRIORITY_NO_QUEUE, "#NPC_DROZ_NAME", TEAM_MILITIA )
	//Woo! Here we come!
	RegisterRadioDialogue( "diag_sp_intro_STS101_08_01_mcor_davis", "diag_sp_intro_STS101_08_01_mcor_davis", PRIORITY_NO_QUEUE, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//This is Captain Meas of the Campbell. We'll provide a support platform.
	RegisterRadioDialogue( "diag_sp_intro_STS101_04_01_mcor_seyedCptn", "diag_sp_intro_STS101_04_01_mcor_seyedCptn", PRIORITY_NO_QUEUE, "#NPC_CPT_MEAS", TEAM_MILITIA )

	//Enemy squadron in sight!
	RegisterRadioDialogue( "diag_sp_intro_STS101_05_01_mcor_sarah", "diag_sp_intro_STS101_05_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//Lock archers! We got the drop on them!
	RegisterRadioDialogue( "diag_sp_intro_STS101_10_01_mcor_sarah", "diag_sp_intro_STS101_10_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//Ready!
	RegisterRadioDialogue( "diag_sp_intro_STS101_11_01_mcor_sarah", "diag_sp_intro_STS101_11_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//Light 'em up!
	RegisterRadioDialogue( "diag_sp_intro_STS101_13_01_mcor_sarah", "diag_sp_intro_STS101_13_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//Fox 2, Fox 2
	RegisterRadioDialogue( "diag_sp_adds_STS801_09_01_mcor_grunt", "diag_sp_adds_STS801_09_01_mcor_grunt", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB23", TEAM_MILITIA )
	//Missile off the rail
	RegisterRadioDialogue( "diag_sp_adds_STS801_10_01_mcor_grunt", "diag_sp_adds_STS801_10_01_mcor_grunt", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB21", TEAM_MILITIA )
	//Splash 1
	RegisterRadioDialogue( "diag_sp_adds_STS801_11_01_mcor_grunt", "diag_sp_adds_STS801_11_01_mcor_grunt", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB31", TEAM_MILITIA )
	//Splash 2
	RegisterRadioDialogue( "diag_sp_adds_STS801_12_01_mcor_grunt", "diag_sp_adds_STS801_12_01_mcor_grunt", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB32", TEAM_MILITIA )
	//Confirm splash on all trail units
	RegisterRadioDialogue( "diag_sp_adds_STS801_13_01_mcor_grunt", "diag_sp_adds_STS801_13_01_mcor_grunt", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BBAC", TEAM_MILITIA )

/************************************************************************************************\

██╗███╗   ██╗████████╗██████╗  ██████╗
██║████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗
██║██╔██╗ ██║   ██║   ██████╔╝██║   ██║
██║██║╚██╗██║   ██║   ██╔══██╗██║   ██║
██║██║ ╚████║   ██║   ██║  ██║╚██████╔╝
╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝

\************************************************************************************************/
	//Goblin at 10 o'clock high!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_02_01_mcor_radCom", "diag_sp_gibraltar_STS102_02_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB31", TEAM_MILITIA )
	//Got one!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_12_01_mcor_radCom", "diag_sp_gibraltar_STS102_12_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB31", TEAM_MILITIA )
	//Good hit! Good hit!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_03_01_mcor_radCom", "diag_sp_gibraltar_STS102_03_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB24", TEAM_MILITIA )
	//He's coming up on your 9!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_08_01_mcor_radCom", "diag_sp_gibraltar_STS102_08_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BBAC", TEAM_MILITIA )
	//Another one down!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_07_01_mcor_radCom", "diag_sp_gibraltar_STS102_07_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB24", TEAM_MILITIA )


	//Mayday! Mayday! Militia Bandits on our six! Need support!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_13_01_imc_grunt1", "diag_sp_gibraltar_STS102_13_01_imc_grunt1", PRIORITY_NO_QUEUE, "#S2S_CALLSIGB_GL3", TEAM_IMC )
	//Viper is supersonic. (Will) be there in twenty seconds. (ALT - ETA: twenty seconds)
	RegisterRadioDialogue( "diag_sp_viperchat_STS670_01_01_mcor_viper", "diag_sp_viperchat_STS670_01_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )

	//More Goblins! They know we're here, take 'em out!!!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_14_01_mcor_sarah", "diag_sp_gibraltar_STS102_14_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//I lost one in the sun!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_06_01_mcor_radCom", "diag_sp_gibraltar_STS102_06_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB24", TEAM_MILITIA )
	//Blackbird 3-1 you got a bogie on your six!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_04_01_mcor_radCom", "diag_sp_gibraltar_STS102_04_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB24", TEAM_MILITIA )
	//Check your fire!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_09_01_mcor_radCom", "diag_sp_gibraltar_STS102_09_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB31", TEAM_MILITIA )
	//good kill good kill  diag_sp_maltaDrone_STS207_01_01_mcor_droz

/************************************************************************************************\

 ██████╗ ██╗██████╗ ██████╗  █████╗ ██╗  ████████╗ █████╗ ██████╗
██╔════╝ ██║██╔══██╗██╔══██╗██╔══██╗██║  ╚══██╔══╝██╔══██╗██╔══██╗
██║  ███╗██║██████╔╝██████╔╝███████║██║     ██║   ███████║██████╔╝
██║   ██║██║██╔══██╗██╔══██╗██╔══██║██║     ██║   ██╔══██║██╔══██╗
╚██████╔╝██║██████╔╝██║  ██║██║  ██║███████╗██║   ██║  ██║██║  ██║
 ╚═════╝ ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝

\************************************************************************************************/
	//We're coming up on a transport! Just burn past it! We have to catch the Draconis!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS103_01_01_mcor_sarah", "diag_sp_gibraltar_STS103_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//IMC transport ship. Designation: Gibraltar. Defensive armament: minimal.
	RegisterDialogue( "diag_sp_gibraltar_STS104_01_01_mcor_bt", "diag_sp_gibraltar_STS104_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//I got an unidentified <bogey at 11 o'clock>!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS105_01_01_mcor_radCom", "diag_sp_gibraltar_STS105_01_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BBAC", TEAM_MILITIA )
	//What the hell is that thing?!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS105_02_01_mcor_radCom", "diag_sp_gibraltar_STS105_02_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB31", TEAM_MILITIA )

	//Viper coming right. (G-force breaths) Target clear! Swift Eight, go south! Crow at 12 o'clock high. Repeat: 12 o'clock high! (ALT - This is Viper..)
	RegisterRadioDialogue( "diag_sp_viperchat_STS666_01_01_mcor_viper", "diag_sp_viperchat_STS666_01_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )

	//Mayday! Mayday! We're going down we're <going down!!!!>
	RegisterRadioDialogue( "diag_sp_gibraltar_STS105_03_01_mcor_radCom", "diag_sp_gibraltar_STS105_03_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BBAC", TEAM_MILITIA )
	//Break right break right! Blackbird Actual is down! It's on our six! AAAAA<AAAAA!!>
	RegisterRadioDialogue( "diag_sp_gibraltar_STS107_02_01_mcor_radCom", "diag_sp_gibraltar_STS107_02_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB24", TEAM_MILITIA )

	//What the hell is that? Anyone got a clear visual?
	RegisterRadioDialogue( "diag_sp_gibraltar_STS106_01_01_mcor_sarah", "diag_sp_gibraltar_STS106_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//It's too fast, I can't track it I can't track it!!!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS107_01_01_mcor_radCom", "diag_sp_gibraltar_STS107_01_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB31", TEAM_MILITIA )
	//It's a Titan! It's some kind of flying Titan!		tough cool, projected
	RegisterRadioDialogue( "diag_sp_gibraltar_STS107_03_01_mcor_gates", "diag_sp_gibraltar_STS107_03_01_mcor_gates", PRIORITY_NO_QUEUE, "#NPC_GATES_NAME", TEAM_MILITIA )


/************************************************************************************************\

██████╗  ██████╗ ███████╗███████╗    ██╗███╗   ██╗████████╗██████╗  ██████╗
██╔══██╗██╔═══██╗██╔════╝██╔════╝    ██║████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗
██████╔╝██║   ██║███████╗███████╗    ██║██╔██╗ ██║   ██║   ██████╔╝██║   ██║
██╔══██╗██║   ██║╚════██║╚════██║    ██║██║╚██╗██║   ██║   ██╔══██╗██║   ██║
██████╔╝╚██████╔╝███████║███████║    ██║██║ ╚████║   ██║   ██║  ██║╚██████╔╝
╚═════╝  ╚═════╝ ╚══════╝╚══════╝    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝

\************************************************************************************************/
	//Airborne bogey acquired. Analysis: Northstar-class Titan, heavily modified. Engaging.
	RegisterDialogue( "diag_sp_bossIntro_STS108_01_01_mcor_bt", "diag_sp_bossIntro_STS108_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Airborne bogey acquired.
	RegisterDialogue( "diag_sp_bossIntro_STS676_01_01_mcor_bt", "diag_sp_bossIntro_STS676_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Northstar-class Titan
	RegisterDialogue( "diag_sp_bossIntro_STS676_02_01_mcor_bt", "diag_sp_bossIntro_STS676_02_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Heavily modified.
	RegisterDialogue( "diag_sp_bossIntro_STS676_03_01_mcor_bt", "diag_sp_bossIntro_STS676_03_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Pattern split. Positive ID on Vanguard One. Visual clear. I've got good tone
	RegisterRadioDialogue( "diag_sp_bossFight_STS673_01_01_mcor_viper", "diag_sp_bossFight_STS673_01_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )

	//Positive ID on Vanguard One.
	RegisterRadioDialogue( "diag_sp_bossFight_STS678_01_01_mcor_viper", "diag_sp_bossFight_STS678_01_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )

	//Visual clear.
	RegisterRadioDialogue( "diag_sp_viperchat_STS677_03_01_mcor_viper", "diag_sp_viperchat_STS677_03_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )

	//I've got good tone
	RegisterRadioDialogue( "diag_sp_bossFight_STS678_02_01_mcor_viper", "diag_sp_bossFight_STS678_02_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )



/************************************************************************************************\

██╗    ██╗██╗██████╗  ██████╗ ██╗    ██╗    ███████╗ █████╗ ██╗     ██╗
██║    ██║██║██╔══██╗██╔═══██╗██║    ██║    ██╔════╝██╔══██╗██║     ██║
██║ █╗ ██║██║██║  ██║██║   ██║██║ █╗ ██║    █████╗  ███████║██║     ██║
██║███╗██║██║██║  ██║██║   ██║██║███╗██║    ██╔══╝  ██╔══██║██║     ██║
╚███╔███╔╝██║██████╔╝╚██████╔╝╚███╔███╔╝    ██║     ██║  ██║███████╗███████╗
 ╚══╝╚══╝ ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝     ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝

\************************************************************************************************/
	//Cooper!!! BT!!!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS108_02_01_mcor_sarah", "diag_sp_gibraltar_STS108_02_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//I got you, kid!
	RegisterRadioDialogue( "diag_sp_widowFall_STS475_01_01_mcor_barker", "diag_sp_widowFall_STS475_01_01_mcor_barker", PRIORITY_NO_QUEUE, "#NPC_BARKER", TEAM_MILITIA )
	// Brace yourself!
	RegisterRadioDialogue( "diag_sp_widowFall_STS475_02_01_mcor_barker", "diag_sp_widowFall_STS475_02_01_mcor_barker", PRIORITY_NO_QUEUE, "#NPC_BARKER", TEAM_MILITIA )

	//Barker. Nice of you to show up.
	RegisterRadioDialogue( "diag_sp_adds_STS801_02_01_mcor_sarah", "diag_sp_adds_STS801_02_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//You're welcome.
	RegisterRadioDialogue( "diag_sp_widowFall_STS123_13_01_mcor_barker", "diag_sp_widowFall_STS123_13_01_mcor_barker", PRIORITY_NO_QUEUE, "#NPC_BARKER", TEAM_MILITIA )



/************************************************************************************************\

██████╗  █████╗ ██████╗ ██╗  ██╗███████╗██████╗     ███████╗██╗  ██╗██╗██████╗
██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██╔════╝██╔══██╗    ██╔════╝██║  ██║██║██╔══██╗
██████╔╝███████║██████╔╝█████╔╝ █████╗  ██████╔╝    ███████╗███████║██║██████╔╝
██╔══██╗██╔══██║██╔══██╗██╔═██╗ ██╔══╝  ██╔══██╗    ╚════██║██╔══██║██║██╔═══╝
██████╔╝██║  ██║██║  ██║██║  ██╗███████╗██║  ██║    ███████║██║  ██║██║██║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝╚═╝

\************************************************************************************************/
	//Battleship Malta at 10 o'clock, guarding the Draconis! We can't get past it!
	RegisterRadioDialogue( "diag_sp_widowFall_STS130_11_01_mcor_sarah", "diag_sp_widowFall_STS130_11_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//Cooper, I need a Pilot on board the Malta to secure the deck now!
	RegisterRadioDialogue( "diag_sp_barkerShip_STS151_11_01_mcor_sarah", "diag_sp_barkerShip_STS151_11_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//Commander Briggs, this is Blackbird Six-Four - we can get him there. BT - we need a fastball.
	RegisterRadioDialogue( "diag_sp_barkerShip_STS151_12_01_mcor_CrowCptn", "diag_sp_barkerShip_STS151_12_01_mcor_CrowCptn", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Copy that Six-Four.
	RegisterDialogue( "diag_sp_barkerShip_STS151_13_01_mcor_bt", "diag_sp_barkerShip_STS151_13_01_mcor_bt", PRIORITY_NO_QUEUE )
	//You can do this, Pilot.
	RegisterDialogue( "diag_sp_barkerShip_STS151_14_01_mcor_bt", "diag_sp_barkerShip_STS151_14_01_mcor_bt", PRIORITY_NO_QUEUE )
	//Let's do it! Cooper, get ready!
	RegisterRadioDialogue( "diag_sp_barkerShip_STS153_01_01_mcor_sarah", "diag_sp_barkerShip_STS153_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//Climb into my hand, and I will throw you to Blackbird 6-4.
	RegisterDialogue( "diag_sp_barkerShip_STS155_01_01_mcor_bt", "diag_sp_barkerShip_STS155_01_01_mcor_bt", PRIORITY_NO_QUEUE )
	//good luck
	RegisterDialogue( "diag_sp_adds_STS801_15_01_mcor_bt", "diag_sp_adds_STS801_15_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Droz:	 "Welcome to the 6-4, Coop."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS169_01_01_mcor_droz", "diag_sp_barkerShip_STS169_01_01_mcor_droz", PRIORITY_NO_QUEUE, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//Crow Captain:	 "Cooper. Listen up, we can't take you directly to the bridge. We'll never get past those guns. We'll drop you off at the stern, and you'll have to work your way forward."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS176_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS176_01_01_mcor_crowCptn", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Gates:	 Contact Left!
	RegisterRadioDialogue( "diag_sp_barkerShip_STS177_01_01_mcor_gates", "diag_sp_barkerShip_STS177_01_01_mcor_gates", PRIORITY_NO_QUEUE, "#NPC_GATES_NAME", TEAM_MILITIA  )
	//Bear:	 Covering Fire!
	RegisterRadioDialogue( "diag_sp_barkerShip_STS178_01_01_mcor_bear", "diag_sp_barkerShip_STS178_01_01_mcor_bear", PRIORITY_NO_QUEUE, "#NPC_BEAR_NAME", TEAM_MILITIA  )
	//Crow Captain: 	Cooper. I'm going to get as close as I can, without crashing.  Time your jump.
	RegisterRadioDialogue( "diag_sp_barkerShip_STS179_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS179_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Get ready."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS180_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS180_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Now! Go! Go!"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS181_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS181_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Wait wait, I gotta pull away."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS182_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS182_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Hold on."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS183_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS183_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Ok I'm pulling her back in get ready."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS184_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS184_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Okay jump!"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS185_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS185_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Don't jump, we're moving away"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS186_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS186_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Let me get her back into position"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS187_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS187_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"I'm banking towards her again, get ready"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS188_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS188_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Do it! Jump!"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS189_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS189_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Don't! Don't! You missed your window"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS190_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS190_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Just hold on a sec."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS191_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS191_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"I'm moving into position now"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS192_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS192_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Your good! Go! Go!"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS193_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS193_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Stop! I can't hold it, backing off."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS194_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS194_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Ok you got it this time"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS195_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS195_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Closing the gap"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS196_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS196_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Now! Jump!"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS197_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS197_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Don't jump! I gotta pull away."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS198_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS198_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Let me line it up."
	RegisterRadioDialogue( "diag_sp_barkerShip_STS199_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS199_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	//Crow Captain: 	"Okay bringing you back in!"
	RegisterRadioDialogue( "diag_sp_barkerShip_STS200_01_01_mcor_crowCptn", "diag_sp_barkerShip_STS200_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )


/************************************************************************************************\

███╗   ███╗ █████╗ ██╗  ████████╗ █████╗     ██████╗ ██████╗  ██████╗ ███╗   ██╗███████╗
████╗ ████║██╔══██╗██║  ╚══██╔══╝██╔══██╗    ██╔══██╗██╔══██╗██╔═══██╗████╗  ██║██╔════╝
██╔████╔██║███████║██║     ██║   ███████║    ██║  ██║██████╔╝██║   ██║██╔██╗ ██║█████╗
██║╚██╔╝██║██╔══██║██║     ██║   ██╔══██║    ██║  ██║██╔══██╗██║   ██║██║╚██╗██║██╔══╝
██║ ╚═╝ ██║██║  ██║███████╗██║   ██║  ██║    ██████╔╝██║  ██║╚██████╔╝██║ ╚████║███████╗
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

\************************************************************************************************/
	//"Nice jump!"
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS204_01_01_mcor_davis", "diag_sp_maltaDrone_STS204_01_01_mcor_davis", PRIORITY_NORMAL, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"We'll cover you from out here, Coop!"
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS205_01_01_mcor_droz", "diag_sp_maltaDrone_STS205_01_01_mcor_droz", PRIORITY_NORMAL, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"You got a guy underneath the stairs!"
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS206_01_01_mcor_davis", "diag_sp_maltaDrone_STS206_01_01_mcor_davis", PRIORITY_NORMAL, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"Good kill! Good kill
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS207_01_01_mcor_droz", "diag_sp_maltaDrone_STS207_01_01_mcor_droz", PRIORITY_NORMAL, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"They're around the corner! Watch your left side!"
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS208_01_01_mcor_gates", "diag_sp_maltaDrone_STS208_01_01_mcor_gates", PRIORITY_NORMAL, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"Shit! Did he just jump in here!?"
	RegisterDialogue( "diag_sp_maltaDrone_STS209_01_01_imc_grunt2", "diag_sp_maltaDrone_STS209_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"Bridge, I got an enemy titan pilot inside Drone Bay 5, I need security down here, now!"
	RegisterDialogue( "diag_sp_maltaDrone_STS210_01_01_imc_grunt1", "diag_sp_maltaDrone_STS210_01_01_imc_grunt1", PRIORITY_NO_QUEUE )

	//"Take out the crow! Take out the crow!"
	RegisterDialogue( "diag_sp_maltaDrone_STS213_01_01_imc_grunt2", "diag_sp_maltaDrone_STS213_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"Get to the spectre racks!"
	RegisterDialogue( "diag_sp_maltaDrone_STS214_01_01_imc_grunt2", "diag_sp_maltaDrone_STS214_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"I'm Going! Cover me!"
	RegisterDialogue( "diag_sp_maltaDrone_STS215_01_01_imc_grunt3", "diag_sp_maltaDrone_STS215_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Powering up the spectres now!"
	RegisterDialogue( "diag_sp_maltaDrone_STS216_01_01_imc_grunt2", "diag_sp_maltaDrone_STS216_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"Spectres online!"
	RegisterDialogue( "diag_sp_maltaDrone_STS217_01_01_imc_grunt3", "diag_sp_maltaDrone_STS217_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Take cover behind the spectres!"
	RegisterDialogue( "diag_sp_maltaDrone_STS218_01_01_imc_grunt2", "diag_sp_maltaDrone_STS218_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"How do you like these spectres you son of a bitch!"
	RegisterDialogue( "diag_sp_maltaDrone_STS219_01_01_imc_grunt3", "diag_sp_maltaDrone_STS219_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Power up the Stalkers!"
	RegisterDialogue( "diag_sp_maltaDrone_STS220_01_01_imc_grunt2", "diag_sp_maltaDrone_STS220_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"I'm on it!"
	RegisterDialogue( "diag_sp_maltaDrone_STS221_01_01_imc_grunt3", "diag_sp_maltaDrone_STS221_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Booting the Stalkers up now!"
	RegisterDialogue( "diag_sp_maltaDrone_STS222_01_01_imc_grunt3", "diag_sp_maltaDrone_STS222_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Stalkers up! Get behind them!"
	RegisterDialogue( "diag_sp_maltaDrone_STS223_01_01_imc_grunt3", "diag_sp_maltaDrone_STS223_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Get those Stalkers online!"
	RegisterDialogue( "diag_sp_maltaDrone_STS224_01_01_imc_grunt2", "diag_sp_maltaDrone_STS224_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"Copy that. Moving to Stalker Racks!"
	RegisterDialogue( "diag_sp_maltaDrone_STS225_01_01_imc_grunt1", "diag_sp_maltaDrone_STS225_01_01_imc_grunt1", PRIORITY_NO_QUEUE )

	//"Turning on the Stalker Racks! Cover me!"
	RegisterDialogue( "diag_sp_maltaDrone_STS226_01_01_imc_grunt1", "diag_sp_maltaDrone_STS226_01_01_imc_grunt1", PRIORITY_NO_QUEUE )

	//"Stalkers online!"
	RegisterDialogue( "diag_sp_maltaDrone_STS227_01_01_imc_grunt1", "diag_sp_maltaDrone_STS227_01_01_imc_grunt1", PRIORITY_NO_QUEUE )

	//"We need stalker support now!"
	RegisterDialogue( "diag_sp_maltaDrone_STS228_01_01_imc_grunt3", "diag_sp_maltaDrone_STS228_01_01_imc_grunt3", PRIORITY_NO_QUEUE )

	//"Moving! Cover my six!"
	RegisterDialogue( "diag_sp_maltaDrone_STS229_01_01_imc_grunt2", "diag_sp_maltaDrone_STS229_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"Powering up the Stalker racks!"
	RegisterDialogue( "diag_sp_maltaDrone_STS230_01_01_imc_grunt2", "diag_sp_maltaDrone_STS230_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"Stalkers engaged!"
	RegisterDialogue( "diag_sp_maltaDrone_STS231_01_01_imc_grunt2", "diag_sp_maltaDrone_STS231_01_01_imc_grunt2", PRIORITY_NO_QUEUE )

	//"This is Sec 4, engaging the hostile."
	RegisterDialogue( "diag_sp_maltaDrone_STS232_01_01_imc_grunt1", "diag_sp_maltaDrone_STS232_01_01_imc_grunt1", PRIORITY_NO_QUEUE )

	//"The room's clear!"
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS234_01_01_mcor_gates", "diag_sp_maltaDrone_STS234_01_01_mcor_gates", PRIORITY_NO_QUEUE, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"The room's clear!" - hangar
	RegisterDialogue( "diag_sp_maltaDrone_STS234_01_01_mcor_gates_hangar", "diag_sp_maltaDrone_STS234_01_01_mcor_gates", PRIORITY_NO_QUEUE )

	//Pilot, use the cargo lift.
	RegisterRadioDialogue( "diag_sp_maltaDrone_STS235_01a_01_mcor_bt", "diag_sp_maltaDrone_STS235_01a_01_mcor_bt", PRIORITY_LOWEST, "#NPC_BT_NAME", TEAM_MILITIA )


/************************************************************************************************\

███╗   ███╗ █████╗ ██╗  ████████╗ █████╗      ██████╗ ██╗   ██╗███╗   ██╗███████╗
████╗ ████║██╔══██╗██║  ╚══██╔══╝██╔══██╗    ██╔════╝ ██║   ██║████╗  ██║██╔════╝
██╔████╔██║███████║██║     ██║   ███████║    ██║  ███╗██║   ██║██╔██╗ ██║███████╗
██║╚██╔╝██║██╔══██║██║     ██║   ██╔══██║    ██║   ██║██║   ██║██║╚██╗██║╚════██║
██║ ╚═╝ ██║██║  ██║███████╗██║   ██║  ██║    ╚██████╔╝╚██████╔╝██║ ╚████║███████║
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝     ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝

\************************************************************************************************/

	//"Sarah, this the campbell. Between the Malta's guns and that flying Titan, we're getting torn up here!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS236_01_01_mcor_seyedCptn", "diag_sp_maltaGuns_STS236_01_01_mcor_seyedCptn", PRIORITY_HIGH, "#NPC_CPT_MEAS", TEAM_MILITIA )

	//"We're working on it - just hang on. Cooper's en route to the Malta's main gun battery."
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS237_01_01_mcor_sarah", "diag_sp_maltaGuns_STS237_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//"I don't know if that's going to be enough."
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS238_01_01_mcor_seyedCptn", "diag_sp_maltaGuns_STS238_01_01_mcor_seyedCptn", PRIORITY_NO_QUEUE, "#NPC_CPT_MEAS", TEAM_MILITIA )

	//"Cooper hurry!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS239_01_01_mcor_sarah", "diag_sp_maltaGuns_STS239_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//"The jump drive is ruptured! abandon ship! aba..."
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS240_01_01_mcor_seyedCptn", "diag_sp_maltaGuns_STS240_01_01_mcor_seyedCptn", PRIORITY_LOWEST, "#NPC_CPT_MEAS", TEAM_MILITIA )

	//We lost the Braxton! Stay the course!!
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS241_01a_01_mcor_sarah", "diag_sp_maltaGuns_STS241_01a_01_mcor_sarah", PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//"Cooper, we can't move up while those guns are firing. Take out the gunner and we'll help you with the last t
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS242_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS242_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	//"Contact!"
	RegisterDialogue( "diag_sp_maltaGuns_STS243_01_01_imc_grunt1", "diag_sp_maltaGuns_STS243_01_01_imc_grunt1", PRIORITY_LOWEST )

	//"Hostile on the Gun platform!"
	RegisterDialogue( "diag_sp_maltaGuns_STS244_01_01_imc_grunt2", "diag_sp_maltaGuns_STS244_01_01_imc_grunt2", PRIORITY_LOWEST )

	//"We're taking fire! Take cover!"
	RegisterDialogue( "diag_sp_maltaGuns_STS245_01_01_imc_grunt3", "diag_sp_maltaGuns_STS245_01_01_imc_grunt3", PRIORITY_LOWEST )

	//"Gun 1 is down!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS246_01_01_mcor_davis", "diag_sp_maltaGuns_STS246_01_01_mcor_davis", PRIORITY_LOWEST, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"Moving into position
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS247_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS247_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	//"I can't get a clear shot!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS248_01_01_mcor_gates", "diag_sp_maltaGuns_STS248_01_01_mcor_gates", PRIORITY_LOWEST, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"They're running for the stalker racks! Stop em!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS249_01_01_mcor_droz", "diag_sp_maltaGuns_STS249_01_01_mcor_droz", PRIORITY_NORMAL, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"Tango down!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS250_01_01_mcor_davis", "diag_sp_maltaGuns_STS250_01_01_mcor_davis", PRIORITY_LOWEST, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"Gun one is clear, keep going!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS251_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS251_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	//"Just wallrun across the gap
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS252_01_01_mcor_gates", "diag_sp_maltaGuns_STS252_01_01_mcor_gates", PRIORITY_LOWEST, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"Gun 2 is down!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS253_01_01_mcor_droz", "diag_sp_maltaGuns_STS253_01_01_mcor_droz", PRIORITY_LOWEST, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"Moving up, hang on
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS254_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS254_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	//"I got a visual!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS255_01_01_mcor_davis", "diag_sp_maltaGuns_STS255_01_01_mcor_davis", PRIORITY_LOWEST, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"Got one!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS256_01_01_mcor_droz", "diag_sp_maltaGuns_STS256_01_01_mcor_droz", PRIORITY_LOWEST, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"Look out they got stalkers on you!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS257_01_01_mcor_gates", "diag_sp_maltaGuns_STS257_01_01_mcor_gates", PRIORITY_LOWEST, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"Man those things are tough!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS258_01_01_mcor_davis", "diag_sp_maltaGuns_STS258_01_01_mcor_davis", PRIORITY_LOWEST, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"Gun two is down, Get the last one!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS259_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS259_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	//"We got you covered!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS260_01_01_mcor_droz", "diag_sp_maltaGuns_STS260_01_01_mcor_droz", PRIORITY_LOWEST, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"Gun 3 is down!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS261_01_01_mcor_gates", "diag_sp_maltaGuns_STS261_01_01_mcor_gates", PRIORITY_LOWEST, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"That's it clean em up!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS262_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS262_01_01_mcor_crowCptn", PRIORITY_LOWEST, "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	//"He's going for the racks!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS263_01_01_mcor_davis", "diag_sp_maltaGuns_STS263_01_01_mcor_davis", PRIORITY_NORMAL, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//"Good kill!"
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS264_01_01_mcor_droz", "diag_sp_maltaGuns_STS264_01_01_mcor_droz", PRIORITY_LOWEST, "#NPC_DROZ_NAME", TEAM_MILITIA )

	//"I got no hostiles in s
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS265_01_01_mcor_gates", "diag_sp_maltaGuns_STS265_01_01_mcor_gates", PRIORITY_HIGH, "#NPC_GATES_NAME", TEAM_MILITIA )

	//"I think that's all of them
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS266_01_01_mcor_davis", "diag_sp_maltaGuns_STS266_01_01_mcor_davis", PRIORITY_HIGH, "#NPC_DAVIS_NAME", TEAM_MILITIA )

	//Well done pilot
	RegisterDialogue( "diag_sp_maltaGuns_STS267_01_01_mcor_bt", "diag_sp_maltaGuns_STS267_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//"Can't believe we pulled that off."
	RegisterDialogue( "diag_sp_maltaGuns_STS268_01_01_mcor_player", "diag_sp_maltaGuns_STS268_01_01_mcor_player", PRIORITY_NO_QUEUE )

	//"The mission is not over, yet."
	RegisterDialogue( "diag_sp_maltaGuns_STS269_01_01_mcor_bt", "diag_sp_maltaGuns_STS269_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//"Is it ever?"	( playful )
	RegisterDialogue( "diag_sp_maltaGuns_STS270_01_01_mcor_player", "diag_sp_maltaGuns_STS270_01_01_mcor_player", PRIORITY_NO_QUEUE )

	//Alright BT, let's link up and take the b
	RegisterDialogue( "diag_sp_maltaGuns_STS271_01_01_mcor_player", "diag_sp_maltaGuns_STS271_01_01_mcor_player", PRIORITY_NO_QUEUE )

	//Negative... 	( feeds directly into mission critical VO below )
	RegisterDialogue( "diag_sp_maltaGuns_STS272_01_01_mcor_bt", "diag_sp_maltaGuns_STS272_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//"There are still ion cannons active on the deck of the malta. They must be disabled from the bridge before we can approach."
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS273_01_01_mcor_bt", "diag_sp_maltaGuns_STS273_01_01_mcor_bt", PRIORITY_NO_QUEUE, "#NPC_BT_NAME", TEAM_MILITIA )

	//"We're on it
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS274_02_01_mcor_bear", "diag_sp_maltaGuns_STS274_02_01_mcor_bear", PRIORITY_NO_QUEUE, "#NPC_BEAR_NAME", TEAM_MILITIA )

	//"And he speaks! What's up Sarge?"
	RegisterDialogue( "diag_sp_maltaGuns_STS275_01_01_mcor_droz", "diag_sp_maltaGuns_STS275_01_01_mcor_droz", PRIORITY_NO_QUEUE )

	//"Helmsman, Get us in zipline range
	RegisterDialogue( "diag_sp_maltaGuns_STS276_01_01_mcor_bear", "diag_sp_maltaGuns_STS276_01_01_mcor_bear", PRIORITY_NO_QUEUE )

	//"Copy that big guy, moving 6-4 into position."
	RegisterDialogue( "diag_sp_maltaGuns_STS277_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS277_01_01_mcor_crowCptn", PRIORITY_NO_QUEUE )

	//"Commander Briggs, we'll also need your help."
	RegisterDialogue( "diag_sp_maltaGuns_STS278_01_01_mcor_bear", "diag_sp_maltaGuns_STS278_01_01_mcor_bear", PRIORITY_NO_QUEUE )

	//"Copy that, Bear. On my way."
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS279_01_01_mcor_sarah", "diag_sp_maltaGuns_STS279_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//"Launching Ziplines!"
	RegisterDialogue( "diag_sp_maltaGuns_STS280_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS280_01_01_mcor_crowCptn", PRIORITY_NO_QUEUE )

	//Cooper, stand by. The 6-4 are coming aboard.
	RegisterRadioDialogue( "diag_sp_maltaGuns_STS274_03_01_mcor_sarah", "diag_sp_maltaGuns_STS274_03_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//"Crew you've got a green light, go go go!"
	RegisterDialogue( "diag_sp_maltaGuns_STS281_01_01_mcor_crowCptn", "diag_sp_maltaGuns_STS281_01_01_mcor_crowCptn", PRIORITY_NO_QUEUE )

	//"Hey Coop, good shit!"
	RegisterDialogue( "diag_sp_maltaGuns_STS282_01_01_mcor_davis", "diag_sp_maltaGuns_STS282_01_01_mcor_davis", PRIORITY_NO_QUEUE )

	//nice work, coop
	RegisterRadioDialogue( "NiceWorkCoop", "diag_sp_maltaGuns_STS282_01a_01_mcor_davis", PRIORITY_NO_QUEUE, "#S2S_CALLSIGB_ALAVI", TEAM_MILITIA )
	//nice work, coop
	RegisterDialogue( "diag_sp_maltaGuns_STS282_01a_01_mcor_davis", "diag_sp_maltaGuns_STS282_01a_01_mcor_davis", PRIORITY_NO_QUEUE )

	//Good covering fire
	RegisterDialogue( "diag_sp_maltaGuns_STS283_01_01_mcor_player", "diag_sp_maltaGuns_STS283_01_01_mcor_player", PRIORITY_NO_QUEUE )

	//"We got your back."
	RegisterDialogue( "diag_sp_maltaGuns_STS284_01_01_mcor_davis", "diag_sp_maltaGuns_STS284_01_01_mcor_davis", PRIORITY_NO_QUEUE )

	//"Thanks"
	RegisterDialogue( "diag_sp_maltaGuns_STS285_01_01_mcor_player", "diag_sp_maltaGuns_STS285_01_01_mcor_player", PRIORITY_NO_QUEUE )

	//"Yeah let's kick some ass!"
	RegisterDialogue( "diag_sp_maltaGuns_STS286_01_01_mcor_droz", "diag_sp_maltaGuns_STS286_01_01_mcor_droz", PRIORITY_NO_QUEUE )

	//"The bridge is through that hangar over there, any ideas?"
	RegisterDialogue( "diag_sp_maltaGuns_STS285_01a_01_mcor_gates", "diag_sp_maltaGuns_STS285_01a_01_mcor_gates", PRIORITY_NO_QUEUE )

	//"Briggs here, what do you need me to do?"
	RegisterDialogue( "diag_sp_maltaGuns_STS288_01_01_mcor_sarah", "diag_sp_maltaGuns_STS288_01_01_mcor_sarah", PRIORITY_NO_QUEUE )

	//"Close the door and keep her steady."
	RegisterDialogue( "diag_sp_maltaGuns_STS289_01_01_mcor_bear", "diag_sp_maltaGuns_STS289_01_01_mcor_bear", PRIORITY_NO_QUEUE )

	//"He's not thinking… no, no…  wait a sec."
	RegisterDialogue( "diag_sp_maltaGuns_STS290_01_01_mcor_davis", "diag_sp_maltaGuns_STS290_01_01_mcor_davis", PRIORITY_NO_QUEUE )

	//"Oh yeah!"
	RegisterDialogue( "diag_sp_maltaGuns_STS291_01_01_mcor_droz", "diag_sp_maltaGuns_STS291_01_01_mcor_droz", PRIORITY_NO_QUEUE )

	//"Follow me"
	RegisterDialogue( "diag_sp_maltaGuns_STS292_01_01_mcor_bear", "diag_sp_maltaGuns_STS292_01_01_mcor_bear", PRIORITY_NO_QUEUE )

	//"I love this job."
	RegisterDialogue( "diag_sp_maltaGuns_STS293_01_01_mcor_droz", "diag_sp_maltaGuns_STS293_01_01_mcor_droz", PRIORITY_NO_QUEUE )

	//"Well it's never boring" ( playful )
	RegisterDialogue( "diag_sp_maltaGuns_STS294_01_01_mcor_davis", "diag_sp_maltaGuns_STS294_01_01_mcor_davis", PRIORITY_NO_QUEUE )

	//"Just move your ass, Davis."	( all business )
	RegisterDialogue( "diag_sp_maltaGuns_STS296_01_01_mcor_gates", "diag_sp_maltaGuns_STS296_01_01_mcor_gates", PRIORITY_NO_QUEUE )

	//Good luck pilot
	RegisterDialogue( "diag_sp_maltaGuns_STS297_01_01_mcor_bt", "diag_sp_maltaGuns_STS297_01_01_mcor_bt", PRIORITY_NO_QUEUE )


/************************************************************************************************\

███╗   ███╗ █████╗ ██╗  ████████╗ █████╗     ██╗  ██╗ █████╗ ███╗   ██╗ ██████╗  █████╗ ██████╗
████╗ ████║██╔══██╗██║  ╚══██╔══╝██╔══██╗    ██║  ██║██╔══██╗████╗  ██║██╔════╝ ██╔══██╗██╔══██╗
██╔████╔██║███████║██║     ██║   ███████║    ███████║███████║██╔██╗ ██║██║  ███╗███████║██████╔╝
██║╚██╔╝██║██╔══██║██║     ██║   ██╔══██║    ██╔══██║██╔══██║██║╚██╗██║██║   ██║██╔══██║██╔══██╗
██║ ╚═╝ ██║██║  ██║███████╗██║   ██║  ██║    ██║  ██║██║  ██║██║ ╚████║╚██████╔╝██║  ██║██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

\************************************************************************************************/

	//Goblin BRAVO - six, prepare for boarding, preflight check list.
	RegisterDialogue( "diag_sp_maltaHangar_STS298a_01_01_imc_command", "diag_sp_maltaHangar_STS298a_01_01_imc_command", PRIORITY_LOWEST )
	//Squad Altpha 2 Charlie, sending the lift down now
	RegisterDialogue( "diag_sp_maltaHangar_STS298a_02_01_imc_command", "diag_sp_maltaHangar_STS298a_02_01_imc_command", PRIORITY_LOWEST )
	//"Code Red. IMC forces engaged in combat on the hangar level.  All security forces, converge on the hangar level. Repeat, Code Red. All security forces, converge on the hangar level."
	RegisterDialogue( "diag_sp_maltaHangar_STS298_01_01_imc_command", "diag_sp_maltaHangar_STS298_01_01_imc_command", PRIORITY_NO_QUEUE )
	//We got the drop on them...6-4, we know what to do.
	RegisterDialogue( "diag_sp_maltaGuns_STS296_02_01_mcor_gates", "diag_sp_maltaGuns_STS296_02_01_mcor_gates", PRIORITY_NO_QUEUE )

	//They're behind us!
	RegisterDialogue( "diag_sp_maltaHangar_STS298a_08_01_imc_grunt2", "diag_sp_maltaHangar_STS298a_08_01_imc_grunt2", PRIORITY_NO_QUEUE )
	//Watch it! Watch it! That's the 6-4!
	RegisterDialogue( "diag_sp_maltaBreach_STS457_01_01_imc_bridgeGrunt1", "diag_sp_maltaBreach_STS457_01_01_imc_bridgeGrunt1", PRIORITY_NO_QUEUE )

	//Get to cover!
	RegisterDialogue( "diag_sp_maltaHangar_STS303_01a_02_mcor_droz", "diag_sp_maltaHangar_STS303_01a_02_mcor_droz", PRIORITY_NO_QUEUE )

	//"That's the bridge up there."
	RegisterDialogue( "diag_sp_maltaHangar_STS301_01_01_mcor_gates", "diag_sp_maltaHangar_STS301_01_01_mcor_gates", PRIORITY_NO_QUEUE )

	//"Come on, Coop. Keep up"
	RegisterDialogue( "diag_sp_maltaHangar_STS307_01_01_mcor_droz", "diag_sp_maltaHangar_STS307_01_01_mcor_droz", PRIORITY_NO_QUEUE )



/************************************************************************************************\

███╗   ███╗ █████╗ ██╗  ████████╗ █████╗     ██████╗ ██████╗ ██╗██████╗  ██████╗ ███████╗
████╗ ████║██╔══██╗██║  ╚══██╔══╝██╔══██╗    ██╔══██╗██╔══██╗██║██╔══██╗██╔════╝ ██╔════╝
██╔████╔██║███████║██║     ██║   ███████║    ██████╔╝██████╔╝██║██║  ██║██║  ███╗█████╗
██║╚██╔╝██║██╔══██║██║     ██║   ██╔══██║    ██╔══██╗██╔══██╗██║██║  ██║██║   ██║██╔══╝
██║ ╚═╝ ██║██║  ██║███████╗██║   ██║  ██║    ██████╔╝██║  ██║██║██████╔╝╚██████╔╝███████╗
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝  ╚═════╝ ╚══════╝

\************************************************************************************************/

	//"Hold your fire, It's bulletproof. We're going to breach the glass, take your marks."
	RegisterDialogue( "diag_sp_maltaBridge_STS308_01_01_mcor_bear", "diag_sp_maltaBridge_STS308_01_01_mcor_bear", PRIORITY_NO_QUEUE )
	//Shaped charges are ready.
	RegisterDialogue( "diag_sp_adds_STS801_06_01_mcor_gates", "diag_sp_adds_STS801_06_01_mcor_gates", PRIORITY_NO_QUEUE )
	//"Tango on the mezzanine"
	RegisterDialogue( "diag_sp_maltaBridge_STS310_01_01_mcor_droz", "diag_sp_maltaBridge_STS310_01_01_mcor_droz", PRIORITY_NO_QUEUE )
	//"The guy by the stairs"
	RegisterDialogue( "diag_sp_maltaBridge_STS311_01_01_mcor_davis", "diag_sp_maltaBridge_STS311_01_01_mcor_davis", PRIORITY_NO_QUEUE )
	//"Hey Coop, watch how the 6-4 does it."
	RegisterDialogue( "diag_sp_maltaBridge_STS312_01_01_mcor_davis", "diag_sp_maltaBridge_STS312_01_01_mcor_davis", PRIORITY_NO_QUEUE )



	//Ready or not...
	RegisterDialogue( "diag_sp_maltaBridge_STS319_01a_01_mcor_bear", "diag_sp_maltaBridge_STS319_01a_01_mcor_bear", PRIORITY_NO_QUEUE )
	//"Breaching! Breaching! Breaching!"
	RegisterDialogue( "diag_sp_maltaBridge_STS320_01_01_mcor_bear", "diag_sp_maltaBridge_STS320_01_01_mcor_bear", PRIORITY_NO_QUEUE )
	//"Clear?!"
	RegisterDialogue( "diag_sp_maltaBridge_STS321_01_01_mcor_droz", "diag_sp_maltaBridge_STS321_01_01_mcor_droz", PRIORITY_NO_QUEUE )
	//"Clear!"
	RegisterDialogue( "diag_sp_maltaBridge_STS322_01_01_mcor_gates", "diag_sp_maltaBridge_STS322_01_01_mcor_gates", PRIORITY_NO_QUEUE )
	//"That's how it's done!"
	RegisterDialogue( "diag_sp_maltaBridge_STS323_01_01_mcor_davis", "diag_sp_maltaBridge_STS323_01_01_mcor_davis", PRIORITY_NO_QUEUE )

	//6-4 on me. Cooper, get to the Captain's console and disable the guns.
	RegisterDialogue( "diag_sp_maltaBridge_STS327_01a_01_mcor_bear", "diag_sp_maltaBridge_STS327_01a_01_mcor_bear", PRIORITY_NO_QUEUE )

	//"Coop, the console's up here.
	RegisterDialogue( "diag_sp_maltaBridge_STS328_01a_01_mcor_droz", "diag_sp_maltaBridge_STS328_01a_01_mcor_droz", PRIORITY_NO_QUEUE )
	//"The console's over here, coop."
	RegisterDialogue( "diag_sp_maltaBridge_STS334_01_01_mcor_davis", "diag_sp_maltaBridge_STS334_01_01_mcor_davis", PRIORITY_NO_QUEUE )

	//Cooper, bypass that console! Kill the guns.
	RegisterDialogue( "diag_sp_maltaBridge_STS337_01_01_mcor_bear", "diag_sp_maltaBridge_STS337_01_01_mcor_bear", PRIORITY_NO_QUEUE )

	//"Commander Briggs, the Malta is ours."
	RegisterDialogue( "diag_sp_maltaBridge_STS339_01_01_mcor_bear", "diag_sp_maltaBridge_STS339_01_01_mcor_bear", PRIORITY_NO_QUEUE )
	//Well done 6-4!  Cooper, you still have control of the bridge. Use your data knife to steer yourself right behind the Draconis.
	RegisterRadioDialogue( "diag_sp_maltaBridge_STS342_02_01_mcor_sarah", "diag_sp_maltaBridge_STS342_02_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//Barker, Get BT back to Cooper
	RegisterRadioDialogue( "diag_sp_maltaBridge_STS342_03_01_mcor_sarah", "diag_sp_maltaBridge_STS342_03_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//"You got it, on my way. (to BT) Hold on, tin man!"
	RegisterRadioDialogue( "diag_sp_maltaBridge_STS343_01_01_mcor_barker", "diag_sp_maltaBridge_STS343_01_01_mcor_barker", PRIORITY_NO_QUEUE, "#NPC_BARKER", TEAM_MILITIA )
	//"All call signs, clean up bogies and rendezvous at the Draconis. This is it!"
	RegisterRadioDialogue( "diag_sp_maltaBridge_STS344_01_01_mcor_sarah", "diag_sp_maltaBridge_STS344_01_01_mcor_sarah", PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//"That's it, Coop, just like that. Just line her up with the Draconis"
	RegisterDialogue( "diag_sp_maltaBridge_STS345_01_01_mcor_droz", "diag_sp_maltaBridge_STS345_01_01_mcor_droz", PRIORITY_LOWEST )
	//"There you go, stay that course, you've almost got them lined up"
	RegisterDialogue( "diag_sp_maltaBridge_STS346_01_01_mcor_davis", "diag_sp_maltaBridge_STS346_01_01_mcor_davis", PRIORITY_LOWEST )
	//"That the correct heading, just keep the stick there."
	RegisterDialogue( "diag_sp_maltaBridge_STS347_01_01_mcor_gates", "diag_sp_maltaBridge_STS347_01_01_mcor_gates", PRIORITY_LOWEST )
	//"That's it, just like that."
	RegisterDialogue( "diag_sp_maltaBridge_STS348_01_01_mcor_droz", "diag_sp_maltaBridge_STS348_01_01_mcor_droz", PRIORITY_LOWEST )
	//"You're on the right course."
	RegisterDialogue( "diag_sp_maltaBridge_STS349_01_01_mcor_davis", "diag_sp_maltaBridge_STS349_01_01_mcor_davis", PRIORITY_LOWEST )
	//"Stay at that heading."
	RegisterDialogue( "diag_sp_maltaBridge_STS350_01_01_mcor_gates", "diag_sp_maltaBridge_STS350_01_01_mcor_gates", PRIORITY_LOWEST )
	//"You're too far off, Coop.  Steer it more to the right"
	RegisterDialogue( "diag_sp_maltaBridge_STS351_01_01_mcor_droz", "diag_sp_maltaBridge_STS351_01_01_mcor_droz", PRIORITY_LOWEST )
	//"You're heading away from her. Try to line them up. Pull the stick to the right."
	RegisterDialogue( "diag_sp_maltaBridge_STS352_01_01_mcor_davis", "diag_sp_maltaBridge_STS352_01_01_mcor_davis", PRIORITY_LOWEST )
	//"You're off course, Cooper.  Pull right. More to the right."
	RegisterDialogue( "diag_sp_maltaBridge_STS353_01_01_mcor_gates", "diag_sp_maltaBridge_STS353_01_01_mcor_gates", PRIORITY_LOWEST )
	//"No, no. More right."
	RegisterDialogue( "diag_sp_maltaBridge_STS354_01_01_mcor_droz", "diag_sp_maltaBridge_STS354_01_01_mcor_droz", PRIORITY_LOWEST )
	//"No. Go right, go right."
	RegisterDialogue( "diag_sp_maltaBridge_STS355_01_01_mcor_davis", "diag_sp_maltaBridge_STS355_01_01_mcor_davis", PRIORITY_LOWEST )
	//"Stop, go to the right."
	RegisterDialogue( "diag_sp_maltaBridge_STS356_01_01_mcor_gates", "diag_sp_maltaBridge_STS356_01_01_mcor_gates", PRIORITY_LOWEST )
	//"Coop you're going the wrong way. Pull it to the left."
	RegisterDialogue( "diag_sp_maltaBridge_STS357_01_01_mcor_droz", "diag_sp_maltaBridge_STS357_01_01_mcor_droz", PRIORITY_LOWEST )
	//"That's not the correct heading, Coop. Steer left."
	RegisterDialogue( "diag_sp_maltaBridge_STS358_01_01_mcor_davis", "diag_sp_maltaBridge_STS358_01_01_mcor_davis", PRIORITY_LOWEST )
	//"You're pulling away from the Draconis. Go left."
	RegisterDialogue( "diag_sp_maltaBridge_STS359_01_01_mcor_gates", "diag_sp_maltaBridge_STS359_01_01_mcor_gates", PRIORITY_LOWEST )
	//"That's wrong, head left"
	RegisterDialogue( "diag_sp_maltaBridge_STS360_01_01_mcor_droz", "diag_sp_maltaBridge_STS360_01_01_mcor_droz", PRIORITY_LOWEST )
	//"No, no. Steer left.  Left."
	RegisterDialogue( "diag_sp_maltaBridge_STS361_01_01_mcor_davis", "diag_sp_maltaBridge_STS361_01_01_mcor_davis", PRIORITY_LOWEST )
	//"Wrong way. Go left."
	RegisterDialogue( "diag_sp_maltaBridge_STS362_01_01_mcor_gates", "diag_sp_maltaBridge_STS362_01_01_mcor_gates", PRIORITY_LOWEST )
	//"Too high, Coop.  Go down lower"
	RegisterDialogue( "diag_sp_maltaBridge_STS363_01_01_mcor_droz", "diag_sp_maltaBridge_STS363_01_01_mcor_droz", PRIORITY_LOWEST )
	//"Pitch it down, Coop. You're too high."
	RegisterDialogue( "diag_sp_maltaBridge_STS364_01_01_mcor_davis", "diag_sp_maltaBridge_STS364_01_01_mcor_davis", PRIORITY_LOWEST )
	//"You're up too high, push the stick forward.."
	RegisterDialogue( "diag_sp_maltaBridge_STS365_01_01_mcor_gates", "diag_sp_maltaBridge_STS365_01_01_mcor_gates", PRIORITY_LOWEST )
	//"Too low, Coop.  Pull up"
	RegisterDialogue( "diag_sp_maltaBridge_STS366_01_01_mcor_droz", "diag_sp_maltaBridge_STS366_01_01_mcor_droz", PRIORITY_LOWEST )
	//"That's too low. Pull back on the stick."
	RegisterDialogue( "diag_sp_maltaBridge_STS367_01_01_mcor_davis", "diag_sp_maltaBridge_STS367_01_01_mcor_davis", PRIORITY_LOWEST )
	//"Cooper, You're too low, pull up."
	RegisterDialogue( "diag_sp_maltaBridge_STS368_01_01_mcor_gates", "diag_sp_maltaBridge_STS368_01_01_mcor_gates", PRIORITY_LOWEST )

	//6-4...just shut up and let him do the driving!
	RegisterDialogue( "diag_sp_maltaBridge_STS370_11_01_mcor_bear", "diag_sp_maltaBridge_STS370_11_01_mcor_bear", PRIORITY_LOW )

	//"That's it, you did it. Now full throttle."
	RegisterDialogue( "diag_sp_maltaBridge_STS369_01_01_mcor_bear", "diag_sp_maltaBridge_STS369_01_01_mcor_bear", PRIORITY_NORMAL )

	// Here's your Titan, Cooper. I'm done babysitting.
	RegisterRadioDialogue( "diag_sp_adds_STS801_04_01_mcor_barker", "diag_sp_adds_STS801_04_01_mcor_barker", PRIORITY_HIGH, "#NPC_BARKER", TEAM_MILITIA )
	//"Ready to transfer control to Pilot."
	RegisterDialogue( "diag_sp_maltaBridge_STS370_01_01_mcor_bt", "diag_sp_maltaBridge_STS370_01_01_mcor_bt", PRIORITY_NO_QUEUE )


/************************************************************************************************\

███╗   ███╗ █████╗ ██╗  ████████╗ █████╗     ██████╗ ███████╗ ██████╗██╗  ██╗
████╗ ████║██╔══██╗██║  ╚══██╔══╝██╔══██╗    ██╔══██╗██╔════╝██╔════╝██║ ██╔╝
██╔████╔██║███████║██║     ██║   ███████║    ██║  ██║█████╗  ██║     █████╔╝
██║╚██╔╝██║██╔══██║██║     ██║   ██╔══██║    ██║  ██║██╔══╝  ██║     ██╔═██╗
██║ ╚═╝ ██║██║  ██║███████╗██║   ██║  ██║    ██████╔╝███████╗╚██████╗██║  ██╗
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝

\************************************************************************************************/
	//Cooper, we'll give you cover from the rear, take the deck and get to the Draconis.
	RegisterDialogue( "diag_sp_maltaDeck_STS372_01_01_mcor_bear", "diag_sp_maltaDeck_STS372_01_01_mcor_bear", PRIORITY_NO_QUEUE )


	//Commander Briggs, this is BT-7274. Viper is down.
	RegisterDialogue( "diag_sp_maltaDeck_STS374_01_01_mcor_bt", "diag_sp_maltaDeck_STS374_01_01_mcor_bt", PRIORITY_NO_QUEUE )
	//Copy that. Board the Draconis and secure the Ark. We'll prep for transfer.
	RegisterRadioDialogue( "diag_sp_maltaDeck_STS377_01_01_mcor_sarah", "diag_sp_maltaDeck_STS377_01_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA )
	//Cooper - ready for fastball.
	RegisterDialogue( "diag_sp_maltaDeck_STS378_01_01_mcor_bt", "diag_sp_maltaDeck_STS378_01_01_mcor_bt", PRIORITY_NO_QUEUE )
	//Recommend you disembark.
	RegisterDialogue( "diag_sp_maltaDeck_STS378_11_01_mcor_bt", "diag_sp_maltaDeck_STS378_11_01_mcor_bt", PRIORITY_NO_QUEUE	 )

	//Climb into my hand, and I will throw you to the Draconis.
	RegisterDialogue( "diag_sp_maltaDeck_STS385_01a_01_mcor_bt", "diag_sp_maltaDeck_STS385_01a_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Adjusting for wind resistance… calculating…
	RegisterDialogue( "diag_sp_BTTackle_STS386_01_01_mcor_bt", "diag_sp_BTTackle_STS386_01_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Brace for impact. - higher intensity
	RegisterDialogue( "diag_sp_olaCrash_STS454_17a_01_mcor_bt", "diag_sp_olaCrash_STS454_17a_01_mcor_bt", PRIORITY_HIGH )

	//2-4 hard right!
	RegisterRadioDialogue( "diag_sp_gibraltar_STS102_11_01_mcor_radCom", "diag_sp_gibraltar_STS102_11_01_mcor_radCom", PRIORITY_NO_QUEUE, "#S2S_CALLSIGN_VL21", TEAM_MILITIA )

/************************************************************************************************\

██████╗  ██████╗ ███████╗███████╗    ███████╗██╗ ██████╗ ██╗  ██╗████████╗
██╔══██╗██╔═══██╗██╔════╝██╔════╝    ██╔════╝██║██╔════╝ ██║  ██║╚══██╔══╝
██████╔╝██║   ██║███████╗███████╗    █████╗  ██║██║  ███╗███████║   ██║
██╔══██╗██║   ██║╚════██║╚════██║    ██╔══╝  ██║██║   ██║██╔══██║   ██║
██████╔╝╚██████╔╝███████║███████║    ██║     ██║╚██████╔╝██║  ██║   ██║
╚═════╝  ╚═════╝ ╚══════╝╚══════╝    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝

\************************************************************************************************/

	//Cooper - Aim for the cockpit.
	RegisterDialogue( "diag_sp_bossFight_STS392_01_01_mcor_bt", "diag_sp_bossFight_STS392_01_01_mcor_bt", PRIORITY_NO_QUEUE )
	//Take the shot
	RegisterDialogue( "diag_sp_bossFight_STS393_01_01_mcor_bt", "diag_sp_bossFight_STS393_01_01_mcor_bt", PRIORITY_NO_QUEUE )
	//Viper One exposed!
	RegisterRadioDialogue( "diag_sp_bossFight_STS674_01_01_mcor_viper", "diag_sp_bossFight_STS674_01_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )
	//I've lost my canopy! Need cover need cover!
	RegisterRadioDialogue( "diag_sp_bossFight_STS675_01_01_mcor_viper", "diag_sp_bossFight_STS675_01_01_mcor_viper", PRIORITY_NO_QUEUE, "#BOSSNAME_VIPER", TEAM_IMC )

/************************************************************************************************\

██╗   ██╗██╗██████╗ ███████╗██████╗     ██████╗ ███████╗ █████╗ ██████╗
██║   ██║██║██╔══██╗██╔════╝██╔══██╗    ██╔══██╗██╔════╝██╔══██╗██╔══██╗
██║   ██║██║██████╔╝█████╗  ██████╔╝    ██║  ██║█████╗  ███████║██║  ██║
╚██╗ ██╔╝██║██╔═══╝ ██╔══╝  ██╔══██╗    ██║  ██║██╔══╝  ██╔══██║██║  ██║
 ╚████╔╝ ██║██║     ███████╗██║  ██║    ██████╔╝███████╗██║  ██║██████╔╝
  ╚═══╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═════╝

\************************************************************************************************/
	//Left arm severed. However, I am still operational. (ALT - Left arm: Severed. However, I am still operational.)
	RegisterDialogue( "diag_sp_bossFight_STS399_11_01_mcor_bt", "diag_sp_bossFight_STS399_11_01_mcor_bt", PRIORITY_NO_QUEUE )
	//We must uphold the mission.
	RegisterDialogue( "diag_sp_bossFight_STS399_12_01_mcor_bt", "diag_sp_bossFight_STS399_12_01_mcor_bt", PRIORITY_NO_QUEUE )
	//This ship is rapidly losing altitude - it is up to us, Cooper.
	RegisterDialogue( "diag_sp_bossFight_STS399_13_01_mcor_bt", "diag_sp_bossFight_STS399_13_01_mcor_bt", PRIORITY_NO_QUEUE )
	//Down here.
	RegisterDialogue( "diag_sp_lifeBoats_STS409_01_01_mcor_bt", "diag_sp_lifeBoats_STS409_01_01_mcor_bt", PRIORITY_NO_QUEUE )


/************************************************************************************************\

 ██████╗ ██████╗ ██████╗ ███████╗    ██████╗  ██████╗  ██████╗ ███╗   ███╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝    ██╔══██╗██╔═══██╗██╔═══██╗████╗ ████║
██║     ██║   ██║██████╔╝█████╗      ██████╔╝██║   ██║██║   ██║██╔████╔██║
██║     ██║   ██║██╔══██╗██╔══╝      ██╔══██╗██║   ██║██║   ██║██║╚██╔╝██║
╚██████╗╚██████╔╝██║  ██║███████╗    ██║  ██║╚██████╔╝╚██████╔╝██║ ╚═╝ ██║
 ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝

\************************************************************************************************/


	//Watch out! There's a Titan!
	RegisterDialogue( "diag_sp_lifeBoats_STS472_01_01_imc_grunt3", "diag_sp_lifeBoats_STS472_01_01_imc_grunt3", PRIORITY_LOW )
	//Lifeboats! Everyone get to their lifeboat!!
	RegisterDialogue( "diag_sp_lifeBoats_STS474_01_01_imc_grunt5", "diag_sp_lifeBoats_STS474_01_01_imc_grunt5", PRIORITY_LOW )

	//We are approaching the Ark's containment unit.
	RegisterDialogue( "diag_sp_lifeBoats_STS412_11_01_mcor_bt", "diag_sp_lifeBoats_STS412_11_01_mcor_bt", PRIORITY_NO_QUEUE )

	//The containment unit is too large to carry. We must improvise.
	RegisterDialogue( "diag_sp_lifeBoats_STS422_11_01_mcor_bt", "diag_sp_lifeBoats_STS422_11_01_mcor_bt", PRIORITY_NO_QUEUE )

	//I cannot reach the Ark. Cooper, I need your help.
	RegisterDialogue( "diag_sp_olaCrash_STS426_11_01_mcor_bt", "diag_sp_olaCrash_STS426_11_01_mcor_bt", PRIORITY_NO_QUEUE )

	//Quickly - we need to move the Ark. We are running out of time. (ALT - Quickly - we need to get off the ship. We are running out of time.)
	RegisterDialogue( "diag_sp_olaCrash_STS426_13_01_mcor_bt", "diag_sp_olaCrash_STS426_13_01_mcor_bt", PRIORITY_NO_QUEUE )

	//This way Coo<per>
	RegisterDialogue( "diag_sp_olaCrash_STS426_14_01_mcor_bt", "diag_sp_olaCrash_STS426_14_01_mcor_bt", PRIORITY_NO_QUEUE )




	//I will not lose another Pilot.
	RegisterDialogue( "diag_sp_olaCrash_STS454_16_01_mcor_bt", "diag_sp_olaCrash_STS454_16_01_mcor_bt", PRIORITY_HIGH )

	//Brace for impact.
	RegisterDialogue( "diag_sp_olaCrash_STS454_17_01_mcor_bt", "diag_sp_olaCrash_STS454_17_01_mcor_bt", PRIORITY_HIGH )




}

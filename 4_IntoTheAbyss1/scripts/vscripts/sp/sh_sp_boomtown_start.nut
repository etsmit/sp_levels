
global function ShSpBoomtownStartCommonInit

void function ShSpBoomtownStartCommonInit()
{
	// Precaching these weapons because they exist in the previous level, so you can carry them to this level
	PrecacheWeapon( "mp_weapon_alternator_smg" )
	PrecacheWeapon( "mp_weapon_autopistol" )
	PrecacheWeapon( "mp_weapon_car" )
	PrecacheWeapon( "mp_weapon_epg" )
	PrecacheWeapon( "mp_weapon_frag_grenade" )
	PrecacheWeapon( "mp_weapon_grenade_gravity" )
	PrecacheWeapon( "mp_weapon_lmg" )
	PrecacheWeapon( "mp_weapon_lstar" )
	PrecacheWeapon( "mp_weapon_mgl" )
	PrecacheWeapon( "mp_weapon_r97" )
	PrecacheWeapon( "mp_weapon_rocket_launcher" )
	PrecacheWeapon( "mp_weapon_rspn101" )
	PrecacheWeapon( "mp_weapon_semipistol" )
	PrecacheWeapon( "mp_weapon_shotgun" )
	PrecacheWeapon( "mp_weapon_sniper" )
	PrecacheWeapon( "mp_weapon_thermite_grenade" )

	SP_BOOMTOWN_START_AutoPrecache()

	// Preliminary scans suggest an exit beyond these caves.
	RegisterDialogue( "BT_EXIT_BEYOND_CAVES", 				"diag_sp_sewersExit_BM142_01_01_mcor_bt", 			PRIORITY_NORMAL )

	// Watch your step.
	RegisterDialogue( "BT_WATCH_YOUR_STEP", 				"diag_sp_sewersExit_BM142_02_01_mcor_bt", 			PRIORITY_LOW )

	// Watch our step.
	RegisterDialogue( "BT_WATCH_OUR_STEP", 					"diag_sp_sewersExit_BM142_03_01_mcor_bt", 			PRIORITY_LOW )

	// Impressive.  Your mobility skills are showing marked improvement.
	RegisterDialogue( "BT_IMPRESSIVE", 						"diag_sp_sewersExit_BM142_43_01_mcor_bt", 			PRIORITY_LOW )

	// Ash, this is Blisk. How copy, over?
	RegisterRadioDialogue( "RADIO_BLISK_INTRO_RADIO_1", 	"diag_sp_entrance_BM192_01_01_imc_blisk", 			PRIORITY_LOW, "#BOSSNAME_BLISK", 	TEAM_IMC, true )

	// This is Ash, go ahead.
	RegisterRadioDialogue( "RADIO_BLISK_INTRO_RADIO_2", 	"diag_sp_entrance_BM192_02_01_imc_ash", 			PRIORITY_LOW, "#BOSSNAME_ASH", 	TEAM_IMC, true )

	// Kane is not responding. I think our Militia Pilot's tryin' to be a hero... He's got to be headed your way. Kill him.
	RegisterRadioDialogue( "RADIO_BLISK_INTRO_RADIO_3", 	"diag_sp_entrance_BM192_04_01_imc_blisk", 			PRIORITY_LOW, "#BOSSNAME_BLISK", 	TEAM_IMC, true )

	// Understood. Ash out.
	RegisterRadioDialogue( "RADIO_BLISK_INTRO_RADIO_4", 	"diag_sp_entrance_BM192_05_01_imc_ash", 			PRIORITY_LOW, "#BOSSNAME_ASH", 	TEAM_IMC, true )

	// It's a Titan! Vanguard-class! Move! Move!
	RegisterDialogue( "RADIO_GAMMA_SQUAD_ITS_A_TITAN", 		"diag_sp_propHouse_BM151_04a_01_imc_grunt1", 		PRIORITY_LOW )

	// Good work, Pilot. Your skills are greatly improving.
	RegisterDialogue( "BT_GOOD_WORK_PILOT", 				"diag_sp_elevator_BM192_01_01_mcor_bt", 		PRIORITY_LOW )

	// Pilot, this loading dock's cargo lift offers a shortcut through the facility. Check your HUD for the control panel.
	RegisterDialogue( "BT_CONTROL_ROOM_NEARBY", 			"diag_sp_elevator_BM192_01a_01_mcor_bt", 			PRIORITY_NORMAL )

	// We cannot proceed through this facility without the cargo lift. I am marking your HUD with the location of the controls.
	RegisterDialogue( "BT_CONTROL_ROOM_NEARBY_NAG", 		"diag_sp_elevator_BM192_02_01_mcor_bt", 			PRIORITY_NORMAL )

	// Cargo lift activated.
	RegisterDialogue( "PA_LIFT_ACTIVATED", 					"diag_sp_elevator_BM192_03_01_imc_facilityPA", 		PRIORITY_HIGH )

	// <ALARM> <ALARM>
	//RegisterDialogue( "PA_ALARM", 							"diag_sp_elevator_BM192_04_01_imc_facilityPA", 		PRIORITY_HIGH )

	// Warning. Warning. Unauthorized Titan detected in Loading Dock 13.
	RegisterDialogue( "PA_UNAUTHORIZED_TITAN", 				"diag_sp_elevator_BM192_06_01_imc_facilityPA", 		PRIORITY_HIGH )

	// Pilot. I require assistance.
	RegisterDialogue( "BT_GRABBED_I_NEED_HELP", 			"diag_sp_elevator_BM192_07_01_mcor_bt", 			PRIORITY_HIGH )

	// Transferring Titan to Asset Reassignment.
	RegisterDialogue( "PA_TRANSFERING_TITAN", 				"diag_sp_elevator_BM192_09_01_imc_facilityPA", 		PRIORITY_HIGH )

	// Ash to Kappa three. I have located a security breach. Loading Dock 13, over.
	RegisterRadioDialogue( "ASH_SECURITY_BREACH", 				"diag_sp_elevator_BM192_10_01_imc_ash", 		PRIORITY_HIGH, "#BOSSNAME_ASH",		TEAM_IMC, true )

	// Roger. Kappa three en route, out.
	RegisterRadioDialogue( "RADIO_ROGER_EN_ROUTE", 				"diag_sp_elevator_BM192_11_01_imc_gcaptain2", 	PRIORITY_HIGH, "#IMC_HQ_COMMS",		TEAM_IMC, true )

	// Pilot... <static> I cannot free myself.... <static> Cooper....
	RegisterRadioDialogue( "BT_CANNOT_FREE_MYSELF", 			"diag_sp_elevator_BM192_12_01_mcor_bt", 		PRIORITY_HIGH, "#NPC_BT_NAME",		TEAM_MILITIA )


	RegisterDialogue( "diag_sp_podChatter_WD741_04_01_mcor_grunt1", 			"diag_sp_podChatter_WD741_04_01_mcor_grunt1", 		PRIORITY_NO_QUEUE )
	RegisterDialogue( "diag_sp_podChatter_WD741_05_01_mcor_grunt2", 			"diag_sp_podChatter_WD741_05_01_mcor_grunt2", 		PRIORITY_NO_QUEUE )
	RegisterDialogue( "diag_sp_podChatter_WD741_06_01_mcor_grunt3", 			"diag_sp_podChatter_WD741_06_01_mcor_grunt3", 		PRIORITY_NO_QUEUE )
}
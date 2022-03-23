global function ShSpSkywayCommonInit

global enum skywayTitanCockpitStatus
{
	DEFAULT,
	START,
	REBOOT,
	BEGIN_PROTOCOLS,
	COMPLETE_PROTOCOL_1,
	GOT_PLAYER_INPUT,
	BEGIN_PROTOCOL_2,
	COMPLETE_PROTOCOL_2,
	BEGIN_PROTOCOL_3,
	COMPLETE_PROTOCOL_3,
	END
}

global const asset HELMET_MODEL = $"models/Humans/heroes/mlt_hero_jack_helmet_static.mdl"

void function ShSpSkywayCommonInit()
{
	SP_SKYWAY_V1_AutoPrecache()

	PrecacheModel( HELMET_MODEL )
	PrecacheModel( $"models/weapons/p2011sp/ptpov_p2011sp.mdl" )

	PrecacheWeapon( "mp_weapon_droneplasma" )
	PrecacheWeapon( "mp_weapon_super_spectre" )
	PrecacheWeapon( "mp_weapon_smart_pistol" )
	PrecacheWeapon( "mp_weapon_smart_pistol_og" )
	PrecacheParticleSystem( $"P_deathfx_turretlaser" )

	// TORTURE ROOM
	RegisterDialogue( "BT_Torture_a_1", "diag_sp_torture_SK101_04_01_mcor_bt",	PRIORITY_NO_QUEUE )	// Cooper....over here...
	RegisterDialogue( "BT_Torture_a_2", "diag_sp_torture_SK101_11_01_mcor_bt",	PRIORITY_NO_QUEUE )	// Cooper....over here...
	RegisterDialogue( "BT_Torture_a_3", "diag_sp_torture_SK101_13_01_mcor_bt",	PRIORITY_NO_QUEUE )	// Cooper....over here...

	RegisterDialogue( "BT_Torture_1", "diag_sp_torture_SK102_02_01_mcor_bt",	PRIORITY_NORMAL )	// Cooper....over here...

	RegisterDialogue( "Slone_Torture_1", "diag_sp_torture_SK101_28a_01_imc_slone", PRIORITY_NORMAL )			//Nice try, love.
	RegisterDialogue( "Slone_Torture_2", "diag_sp_torture_SK101_28b_01_imc_slone", PRIORITY_NORMAL )			//Say goodnight.

	RegisterDialogue( "Blisk_Torture_1", "diag_sp_torture_SK102_01_01_imc_blisk", PRIORITY_NORMAL )			//Oi! Get the Ark out of here! We're running out of time!

	RegisterDialogue( "BT_Torture_b_1", "diag_sp_torture_SK102_16_01_mcor_bt", PRIORITY_NORMAL )			//Cooper, I can no longer uphold the mission...
	RegisterDialogue( "BT_Torture_b_2", "diag_sp_torture_SK102_17_01_mcor_bt", PRIORITY_NORMAL )			//...but you still can.
	RegisterDialogue( "BT_Torture_b_3", "diag_sp_torture_SK102_18_01_mcor_bt", PRIORITY_NORMAL )			//Take the SERE (pr. 'sear') Kit. It is your best...chance...for survival.

	// SP RUN
	RegisterRadioDialogue( "SP_RUN_RADIO_1",	"diag_sp_pistolRun_SK110_01_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// All callsigns report! We are heading into enemy territory - expect heavy fire.  This is Pilot Cooper's last known position.
	RegisterRadioDialogue( "SP_RUN_RADIO_2",	"diag_sp_pistolRun_SK110_02_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// All callsigns fire at will!  Captain - do you have a fix on that signal?
	RegisterRadioDialogue( "SP_RUN_RADIO_3",	"diag_sp_pistolRun_SK110_03_01_mcor_captain2", PRIORITY_NORMAL, "#NPC_REYES_NAME", TEAM_MILITIA )	// I've got something, but it's faint - cannot confirm.
	RegisterRadioDialogue( "SP_RUN_RADIO_4",	"diag_sp_pistolRun_SK113_01_01_mcor_officer", PRIORITY_NORMAL, "#NPC_JAO_NAME", TEAM_MILITIA )	// Commander Briggs, I'm picking up a datacore, it's a weak signal!
	RegisterRadioDialogue( "SP_RUN_RADIO_5",	"diag_sp_pistolRun_SK110_04_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// Cooper! Cooper!  Damn it!
	RegisterRadioDialogue( "SP_RUN_RADIO_6",	"diag_sp_pistolRun_SK113_04_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// Are you sure you have the coordinates? Boost the signal! I need to get through to them!
	RegisterRadioDialogue( "SP_RUN_RADIO_7",	"diag_sp_pistolRun_SK113_05_01_mcor_officer", PRIORITY_NORMAL, "#NPC_JAO_NAME", TEAM_MILITIA )	// Commander Briggs, I have a lock on Cooper's position! He's pulled BT's datacore! He must have the SERE Kit!
	RegisterRadioDialogue( "SP_RUN_RADIO_8",	"diag_sp_pistolRun_SK113_02_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// BT! Cooper! What's your status? Cooper! How copy, over!
	RegisterRadioDialogue( "SP_RUN_RADIO_9",	"diag_sp_pistolRun_SK113_03_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// BT-7274! Cooper! How copy, over!
	RegisterRadioDialogue( "SP_RUN_RADIO_10",	"diag_sp_pistolRun_SK110_05_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// *Static* *Static*...BT...Cooper....*Static*....Cooper... Is that you?...I'm picking up BT's datacore.

	RegisterRadioDialogue( "SP_RUN_RADIO_11",	"diag_sp_pistolRun_SK113_06_01_mcor_sarah", PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )		// Cooper! This is Commander Sarah Briggs!
	RegisterRadioDialogue( "SP_RUN_RADIO_12",	"diag_sp_pistolRun_SK110_06_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// If you are reading this: get to the bridge one klick north of your position.
	RegisterRadioDialogue( "SP_RUN_RADIO_13",	"diag_sp_pistolRun_SK110_07_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// We've got only one shot to turn this fight around and you're it.

	RegisterRadioDialogue( "SP_RUN_RADIO_14",	"diag_sp_pistolRun_SK110_08_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// Our fleet's moving in on the Fold Weapon location.
	RegisterRadioDialogue( "SP_RUN_RADIO_15",	"diag_sp_pistolRun_SK110_09_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// We're coming. It's not over yet.

	RegisterRadioDialogue( "SP_RUN_RADIO_16",	"diag_sp_pistolRun_SK113_07_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// You're headed in the right direction, just keep moving!
	RegisterRadioDialogue( "SP_RUN_RADIO_17",	"diag_sp_pistolRun_SK113_08_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// The anti-air defenses are extremely heavy around the Fold Weapon!
	RegisterRadioDialogue( "SP_RUN_RADIO_18",	"diag_sp_pistolRun_SK113_09_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// We're having trouble getting boots on the ground and we're running out of options.

	RegisterRadioDialogue( "SP_RUN_RADIO_19",	"diag_sp_pistolRun_SK113_10_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// Cooper! We have one last Vanguard in the racks!
	RegisterRadioDialogue( "SP_RUN_RADIO_20",	"diag_sp_pistolRun_SK113_11_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// I'm pulling its datacore and preparing it for Titanfall!
	// RegisterRadioDialogue( "SP_RUN_RADIO_21",	"diag_sp_pistolRun_SK113_12_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		// Now check your HUD! Get to that secure drop point! Go!

	RegisterRadioDialogue( "SARAH_RADIO_HOTDROP_1",	"diag_sp_pistolRun_SK113_14_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Cooper, your Titan's standing by, call it when ready.
	RegisterRadioDialogue( "SARAH_RADIO_HOTDROP_2",	"diag_sp_pistolRun_SK113_15_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Cooper. Call you're Titan when ready.
	RegisterRadioDialogue( "SARAH_RADIO_HOTDROP_3",	"diag_sp_pistolRun_SK113_16_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // We have your Titan waiting. Call it when you're ready.
	RegisterRadioDialogue( "SARAH_RADIO_HOTDROP",	"diag_sp_titanHill_SK131_04_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Standby for Titanfall.

	RegisterDialogue( "BT_REUNION_0",	"diag_sp_titanHill_SK131_05_01_mcor_bt", PRIORITY_NORMAL ) // Hello Jack
	RegisterDialogue( "BT_REUNION_1",	"diag_sp_titanHill_SK131_20_01_mcor_bt", PRIORITY_NORMAL ) // It is time to complete our mission.


	// Titan Hill
	RegisterRadioDialogue( "TITAN_HILL_1",	"diag_sp_titanHill_SK131_21_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		//Cooper, I'm throwing everything I've got at the IMC but it's not going to be enough.
	RegisterRadioDialogue( "TITAN_HILL_2",	"diag_sp_titanHill_SK131_22_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		//Commander Briggs to all battle stations, I want close fire support on Cooper and BT. Do whatever it takes to cover them! I don't care what it takes, nothing touches that titan!
	RegisterRadioDialogue( "TITAN_HILL_3",	"diag_sp_titanHill_SK131_23_01_mcor_captain1", PRIORITY_NORMAL, "#NPC_REYES_NAME", TEAM_MILITIA )	//Solid copy, wilco.
	RegisterRadioDialogue( "TITAN_HILL_4",	"diag_sp_titanHill_SK131_24_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )		//Cooper, get up that hill. We've cover you, move!

	RegisterRadioDialogue( "BOMBARD_0",	"diag_sp_titanHill_SK131_36_01_mcor_bcaptain1", PRIORITY_LOWEST, "#NPC_REYES_NAME", TEAM_MILITIA )  // Tracking targets --- firing, danger close!
	RegisterRadioDialogue( "BOMBARD_1",	"diag_sp_titanHill_SK131_34_01_mcor_bcaptain1", PRIORITY_LOWEST, "#NPC_REYES_NAME", TEAM_MILITIA )  // I see them - firing, danger close!
	RegisterRadioDialogue( "BOMBARD_2",	"diag_sp_titanHill_SK131_35_01_mcor_bcaptain1", PRIORITY_LOWEST, "#NPC_REYES_NAME", TEAM_MILITIA )  // Targets locked - firing!

	// Titan Hill 2
	RegisterRadioDialogue( "TITAN_HILL_A_0",	"diag_sp_titanHill_SK131_31_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Keep moving, don't let up!

	RegisterRadioDialogue( "TITAN_HILL_A_1",	"diag_sp_titanHill_SK131_25_01_mcor_pilot1", PRIORITY_NORMAL, "#NPC_SANTOS_NAME", TEAM_MILITIA )		// Mayday, mayday, this is Echo-420. We're hit! She's stalling! I can't...she's not pulling out of it!
	RegisterRadioDialogue( "TITAN_HILL_A_2",	"diag_sp_titanHill_SK131_26_01_mcor_bcaptain1", PRIORITY_NORMAL, "#NPC_REYES_NAME", TEAM_MILITIA )		// Come in HQ, this is Captain Loo of the Frigate Razorback! These Goblins are tearing us apart! Requesting authorization to divert fire and engage.
	RegisterRadioDialogue( "TITAN_HILL_A_3",	"diag_sp_titanHill_SK131_27_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )			// Denied Razorback. We need everything we've got covering Cooper. The order stands.
	RegisterRadioDialogue( "TITAN_HILL_A_4",	"diag_sp_titanHill_SK131_29_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )			// The Battleship Partisan just went dark. Give me a sitrep--now!
	RegisterRadioDialogue( "TITAN_HILL_A_5",	"diag_sp_titanHill_SK131_30_01_mcor_bcaptain2", PRIORITY_NORMAL, "#NPC_JAO_NAME", TEAM_MILITIA )		// This is Cpt. Landegger of the Copperhead. The Partisan took a broadside. No escape pods jettisoned, not a single one. I'm sorry general.

	RegisterRadioDialogue( "TITAN_HILL_B_1",	"diag_sp_titanHill_SK131_41_01_mcor_gates", PRIORITY_NORMAL, "#NPC_GATES_NAME", TEAM_MILITIA ) // Commander Briggs, this is Gates of the 6-4.  Are we late to the party?
	RegisterRadioDialogue( "TITAN_HILL_B_2",	"diag_sp_titanHill_SK131_42_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // You're just in time, Gates.  How much juice do you have left in the Malta?
	RegisterRadioDialogue( "TITAN_HILL_B_3",	"diag_sp_titanHill_SK131_43_01_mcor_gates", PRIORITY_NORMAL, "#NPC_GATES_NAME", TEAM_MILITIA ) // We've got plenty to spare - Don't worry, Coop!  We've got your back!
	RegisterRadioDialogue( "TITAN_HILL_B_4",	"diag_sp_titanHill_SK131_44_01_mcor_bear", PRIORITY_NORMAL, "#NPC_BEAR_NAME", TEAM_MILITIA ) // Targetting systems online - we are weapons hot!

	RegisterRadioDialogue( "BOMBARD_B_0",	"diag_sp_titanHill_SK131_46_01_mcor_bear", PRIORITY_LOWEST, "#NPC_BEAR_NAME", TEAM_MILITIA )  // Target locked - firing!
	RegisterRadioDialogue( "BOMBARD_B_1",	"diag_sp_titanHill_SK131_47_01_mcor_bear", PRIORITY_LOWEST, "#NPC_BEAR_NAME", TEAM_MILITIA )  // Firing - danger close!
	RegisterRadioDialogue( "BOMBARD_B_2",	"diag_sp_titanHill_SK131_48_01_mcor_bear", PRIORITY_LOWEST, "#NPC_BEAR_NAME", TEAM_MILITIA )  // Firing!

	// Smash Hall
	RegisterRadioDialogue( "SMASH_HALL_1",	"diag_sp_smashHallway_SK141_01_01_mcor_bt", PRIORITY_NORMAL, "#NPC_BT_NAME", TEAM_MILITIA )
	RegisterRadioDialogue( "SMASH_HALL_2",	"diag_sp_smashHallway_SK141_02_01_mcor_bt", PRIORITY_NORMAL, "#NPC_BT_NAME", TEAM_MILITIA )
	RegisterRadioDialogue( "SMASH_HALL_3",	"diag_sp_smashHallway_SK141_03_01_mcor_bt", PRIORITY_NORMAL, "#NPC_BT_NAME", TEAM_MILITIA )
	RegisterRadioDialogue( "SMASH_HALL_4",	"diag_sp_smashHallway_SK141_01_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )
	RegisterRadioDialogue( "SMASH_HALL_5",	"diag_sp_smashHallway_SK140_01_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )
	RegisterDialogue( "SMASH_HALL_6",	"diag_sp_extra_GB101_64_01_mcor_bt", PRIORITY_NORMAL )


	// Targeting Room
	RegisterDialogue( "TARGETING_ROOM_1", "diag_sp_sculptorRing_SK151_01_01_imc_genMarder", PRIORITY_NO_QUEUE )
	RegisterDialogue( "TARGETING_ROOM_2", "diag_sp_sculptorRing_SK151_02_01_imc_facilityPA", PRIORITY_NO_QUEUE )
	RegisterDialogue( "TARGETING_ROOM_3", "diag_sp_sculptorRing_SK151_03_01_imc_facilityPA", PRIORITY_NO_QUEUE )
	RegisterDialogue( "TARGETING_ROOM_4", "diag_sp_sculptorRing_SK151_04_01_imc_genMarder", PRIORITY_NO_QUEUE )
	RegisterDialogue( "TARGETING_ROOM_5", "diag_sp_sculptorRing_SK151_04_01_imc_facilityPA", PRIORITY_NO_QUEUE )

	// Slone Fight
	RegisterRadioDialogue( "SLONE_FIGHT_1", "diag_sp_sloneFight_SK162_01_01_imc_slone", PRIORITY_HIGH, "#BOSSNAME_SLONE", TEAM_IMC )	// I gotta say, Pilot - this is more entertaining that I expected!
	RegisterRadioDialogue( "SLONE_FIGHT_2", "diag_sp_sloneFight_SK162_02_01_imc_slone", PRIORITY_HIGH, "#BOSSNAME_SLONE", TEAM_IMC )	// Get him, lads!
	RegisterRadioDialogue( "SLONE_FIGHT_3", "diag_sp_sloneFight_SK162_03_01_imc_slone", PRIORITY_HIGH, "#BOSSNAME_SLONE", TEAM_IMC )	// Alright, I'm ready for more!
	RegisterRadioDialogue( "SLONE_FIGHT_4", "diag_sp_sloneFight_SK162_04_01_imc_slone", PRIORITY_HIGH, "#BOSSNAME_SLONE", TEAM_IMC )	// You're a tough lil bugger ain'tcha?
	RegisterRadioDialogue( "SLONE_FIGHT_5", "diag_sp_sloneFight_SK162_05_01_imc_slone", PRIORITY_HIGH, "#BOSSNAME_SLONE", TEAM_IMC )	// Let's see how you handle these!
	RegisterRadioDialogue( "SLONE_FIGHT_6", "diag_sp_sloneFight_SK162_06_01_imc_slone", PRIORITY_HIGH, "#BOSSNAME_SLONE", TEAM_IMC )	// Oy! Ya ain't walkin away that easy!

	RegisterRadioDialogue( "SLONE_PHASE_1",	"diag_sp_injectorRoom_SK161_01_01_imc_facilityPA", PRIORITY_NO_QUEUE, "", TEAM_IMC )
	RegisterRadioDialogue( "SLONE_PHASE_2",	"diag_sp_injectorRoom_SK161_11_01_imc_facilityPA", PRIORITY_NO_QUEUE, "", TEAM_IMC )
	RegisterRadioDialogue( "SLONE_PHASE_3",	"diag_sp_injectorRoom_SK161_12_01_imc_facilityPA", PRIORITY_NO_QUEUE, "", TEAM_IMC )
	RegisterRadioDialogue( "SLONE_PHASE_4",	"diag_sp_injectorRoom_SK161_13_01_imc_facilityPA", PRIORITY_NO_QUEUE, "", TEAM_IMC )
	RegisterRadioDialogue( "SLONE_PHASE_5",	"diag_sp_injectorRoom_SK161_14a_01_imc_facilityPA", PRIORITY_NO_QUEUE, "", TEAM_IMC )
	RegisterRadioDialogue( "SLONE_PHASE_6",	"diag_sp_injectorRoom_SK161_16_01_imc_facilityPA", PRIORITY_NO_QUEUE, "", TEAM_IMC )

	// Blisk Farewell
	RegisterRadioDialogue( "BLISK_FAREWELL_1", "diag_sp_injectorRoom_SK161_15_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Cooper! Get the Ark out of there before it launches! Hurry!

	RegisterDialogue( "BLISK_FAREWELL_a_1", "diag_sp_injectorRoom_SK163_01_01_mcor_bt", PRIORITY_NORMAL ) // Cooper...the injector backblast has overloaded my...critical internal systems.
	RegisterDialogue( "BLISK_FAREWELL_a_2", "diag_sp_injectorRoom_SK163_02_01_mcor_bt", PRIORITY_NORMAL ) // Auto-navigation system offline. Weapons systems offline. Reactor core - unstable. Neural link pathways - deteriorating. Attempting to restore ocular systems.
	RegisterDialogue( "BLISK_FAREWELL_a_3", "diag_sp_injectorRoom_SK163_03_01_mcor_bt", PRIORITY_NORMAL ) // Ocular systems restored.
	RegisterDialogue( "BLISK_FAREWELL_a_4", "diag_sp_extra_GB101_95_01_mcor_bt", PRIORITY_NO_QUEUE ) // A throw is our only option here
	RegisterDialogue( "BLISK_FAREWELL_a_5", "diag_sp_extra_GB101_95_02_mcor_bt", PRIORITY_NORMAL ) // A throw is our only option here
	RegisterDialogue( "BLISK_FAREWELL_a_5b", "diag_sp_extra_GB101_95_02b_mcor_bt", PRIORITY_NORMAL ) // A throw is our only option here
	RegisterDialogue( "BLISK_FAREWELL_a_6", "diag_sp_injectorRoom_SK163_04_01_mcor_bt", PRIORITY_NO_QUEUE ) // Warning - hostile Titan detected.

	RegisterRadioDialogue( "BLISK_FAREWELL_b_1", "diag_sp_injectorRoom_SK163_05_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Cooper! BT! Do you read?!
	RegisterRadioDialogue( "BLISK_FAREWELL_b_2", "diag_sp_injectorRoom_SK163_06_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Fire everything we’ve got at it!
	RegisterRadioDialogue( "BLISK_FAREWELL_b_3", "diag_sp_injectorRoom_SK163_07_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Nothing’s putting a dent in it!
	RegisterRadioDialogue( "BLISK_FAREWELL_b_4", "diag_sp_injectorRoom_SK163_08_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Cooper! BT! Do you read?!
	RegisterRadioDialogue( "BLISK_FAREWELL_b_5", "diag_sp_injectorRoom_SK163_09_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // We’ve fired everything at the Fold Weapon - no effect on target!

	// BT Sacrifice
	RegisterRadioDialogue( "BT_SACRIFICE_1",	"diag_sp_injectorRoom_SK163_10_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // BT! Cooper! Respond!
	RegisterRadioDialogue( "BT_SACRIFICE_2",	"diag_sp_injectorRoom_SK163_11_01_mcor_sarah", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Boost the signal.
	RegisterRadioDialogue( "BT_SACRIFICE_3",	"diag_sp_injectorRoom_SK163_12_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // BT! Cooper! Our ground teams can’t make it there in time! You’ve got to find a way to destroy the Fold Weapon from the inside!! There’s no other way!
	RegisterRadioDialogue( "BT_SACRIFICE_4",	"diag_sp_injectorRoom_SK163_13_01_mcor_bt", PRIORITY_NORMAL, "", TEAM_MILITIA ) // Cooper, I require your assistance. My auto navigation systems are offline. Get me into that injector assembly. We must do this together.

	RegisterRadioDialogue( "BT_SACRIFICE_5",	"diag_sp_injectorRoom_SK163_14_01_mcor_bt", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Commander Briggs, I believe I have a solution: In its exposed state, my reactor core may be able to destabilize the Ark at the center of the Fold Weapon.
	RegisterRadioDialogue( "BT_SACRIFICE_6",	"diag_sp_injectorRoom_SK163_15_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Say again. Repeat your last.
	RegisterRadioDialogue( "BT_SACRIFICE_7",	"diag_sp_injectorRoom_SK163_16_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA ) // What are you saying?
	RegisterRadioDialogue( "BT_SACRIFICE_8",	"diag_sp_injectorRoom_SK163_17_01_mcor_bt", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // We can blow it up. I’m sending you coordinates for a dropship rendezvous.
	RegisterRadioDialogue( "BT_SACRIFICE_9",	"diag_sp_injectorRoom_SK163_18_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Coordinates received. We’ll be there, but I don’t see how you can.
	RegisterRadioDialogue( "BT_SACRIFICE_10",	"diag_sp_injectorRoom_SK163_19_01_mcor_bt", PRIORITY_NO_QUEUE, "", TEAM_MILITIA ) // Trust me. I’ve done the math.
	RegisterRadioDialogue( "BT_SACRIFICE_11",	"diag_sp_injectorRoom_SK163_20_01_mcor_sarah", PRIORITY_NO_QUEUE, "#NPC_SARAH_NAME", TEAM_MILITIA ) // I sure as hell hope so. We’re on our way. Good luck - both of you. Briggs out.

	RegisterRadioDialogue( "BT_SACRIFICE_NAG_1",	"diag_sp_injectorRoom_SK163_21_01_mcor_bt", PRIORITY_NORMAL, "", TEAM_MILITIA ) // We must keep going Cooper - my reactor core has become very unstable. I don’t know how long we have...
	RegisterRadioDialogue( "BT_SACRIFICE_NAG_2",	"diag_sp_injectorRoom_SK163_22_01_mcor_bt", PRIORITY_NORMAL, "", TEAM_MILITIA ) // The Fold Weapon has energized its final phase using the Ark...we are...running out of...time. Move Cooper.

	RegisterDialogue( "BT_PreFire_1a", "diag_sp_extra_GB101_97_01_mcor_player", PRIORITY_NORMAL )
	RegisterDialogue( "BT_PreFire_1b", "diag_sp_extra_GB101_96_01_mcor_player", PRIORITY_NORMAL )
	RegisterDialogue( "BT_PreFire_2", "diag_sp_extra_GB101_88_01_mcor_player", PRIORITY_NORMAL )

	// Protocol 3: Protect The Pilot
	RegisterDialogue( "diag_sp_pilotLink_WD141_44_01_mcor_bt", "diag_sp_extra_GB101_99_01_mcor_bt", PRIORITY_NO_QUEUE )

	// BEEEE TEEEEEE!!
	RegisterDialogue( "diag_sp_extra_GB101_78_01_mcor_player", 	"diag_sp_extra_GB101_93_01_mcor_player",			PRIORITY_HIGH )

	// A throw is our only option here
	RegisterDialogue( "diag_sp_extra_GB101_95_03_mcor_bt", 	"diag_sp_extra_GB101_95_03_mcor_bt",			PRIORITY_HIGH )

	// Calculating
	RegisterDialogue( "diag_sp_extra_GB101_94_01_mcor_bt", 	"diag_sp_extra_GB101_94_01_mcor_bt",			PRIORITY_HIGH )


	//RISING WORLD RUN
	RegisterRadioDialogue( "RWR_1",	"diag_sp_rwrun_SK302_01_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Cooper, we just lost BT’s signal! We’re almost there!
	RegisterRadioDialogue( "RWR_2",	"diag_sp_rwrun_SK302_02_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Cooper - I’m marking your HUD with the coordinates. The evac site might be in midair. There’s nothing we can touch down on here!”
	RegisterRadioDialogue( "RWR_3",	"diag_sp_rwrun_SK302_03_01_mcor_barker", PRIORITY_NORMAL, "#NPC_BARKER", TEAM_MILITIA ) // And if I’m flying through this mess, you better be there on time.
	RegisterRadioDialogue( "RWR_4",	"diag_sp_rwrun_SK302_04_01_mcor_barker", PRIORITY_NORMAL, "#NPC_BARKER", TEAM_MILITIA ) // If I’m flying through this shitstorm/shitshow, you better be there on time, kid.
	RegisterRadioDialogue( "RWR_5",	"diag_sp_rwrun_SK302_05_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Move, Pilot!
	RegisterRadioDialogue( "RWR_6",	"diag_sp_rwrun_SK302_06_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // I'm tracking you. Keep going.
	RegisterRadioDialogue( "RWR_7",	"diag_sp_rwrun_SK302_07_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // That’s it, you’re almost there! Move move!
	RegisterRadioDialogue( "RWR_8",	"diag_sp_rwrun_SK302_08_01_mcor_barker", PRIORITY_NORMAL, "#NPC_BARKER", TEAM_MILITIA ) // Got visual.

	RegisterRadioDialogue( "RWR_b_1",	"diag_sp_rwrun_SK302_09_01_mcor_sarah", PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA ) // Cooper. Jump for it.
	RegisterDialogue( "RWR_b_2",	"diag_sp_rwrun_SK302_10_01_mcor_sarah", PRIORITY_NORMAL ) // Got ya.
	RegisterDialogue( "RWR_b_3",	"diag_sp_rwrun_SK302_11_01_mcor_sarah", PRIORITY_NORMAL ) // Come on.
	RegisterDialogue( "RWR_b_4",	"diag_sp_rwrun_SK302_12_01_mcor_sarah", PRIORITY_NORMAL ) // Barker, get us out of here.
	RegisterDialogue( "RWR_b_5",	"diag_sp_rwrun_SK302_13_01_mcor_barker", PRIORITY_NORMAL ) // Hang on.

	// Exploding Planet
	RegisterDialogue( "TYPHON_1a",	"diag_sp_extras_SK999_04a_01_mcor_sarah", PRIORITY_NORMAL ) // Pilot Cooper.
	RegisterDialogue( "TYPHON_1b",	"diag_sp_extras_SK999_07_01_mcor_sarah", PRIORITY_NORMAL ) // A lot of people owe their lives to you.
	RegisterDialogue( "TYPHON_1c",	"diag_sp_extras_SK999_07a_01_mcor_sarah", PRIORITY_NORMAL ) // And to BT...
	RegisterDialogue( "TYPHON_2",	"diag_sp_rwrun_SK302_15_01_mcor_sarah", PRIORITY_NORMAL ) // Barker. Set a course for Harmony. Take us home.
	RegisterDialogue( "TYPHON_3",	"diag_sp_rwrun_SK302_16_01_mcor_barker", PRIORITY_NORMAL ) // You got it.

	// BT Sacrifice BT Memories
	RegisterDialogue( "BT_MEMORY_1", "diag_sp_sacrifice_SK171_01_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_2", "diag_sp_sacrifice_SK171_02_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_3", "diag_sp_sacrifice_SK171_04_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_4", "diag_sp_sacrifice_SK171_05_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_5", "diag_sp_sacrifice_SK171_03_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_6", "diag_sp_sacrifice_SK171_06_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_7", "diag_sp_sacrifice_SK171_07_01_mcor_bt", PRIORITY_NORMAL )
	RegisterDialogue( "BT_MEMORY_8", "diag_sp_sacrifice_SK171_08_01_mcor_bt", PRIORITY_NORMAL )

	RegisterDialogue( "BT_GOODBYE_JACK", "diag_sp_injectorRoom_SK163_27_01_mcor_bt", PRIORITY_NO_QUEUE )
	RegisterDialogue( "BT_GOODBYE", "diag_sp_injectorRoom_SK163_28_01_mcor_bt", PRIORITY_NO_QUEUE )
	RegisterDialogue( "BT_TRUST_ME", "diag_sp_spoke1_BE117_04_01_mcor_bt_skydedi", PRIORITY_NO_QUEUE )

	RegisterDialogue( "HARMONY_1", "diag_sp_afterRescue_SK610_01_01_mcor_player", PRIORITY_NORMAL )
	RegisterDialogue( "HARMONY_2", "diag_sp_afterRescue_SK610_02_01_mcor_player", PRIORITY_NORMAL )
	RegisterDialogue( "HARMONY_3", "diag_sp_afterRescue_SK610_03_01_mcor_player", PRIORITY_NORMAL )
	RegisterDialogue( "HARMONY_4", "diag_sp_afterRescue_SK610_04_01_mcor_player", PRIORITY_NORMAL )

	RegisterDialogue( "HARMONY_RD_1", "diag_sp_afterRescue_SK615_01_01_mcor_atc1", PRIORITY_NO_QUEUE )
	RegisterDialogue( "HARMONY_RD_2", "diag_sp_afterRescue_SK615_02_01_mcor_atc2", PRIORITY_NO_QUEUE )
	RegisterDialogue( "HARMONY_RD_3", "diag_sp_afterRescue_SK615_03_01_mcor_atc1", PRIORITY_NO_QUEUE )
	RegisterDialogue( "HARMONY_RD_4", "diag_sp_afterRescue_SK615_04_01_mcor_atc2", PRIORITY_NO_QUEUE )
}
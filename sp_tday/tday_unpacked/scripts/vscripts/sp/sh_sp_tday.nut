global const asset DRACONIS_SKYBOX = $"models/vehicle/draconis/vehicle_draconis_hero_animated_1000x.mdl"
global const asset DRACONIS_INLEVEL = $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl"
global const float DRACONIS_ESCAPE_TIME = 16.85 // 17.85

global const int DRACONIS_NONE = 0
global const int DRACONIS_IDLING = 1
global const int DRACONIS_THRUSTERS = 2
global const int DRACONIS_AFTERBURNERS = 3
global const int DRACONIS_FLYING = 4

global function ShSpTdayCommonInit

void function ShSpTdayCommonInit()
{
	SP_TDAY_AutoPrecache()
	PrecacheModel( $"models/Humans/heroes/imc_hero_slone.mdl" ) // if the boss' model were to change, it would become a late-precache error and be caught. In the future we should probably have a way to mark bosses for precache.
	PrecacheWeapon( "mp_weapon_turret_tday" )
	PrecacheWeapon( "mp_weapon_super_spectre" )

	//########################
	// 		  Intro
	//########################

	// Listen up! The IMC have developed a “Fold Weapon.” It has the power to destroy entire worlds but - without its power source the “Ark” - it is inoperable. Your mission is to capture the Ark before it can leave the airbase!
	RegisterDialogue( "SARAH_LISTEN_UP", 				"diag_sp_bombardment_TD101_01_01_mcor_sarah", 		PRIORITY_NO_QUEUE )

	// Marauder Corps! Weapons hot!
	RegisterDialogue( "SARAH_WEAPONS_HOT", 				"diag_sp_bombardment_TD101_02_01_mcor_sarah", 		PRIORITY_NO_QUEUE )

	// Standby for Titanfall!
	RegisterDialogue( "SARAH_STANDBY_FOR_TITANFALL", 	"diag_sp_bombardment_TD101_03_01_mcor_sarah", 		PRIORITY_NO_QUEUE )

	// Watch out for the cannons!
	RegisterDialogue( "WATCH_FOR_CANNONS", 				"diag_sp_bombardment_TD101_09_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Unless we take out those cannons, we're not getting any closer to that ship!
	RegisterRadioDialogue( "SARAH_UNLESS_TAKE_OUT_CANNONS", 	"diag_sp_bombardment_TD101_14_01_mcor_sarah", 		PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Get to cover Cooper! We're taking down that wall!
	RegisterRadioDialogue( "SARAH_GET_TO_COVER_COOPER", 		"diag_sp_bombardment_TD101_03a_01_mcor_sarah", 		PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Wilson in position.
	RegisterDialogue( "WILSON_IN_POSITION", 			"diag_sp_bombardment_TD101_04_01_mcor_pilot1", 		PRIORITY_NO_QUEUE )

	// Grenier good to go.
	RegisterDialogue( "GRENIER_GOOD_TO_GO", 			"diag_sp_bombardment_TD101_05_01_mcor_pilot2", 		PRIORITY_NO_QUEUE )

	// All Acolyte pods locked and loaded.
	RegisterDialogue( "ACOLYTE_PODS_READY", 			"diag_sp_bombardment_TD101_06_01_mcor_pilot3", 		PRIORITY_NO_QUEUE )

	// This is Commander Briggs. Go weapons free - Fire!!!!
	RegisterRadioDialogue( "SARAH_WEAPONS_FREE_FIRE", 		"diag_sp_bombardment_TD101_07_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Open fire!
	RegisterDialogue( "OPEN_FIRE", 						"diag_sp_bombardment_TD101_11_01_mcor_pilot1", 		PRIORITY_NORMAL )

	//########################
	// 		  Charge
	//########################

	// Move! Move! Move!
	RegisterDialogue( "MOVE_MOVE_MOVE", 				"diag_sp_bombardment_TD101_08_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// We got IMC Titans! Stay alert!
	RegisterDialogue( "IMC_TITANS_STAY_ALERT", 			"diag_sp_bombardment_TD101_10_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// IMC Titans! Take 'em out!
	RegisterDialogue( "IMC_TITANS_TAKE_EM_OUT", 		"diag_sp_bombardment_TD101_13_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Engage! Engage!
	RegisterDialogue( "ENGAGE_ENGAGE", 					"diag_sp_bigCharge_TD111_01_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Go! Go! Go!
	RegisterDialogue( "GO_GO_GO", 						"diag_sp_bigCharge_TD111_02_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Be advised. We got air support inbound, danger close.
	//RegisterDialogue( "AIR_SUPPORT_INBOUND", 			"diag_sp_bigCharge_TD111_03_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Hit 'em hard! Move! Move!
	RegisterDialogue( "HIT_EM_HARD", 					"diag_sp_bigCharge_TD111_04_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Pick your targets and focus your fire!
	RegisterDialogue( "FOCUS_FIRE", 					"diag_sp_bigCharge_TD111_05_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Take out those Titans! Fire! Fire!
	RegisterDialogue( "TAKE_OUT_THOSE_TITANS", 			"diag_sp_bigCharge_TD111_06_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// We're pushing 'em back! Keep it up!
	RegisterDialogue( "KEEP_IT_UP", 					"diag_sp_bigCharge_TD111_10_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Got a lot of hostiles up ahead...
	RegisterDialogue( "HOSTILES_UP_AHEAD", 				"diag_sp_bigCharge_TD111_11_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Watch for hostile Titanfalls!
	RegisterDialogue( "WATCH_FOR_TITANFALLS", 			"diag_sp_bigCharge_TD111_13_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Sparrow eight, lock targets. Suppressing fire.
	RegisterDialogue( "SARAH_SUPPRESSING_FIRE", 		"diag_sp_bigCharge_TD115_04_01_mcor_sarah", 		PRIORITY_HIGH )

	// Elk Four - Get to that Underground Entrance.
	RegisterDialogue( "SARAH_GET_TO_ENTRANCE", 			"diag_sp_bigCharge_TD115_01_01_mcor_sarah", 		PRIORITY_HIGH )

	// Stork two - Watch your six.
	RegisterDialogue( "SARAH_WATCH_SIX", 				"diag_sp_bigCharge_TD115_02_01_mcor_sarah", 		PRIORITY_HIGH )

	// Keep moving. That ship could take off at any moment.
	RegisterDialogue( "SARAH_KEEP_MOVING", 				"diag_sp_bigCharge_TD115_03_01_mcor_sarah", 		PRIORITY_HIGH )

	// Use your cores, people.
	RegisterDialogue( "SARAH_USE_CORES", 				"diag_sp_bigCharge_TD115_05_01_mcor_sarah", 		PRIORITY_HIGH )

	// Badger six - Take the sideline.
	RegisterDialogue( "SARAH_TAKE_SIDELINE", 			"diag_sp_bigCharge_TD115_06_01_mcor_sarah", 		PRIORITY_HIGH )

	// We got reapers. Elk seven - turn it around.
	RegisterDialogue( "SARAH_WE_GOT_REAPERS", 			"diag_sp_bigCharge_TD115_08_01_mcor_sarah", 		PRIORITY_HIGH )

	// Watch for flanking.
	RegisterDialogue( "SARAH_WATCH_FOR_FLANKING", 		"diag_sp_bigCharge_TD115_09_01_mcor_sarah", 		PRIORITY_HIGH )

	// More IMC Titan's moving in.
	RegisterDialogue( "SARAH_TITANS_MOVING_IN", 		"diag_sp_bigCharge_TD115_10_01_mcor_sarah", 		PRIORITY_HIGH )

	// Let's bring the war to them. Keep moving forward.
	RegisterDialogue( "SARAH_KEEP_MOVING_FORWARD", 		"diag_sp_bigCharge_TD115_11_01_mcor_sarah", 		PRIORITY_HIGH )

	// Elk four. I need you up ahead, now.
	RegisterDialogue( "SARAH_NEED_YOU_UP_AHEAD", 		"diag_sp_bigCharge_TD115_12_01_mcor_sarah", 		PRIORITY_HIGH )

	//########################
	// 	   Charge Deaths
	//########################

	// I'm hit! My hatch is jammed! Noooooo!
	RegisterDialogue( "TITAN_DEATH_HATCH_JAMMED", 		"diag_sp_bigCharge_TD111_07_01_mcor_pilot4", 		PRIORITY_HIGH )

	// Elk nine - Come in. Ugh. Keep moving.
	RegisterDialogue( "SARAH_ELK_NINE_UGH", 			"diag_sp_bigCharge_TD115_07_01_mcor_sarah", 		PRIORITY_HIGH )

	// I need back up! Taking fire taking fire AAAAAAA!!!
	RegisterDialogue( "TITAN_DEATH_NEED_BACKUP", 		"diag_sp_bigCharge_TD111_12_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Shark Two One my weapon's down! Cover me cover [me]
	RegisterDialogue( "TITAN_DEATH_WEAPONS_DOWN", 		"diag_sp_bigCharge_TD111_14_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// I'm hit! Taking major fire from all [sides!]
	RegisterDialogue( "TITAN_DEATH_IM_HIT", 			"diag_sp_bigCharge_TD111_15_01_mcor_pilot3", 		PRIORITY_NORMAL )

	//########################
	// 	   Fuel Storage
	//########################

	// Incoming enemy Titans!
	RegisterDialogue( "INCOMING_ENEMY_TITANS", 			"diag_sp_fuelStorage_TD121_01_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Spread out! Titans at the blast door!
	RegisterDialogue( "TITANS_AT_BLAST_DOOR", 			"diag_sp_fuelStorage_TD121_02_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// We got more IMC! Watch out!
	RegisterDialogue( "MORE_IMC_WATCH_OUT", 			"diag_sp_fuelStorage_TD121_03_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Cooper. You're with me.
	RegisterRadioDialogue( "SARAH_COOPER_WITH_ME", 			"diag_sp_fuelStorage_TD121_04_01_mcor_sarah", 		PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Into the tunnels!
	RegisterRadioDialogue( "SARAH_INTO_THE_TUNNELS", 		"diag_sp_fuelStorage_TD121_05_01_mcor_sarah", 		PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Elk Four, Stork two - Lock this area down.
	RegisterRadioDialogue( "SARAH_LOCK_AREA_DOWN", 			"diag_sp_fuelStorage_TD125_01_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// BT, Pilot Cooper - you're with me. Let's go.
	RegisterRadioDialogue( "SARAH_COOPER_WITH_ME_LETS_GO", 	"diag_sp_fuelStorage_TD125_02_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// We've got to get to that ship before it takes off.
	RegisterRadioDialogue( "SARAH_GET_TO_THAT_SHIP", 		"diag_sp_fuelStorage_TD125_05_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Follow me, there's a lift up ahead.
	RegisterRadioDialogue( "SARAH_LIFT_AHEAD", 				"diag_sp_fuelStorage_TD125_06_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// You still with me, Pilot? The lift's up ahead. Hurry.
	RegisterRadioDialogue( "SARAH_NAG_LIFT_AHEAD", 			"diag_sp_fuelStorage_TD125_09_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Watch out. IMC Titans' up ahead.
	RegisterRadioDialogue( "SARAH_WATCH_OUT_TITANS", 		"diag_sp_fuelStorage_TD125_03_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Go. Go. Go.
	RegisterRadioDialogue( "SARAH_GO_GO_GO", 				"diag_sp_fuelStorage_TD125_11_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Take those Titan's out, Pilot.
	RegisterRadioDialogue( "SARAH_TAKE_THOSE_TITANS_OUT", 	"diag_sp_fuelStorage_TD125_07_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Move it, Pilot. Move it.
	RegisterRadioDialogue( "SARAH_MOVE_IT_PILOT", 			"diag_sp_fuelStorage_TD125_10_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Watch out. We've got more company.
	RegisterRadioDialogue( "SARAH_WATCH_OUT_MORE_COMPANY", 	"diag_sp_fuelStorage_TD125_12_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//##########################
	// Fuel Storage Pilot Kills
	//##########################

	// Nice shot, Pilot Cooper. We need to keep moving.
	RegisterRadioDialogue( "SARAH_NICE_SHOT", 				"diag_sp_fuelStorage_TD125_04_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Good take down, Pilot. Let's keep moving.
	RegisterRadioDialogue( "SARAH_GOOD_TAKE_DOWN", 			"diag_sp_fuelStorage_TD125_08_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//########################
	// 	     Elevator
	//########################

	// C'mon, Coop. Follow me.
	RegisterRadioDialogue( "SARAH_FOLLOW_ME", 				"diag_sp_pilotAndSarah_TD131_11_01_mcor_sarah", 	PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// This way, Cooper.
	RegisterRadioDialogue( "SARAH_THIS_WAY_COOPER", 			"diag_sp_pilotAndSarah_TD131_12_01_mcor_sarah", 	PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// We gotta keep movin, Cooper. Follow me.
	RegisterRadioDialogue( "SARAH_WE_GOTTA_KEEP_MOVIN", 		"diag_sp_pilotAndSarah_TD131_13_01_mcor_sarah", 	PRIORITY_NORMAL, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Here we go. Get ready, Pilot. Going up.
	RegisterRadioDialogue( "SARAH_GOING_UP", 				"diag_sp_pilotAndSarah_TD132_14_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// That was the easy part.
	RegisterRadioDialogue( "SARAH_THAT_WAS_EASY_PART", 		"diag_sp_pilotAndSarah_TD132_15_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Well, you're doing a good job, Cooper. And as far as I'm concerned, you've earned your pilot certification.
	RegisterRadioDialogue( "SARAH_ELEVATOR_TALK1", 			"diag_sp_pilotAndSarah_TD132_17_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Now let's finish this thing and get home.
	RegisterRadioDialogue( "SARAH_ELEVATOR_TALK2", 			"diag_sp_pilotAndSarah_TD132_18_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//########################
	// 	   	   VTOL
	//########################

	// There she is. We still have time to intercept the Ark.
	RegisterRadioDialogue( "SARAH_THERES_THE_ARK", 			"diag_sp_refueling_TD139_01_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Move. Move. Incoming hostiles.
	RegisterDialogue( "SARAH_MOVE_INCOMING_HOSTILES", 	"diag_sp_refueling_TD139_02_01_mcor_sarah", 	PRIORITY_NORMAL )

	// We're closing on the Draconis. Keep going.
	RegisterRadioDialogue( "SARAH_CLOSING_IN_ON_DRACONIS", 	"diag_sp_refueling_TD141_13_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Keep pushing forward. We cannot let the Ark leave on that ship.
	RegisterRadioDialogue( "SARAH_KEEP_PUSHING_FORWARD", 	"diag_sp_refueling_TD139_04_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Nice shooting - Keep moving.
	RegisterDialogue( "SARAH_NICE_SHOOTING", 			"diag_sp_refueling_TD139_05_01_mcor_sarah", 	PRIORITY_NORMAL )

	//########################
	// 	  VTOL Friendlies
	//########################

	// Back up. I need back up. Aaaaaaah.
	RegisterDialogue( "TITAN_DEATH_NED_BACKUP_AHH", 	"diag_sp_refueling_TD141_02_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Standby for Titanf-- (explosion)
	RegisterDialogue( "TITAN_DEATH_STANDBY", 			"diag_sp_refueling_TD141_05_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// We're going down.
	RegisterDialogue( "TITAN_DEATH_GOING_DOWN", 		"diag_sp_refueling_TD141_06_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// I got one.  ....NO.
	RegisterDialogue( "TITAN_DEATH_I_GOT_ONE", 			"diag_sp_refueling_TD141_08_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Friendly down.
	RegisterDialogue( "TITAN_DEATH_FRIENDLY_DOWN", 		"diag_sp_refueling_TD141_10_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Eject. Eject.
	RegisterDialogue( "TITAN_DEATH_EJECT_EJECT", 		"diag_sp_refueling_TD141_11_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// We're taking hits. We're surrounded.
	RegisterDialogue( "TAKING_HITS_SURROUNDED", 		"diag_sp_refueling_TD141_01_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// [we got] IMC coming up from the east.
	RegisterDialogue( "IMC_COMING_FROM_EAST", 			"diag_sp_refueling_TD141_03_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Owl Twelve - taking heavy damage.
	RegisterDialogue( "TAKING_HEAVY_DAMAGE", 			"diag_sp_refueling_TD141_07_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// We got incoming IMC Titans. Repeat. Incoming...
	RegisterDialogue( "INCOMING_IMC_TITANS", 			"diag_sp_refueling_TD141_09_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Militia Forces, Arm up.
	RegisterDialogue( "MILITIA_FORCES_ARM_UP", 			"diag_sp_refueling_TD141_12_01_mcor_pilot3", 		PRIORITY_NORMAL )

	//########################
	// 	 Fire On The Runway
	//########################

	// We just lost Sparrow 8...
	RegisterDialogue( "FRIENDLY_TITAN_WE_LOST_SPARROW", 		"diag_sp_runway_TD151_06_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Cardinal Two is down.
	RegisterDialogue( "FRIENDLY_TITAN_CARDINAL_DOWN", 			"diag_sp_runway_TD151_07_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// They're picking us off one by one.
	RegisterDialogue( "FRIENDLY_TITAN_PICKING_US_OFF", 			"diag_sp_runway_TD151_08_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Cardinal Three Seven, coming up the side.
	RegisterDialogue( "FRIENDLY_TITAN_COMING_UP_SIDE", 			"diag_sp_runway_TD151_02_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Cardinal Three Two, I got a lock. Taking the shot.
	RegisterDialogue( "FRIENDLY_TITAN_TAKING_SHOT", 			"diag_sp_runway_TD151_03_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// Splash...no effect on target. There's just too many of them.
	RegisterDialogue( "FRIENDLY_TITAN_TOO_MANY_OF_THEM", 		"diag_sp_runway_TD151_04_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Sparrow 8 - Watch your six.
	RegisterDialogue( "FRIENDLY_TITAN_WATCH_SIX", 				"diag_sp_runway_TD151_05_01_mcor_pilot1", 		PRIORITY_NORMAL )

	// Move. Move.
	RegisterDialogue( "FRIENDLY_TITAN_MOVE_MOVE", 				"diag_sp_runway_TD151_09_01_mcor_pilot2", 		PRIORITY_NORMAL )

	// They're hitting us bad.
	RegisterDialogue( "FRIENDLY_TITAN_HITTING_US_BAD", 			"diag_sp_runway_TD151_10_01_mcor_pilot3", 		PRIORITY_NORMAL )

	// Their escort is here. We don't have much time.
	RegisterRadioDialogue( "SARAH_ESCORT_IS_HERE", 				"diag_sp_runway_TD151_11_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// They're powering up.
	RegisterDialogue( "FRIENDLY_TITAN_POWERING_UP", 			"diag_sp_runway_TD151_15_01_mcor_pilot2", 		PRIORITY_HIGH )

	// Final launch checks complete. All systems go.
	RegisterDialogue( "IMC_PILOT_LAUNCH_CHECKS_COMPLETE", 		"diag_sp_runway_TD151_12_01_imc_olaPA", 		PRIORITY_HIGH )

	// They're taking off. We need to get to that ship.
	RegisterRadioDialogue( "SARAH_THEYRE_TAKING_OFF", 			"diag_sp_runway_TD151_13_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Move. Don't let them get away.
	RegisterDialogue( "FRIENDLY_TITAN_DONT_LET_THEM", 			"diag_sp_runway_TD151_14_01_mcor_pilot1", 		PRIORITY_HIGH )

	// They're getting away.
	RegisterDialogue( "FRIENDLY_TITAN_GETTING_AWAY", 			"diag_sp_runway_TD151_16_01_mcor_pilot3", 		PRIORITY_HIGH )

	// All Militia Forces, move in on the Draconis.
	RegisterRadioDialogue( "SARAH_MIL_FORCES_MOVE_IN", 			"diag_sp_refueling_TD141_14_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// The Draconis is almost fueled. Move. Move.
	RegisterRadioDialogue( "SARAH_ALMOST_FUELED", 				"diag_sp_refueling_TD141_15_01_mcor_sarah", 	PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Let’s go Pilot, we have no other options. We NEED to catch that ship.
	RegisterRadioDialogue( "SARAH_CATCH_THAT_SHIP", 			"diag_sp_runway_TD151_17_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	//########################
	// 	    OLA Launch
	//########################

	// Don't let them get away. Get to that ramp.
	RegisterRadioDialogue( "SARAH_GET_TO_RAMP", 				"diag_sp_launch_TD161_04_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Blisk, this is Slone. The Ark is headed your way. I'll let Viper take it from here. See you soon...
	RegisterDialogue( "SLONE_ARC_HEADED_YOUR_WAY", 				"diag_sp_launch_TD161_01_01_imc_slone", 		PRIORITY_HIGH )

	// Move it. We got 'em, Cooper!
	RegisterRadioDialogue( "SARAH_WE_GOT_EM_COOPER", 			"diag_sp_launch_TD161_03_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// This is it! This is for the Frontier.
	//RegisterRadioDialogue( "SARAH_FOR_THE_FRONTIER", 			"diag_sp_launch_TD161_05_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )

	// Get to a ship. We're going after 'em.
	RegisterRadioDialogue( "SARAH_GOING_AFTER_THEM", 			"diag_sp_launch_TD161_02_01_mcor_sarah", 		PRIORITY_HIGH, "#NPC_SARAH_NAME", TEAM_MILITIA )
}



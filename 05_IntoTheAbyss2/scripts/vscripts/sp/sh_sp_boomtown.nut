
global function InitBoomtownDialogue

void function InitBoomtownDialogue()
{
	switch( GetMapName() )
	{
		case "sp_boomtown":

			// --------------------------
			// HOSE CAVES
			// --------------------------

			// Pilot... Pilot... I need assistance...
			RegisterRadioDialogue( "BT_I_NEED_ASSISTANCE",		"diag_sp_assembly_BM164_01_01_mcor_bt", 		PRIORITY_HIGH,	"#NPC_BT_NAME", 	TEAM_MILITIA )

			// Looks like the automated security in this place has picked up a Titan.
			RegisterDialogue( "GRUNT1_PICKED_UP_TITAN",			"diag_sp_assembly_BM164_02_01_imc_grunt1", 		PRIORITY_NORMAL )

			// Heh. Less work for us.
			RegisterDialogue( "GRUNT2_LESS_WORK_FOR_US",		"diag_sp_assembly_BM164_03_01_imc_grunt1", 		PRIORITY_NORMAL )

			// *Static* Pilot....I am being taken down an assembly line. <There> may be a common exit. <I> recommend <you> follow the flow of the platforms...*Static*
			RegisterRadioDialogue( "BT_ASSEMBLY_LINE",			"diag_sp_assembly_BM160_06_01_mcor_bt", 		PRIORITY_HIGH,	"#NPC_BT_NAME", 	TEAM_MILITIA )

			// I can see IMC infantry scattered throughout this facility. Be careful, Pilot.
			RegisterRadioDialogue( "BT_BE_CAREFUL_PILOT",		"diag_sp_assembly_BM162a_01_01_mcor_bt", 		PRIORITY_HIGH,	"#NPC_BT_NAME", 	TEAM_MILITIA )

			// --------------------------
			// ASSEMBLY
			// --------------------------

			RegisterRadioDialogue( "ASH_RADIO_ASSEMBLY_01",	"diag_sp_assembly_BM162_01_01_imc_ash", 		PRIORITY_HIGH,	"#BOSSNAME_ASH", 	TEAM_IMC, true ) 		// Ash to Blisk. I have Vanguard-class Titan, what would you like me to do with it?
			RegisterRadioDialogue( "BLISK_RADIO_ASSEMBLY_02","diag_sp_assembly_BM162_02_01_imc_blisk", 		PRIORITY_HIGH,	"#BOSSNAME_BLISK", 	TEAM_IMC, true ) 		// I don’t bloody care. Destroy it. What about its Pilot?
			RegisterRadioDialogue( "ASH_RADIO_ASSEMBLY_03",	"diag_sp_assembly_BM162_03_01_imc_ash", 		PRIORITY_HIGH,	"#BOSSNAME_ASH", 	TEAM_IMC, true ) 		// He is being dealt with. This station is equipped-- (cut off)
			RegisterRadioDialogue( "BLISK_RADIO_ASSEMBLY_04", "diag_sp_assembly_BM162_04_01_imc_blisk", 	PRIORITY_HIGH,	"#BOSSNAME_BLISK", 	TEAM_IMC, true ) 		// Oy! We are not the IMC, we are mercenaries! You are not there to run that facility, eh! Scuttle that place up if you have to. Blisk out.

			// I see you, Pilot
			RegisterDialogue( "ASH_TOWN_CLIMB_ENTRY_1",	"diag_sp_townClimb_BM171_03a_04_imc_ash",	PRIORITY_HIGH )

			// I admire your perseverance. If only the IMC infantry were as dedicated.
			RegisterDialogue( "ASH_TOWN_CLIMB_ENTRY_2",	"diag_sp_townClimb_BM171_09a_01_imc_ash",	PRIORITY_HIGH )

			// Only one way out Pilot… up.
			RegisterDialogue( "ASH_TOWN_CLIMB_ENTRY_3", 	"diag_sp_townClimb_BM171_05a_01_imc_ash",	PRIORITY_HIGH )

			// The dome is still waiting. Rest assured I will not execute you summarily. You have my word.
			RegisterDialogue( "ASH_DOME_STILL_WAITING", 	"diag_sp_townClimb_BM171_09_01_imc_ash",	PRIORITY_HIGH )


			// Pilot. This facility is extremely dangerous, watch for crushing hazards on the assembly line.
			RegisterRadioDialogue( "BT_ASSEMBLY_LINE_DANGEROUS",	"diag_sp_assembly_BM162a_02_01_mcor_bt", 		PRIORITY_HIGH,	"#NPC_BT_NAME", 	TEAM_MILITIA )

			// Impressive, Pilot. You made it all this way alive. Unfortunately for you, there is only one way out. Step onto a moving platform.
			RegisterDialogue( "ASH_DOME_AWAITS_YOU", 	"diag_sp_townClimb_BM171_03a_03_imc_ash", 		PRIORITY_NORMAL )

			// Step onto a moving platform, Pilot.
			RegisterDialogue( "ASH_NAG_ENTER_DOME_1", 	"diag_sp_townClimb_BM171_03c_01_imc_ash", 		PRIORITY_NORMAL )

			// Only one way out Pilot… Please, step onto a platform below.
			RegisterDialogue( "ASH_NAG_ENTER_DOME_2", 	"diag_sp_townClimb_BM171_05b_01_imc_ash", 		PRIORITY_NORMAL )

			// There is only one way out. I will hold a platform for you if you require more time.
			RegisterDialogue( "ASH_NAG_ENTER_DOME_3", 	"diag_sp_townClimb_BM171_08_01_imc_ash", 		PRIORITY_NORMAL )

			// Well done, Pilot. I will take it from here.
			RegisterDialogue( "ASH_TAKE_IT_FROM_HERE", 	"diag_sp_townClimb_BM171_09b_01_imc_ash", 	PRIORITY_NORMAL )

			// Very disappointing. I expected so much more of you.
			RegisterDialogue( "ASH_DISAPPOINTING", 	"diag_sp_boomExtra_BM112_27_01_imc_ash_alt", 		PRIORITY_NORMAL )

			// Pilot, scans indicate the dome above is your best course of action to find an exit. I recommend getting there by any means neccessary.
			RegisterRadioDialogue( "BT_ANY_MEANS_NECCESSARY",	"diag_sp_townClimb_BM171_11_01_mcor_bt", 	PRIORITY_HIGH,		"#NPC_BT_NAME", 	TEAM_MILITIA )

			// --------------------------
			// ASSEMBLY GRUNT CONTEXT
			// --------------------------

			// He's on the platform!
			RegisterDialogue( "GRUNT_HES_ON_PLATFORM", 		"diag_sp_assembly_BM163_01_01_imc_grunt1", PRIORITY_NO_QUEUE )

			// Get him before he gets further down the assembly!
			RegisterDialogue( "GRUNT_GET_HIM", 				"diag_sp_assembly_BM163_02_01_imc_grunt2", PRIORITY_NO_QUEUE )

			// Watch out! He's movin' quick on the converyor!
			RegisterDialogue( "GRUNT_ON_CONVEYOR", 			"diag_sp_assembly_BM163_03_01_imc_grunt1", PRIORITY_NO_QUEUE )

			// There's no way he's going to survive out there, but kill him anyway!
			RegisterDialogue( "GRUNT_KILL_HIM_ANYWAY", 		"diag_sp_assembly_BM163_04_01_imc_grunt2", PRIORITY_NO_QUEUE )

			// That platform's moving outa reach! Gamma two - Take him out!
			RegisterDialogue( "GRUNT_MOVING_OUTA_REACH", 	"diag_sp_assembly_BM163_05_01_imc_grunt1", PRIORITY_NO_QUEUE )

			// Pilot spotted on moving platform! Get him before he escapes!
			RegisterDialogue( "GRUNT_BEFORE_HE_ESCAPES", 	"diag_sp_assembly_BM163_06_01_imc_grunt2", PRIORITY_NO_QUEUE )



			// --------------------------
			// PA System
			// --------------------------
			RegisterDialogue( "PA_LoadScenarioStart" ,"diag_sp_ReaperTown_BM102_01a_01_imc_facilityPA",		PRIORITY_NORMAL ) 	// Loading scenario 127 in Dynamic Simulation Dome 314.
			RegisterDialogue( "PA_ScenarioLoadComplete" ,"diag_sp_ReaperTown_BM102_03a_01_imc_facilityPA", 	PRIORITY_NORMAL ) 	// Scenario 127 load complete.
			RegisterDialogue( "PA_ScenarioInfo" ,"diag_sp_ReaperTown_BM102_04a_01_imc_facilityPA", 			PRIORITY_NORMAL ) 	// Intiating IMC Reaper Test Scenario - Beta
			RegisterDialogue( "PA_DeployMilitia" ,"diag_sp_ReaperTown_BM102_06a_01_imc_facilityPA",			PRIORITY_NORMAL ) 	// Delivering Militia test subjects.
			RegisterDialogue( "PA_DeployAnotherReaper" ,"diag_sp_ReaperTown_BM102_22a_01_imc_facilityPA", 	PRIORITY_NORMAL ) 	// Deploying additional Reaper to test scenario.


			// --------------------------
			// Ash
			// --------------------------
			RegisterDialogue( "ASH_WelcomePilot" ,"diag_sp_ReaperTown_BM102_02_01_imc_ash", 				PRIORITY_HIGH ) 	// Welcome, Pilot. Let us see how impressive you truly are.
			RegisterDialogue( "ASH_DeploySpectresWarmUp", "diag_sp_ReaperTown_BM102_10a_01_imc_ash", 		PRIORITY_HIGH )  	//	Let us begin... Deploying Spectres.
			RegisterDialogue( "ASH_DeployMultipleReapers" ,"diag_sp_ReaperTown_BM102_20a_02_imc_ash",		PRIORITY_HIGH ) 	// Your tactics are impressive. I'm sure the IMC won't mind if I deploy a few more units.
			RegisterDialogue( "ASH_ThanksPilot", "diag_sp_ReaperTown_BM102_23a_02_imc_ash", 				PRIORITY_HIGH ) 	//	The IMC really ought to thank me for helping make the Reaper more effective. Perhaps I'll have to renegotiate my contract.
			RegisterDialogue( "ASH_Should_Have_Died", "diag_sp_ReaperTown_BM102_25a_01_imc_ash", 			PRIORITY_HIGH ) 	//	How strange... This is taking longer than expected. You should have died by now.
			RegisterRadioDialogue( "ASH_ToKappa_ReportToDome", "diag_sp_ReaperTown_BM102_27a_01_imc_ash", 	PRIORITY_HIGH,	"#BOSSNAME_ASH", 	TEAM_IMC, true ) 	// Kappa One, report to Dome 3-1-4 immediately. Objective - destroy the Militia Pilot. How copy, over.
			RegisterDialogue( "ASH_EliminatePilot" ,"diag_sp_ReaperTown_BM102_35_01_imc_ash", 				PRIORITY_HIGH ) 	// Kappa One, eliminate the militia Pilot. You are cleared to engage.
			RegisterDialogue( "ASH_DeployMoreIMC", "diag_sp_ReaperTown_BM102_24a_01_imc_ash", 				PRIORITY_HIGH ) 	//	Let's make this a little more interesting.
			RegisterDialogue( "ASH_TimeToEndThis", "diag_sp_ReaperTown_BM102_34_01_imc_ash", 				PRIORITY_HIGH ) 	// I admire your perseverance, but it's time to end this.
			RegisterDialogue( "ASH_Im_Coming_Down", "diag_sp_ReaperTown_BM102_39_01_imc_ash", 				PRIORITY_HIGH ) 	// As I should have expected, the IMC infantry clearly lack your resolve. Perhaps I have no choice but to step in personally. A rare miscalculation on my part.



			// --------------------------
			// Militia Grunts
			// --------------------------
			RegisterDialogue( "GRUNT1_ArmUp" ,"diag_sp_ReaperTown_BM102_07_01_mcor_grunt1", 				PRIORITY_NORMAL ) 	// It's another test. Arm up!
			RegisterDialogue( "GRUNT2_BarelySurvivedBefore" ,"diag_sp_ReaperTown_BM102_08_01_mcor_grunt2", 	PRIORITY_NORMAL ) 	// We barely survived the last one!
			RegisterDialogue( "GRUNT3_ShutUpGrabGun" ,"diag_sp_ReaperTown_BM102_09_01_mcor_grunt3", 		PRIORITY_NORMAL ) 	// Shut up and grab a gun!
			RegisterDialogue( "GRUNT1_EyesForward" ,"diag_sp_ReaperTown_BM103_02a_01_mcor_grunt1", 			PRIORITY_NORMAL ) 	// Keep it together. Stay in formation. Eyes forward!
			RegisterDialogue( "GRUNT2_SpectresOpenFire" ,"diag_sp_ReaperTown_BM102_12_01_mcor_grunt2", 		PRIORITY_NORMAL ) 	// Spectres, straight ahead!  Open fire!
			RegisterDialogue( "GRUNT3_WhatIsThat" ,"diag_sp_ReaperTown_BM102_15_01_mcor_grunt3", 			PRIORITY_NORMAL ) 	// What the hell is that?!
			RegisterDialogue( "GRUNT2_ItsAReaper" ,"diag_sp_ReaperTown_BM102_16_01_mcor_grunt2", 			PRIORITY_NORMAL ) 	// I think that's a Reaper! Shoot it!
			RegisterDialogue( "GRUNT2_LookOut" ,"diag_sp_ReaperTown_BM102_18_01_mcor_grunt2", 				PRIORITY_NORMAL ) 	// Look out!
			RegisterDialogue( "GRUNT3_Aaaaah" ,"diag_sp_ReaperTown_BM102_19_01_mcor_grunt3", 				PRIORITY_NORMAL ) 	// Aaaaaaaah!!!
			RegisterDialogue( "GRUNT2_APilot", "diag_sp_ReaperTown_BM103_01a_01_mcor_grunt2", 				PRIORITY_NORMAL )  	// Look! A Pilot! Now the odds are in our favor.
			RegisterDialogue( "GRUNT1_AimSharp", "diag_sp_ReaperTown_BM102_11_01_mcor_grunt1", 				PRIORITY_NORMAL )  	// Nothing about this is in our favor. Aim sharp!


			// --------------------------
			// IMC Breach Squad
			// --------------------------
			RegisterRadioDialogue( "IMC_CAPTAIN_MovingToDome", "diag_sp_ReaperTown_BM102_28a_01_imc_gcaptain", 	PRIORITY_NORMAL, "#NPC_DARNO_NAME", TEAM_IMC, true )   // Solid copy.  Proceeding to dome 314.
			RegisterRadioDialogue( "IMC_CAPTAIN_InPosition", "diag_sp_ReaperTown_BM102_29a_01_imc_gcaptain", 	PRIORITY_NORMAL, "#NPC_DARNO_NAME", TEAM_IMC, true  )  // Kappa One in position.  Awaiting orders to proceed.
			RegisterRadioDialogue( "IMC_CAPTAIN_BreachPrep" ,"diag_sp_ReaperTown_BM102_31_01_imc_gcaptain", 	PRIORITY_NORMAL, "#NPC_DARNO_NAME", TEAM_IMC, true  )  // Acknowledged. Squad, prepare for dome breach!

			// --------------------------
			// BT
			// --------------------------
			RegisterRadioDialogue( "BT_VideoEstablished" ,"diag_sp_ReaperTown_BM102_24b_07_mcor_bt", 			PRIORITY_HIGH, "#NPC_BT_NAME", TEAM_MILITIA )	// Pilot-to-Titan video feed re-established. Cooper, the houses contain weapon caches. I saw them being loaded on the assembly line.
			RegisterRadioDialogue( "BT_ExitThruWall" ,"diag_sp_ReaperTown_BM102_38_01_mcor_bt", 				PRIORITY_HIGH, "#NPC_BT_NAME", TEAM_MILITIA )	// Cooper, I have detected an opening in the outer wall. You should get out of there while you can. Marking your HUD.
			break


	case "sp_boomtown_end":

			// --------------------------
			// BT
			// --------------------------
			RegisterRadioDialogue( "BT_AboveDome_DoYouRead", "diag_sp_aboveDome_BM121_02_01_mcor_bt", 	PRIORITY_HIGH, "#NPC_BT_NAME", TEAM_MILITIA ) 	// Pilot. <static> <static> Do you read? <static> Pilot Cooper.
			RegisterRadioDialogue( "BT_AboveDome_UnderAttack", "diag_sp_aboveDome_BM121_03_01_mcor_bt", PRIORITY_HIGH, "#NPC_BT_NAME", TEAM_MILITIA )	// I am <static> under attack. <static> Assistance required.
			RegisterDialogue( "BT_ExitAhead" ,"diag_sp_jumbleRun_BM181_03_03_mcor_bt", 					PRIORITY_HIGH )									// Pilot, I detect an exit beyond this dome. Check your HUD.
			RegisterDialogue( "BT_DangerousEnv" ,"diag_sp_jumbleRun_BM181_04_01_mcor_bt", 				PRIORITY_HIGH )									// This is a highly dangerous environment.  I suggest you embark, Pilot!
			RegisterDialogue( "BT_ExitThruTunnel" ,"diag_sp_jumbleRun_BM182_07_01_mcor_bt", 			PRIORITY_HIGH )									// Pilot, the security lockdown has been disengaged. I recommend we leave through the tunnel.
			RegisterDialogue( "BT_NoMoreShortcuts" ,"diag_sp_jumbleRun_BM182_08_01_mcor_bt", 			PRIORITY_HIGH )									// Pilot, I have concluded we should take no further shortcuts.


			// --------------------------
			// BLISK & ASH Radio Intercept
			// --------------------------
			RegisterRadioDialogue( "BLISK_Intro_01" ,"diag_sp_ReaperTown_BM102_38a_01_imc_blisk", 	PRIORITY_HIGH, "#BOSSNAME_BLISK", 	TEAM_IMC, true )		// Ash - this is Blisk, tell me that Pilot has been taken care of, eh!
			RegisterRadioDialogue( "ASH_Intro_01" ,"diag_sp_ReaperTown_BM102_38a_02_imc_ash", 		PRIORITY_HIGH, "#BOSSNAME_ASH", 	TEAM_IMC, true )		// It will not be long, I have separated him from the Titan. He will not survive alone.
			RegisterRadioDialogue( "BLISK_Intro_02" ,"diag_sp_convo_BM201_01_01_imc_blisk", 		PRIORITY_HIGH, "#BOSSNAME_BLISK", 	TEAM_IMC, true )		// Stop - toying - with him. Get the job done - now.
			RegisterRadioDialogue( "ASH_Intro_02" ,"diag_sp_convo_BM201_02_01_imc_ash", 			PRIORITY_HIGH, "#BOSSNAME_ASH", 	TEAM_IMC, true )		// As you wish, Blisk. I'll take care of it personally.
			RegisterRadioDialogue( "BLISK_Intro_03" ,"diag_sp_convo_BM201_03_01_imc_blisk", 		PRIORITY_HIGH, "#BOSSNAME_BLISK", 	TEAM_IMC, true )		// Stop - toying - with him. Get the job done - now.
			RegisterRadioDialogue( "ASH_Intro_03" ,"diag_sp_convo_BM201_04a_01_imc_ash", 			PRIORITY_HIGH, "#BOSSNAME_ASH", 	TEAM_IMC, true )		// As you wish, Blisk. I'll take care of it personally.
			RegisterRadioDialogue( "BLISK_Intro_04" ,"diag_sp_convo_BM201_04_01_imc_blisk", 		PRIORITY_HIGH, "#BOSSNAME_BLISK", 	TEAM_IMC, true )		// Don’t worry - with the price I’m putting on his head, you can buy all the toys you want.
			RegisterRadioDialogue( "ASH_Intro_04" ,"diag_sp_convo_BM201_04a_02_imc_ash", 			PRIORITY_HIGH, "#BOSSNAME_ASH", 	TEAM_IMC, true )		// All units, this is Ash. This facility no longer serves our needs. I suggest you evacuate now.

			break
	}
}


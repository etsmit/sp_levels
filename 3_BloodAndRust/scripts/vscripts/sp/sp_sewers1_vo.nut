global function Sewers1_VO_Init

void function Sewers1_VO_Init()
{
	// --------------------------
	// INTRO
	// --------------------------
	RegisterDialogue( "BT_Intro_01", "diag_sp_extra_GB101_66_01_mcor_bt", PRIORITY_HIGH )  // Pilot, the IMC will continue to search for us. Our only chance of survival is to rendezvous with Major Anderson 60 klicks from our current location.
	RegisterDialogue( "BT_Intro_02", "diag_sp_extra_GB101_69_01_mcor_bt", PRIORITY_HIGH )  // We have a long jouney through unknown enemy occupied territory.
	RegisterDialogue( "BT_Intro_03", "diag_sp_extra_GB101_73_01_mcor_bt", PRIORITY_HIGH )  // We will have to improvise and adapt if we wish to survive.
	RegisterDialogue( "BT_SLUDGE_WARN", "diag_sp_mortarRun_SE101_14_01_mcor_bt", PRIORITY_NORMAL )  // Be careful, Pilot.  This toxic sludge appears corrosive to organic life.
	RegisterDialogue( "BT_SLUDGE_WARN_EMBARK", "diag_sp_mortarRun_SE101_15_01_mcor_bt", PRIORITY_NORMAL )  // Pilot, this toxic sludge appears corrosive to organic life.  I advise you embark into the cockpit.
	RegisterDialogue( "BT_TONE_INTRO", "diag_sp_extra_GB101_37_01_mcor_bt", PRIORITY_NORMAL )

	RegisterRadioDialogue( "MILITIA_RADIO_1", "diag_sp_mortarRun_SE101_02_01_mcor_grunt1", PRIORITY_HIGH, "#NPC_FREEBORN_NAME", TEAM_MILITIA ) // *Static* This is Wombat 3-2. We're taking heavy casualties down here! Any Militia forces, please assist! *Static*
	RegisterRadioDialogue( "MILITIA_RADIO_2", "diag_sp_mortarRun_SE101_03_01_mcor_grunt2", PRIORITY_HIGH, "#NPC_FREEBORN_NAME", TEAM_MILITIA )  // *Static* We've suffered 95% losses! *Static*
	RegisterRadioDialogue( "FREEBORN_GOT_A_FRIENDLY", "diag_sp_mortarRun_SE108_01_01_mcor_grunt1", PRIORITY_HIGH, "#NPC_FREEBORN_NAME", TEAM_MILITIA ) // We got a friendly Vanguard class Titan.
	RegisterRadioDialogue( "SHAVER_IS_IT_BT", "diag_sp_mortarRun_SE108_02_01_mcor_grunt2", PRIORITY_HIGH, "#NPC_SHAVER_NAME", TEAM_MILITIA ) // Is that BT?
	RegisterRadioDialogue( "SHAVER_USE_YOUR_HELP", "diag_sp_mortarRun_SE108_03_01_mcor_grunt3", PRIORITY_HIGH, "#NPC_SHAVER_NAME", TEAM_MILITIA ) // Good to see you, Captain. We could use some help.
	RegisterRadioDialogue( "FREEBORN_THANKS_FOR_ASSIST", "diag_sp_mortarRun_SE108_04_01_mcor_grunt1", PRIORITY_HIGH, "#NPC_FREEBORN_NAME", TEAM_MILITIA ) // Thanks for the assists, sir. We'll secure this area.
	RegisterRadioDialogue( "SHAVER_THANKS_FOR_ASSIST", "diag_sp_mortarRun_SE108_04_01_mcor_grunt1", PRIORITY_HIGH, "#NPC_SHAVER_NAME", TEAM_MILITIA ) // Thanks for the assists, sir. We'll secure this area.
	RegisterDialogue( "IMC_SEND_TITANS", "diag_sp_mortarRun_SE101_18_01_imc_grunt3", PRIORITY_NO_QUEUE )  // Send heavy titan reinforcements now!
	RegisterDialogue( "IMC_REPORT_TITAN", "diag_sp_mortarRun_SE101_19_01_imc_grunt1", PRIORITY_NO_QUEUE )  // We have eyes on a Militia Titan entering the Reclamation Facility!
	RegisterDialogue( "IMC_WARN_GAMMA_SQUAD", "diag_sp_mortarRun_SE101_20_01_imc_grunt2", PRIORITY_NO_QUEUE )  // Gamma squad - Militia Titan headed your way! It's a Vanguard-class.


	// --------------------------
	// SEWER SPLIT
	// --------------------------
	RegisterDialogue( "IMC_TITAN_SUPPRESSED_US", "diag_sp_sewerSplit_SE111_01_01_imc_grunt1", PRIORITY_NO_QUEUE )  // The titan has us suppressed!  Does anyone have eyes on the pilot?!
	RegisterDialogue( "IMC_GAMMA_SQUAD_DEAD", "diag_sp_sewerSplit_SE111_02_01_imc_grunt2", PRIORITY_NO_QUEUE )  // They took out Gamma squad!  Call for reinforcements!
	RegisterDialogue( "IMC_TITAN_IN_DRAIN", "diag_sp_sewerSplit_SE111_03_01_imc_pilot", PRIORITY_NO_QUEUE )  // Blisk, we have an enemy Titan near the south storm drains. Requesting support.
	RegisterDialogue( "IMC_TITAN_WEAPONS_FREE", "diag_sp_sewerSplit_SE109_01_01_imc_pilot1", PRIORITY_NO_QUEUE ) // Militia Titan. Weapons free!
	RegisterDialogue( "IMC_TITAN_ROGER_ENGAGING", "diag_sp_sewerSplit_SE109_02_01_imc_pilot2", PRIORITY_NO_QUEUE ) // Roger. Engaging hostile Titan.
	RegisterDialogue( "BT_FIND_GATE_CONTROL", "diag_sp_sewerSplit_SE111_04_01_mcor_bt", PRIORITY_NO_QUEUE )  // Pilot, our path through this facility is blocked by a Flow Regulation Gate. There should be a control interface nearby.
	RegisterDialogue( "PA_OPEN_GATE", "diag_sp_sewerSplit_SE111_06_01_imc_facilityPA", PRIORITY_NO_QUEUE )  // Maintenance override engaged. Activating safety airlock procedures.
	RegisterDialogue( "PA_TOXIC_FUMES", "diag_sp_sewerSplit_SE111_06b_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Warning. Toxic fumes dispersing in main chamber.
	RegisterDialogue( "PA_AIRLOCK_ENGAGED", "diag_sp_sewerSplit_SE111_06a_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Activating control room safety airlock procedures.


	// --------------------------
	// SLUDGE FALLS
	// --------------------------
	RegisterRadioDialogue( "BT_HELP_MILITIA", "diag_sp_extra_SE812_01_01_mcor_bt", PRIORITY_NO_QUEUE, "#NPC_BT_NAME", TEAM_MILITIA )  // Pilot, I am detecting friendly Militia forces along your path. They may need assistance.
	RegisterDialogue( "IMC_CONV_01_A", "diag_sp_sludgeFalls_SE121_01_01_imc_grunt1", PRIORITY_LOW )  // Hey, what's up with that mercenary?  He's gotta be hopped up on something.
	RegisterDialogue( "IMC_CONV_01_B", "diag_sp_sludgeFalls_SE121_02_01_imc_grunt2", PRIORITY_LOW )  // Best to just stay away from him, mate.  Kane's bloody unpredictable.
	RegisterDialogue( "IMC_CONV_01_C", "diag_sp_sludgeFalls_SE121_03_01_imc_grunt1", PRIORITY_LOW )  // Roger.  That Merc doesn't care who he kills.


	// --------------------------
	// CORKSCREW ROOM
	// --------------------------
	RegisterRadioDialogue( "MILITIA_CORKSCREW_RADIOINTERCEPT_01", "diag_sp_corkscrew_SE130_01_01_mcor_grunt1", PRIORITY_NO_QUEUE, "#NPC_BABB_NAME", TEAM_MILITIA ) // This is Racoon three. 9th Militia Fleet. We're held up in the Reclamation facility.
	RegisterRadioDialogue( "MILITIA_CORKSCREW_RADIOINTERCEPT_02", "diag_sp_corkscrew_SE130_02_01_mcor_grunt1", PRIORITY_NO_QUEUE, "#NPC_BABB_NAME", TEAM_MILITIA ) // The IMC have some new mechanized infantry. We're trapped.
	RegisterRadioDialogue( "MILITIA_CORKSCREW_RADIOINTERCEPT_03", "diag_sp_corkscrew_SE130_03_01_mcor_grunt1", PRIORITY_NO_QUEUE, "#NPC_BABB_NAME", TEAM_MILITIA ) // Repeat... New mechanized infantry --Fire!
	RegisterDialogue( "MILITIA_SEE_SOMETHING_MOVING", "diag_sp_corkscrew_SE130_04_01_mcor_grunt1", PRIORITY_NORMAL ) // Captain, I see something moving by the pipes. Eyes up!
	RegisterDialogue( "MILITIA_GOT_A_PILOT", "diag_sp_corkscrew_SE131_02_01_mcor_grunt1", PRIORITY_NORMAL )  // A Pilot! Captain, we got a Pilot.
	RegisterDialogue( "MILITIA_HES_SRS", "diag_sp_corkscrew_SE131_03_01_mcor_grunt2", PRIORITY_NORMAL )  // He's SRS! Look at his helmet!
	RegisterDialogue( "MILITIA_GOOD_TO_SEE_PILOT", "diag_sp_corkscrew_SE130_05_01_mcor_grunt1", PRIORITY_NORMAL ) // Good to see a friendly Pilot, sir. Our squad has taken a beatin'. They could use some help up ahead. Luis...
	RegisterDialogue( "MILITIA_REINFORCEMENTS_ON_SIX", "diag_sp_corkscrew_SE131_19_01_mcor_grunt1", PRIORITY_NO_QUEUE )  // Reinforcements on your six!
	RegisterDialogue( "MILITIA_ABOUT_TIME", "diag_sp_corkscrew_SE131_20_01_mcor_grunt4", PRIORITY_NO_QUEUE )  // About time!
	RegisterDialogue( "MILITIA_KEEP_FIRING_SHORT", "diag_sp_corkscrew_SE131_21_01_mcor_grunt1", PRIORITY_NO_QUEUE )  // Keep firing!
	RegisterDialogue( "MILITIA_HERE_THEY_COME", "diag_sp_corkscrew_SE131_12_01_mcor_grunt1", PRIORITY_NO_QUEUE )  // Here they come!  Weapons free!
	RegisterDialogue( "MILITIA_COMING_THRU_SLUDGE", "diag_sp_corkscrew_SE131_13_01_mcor_grunt2", PRIORITY_NO_QUEUE )  // They're coming throught the sludge!
	RegisterDialogue( "MILITIA_TOO_MANY", "diag_sp_corkscrew_SE131_14_01_mcor_grunt2", PRIORITY_NO_QUEUE )  // There's too many of them!
	RegisterDialogue( "MILITIA_KEEP_FIRING", "diag_sp_corkscrew_SE131_15_01_mcor_grunt1", PRIORITY_NO_QUEUE )  // Shut up and keep firing!
	RegisterDialogue( "MILITIA_THANKS_FOR_ASSIST", "diag_sp_corkscrew_SE131_16_01_mcor_grunt1", PRIORITY_NORMAL )  // Thanks for the assist, sir.
	RegisterDialogue( "MILITIA_GO_AHEAD", "diag_sp_corkscrew_SE131_18_01_mcor_grunt1", PRIORITY_NORMAL )  // This is as far as we can go.  You go ahead, sir.  We'll hold out here.
	RegisterDialogue( "MILITIA_TURRET_GUY_1", "diag_sp_recExtra_BE705_01_01_mcor_grunt_01", PRIORITY_LOW )
	RegisterDialogue( "MILITIA_TURRET_GUY_2", "diag_sp_recExtra_BE705_01_01_mcor_grunt_02", PRIORITY_LOW )
	RegisterDialogue( "MILITIA_TURRET_GUY_3", "diag_sp_recExtra_BE705_01_01_mcor_grunt_03", PRIORITY_LOW )
	RegisterDialogue( "IMC_CORKSCREW_CONV_01", "diag_sp_patrolChat_SE701_01_01_imc_grunt1", PRIORITY_LOW ) // Hey, turns out General Marder and his research team have found something that's going to give us quite the advantage against the Militia uprising.
	RegisterDialogue( "IMC_CORKSCREW_CONV_02", "diag_sp_patrolChat_SE701_02_01_imc_grunt2", PRIORITY_LOW ) // Not exactly up on current events are you mate? That's months old news. Bigger question is, can they make the real thing work, up in the mountains? I heard they practically blew up the test site, last time they tried the prototype. (ALT - Not exactly up on current events are you mate? That's months old news. Bigger question is, can they make the real thing work? I heard they practically blew up the test site, last time they tried the prototype.
	RegisterDialogue( "IMC_CORKSCREW_CONV_03", "diag_sp_patrolChat_SE701_03_01_imc_grunt1", PRIORITY_LOW ) // Brilliant. I hope they got what they needed...


	// --------------------------
	// PIPEROOM CLIMB
	// --------------------------


	// --------------------------
	// SEWER ARENA
	// --------------------------
	// BT
	RegisterRadioDialogue( "BT_DISABLE_SLUDGE", "diag_sp_sewerArena_SE151_05_01_mcor_bt", PRIORITY_NORMAL, "#NPC_BT_NAME", TEAM_MILITIA )  // Scans suggest you can disable this sludge in the next room by shutting off the processing pumps.  Marking your HUD.
	RegisterRadioDialogue( "BT_DISABLE_SLUDGE_NAG", "diag_sp_pilotarena_SE100_03_01_mcor_bt", PRIORITY_NORMAL, "#NPC_BT_NAME", TEAM_MILITIA )  // Pilot, we will need deactivate the sludge flows in order to regroup. I have marked the controls on your HUD.
	RegisterDialogue( "BT_HANDLED_YOURSELF_WELL", "diag_sp_sewerArena_SE152_13_01_mcor_bt", PRIORITY_NORMAL ) // Pilot, that was a difficult battle. You handled yourself well. I have noted it for the record.
	RegisterDialogue( "BT_EXIT_THIS_WAY", "diag_sp_sewerArena_SE152_14_01_mcor_bt", PRIORITY_NORMAL ) // Pilot, I have identified an exit on this side. This way.
	RegisterDialogue( "BT_PONTIFICIATES", "diag_sp_pipeClimb_SE142_07_01_imc_bt", PRIORITY_NORMAL ) // As on many other worlds in the Frontier, this IMC facility does not follow standard protocols and is discharging toxins without regard for the health of this planet. It will not take long for these toxic fumes and sludge to completely destroy Typhon.
	RegisterDialogue( "BT_PROTO_2", "diag_sp_pilotLink_WD141_42_01_mcor_bt_sewers", PRIORITY_NORMAL ) // Protocol 2: Uphold The Mission
	RegisterDialogue( "BT_RESUME_MISSION", "diag_sp_pilotLink_WD141_46_01_mcor_bt_sewers", PRIORITY_NORMAL ) // Our orders are to resume Special Operation #217 - Rendezvous with Major Anderson of the SRS.

	// PA System - Sludge status
	RegisterDialogue( "PA_PUMP_OVERRIDE", "diag_sp_sewerArena_SE151_12_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Overriding pump filter system. Emergency shutdown initiated.
	RegisterDialogue( "PA_PUMP_SHUTDOWN_20", "diag_sp_sewerArena_SE152_02_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Pump shutdown sequence at... 20%
	RegisterDialogue( "PA_PUMP_SHUTDOWN_40", "diag_sp_sewerArena_SE152_03_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Pump shutdown sequence at... 40%
	RegisterDialogue( "PA_PUMP_SHUTDOWN_50", "diag_sp_sewerArena_SE152_04_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Pump shutdown sequence at... 50%
	RegisterDialogue( "PA_PUMP_SHUTDOWN_80", "diag_sp_sewerArena_SE152_05_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Pump shutdown sequence at... 80%
	RegisterDialogue( "PA_PUMP_SHUTDOWN_90", "diag_sp_sewerArena_SE152_06_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Pump shutdown sequence at... 90%
	RegisterDialogue( "PA_PUMP_SHUTDOWN_COMPLETE", "diag_sp_sewerArena_SE152_07_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Pump shutdown sequence complete.

	// IMC Forces
	RegisterDialogue( "IMC_NEED_REINFORCEMENTS", "diag_sp_sewerArena_SE151_06_01_imc_grunt1", PRIORITY_NO_QUEUE )  // We need reinforcements in the pump room now!
	RegisterDialogue( "IMC_CALL_FOR_BACKUP", "diag_sp_sewerArena_SE152_01_01_imc_grunt1", PRIORITY_NO_QUEUE ) // Back up! Call for back up!
	RegisterDialogue( "IMC_DROP_TICKS", "diag_sp_sewerArena_SE151_07_01_imc_grunt1", PRIORITY_NO_QUEUE )  // Drop in the Ticks!  Flush em' out!
	RegisterDialogue( "IMC_FOCUS_FIRE_TITAN", "diag_sp_sewerArena_SE151_09_01_imc_grunt1", PRIORITY_NO_QUEUE )  // Focus fire on that titan!
	RegisterDialogue( "SewerArena_imc_ticksReleased1", "diag_sp_pilotarena_SE101_01_01_imc_imcGoblin01", PRIORITY_NO_QUEUE )// Lambda Four Airborne, releasing Ticks.
	RegisterDialogue( "SewerArena_imc_reinforce1", "diag_sp_pilotarena_SE101_02_01_imc_grunt01", PRIORITY_NO_QUEUE ) // Lambda Four Ground rappelling in.
	RegisterDialogue( "SewerArena_imc_ticksReleased2", "diag_sp_pilotarena_SE101_03_01_imc_imcGoblin02", PRIORITY_NO_QUEUE ) // Lambda Five Airborne on station, releasing Ticks.
	RegisterDialogue( "SewerArena_imc_reinforce2", "diag_sp_pilotarena_SE101_04_01_imc_grunt02", PRIORITY_NO_QUEUE ) // Lambda Five Ground rappelling now!
	RegisterDialogue( "SewerArena_imc_ticksReleased3", "diag_sp_pilotarena_SE101_05_01_imc_imcGoblin03", PRIORITY_NO_QUEUE ) // Be advised, Tau Five Airborne releasing Ticks.
	RegisterDialogue( "SewerArena_imc_reinforce3", "diag_sp_pilotarena_SE101_06_01_imc_grunt04", PRIORITY_NO_QUEUE ) // Tau Four Ground rappelling in.
	RegisterDialogue( "SewerArena_imc_reinforce4", "diag_sp_pilotarena_SE101_07_01_imc_grunt05", PRIORITY_NO_QUEUE ) // Tau Five Ground on station. ALT Tau Five Airborne on station.
	RegisterDialogue( "SewerArena_boss_tickWaveStart", "diag_sp_pilotarena_SE102_09_01_imc_dispatch", PRIORITY_NO_QUEUE ) // Counterforce Actual, deploy Ticks at will! Full sequence, deploy for effect!
	RegisterDialogue( "SewerArena_bt_joinsFight", "diag_sp_pilotarena_SE103_01_01_mcor_bt", PRIORITY_NO_QUEUE )	// Visual contact reestablished with Pilot. Commencing supporting fire. Danger close.
	RegisterDialogue( "SewerArena_imc_reaxToTitan1", "diag_sp_pilotarena_SE102_20_01_imc_grunt", PRIORITY_NORMAL ) // Kane! Come in! There's a Vanguard Titan in here with us! We're gonna be slaughtered!


	// --------------------------
	// KANE ARENA
	// --------------------------
	RegisterDialogue( "BT_WellDone", "diag_sp_kaneArena_SE161_06_01_mcor_bt", PRIORITY_NO_QUEUE )  // Well done, Pilot.
	RegisterDialogue( "BT_GetRadio", "diag_sp_kaneArena_SE161_07_01_mcor_bt", PRIORITY_NO_QUEUE )  // Pilot, Kane's radio is an IMC specialized flag radio. I advise you retrieve it.
	RegisterRadioDialogue( "RadioIntercept_01", "diag_sp_kaneArena_SE161_08_01_imc_blisk", PRIORITY_NO_QUEUE, "#BOSSNAME_BLISK", TEAM_IMC, true )  // Slone, this is Blisk. The IMC want the package delivered, now. Prep the Draconis.
	RegisterRadioDialogue( "RadioIntercept_02", "diag_sp_kaneArena_SE161_09_01_imc_slone", PRIORITY_NO_QUEUE, "#BOSSNAME_SLONE", TEAM_IMC, true )  // Copy. Got myself 3 captured Militia. What shall I do with them?
	RegisterRadioDialogue( "RadioIntercept_03", "diag_sp_kaneArena_SE161_10_01_imc_blisk", PRIORITY_NO_QUEUE, "#BOSSNAME_BLISK", TEAM_IMC, true )  // I don't bloody care. You have your orders.
	RegisterRadioDialogue( "RadioIntercept_04", "diag_sp_kaneArena_SE163_07_01_mcor_grunt1", PRIORITY_NO_QUEUE, "#BOSSNAME_SLONE", TEAM_IMC, true ) // No...don't!
	RegisterRadioDialogue( "RadioIntercept_05", "diag_sp_kaneArena_SE161_12_01_imc_slone", PRIORITY_NO_QUEUE, "#BOSSNAME_SLONE", TEAM_IMC, true )  // (BANG! BANG! BANG!)
	RegisterRadioDialogue( "RadioIntercept_06", "diag_sp_kaneArena_SE161_13_01_imc_slone", PRIORITY_NO_QUEUE, "#BOSSNAME_SLONE", TEAM_IMC, true )  // On my way. Slone out.
	RegisterDialogue( "KANE_HELMET_AMBIENT_1", "diag_sp_kaneArena_SE162_01_01_imc_grunt1", PRIORITY_NORMAL ) // Gamma Six to Kane - A Vanguard Titan and its Pilot are breaking through the facility, over!
	RegisterDialogue( "KANE_HELMET_AMBIENT_2", "diag_sp_kaneArena_SE162_02_01_imc_grunt2", PRIORITY_NORMAL ) // Kane! We need reinforcements in the tunnels! Kane, how copy, over?
	RegisterDialogue( "KANE_HELMET_AMBIENT_3", "diag_sp_kaneArena_SE162_03_01_imc_grunt1", PRIORITY_NORMAL ) // Come in, Kane!
	RegisterDialogue( "KANE_HELMET_AMBIENT_4", "diag_sp_kaneArena_SE162_04_01_imc_grunt2", PRIORITY_NORMAL ) // Kane! Do you read! Our Ground squads are down!
	RegisterDialogue( "BT_WE_HAVE_ADVANTAGE", "diag_sp_kaneArena_SE163_08_01_mcor_bt", PRIORITY_NORMAL ) // The ability to decrypt enemy communications has a strong history in warfare. This will work to our advantage.
	RegisterDialogue( "BT_KEEP_MOVING", "diag_sp_extra_SE812_02_01_mcor_bt", PRIORITY_NORMAL ) // In order to survive, we must keep moving.
	RegisterDialogue( "BT_THERMITE_WARN_1", "diag_sp_kaneArena_SE163_05_01_mcor_bt", PRIORITY_NORMAL ) // Pilot, avoid any pools of thermite. They cause heavy damage.
	RegisterDialogue( "BT_THERMITE_WARN_2", "diag_sp_kaneArena_SE163_06_01_mcor_bt", PRIORITY_NORMAL ) // Pilot, stay out of Kane's thermite residue. It causes heavy damage


	// --------------------------
	// MISC
	// --------------------------
	RegisterDialogue( "DEAD_IMC_CHATTER_A_01", "diag_sp_deadRadio_SE801_01_01_imc_grunt1", PRIORITY_NO_QUEUE ) // Kane. Come in. There's a Vanguard Class Titan in the facility. I think it's SRS.
	RegisterDialogue( "DEAD_IMC_CHATTER_A_02", "diag_sp_deadRadio_SE801_02_01_imc_kane", PRIORITY_NO_QUEUE ) // You think it's SRS. All Vanguards are SRS, you idiot. If you can't handle the job, I will. Just leave it to good ol' Kane to clean up your mess! IMC deadweight...
	RegisterDialogue( "KANE_PA_LISTEN_UP_01", "diag_kanePa_SE_811_01_01_imc_kane", PRIORITY_NO_QUEUE ) // Listen up! This is Kane. What we have here my IMC and Militia friends, is a failure to communicate!  - And that's ok! - that's ok....That's all good.
	RegisterDialogue( "KANE_PA_KANES_PLACE", "diag_kanePa_SE_811_13_01_imc_kane", PRIORITY_NO_QUEUE ) // To any Militia left in the facility. Just so you know, this is Kane's place. You're welcome to stay as long as it takes to kill you...which, by the way, WILL NOT BE LONG!
	RegisterDialogue( "KANE_PA_SRS_TITAN_HERE", "diag_kanePa_SE_811_17_01_imc_kane", PRIORITY_NO_QUEUE ) // So, I got word there's some Vanguard-Class Titan and an SRS Pilot takin' out my IMC support. Whoever you are...(slow to medium clapping)...not baaad, not bad at all my friend. Jeez I hope you're better than the last one I killed...
	RegisterDialogue( "KANE_PA_IM_COMING_DOWN", "diag_kanePa_SE_811_18_01_imc_kane", PRIORITY_NO_QUEUE ) // IMC...security forces...(sigh) I guess that's why they pay me the big bucks...you want something done right, you do it yourself. All right scrubs, enough's enough. I'm comin' down.
	RegisterDialogue( "PA_WARNING_01", "diag_sp_scattered_SE501_01_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Caution: Hazardous waste may cause severe injury or death.  The wearing of a hazmat suit is required at all times within this facility.
	RegisterDialogue( "PA_WARNING_02", "diag_sp_scattered_SE501_02_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Hazardous waste pumps now fiiltering Automated Testing Facility - Dome 1
	RegisterDialogue( "PA_WARNING_03", "diag_sp_scattered_SE501_03_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Attention: There is a deceased prowler in subjunction 3A. Requesting immediate removal.
	RegisterDialogue( "PA_WARNING_04", "diag_sp_scattered_SE501_04_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Hazardous waste pumps now fiiltering Automated Testing Facility - Dome 2
	RegisterDialogue( "PA_WARNING_05", "diag_sp_scattered_SE501_05_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Exterior drainage pumps switched to primary systems.
	RegisterDialogue( "PA_WARNING_06", "diag_sp_scattered_SE501_06_01_imc_facilityPA", PRIORITY_NO_QUEUE ) // Hazardous waste pumps now fiiltering Automated Testing Facility - Dome 3
}

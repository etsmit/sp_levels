global function ServerCallback_SetupJumpJetAnimEvents
global function ServerCallback_SignalAnimDone
global function ServerCallback_DisableDropshipLights
global function ServerCallback_DisableDropshipDamage
global function ServerCallBack_Afterburners_On
global function ServerCallBack_Afterburners_Off
global function ServerCallback_s2sBossFightBlur
global function ServerCallback_s2sCrash
global function ServerCallback_ShipStreamingSetup
global function ServerCallback_LevelIntroText
global function ClientCodeCallback_MapInit

const END_SCREEN_FX = $"P_exp_screen_s2s"

struct CallsignStruct
{
	string callsign
	int team
}

struct
{
	var shipNameRui
	table< string, CallsignStruct > shipScriptNameMap
	table< int, StreamingData > DynamicStreamingData

} file

void function ClientCodeCallback_MapInit()
{
	FlagInit( "ShipStreamingInitializedClient" )

	InitS2SDialogue()
	ShSpS2SCommonInit()

	RegisterServerVarChangeCallback( "ShipTitles", ShipTitlesChangedCallback )
	RegisterServerVarChangeCallback( "ShipStreaming", ShipStreamingChangedCallback )

	RegisterSignal( "KillJumpJetFX" )
	RegisterSignal( "ShipStreamingSet" )

	PrecacheParticleSystem( END_SCREEN_FX )

	file.shipNameRui = RuiCreate( $"ui/targetinfo_s2s_shipname.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	ModelFX_BeginData( "titanHealth", TITAN_VIPER_SCRIPTED_MODEL, "all", true )
	ModelFX_EndData()
	ModelFX_BeginData( "titanDoomed", TITAN_VIPER_SCRIPTED_MODEL, "all", false )
	ModelFX_EndData()
	ModelFX_BeginData( "titanDamage", TITAN_VIPER_SCRIPTED_MODEL, "all", true )
	ModelFX_EndData()
}

void function ServerCallback_LevelIntroText()
{
	BeginIntroSequence()
	var infoText = RuiCreate( $"ui/sp_level_title.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 100 )
	RuiSetGameTime( infoText, "startTime", Time() )
	RuiSetString( infoText, "txtLine1", "#S2S_INTRO_TEXT_LINE1" )
	RuiSetString( infoText, "txtLine2", "#S2S_INTRO_TEXT_LINE2" )
	RuiSetString( infoText, "txtLine3", "#S2S_INTRO_TEXT_LINE3" )
}

void function EntitiesDidLoad()
{
	thread S2S_ShipTargetNameThink()
}

void function ServerCallback_s2sBossFightBlur( float hold = 0.1 )
{
	thread S2sBossFightBlur_Thread( hold )
}

void function S2sBossFightBlur_Thread( float hold = 0.1 )
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDestroy" )

	SetScreenBlur( 1, 0.5, EASING_CUBIC_OUT )
	wait 1.0

	float fadein = 0.2
	float fadeout = 0.1
	thread Blink( player, fadein, hold, fadeout, 255 )
	wait fadein
	SetScreenBlur( 0.4, 0.25, EASING_CUBIC_OUT )

	wait 0.25

	SetScreenBlur( 0.75, 0.5, EASING_CUBIC_IN )
	wait 0.5

	waitthread Blink( player )
	SetScreenBlur( 0, 1.5, EASING_CUBIC_OUT )
	waitthread Blink( player )
}

void function Blink( entity player, float fadein = 0.1, float hold = 0.0, float fadeout = 0.1, float darkAlpha = 200 )
{
	// FADE_OUT is fade to value
	// FADE_IN is fade from value
	player.EndSignal( "OnDestroy" )

	ScreenFade( player, 0, 0, 0, darkAlpha, fadein, hold, FFADE_OUT )	// fade from black to clear
	wait fadein + hold

	ScreenFade( player, 0, 0, 0, darkAlpha, fadeout, 0, FFADE_IN )	// fade from black to clear
	wait fadeout
}

void function ServerCallback_s2sCrash()
{
	S2S_CrashScreenFX()

	thread S2S_CrashThread()
}

void function S2S_CrashScreenFX()
{
	entity player = GetLocalViewPlayer()
	int index = GetParticleSystemIndex( END_SCREEN_FX )

	if ( IsValid( player.GetCockpit() ) )
	{
		int fxID1 = StartParticleEffectOnEntity( player, index, FX_PATTACH_POINT_FOLLOW, player.GetCockpit().LookupAttachment( "CAMERA" ) )
		EffectSetIsWithCockpit( fxID1, true )
	}
}

void function S2S_CrashThread()
{
	while( 1 )
	{
		SetScreenBlur( 1, 0.1, EASING_SINE_IN )

		wait RandomFloatRange( 0.1, 0.3 )

		SetScreenBlur( RandomFloatRange( 0.3, 0.6 ), 0.1, EASING_SINE_IN )

		wait RandomFloatRange( 0.1, 0.3 )
	}
}

void function ServerCallback_SetupJumpJetAnimEvents( int eHandle )
{
	entity guy = GetEntityFromEncodedEHandle( eHandle )

	SetupNPCJumpJetAnimEvents( guy )
}

void function ServerCallback_SignalAnimDone( int eHandle )
{
	entity guy = GetEntityFromEncodedEHandle( eHandle )
	guy.Signal( "OnAnimationDone" )
}

void function ServerCallback_DisableDropshipLights( int eHandle )
{
	entity ent = GetEntityFromEncodedEHandle( eHandle )
	ModelFX_DisableGroup( ent, "foe_lights" )
 	ModelFX_DisableGroup( ent, "friend_lights" )
 	ModelFX_EnableGroup( ent, "thrusters" )
}

void function ServerCallback_DisableDropshipDamage( int eHandle )
{
	entity ent = GetEntityFromEncodedEHandle( eHandle )
 	ModelFX_DisableGroup( ent, "dropshipDamage" )
}

void function ServerCallBack_Afterburners_On( int eHandle )
{
	entity ent = GetEntityFromEncodedEHandle( eHandle )
 	ModelFX_EnableGroup( ent, "afterburners" )
}

void function ServerCallBack_Afterburners_Off( int eHandle )
{
	entity ent = GetEntityFromEncodedEHandle( eHandle )
 	ModelFX_DisableGroup( ent, "afterburners" )
}

void function SetupNPCJumpJetAnimEvents( entity playerOrDecoy )
{
	if ( !IsAlive( playerOrDecoy ) )
		return

	AddAnimEvent( playerOrDecoy, "HMN_Jump_Jet", OnNPCJumpJet )
	AddAnimEvent( playerOrDecoy, "HMN_Jump_Jet_Left", OnNPCJumpJetLeft )
	AddAnimEvent( playerOrDecoy, "HMN_Jump_Jet_Right", OnNPCJumpJetRight )
	AddAnimEvent( playerOrDecoy, "HMN_Jump_Jet_DBL", OnNPCJumpJetDBL )
	AddAnimEvent( playerOrDecoy, "HMN_Jump_Jet_WallRun_Left", OnNPCJumpJetWallRun_Left )
	AddAnimEvent( playerOrDecoy, "HMN_Jump_Jet_WallRun_Right", OnNPCJumpJetWallRun_Right )
	//AddAnimEvent( playerOrDecoy, "HMN_Melee", OnNPCMeleeTrails )
}

/*void function ServerCallback_SendSignal( int eHandle, int stringID )
{
	entity guy = GetEntityFromEncodedEHandle( eHandle )
	string msg = GetMsgFromID( stringID )
	guy.Signal( msg )
}*/

void function OnNPCJumpJet( entity npc )
{
	EmitSoundOnEntity( npc, "s2s_jumpjet_jet_body_3p_64" )
	array<int> particleEffects = PlayJumpjetFXNPC( npc, eJumpJetType.ON )

	FXCleanUp( npc, particleEffects, "eJumpJetType.ON" )
}

void function OnNPCJumpJetLeft( entity npc )
{
	EmitSoundOnEntity( npc, "s2s_jumpjet_jet_body_3p_64" )
	if ( !GetJumpJetFXData().attachments.contains( "vent_left" ) )
		return

	array<int> particleEffects = PlayJumpjetFXNPC( npc, eJumpJetType.ON, [ "vent_left" ] )

	if ( particleEffects.len() == 0 )
		return

	int lightFX = PlayJumpjetLightNPC( npc )
	if ( lightFX != 0 )
		particleEffects.append( lightFX )

	FXCleanUp( npc, particleEffects, "eJumpJetType.ON" )
}

void function OnNPCJumpJetRight( entity npc )
{
	EmitSoundOnEntity( npc, "s2s_jumpjet_jet_body_3p_64" )
	if ( !GetJumpJetFXData().attachments.contains( "vent_right" ) )
		return

	array<int> particleEffects = PlayJumpjetFXNPC( npc, eJumpJetType.ON, [ "vent_right" ] )

	if ( particleEffects.len() == 0 )
		return

	int lightFX = PlayJumpjetLightNPC( npc )
	if ( lightFX != 0 )
		particleEffects.append( lightFX )

	FXCleanUp( npc, particleEffects, "eJumpJetType.ON" )
}

void function OnNPCJumpJetDBL( entity npc )
{
	EmitSoundOnEntity( npc, "s2s_jumpjet_jump_body_3p_64" )
	array<int> particleEffects = PlayJumpjetFXNPC( npc, eJumpJetType.DBL )

	//No need to clean this up since it is a one time effect unlike wallrun and normal jumpjet effects which are looping
}

void function OnNPCJumpJetWallRun_Left( entity npc )
{
	array<int> particleEffects = PlayJumpjetFXNPC( npc, eJumpJetType.WR, [ "vent_left_out" ] )

	FXCleanUp( npc, particleEffects, "eJumpJetType.WR" )
}

void function OnNPCJumpJetWallRun_Right( entity npc )
{
	array<int> particleEffects = PlayJumpjetFXNPC( npc, eJumpJetType.WR, [ "vent_right_out" ] )

	FXCleanUp( npc, particleEffects, "eJumpJetType.WR" )
}

array<int> function PlayJumpjetFXNPC( entity npc, int jumpjetType = eJumpJetType.ON, array<string> attachments = [] )
{
//	if ( !ShouldDoJumpjetEffects( npc ) )
//		return []

	int fxID = GetJumpjetFXForNPC( npc, jumpjetType )

	if ( fxID == 0 )
		return []

	if ( attachments.len() == 0 )
		attachments = GetJumpJetFXData().attachments

	array<int> particleEffects
	foreach ( attachment in attachments )
	{
		int jumpJet = StartParticleEffectOnEntity( npc, fxID, FX_PATTACH_POINT_FOLLOW, npc.LookupAttachment( attachment ) )
		particleEffects.append( jumpJet )
	}

	return particleEffects
}

int function PlayJumpjetLightNPC( entity npc )
{
	//if ( !ShouldDoJumpjetEffects( npc ) )
	//	return 0

	int fxID = GetJumpjetFXForNPC( npc, eJumpJetType.RT )

	if ( fxID == 0 )
		return 0

	return StartParticleEffectOnEntity( npc, fxID, FX_PATTACH_POINT_FOLLOW, npc.LookupAttachment( GetJumpJetFXData().rt_light_attachment ) )
}

int function GetJumpjetFXForNPC( entity npc, int jumpjetType )
{
	JumpJetDataStruct dataStruct = GetJumpJetFXData()

	JumpJetFXNamesStruct namesStruct = dataStruct.enemyJumpJets
	if ( npc.GetTeam() == GetLocalViewPlayer().GetTeam() )
		namesStruct = dataStruct.friendlyJumpJets

	asset[ 4 ] names = namesStruct.regularJumpJets
//	if ( ShouldDoStealthJumpJetFX( npc ) )
//		names = namesStruct.stealthJumpJets

	asset fxString = names[ jumpjetType ]

	int fxID = GetParticleSystemIndex( fxString ) //If there's no particle system associated with it, it'll return 0. Dealt with in PlayJumpJetFXNPC

	return fxID
}

void function FXCleanUp( entity npc, array<int> particleEffects, string stopSignalName )
{
	npc.Signal( "KillJumpJetFX" )

	if ( particleEffects.len() == 0 )
		return

	thread KillExistingFX( npc, particleEffects, stopSignalName )
}

void function KillExistingFX( entity npc, array<int> particleEffects, string stopSignalName )
{
	npc.EndSignal( "OnDeath" )
	npc.EndSignal( "OnDestroy" )
	npc.Signal( stopSignalName ) //Kill previous thread. Ensures Jumpjet effects don't keep piling on to each other.
	npc.EndSignal( stopSignalName )


	OnThreadEnd
	(
		function() : ( npc, particleEffects )
		{
			foreach( particle in particleEffects )
			{
				if ( EffectDoesExist( particle ) )
				{
					EffectStop( particle, false, true )
				}
			}
		}
	)

	WaittillAnimDone( npc ) //this doesn't work.. i have to force it through script
}

CallsignStruct function CreateCallsign( string locString, int team )
{
	CallsignStruct newcallsign
	newcallsign.callsign = locString
	newcallsign.team = team

	return newcallsign
}

void function S2S_ShipTargetNameThink()
{
	var deferredTrace

	while ( true )
	{
		entity player = GetLocalViewPlayer()

		vector traceStart 	= player.EyePosition()
		vector viewDir 		= player.GetViewVector()
		vector traceEnd 	= traceStart + viewDir * 40000
		var deferredTrace 	= DeferredTraceLine( traceStart, traceEnd, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

		while ( !IsDeferredTraceFinished( deferredTrace ) )
			WaitFrame()

		TraceResults result = GetDeferredTraceResult( deferredTrace )
		while ( result.hitSky || ( IsValid( result.hitEnt ) && result.hitEnt.GetScriptName() == "bridge_glass_front" ) )
		{
			traceStart 	= result.endPos + viewDir * 350
			traceEnd 	= traceStart + viewDir * 80000
			deferredTrace = DeferredTraceLine( traceStart, traceEnd, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
			while ( !IsDeferredTraceFinished( deferredTrace ) )
				WaitFrame()

			result = GetDeferredTraceResult( deferredTrace )
		}

		if ( IsValid( result.hitEnt ) && result.hitEnt.GetScriptName() in file.shipScriptNameMap )
		{
			RuiSetBool( file.shipNameRui, "isVisible", true )
			RuiSetString( file.shipNameRui, "titleText", file.shipScriptNameMap[result.hitEnt.GetScriptName()].callsign )
			RuiSetInt( file.shipNameRui, "team", file.shipScriptNameMap[result.hitEnt.GetScriptName()].team )
		}
		else
		{
			RuiSetBool( file.shipNameRui, "isVisible", false )

			#if DEV
				if ( GetBugReproNum() == 100 )
					printt( "hitEnt", result.hitEnt )
			#endif
		}

		wait 0.1
	}
}

void function ShipTitlesNoDraconis()
{
	file.shipScriptNameMap = {}
	InitShipScriptName_Sarah()
	InitShipScriptName_Barker()
	InitShipScriptName_Trinity()
	InitShipScriptName_Gibraltar()
	//InitShipScriptName_Draconis()
	InitShipScriptName_Malta()
	InitShipScriptName_Crows()
}

void function ShipTitlesNoMalta()
{
	file.shipScriptNameMap = {}
	InitShipScriptName_Sarah()
	InitShipScriptName_Barker()
	InitShipScriptName_Trinity()
	InitShipScriptName_Gibraltar()
	InitShipScriptName_Draconis()
	//InitShipScriptName_Malta()
	InitShipScriptName_Crows()
}

void function ShipTitlesNoBarker()
{
	file.shipScriptNameMap = {}
	InitShipScriptName_Sarah()
	//InitShipScriptName_Barker()
	InitShipScriptName_Trinity()
	InitShipScriptName_Gibraltar()
	InitShipScriptName_Draconis()
	InitShipScriptName_Malta()
	InitShipScriptName_Crows()
}

void function ShipTitlesEverything()
{
	file.shipScriptNameMap = {}
	InitShipScriptName_Sarah()
	InitShipScriptName_Barker()
	InitShipScriptName_Trinity()
	InitShipScriptName_Gibraltar()
	InitShipScriptName_Draconis()
	InitShipScriptName_Malta()
	InitShipScriptName_Crows()
}

void function ShipTitlesNoTrinity()
{
	file.shipScriptNameMap = {}
	InitShipScriptName_Sarah()
	InitShipScriptName_Barker()
	//InitShipScriptName_Trinity()
	InitShipScriptName_Gibraltar()
	InitShipScriptName_Draconis()
	InitShipScriptName_Malta()
	InitShipScriptName_Crows()
}

void function ShipTitlesNone()
{
	file.shipScriptNameMap = {}
}

void function InitShipScriptName_Trinity()
{
	file.shipScriptNameMap[ "TRINITY_CHUNK_EXTERIOR" ] 	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "TRINITY_CHUNK_INTERIOR" ] 	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorLB" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorLT" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorLB2" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorLT2" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorRB" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorRT" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorRB2" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
	file.shipScriptNameMap[ "trinity_hangardoorRT2" ]	<- CreateCallsign( "#S2S_CALLSIGN_TRINITY", TEAM_MILITIA )
}

void function InitShipScriptName_Sarah()
{
	file.shipScriptNameMap[ "S2S_CALLSIGN_SARAH" ]	<- CreateCallsign( "#NPC_SARAH_NAME", TEAM_MILITIA )
}

void function InitShipScriptName_Barker()
{
	file.shipScriptNameMap[ "GEO_CHUNK_BARKERSHIP" ]	<- CreateCallsign( "#NPC_BARKER", TEAM_MILITIA )
}

void function InitShipScriptName_Gibraltar()
{
	file.shipScriptNameMap[ "GIBRALTAR_CHUNK_EXTERIOR" ]	<- CreateCallsign( "#S2S_CALLSIGN_THERMOPYLE", TEAM_IMC )
	file.shipScriptNameMap[ "GIBRALTAR_CHUNK_INTERIOR" ]	<- CreateCallsign( "#S2S_CALLSIGN_THERMOPYLE", TEAM_IMC )
}

void function InitShipScriptName_Draconis()
{
	file.shipScriptNameMap[ "DRACONIS_CHUNK_LOWDEF" ]	<- CreateCallsign( "#S2S_CALLSIGN_DRACONIS", TEAM_IMC )
	file.shipScriptNameMap[ "DRACONIS_CHUNK_HIGHDEF" ]	<- CreateCallsign( "#S2S_CALLSIGN_DRACONIS", TEAM_IMC )
	file.shipScriptNameMap[ "DRACONIS_HIGHLIGHT_MODEL" ]	<- CreateCallsign( "#S2S_CALLSIGN_DRACONIS", TEAM_IMC )
}

void function InitShipScriptName_Malta()
{
	file.shipScriptNameMap[ "GEO_CHUNK_HANGAR" ] 		<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_HANGAR_FAKE" ] 	<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_DECK" ] 			<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_DECK_FAKE" ] 	<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_BRIDGE" ] 		<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_BACK" ] 			<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_BACK_FAKE" ] 	<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_EXTERIOR_ENGINE" ] <- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_EXTERIOR_L" ] 	<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
	file.shipScriptNameMap[ "GEO_CHUNK_EXTERIOR_R" ] 	<- CreateCallsign( "#S2S_CALLSIGN_MALTA", TEAM_IMC )
}

void function InitShipScriptName_Crows()
{
		//crows
	file.shipScriptNameMap[ "CrowTemplate" ] 			<- CreateCallsign( "#S2S_CALLSIGN_BB64", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB64" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB64", TEAM_MILITIA )

	file.shipScriptNameMap[ "S2S_CALLSIGN_BB21" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB21", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB22" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB22", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB23" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB23", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB24" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB24", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB31" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB31", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB32" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB32", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB33" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB33", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BB34" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BB34", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_BBAC" ] 		<- CreateCallsign( "#S2S_CALLSIGN_BBAC", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RVAC" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RVAC", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV21" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV21", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV22" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV22", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV23" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV23", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV24" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV24", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV31" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV31", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV32" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV32", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV33" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV33", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_RV34" ] 		<- CreateCallsign( "#S2S_CALLSIGN_RV34", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CRAC" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CRAC", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR21" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR21", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR22" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR22", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR23" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR23", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR24" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR24", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR31" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR31", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR32" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR32", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR33" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR33", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_CR34" ] 		<- CreateCallsign( "#S2S_CALLSIGN_CR34", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VLAC" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VLAC", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL21" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL21", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL22" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL22", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL23" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL23", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL24" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL24", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL31" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL31", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL32" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL32", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL33" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL33", TEAM_MILITIA )
	file.shipScriptNameMap[ "S2S_CALLSIGN_VL34" ] 		<- CreateCallsign( "#S2S_CALLSIGN_VL34", TEAM_MILITIA )
}

void function ShipTitlesChangedCallback()
{
	switch( level.nv.ShipTitles )
	{
		case SHIPTITLES_EVERYTHING:
			ShipTitlesEverything()
			break

		case SHIPTITLES_NOBARKER:
			ShipTitlesNoBarker()
			break

		case SHIPTITLES_NOMALTA:
			ShipTitlesNoMalta()
			break

		case SHIPTITLES_NODRACONIS:
			ShipTitlesNoDraconis()
			break

		case SHIPTITLES_NOTRINITY:
			ShipTitlesNoTrinity()
			break

		case SHIPTITLES_NONE:
			ShipTitlesNone()
			break
	}
}

void function ShipStreamingChangedCallback()
{
	thread ShipStreamingSet()
}

void function ShipStreamingSet()
{
	Signal( level, "ShipStreamingSet" )

	if ( !Flag( "ShipStreamingInitializedClient" ) )
	{
		EndSignal( level, "ShipStreamingSet" )
		FlagWait( "ShipStreamingInitializedClient" )
	}

	Assert( file.DynamicStreamingData.len() == SHIPSTREAMING_DRACONIS )

	switch( level.nv.ShipStreaming )
	{
		case SHIPSTREAMING_DEFAULT:
			ClearStreamingRelativeEntity()
			break

		default:
			StreamingData data = file.DynamicStreamingData[ expect int( level.nv.ShipStreaming ) ]
			if ( !IsValid( data.template ) )
				return
			SetStreamingRelativeEntity( data.template, data.origin, data.angles )
			break
	}

	printt( "" )
	printt( "--------------------------------------------" )
	printt( "STREAMING SET: " + level.nv.ShipStreaming )
	printt( "--------------------------------------------" )
	printt( "" )
}

void function ServerCallback_ShipStreamingSetup( int eHandle, int streaming, float ox, float oy, float oz, float ax, float ay, float az )
{
	StreamingData data
	data.template = GetEntityFromEncodedEHandle( eHandle )
	data.origin = < ox, oy, oz >
	data.angles = < ax, ay, az >

	file.DynamicStreamingData[ streaming ] <- data

	if ( file.DynamicStreamingData.len() == SHIPSTREAMING_DRACONIS )
	{
		FlagSet( "ShipStreamingInitializedClient" )

		printt( "" )
		printt( "--------------------------------------------" )
		printt( "STREAMING INITIALIZED ON CLIENT" )
		printt( "--------------------------------------------" )
		printt( "" )
	}
}

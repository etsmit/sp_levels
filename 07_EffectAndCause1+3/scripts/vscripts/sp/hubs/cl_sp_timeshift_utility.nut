untyped

global function ServerCallback_WakingUpLevelEnd
global function ServerCallback_FrozenLightStart
global function ClTimeshiftUtilityInit
global function ServerCallback_TimeFlipped
global function ServerCallback_FlippingToFrozen
global function ServerCallback_PlayerIndoorsChanged
global function ServerCallback_PlayGloveGlow
global function ServerCallback_StopGloveGlow
global function ServerCallback_LabRatLasers
global function ServerCallback_TimeDeviceAcquired
global function ServerCallback_ScriptedTimeshiftStart
global function ServerCallback_ShowHoloDecoding
global function ServerCallback_ClearScanningHudElem
global function ServerCallback_ShowCoreDecoding
global function ServerCallback_ShowTitanTimeshiftHint
global function ServerCallback_ShowHologramTitles
global function ServerCallback_DisableAllLasers
global function ServerCallback_StopRingSounds
global function ServerCallback_LevelInfoText
global function ServerCallback_FanDropBlur
global function ScriptCallback_DestroyHintOnMenuOpen	// called on "ingamemenu_activate"

const DUMMY_MODEL = $"models/Robots/stalker/robot_stalker.mdl"

const TIMEZONE_DAY = 0
const TIMEZONE_NIGHT = 1
const TIMEZONE_FROZEN = 3

const vector textColor				= <0.96, 0.96, 0.96>
const vector textYellow				= <1.0, 0.75, 0.0>
const float titleAlpha				= 1.0	//0.75
const float textAlpha				= 0.75	//0.5
const float xOffset					= 0.03
const float yOffset					= 0.1

const float fullWidth				= 1920
const float fullHeight				= 1080

//---------------------
// CLIENT FX
//---------------------
const FX_CORE_GLITCH_SCREENFX = $"P_tpod_screen_distort"
const FX_CORE_GLITCH_SCREENFX2 = $"P_ts_screen_distort"
const FX_CORE_GLITCH_SCREENFX3 = $"P_ts_screen_fizzle"

const FX_WEATHER_RAIN = $"P_weather_rain_ts"
const FX_WEATHER_RAIN_SCREEN = $"P_player_screen_rain"
const FX_WEATHER_LIGHTNING = $"P_lightning_4096"
const FX_WEATHER_LIGHTNING_SB = $"P_lightning_SB_32"
const FX_LASER = $"P_security_laser"
const FX_TIMESHIFT_PULSE_PLAYER = $"P_timeshift_trans_flash"
const FX_TIMESHIFT_SWAP_EFFECT = $"P_timeshift_trans_screen"
const FX_TIMESHIFT_PRE_EFFECT = $"P_timeshift_trans_screen_warmup"
const FX_HOLO_SCAN_ENVIRONMENT = $"P_ar_holopulse_CP"

const FX_TIMESHIFT_GLOVE_BLUE_LOOP = $"P_timeshift_gauntlet_blue"
const FX_TIMESHIFT_GLOVE_ORANGE_LOOP = $"P_timeshift_gauntlet_orange"
const FX_TIMESHIFT_GLOVE_RED_LOOP = $"P_timeshift_gauntlet_red"
//const FX_TIMESHIFT_GLOVE_RED_LOOP = $"ts_gaunt_start_nrg_orange"

//----------------------
// CLIENT SOUND
//----------------------
const SFX_SNOW_BG = "AMB_EXT_SnowWind"
const SFX_RAIN_BG = "AMB_EXT_TimeshiftLightRainLayer"
const SFX_LIGHTNING_STRIKE = "Timeshift_Scr_Thunderclap_EXT"
const SOUND_LASER_LOOP = "Timeshift_LaserMesh_Loop"
const SOUND_LASER_DEACTIVATE = "BubbleShield_End"

struct
{
	int playerIsIndoors
	var scanningHudElem
	var ruiFloatText1
	var ruiFloatText2
	bool isCoreDataDownloadComplete = false
	int colorCorrectionOvergrown
	int colorCorrectionPristine
	int colorCorrectionFrozen
	array <entity> laserMeshEnts
} file



void function ServerCallback_StopRingSounds()
{

	entity emitter_rings_spin_sound = GetEntByScriptName( "emitter_rings_spin_sound" )
	if ( IsValid( emitter_rings_spin_sound) )
	{
		emitter_rings_spin_sound.Destroy()
	}

}
////////////////////////////////////////////////////////////////////
void function ClTimeshiftUtilityInit()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	Temp_InitTimeshiftDialogue()


	PrecacheParticleSystem( FX_CORE_GLITCH_SCREENFX )
	PrecacheParticleSystem( FX_CORE_GLITCH_SCREENFX2 )
	PrecacheParticleSystem( FX_CORE_GLITCH_SCREENFX3 )
	PrecacheParticleSystem( FX_HOLO_SCAN_ENVIRONMENT )
	PrecacheParticleSystem( FX_WEATHER_RAIN )
	PrecacheParticleSystem( FX_WEATHER_RAIN_SCREEN )
	PrecacheParticleSystem( FX_WEATHER_LIGHTNING )
	PrecacheParticleSystem( FX_WEATHER_LIGHTNING_SB )
	PrecacheParticleSystem( FX_TIMESHIFT_PULSE_PLAYER )
	PrecacheParticleSystem( FX_TIMESHIFT_SWAP_EFFECT )
	PrecacheParticleSystem( FX_TIMESHIFT_PRE_EFFECT )
	PrecacheParticleSystem( FX_TIMESHIFT_GLOVE_BLUE_LOOP )
	PrecacheParticleSystem( FX_TIMESHIFT_GLOVE_ORANGE_LOOP )
	PrecacheParticleSystem( FX_TIMESHIFT_GLOVE_RED_LOOP )

	PrecacheModel( DUMMY_MODEL )
	level.rainSound <- null
	level.g_weatherFXHandle <- null
	level.g_screenFXHandle <- null
	level.timeZone <- TIMEZONE_NIGHT

	RegisterSignal( "BreakableDestroyed" )

	//file.vortexCamera = CreateClientSidePointCamera( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), 50 )
	//file.vortexCamera.SetFOV( 90 )
	//file.vortexCamera.SetActive( true )

	RegisterSignal( "StopLaserMesh" )
	RegisterSignal( "TimeSwapped" )
	RegisterSignal( "DestroyScanningHudElem" )
	StatusEffect_RegisterEnabledCallback( eStatusEffect.laser_mesh, LaserMeshEnable )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.laser_mesh, LaserMeshDisable )

	FlagInit( "StopCoreTextDump" )
	FlagInit( "player_is_indoors" )
	FlagInit( "PlayerPickedUpTimeshiftDevice" )


	file.colorCorrectionOvergrown = ColorCorrection_Register( "materials/correction/sp_timeshift_overgrown.raw" )
	file.colorCorrectionPristine = ColorCorrection_Register( "materials/correction/sp_timeshift_pristine.raw" )
	file.colorCorrectionFrozen = ColorCorrection_Register( "materials/correction/sp_timeshift_frozen.raw" )

	RegisterConCommandTriggeredCallback( "ingamemenu_activate", ScriptCallback_DestroyHintOnMenuOpen )


}


void function ScriptCallback_DestroyHintOnMenuOpen( entity player )
{
	if ( GetGlobalNetBool( "DestroyHintOnMenuOpen" ) )
		DestroyOnscreenHint()
}

void function ServerCallback_LevelInfoText()
{
	BeginIntroSequence()
	var infoText = RuiCreate( $"ui/sp_level_title.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 100 )
	RuiSetGameTime( infoText, "startTime", Time() )
	RuiSetString( infoText, "txtLine1", "#TIMESHIFT_INTRO_TEXT_LINE1" )
	RuiSetString( infoText, "txtLine2", "#TIMESHIFT_INTRO_TEXT_LINE2" )
}

void function ServerCallback_WakingUpLevelEnd()
{
	thread WakingUpLevelEndThread()
}

void function WakingUpLevelEndThread()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return
	player.EndSignal( "OnDestroy" )


	OnThreadEnd(
		function() : (  )
		{
			ScreenFade( GetLocalViewPlayer(), 0, 0, 0, 0, 0, 5, FFADE_IN | FFADE_PURGE )
			SetScreenBlur( 0, 0, EASING_SINE_INOUT )
			DoF_LerpFarDepthToDefault( 3 )
			DoF_LerpNearDepthToDefault( 3 )
		}
	)
	delaythread ( 2 ) RainOnScreen( player )
	DoF_SetFarDepth( 4500, 7500 )
	DoF_SetNearDepth( 0, 18 )

	SetScreenBlur( 1, 0, EASING_SINE_INOUT )
	ScreenFade( player, 255, 255, 255, 255, 2, 2, FFADE_IN | FFADE_PURGE )	// fade from black to clear
	wait 4

	wait 2
	SetScreenBlur( 0, 4, EASING_SINE_INOUT )
	wait 6.0

}


void function ServerCallback_DisableAllLasers()
{
	foreach ( ent in file.laserMeshEnts )
	{
		ent.Signal( "StopLaserMesh" )
	}

}

void function LaserMeshEnable( entity maxs, int statusEffect, bool actuallyChanged )
{
	thread LaserMeshClientThread( maxs, actuallyChanged )
}

void function LaserMeshDisable( entity maxs, int statusEffect, bool actuallyChanged )
{
	maxs.Signal( "StopLaserMesh" )
}

void function LaserMeshClientThread( entity maxs, bool showStartupEffects )
{
	array< int > fxHandles

	vector topCorner = maxs.GetOrigin()
	vector btmCorner = maxs.GetLinkEnt().GetOrigin()

	vector soundOrigin = (topCorner + btmCorner) * 0.5

	vector laserOffset = <btmCorner.x, btmCorner.y, topCorner.z> - topCorner

	int laserEffect = PrecacheParticleSystem( FX_LASER )

	float increment = 10.0
	while ( topCorner.z >= btmCorner.z )
	{
		if ( showStartupEffects )
			WaitFrame()

		topCorner = topCorner + ( Vector( 0, 0, -( increment ) ) )
		vector topCornerConnect = topCorner + laserOffset

		int fxHandle = StartParticleEffectInWorldWithHandle( laserEffect, topCorner, topCornerConnect )
		EffectSetControlPointVector( fxHandle, 2, topCornerConnect )

		fxHandles.append( fxHandle )
	}

	thread EmitSoundAtPositionHack( TEAM_UNASSIGNED, soundOrigin, SOUND_LASER_LOOP )

	OnThreadEnd(
		void function() : ( maxs, fxHandles, soundOrigin )
		{
			foreach ( fxHandle in fxHandles )
			{
				EffectStop( fxHandle, true, true )
			}
			//StopSoundAtPosition( soundOrigin, SOUND_LASER_LOOP )
			EmitSoundAtPosition( TEAM_UNASSIGNED, soundOrigin, SOUND_LASER_DEACTIVATE )
		}
	)

	file.laserMeshEnts.append( maxs )

	maxs.WaitSignal( "StopLaserMesh" )
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

void function ServerCallback_ShowHoloDecoding( int logIndex = 0 )
{
	thread HoloDecodingThread( logIndex )
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
void function ServerCallback_ClearScanningHudElem()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return
	player.Signal( "DestroyScanningHudElem" )

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

void function HoloDecodingThread( int logIndex )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return


	file.scanningHudElem = RuiCreate( $"ui/helmet_scanning_percentbar.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	//file.scanningHudElem.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DestroyScanningHudElem" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
				StopSoundOnEntity( player, "Timeshift_Scr_HelmetHUDTelemetryLoop" )
			if ( IsValid( file.scanningHudElem ) )
				RuiDestroyIfAlive( file.scanningHudElem )
			if ( IsValid( file.ruiFloatText1 ) )
				RuiDestroyIfAlive( file.ruiFloatText1 )
			if ( IsValid( file.ruiFloatText2 ) )
				RuiDestroyIfAlive( file.ruiFloatText2 )
		}
	)

	array <entity> andersonModels = GetEntArrayByScriptName( "anderson_holo" )

	//--------------------------
	//defaults for AUDIO logs
	//--------------------------
	string decodingTitle = "#TIMESHIFT_INFO_DECODING_AUDIO_LOGS"
	float stage1Duration = 1
	float stage2Duration = 1
	float analyzingTime = 2
	string calibratingString = "#TIMESHIFT_INFO_STANDBY_AUDIO"
	string logAuthor



	if ( logIndex == 0 )
		logAuthor = "#TIMESHIFT_INFO_HOLO_PLAYBACK_ANDERSON"
	else if ( logIndex == 1 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_BRUMBLY"
	else if ( logIndex == 2 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_SUE"
	else if ( logIndex == 3 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_MARDER"
	else if ( logIndex == 4 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_WILSON"
	else if ( logIndex == 5 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_ALTAMIRANO"
	else if ( logIndex == 6 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_MARDER"
	else if ( logIndex == 7 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_BIGRIG"
	else if ( logIndex == 8 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_TYLER"
	else if ( logIndex == 9 )
		logAuthor = "#TIMESHIFT_AUDIOLOG_NAME_MARDER"
	else
		Assert( 0, "Unhandled audio log index: " + logIndex )


	//--------------------------------
	// defaults for HOLOGRAPHIC logs
	//--------------------------------
	if ( logIndex == 0 )
	{
		decodingTitle = "#TIMESHIFT_INFO_DECODING_VISUAL_LOGS"
		stage1Duration = 3
		stage2Duration = 2
		analyzingTime = 5
		calibratingString = "#TIMESHIFT_INFO_STANDBY_HOLO"
	}


	int scanEffectIndex
	int particleIndex


	foreach( andersonModel in andersonModels )
	{
		scanEffectIndex = GetParticleSystemIndex( FX_HOLO_SCAN_ENVIRONMENT )
		particleIndex = StartParticleEffectInWorldWithHandle( scanEffectIndex, andersonModel.GetOrigin(), <0,0,0> )
		EffectSetControlPointVector( particleIndex, 1, <2.5,50,0> )
	}





	//setting all the exposed values from script here
	RuiSetFloat( file.scanningHudElem, "startTime", Time() )
	RuiSetFloat( file.scanningHudElem, "fadeInDuration", 0.5 )
	RuiSetFloat( file.scanningHudElem, "stage1Duration", stage1Duration )
	RuiSetFloat( file.scanningHudElem, "stage2Duration", stage2Duration )

	RuiSetString( file.scanningHudElem, "stage1Text", decodingTitle )
	RuiSetString( file.scanningHudElem, "stage2Text", calibratingString )
	RuiSetString( file.scanningHudElem, "stage3TextTop", "#TIMESHIFT_INFO_HOLO_PLAYBACK" )
	RuiSetString( file.scanningHudElem, "stage3TextBottom", logAuthor )

	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUDTelemetryLoop" )
	wait analyzingTime
	StopSoundOnEntity( player, "Timeshift_Scr_HelmetHUDTelemetryLoop" )
	EmitSoundOnEntity( player, "Wilds_Scr_HelmetHUDText_Finish" )

	RuiSetFloat( file.scanningHudElem, "startTime", Time() )
	RuiSetFloat( file.scanningHudElem, "fadeInDuration", 0 )
	RuiSetFloat( file.scanningHudElem, "stage1Duration", 0 )
	RuiSetFloat( file.scanningHudElem, "stage2Duration", 0 )

	RuiDestroyIfAlive( file.scanningHudElem )


	int count = 0

	if ( logIndex != 0 )
		return

	//Only doing labels for Anderson now...not laptops

	foreach( andersonModel in andersonModels )
	{
		scanEffectIndex = GetParticleSystemIndex( FX_HOLO_SCAN_ENVIRONMENT )
		particleIndex = StartParticleEffectInWorldWithHandle( scanEffectIndex, andersonModel.GetOrigin(), <0,0,0> )
		EffectSetControlPointVector( particleIndex, 1, <2.5,50,0> )
		count++

		if ( count == 1 )
		{
			file.ruiFloatText1 = RuiCreate( $"ui/basic_float_text.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
			RuiSetResolutionToScreenSize( file.ruiFloatText1 )
			RuiSetString( file.ruiFloatText1, "floatText", logAuthor )
			RuiTrackFloat3( file.ruiFloatText1, "pos", andersonModel, RUI_TRACK_OVERHEAD_FOLLOW )

		}
		else
		{
			file.ruiFloatText2 = RuiCreate( $"ui/basic_float_text.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
			RuiSetResolutionToScreenSize( file.ruiFloatText2 )
			RuiSetString( file.ruiFloatText2, "floatText", logAuthor )
			RuiTrackFloat3( file.ruiFloatText2, "pos", andersonModel, RUI_TRACK_OVERHEAD_FOLLOW )
		}


	}



	WaitForever()
	/*
	foreach( andersonModel in andersonModels )
		thread AndersonHoloTextBlink( andersonModel, player, logAuthor )


	while( true )
	{
		wait 1.5
		RuiDestroyIfAlive( file.scanningHudElem )
		wait 0.5
		file.scanningHudElem = RuiCreate( $"ui/helmet_scanning_percentbar.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
		RuiSetString( file.scanningHudElem, "stage3TextTop", "#TIMESHIFT_INFO_HOLO_PLAYBACK" )
		RuiSetString( file.scanningHudElem, "stage3TextBottom", logAuthor )
		EmitSoundOnEntity( player, "UI_HoloTutorial_AnalyzingFinish" )

	}

	*/
}


void function AndersonHoloTextBlink( entity andersonModel, entity player, string logAuthor )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DestroyScanningHudElem" )

	var topology
	var hudElem

	OnThreadEnd(
		function() : ( player, hudElem )
		{
			if ( IsValid( player ) )
				StopSoundOnEntity( player, "Timeshift_Scr_HelmetHUDTelemetryLoop" )
			if ( IsValid( hudElem )	)
				RuiDestroyIfAlive( hudElem )
		}
	)

	wait 1
	while( true )
	{
		topology = Timeshift_CreateRUITopology( andersonModel.GetOrigin() + Vector( 0, 0, 100 ), andersonModel.GetAngles(), 256, 128 )
		hudElem = RuiCreate( $"ui/helmet_scanning_percentbar.rpak", topology, RUI_DRAW_WORLD, 0 )
		RuiSetString( hudElem, "stage3TextTop", "#TIMESHIFT_INFO_HOLO_PLAYBACK" )
		RuiSetString( hudElem, "stage3TextBottom", logAuthor )
		WaitFrame()
		RuiDestroyIfAlive( hudElem )
		RuiTopology_Destroy( topology )
		WaitFrame()


	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
void function ServerCallback_ShowCoreDecoding()
{
	thread CoreDecodingThread()

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
void function CoreDecodingThread()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	player.EndSignal( "OnDeath" )

	entity core_dummy = GetEntByScriptName( "core_dummy" )


	ClWeaponStatus_SetOffhandVisible( OFFHAND_LEFT, false )
	ClWeaponStatus_SetOffhandVisible( OFFHAND_RIGHT, false )
	ClWeaponStatus_SetOffhandVisible( OFFHAND_INVENTORY, false )
	if ( player.IsTitan() )
		ClWeaponStatus_SetOffhandVisible( OFFHAND_TITAN_CENTER, false )
	ClWeaponStatus_SetWeaponVisible( false )



	float xOffset = 0.05

	//vector textColor1 = <0.93, 0.53, 0.16>
	vector textColor1 = <1.00, 0.34, 0.09>

	array<var> ruis = []



	//var rebootRui = RuiCreate( $"ui/helmet_reboot.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	//ruis.append( rebootRui )
	//ruis.append( borderRui )

	var helmetRui = CreateCockpitRui( $"ui/helmet_border.rpak", 100 )



	// LINE 1
	var titleRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( titleRui, "maxLines", 30 )
	RuiSetInt( titleRui, "lineNum", 0 )
	RuiSetString( titleRui, "msgText", Localize( "#SEWERS_RADIO_HUD_TITLE", "" ) )
	RuiSetFloat( titleRui, "msgFontSize", 30.0 )
	RuiSetFloat( titleRui, "msgAlpha", 0 )
	RuiSetFloat3( titleRui, "msgColor", textColor )
	RuiSetFloat2( titleRui, "msgPos", <xOffset,0.1,0.0> )
	//RuiSetFloat2( titleRui, "msgPos", < 0.75, 0.1, 0.0 > )
	ruis.append( titleRui )

	RuiSetString( titleRui, "msgText", "#SEWERS_RADIO_HUD_TITLE" )

	delaythread ( 1.5 ) Timeshift_RuiFlickerIn( titleRui )


	//wait 0.25
	wait 1.5


	delaythread( 2 ) CoreDecodingFinish()
	var warningRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( warningRui, "maxLines", 30 )
	RuiSetInt( warningRui, "lineNum", 0 )
	RuiSetString( warningRui, "msgText", "#HUD_WARNING_UNSTABLE_HOST" )
	RuiSetFloat( warningRui, "msgFontSize", 30.0 )
	RuiSetFloat( warningRui, "msgAlpha", 0.8 )
	RuiSetFloat3( warningRui, "msgColor", <1.0,0.0,0.0> )
	RuiSetFloat2( warningRui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( warningRui )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_UnstableSource" )
	EmitSoundOnEntity( player, "Timeshift_Scr_CoreScan_ReachDown" )

	wait 0.25
	RuiSetFloat( warningRui, "msgAlpha", 0.0 )

	wait 0.25
	RuiSetFloat( warningRui, "msgAlpha", 1.0 )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_UnstableSource" )
	wait 0.25
	RuiSetFloat( warningRui, "msgAlpha", 0.0 )
	wait 0.25
	RuiSetFloat( warningRui, "msgAlpha", 1.0 )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_UnstableSource" )

	wait 1

	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_UnstableSource" )
	RuiSetString( warningRui, "msgText", "#HUD_TIMESHIFT_SCAN_TITLE" )

	wait 1

	var scanStatusRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( scanStatusRui, "maxLines", 30 )
	RuiSetInt( scanStatusRui, "lineNum", 1 )
	RuiSetString( scanStatusRui, "msgText", "#HUD_SCAN_ASSIMILATE" )
	RuiSetFloat( scanStatusRui, "msgFontSize", 30.0 )
	RuiSetFloat( scanStatusRui, "msgAlpha", 0.8 )
	RuiSetFloat3( scanStatusRui, "msgColor", textColor1 )
	RuiSetFloat2( scanStatusRui, "msgPos", <xOffset,0.2,0.0> )



	wait 0.5

	//RuiSetString( scanStatusRui, "msgText2", "#HUD_DOWNLOADING" )
	thread BlinkRui( scanStatusRui )

	wait 1

	wait 0.5

	thread CoreDecodingCallouts( player )
/*

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 2 )
	RuiSetString( rui, "msgText", "#HUD_SCANNING_ASSIMILATING1" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	thread AnimateDots( rui )
	ruis.append( rui )
*/
	wait 0.1


	//EmitSoundOnEntity( player, "Pilot_Eviscerate_Activate" )


	thread CoreScanTextDump( xOffset )


	while( !file.isCoreDataDownloadComplete )
		wait 0.5
	/*
	foreach ( r in ruis )
	{
		thread FlickerOut( r )
	}
	*/
	delaythread ( 5 ) CoreGlitchSound( player )
	delaythread ( 10 ) CoreScreenGlitch( player )
	//RuiSetString( scanStatusRui, "msgText", "#HUD_SCAN_ASSIMILATE" )


	int progress = 0

	for ( int i=0; i<=100; i+=1 )
	{
		RuiSetString( scanStatusRui, "msgText2", string(i) )
  		EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )
		wait 0.08
	}


	//EmitSoundOnEntity( GetLocalViewPlayer(), "dataknife_complete" )
	thread FlickerOut( warningRui )


	RuiSetString( scanStatusRui, "msgText", "#HUD_SCAN_COMPLETE" )
	RuiSetString( scanStatusRui, "msgText2", "" )
	delaythread ( 0.1 ) BlinkScanComplete( scanStatusRui )

	wait 4

	//FlickerOut( scanStatusRui, false )
	RuiSetFloat( scanStatusRui, "msgAlpha", 1.0 )

	wait 1

	thread FlickerOut( titleRui )
	waitthread FlickerOut( scanStatusRui )

	if ( IsValid( helmetRui ) )
		RuiDestroyIfAlive( helmetRui )

}

void function Timeshift_RuiFlickerIn( var rui )
{
	int flickerCount = 4
	for( int i = 0; i < flickerCount; i++ )
	{
		wait 0.05
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		wait 0.05
		RuiSetFloat( rui, "msgAlpha", textAlpha )
	}
}


void function CoreGlitchSound( entity player )
{
	EmitSoundOnEntity( player, "Timeshift_Scr_CoreScan" )
}

void function CoreDecodingCallouts( entity player )
{
	entity core_dummy = GetEntByScriptName( "core_dummy" )
	entity dummyModel = CreatePropDynamic( DUMMY_MODEL, core_dummy.GetOrigin() + Vector( 10, 20, -50 ), Vector( 0, 0, 0 ) )
	dummyModel.Hide()

	int yPos = -80
	int zPos = 70

	/*
	delaythread ( 1 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_01", Vector( 5, -30, -10 ), 1 )
	delaythread ( 3.7 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_02", Vector( 600, -80, 70 ), 1 )
	delaythread ( 5.7 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_03", Vector( 50, 20, 10 ), 1 )
	delaythread ( 7 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_04", Vector( 5, -10, -10 ), 1 )
	delaythread ( 8.75 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_05", Vector( 40, -80, 70 ), 1 )
	*/
	float displayTimeBeforeCompleteLocal = 0.75

	delaythread ( 1 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_01", Vector( 5, -30, -10 ), displayTimeBeforeCompleteLocal )
	delaythread ( 3 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_02", Vector( 600, -80, 70 ), displayTimeBeforeCompleteLocal )
	delaythread ( 5 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_03", Vector( 50, 20, 10 ), displayTimeBeforeCompleteLocal )
	delaythread ( 6.3 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_04", Vector( 5, -10, -10 ), displayTimeBeforeCompleteLocal )
	delaythread ( 8 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_05", Vector( 40, -80, 70 ), 1, 1 )

	//delaythread ( 5 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_05", Vector( 40, -80, 70 ), 5, 0 )




	/*
	delaythread ( 1 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_01", Vector( 20, yPos, zPos ), 5, 0 )
	delaythread ( 2 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_02", Vector( 40, yPos, zPos ), 4, 0.25 )
	delaythread ( 3 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_03", Vector( 80, yPos, zPos ), 3, 0.5 )
	delaythread ( 4 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_04", Vector( 180, yPos, zPos ), 2, 0.75 )
	delaythread ( 5 ) Callout( player, dummyModel, "#TIMESHIFT_SCAN_CALLOUT_TITLE_05", Vector( 600, yPos, zPos ), 1, 1 )
	*/



}


void function Callout( entity player, entity dummyModel, string messageFlyout, vector titleOffset, float displayTimeBeforeComplete, float completeWaitTimeAdditional = 0 )
{

	var flyoutRui = RuiCreate( $"ui/flyout_generic.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )

	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHud_ScanMilestone" )

	RuiSetGameTime( flyoutRui, "startTime", Time() )
	RuiTrackFloat3( flyoutRui, "pos", dummyModel, RUI_TRACK_POINT_FOLLOW, dummyModel.LookupAttachment( "CHESTFOCUS" ) )
	RuiSetFloat3( flyoutRui, "offset", titleOffset )
	RuiSetString( flyoutRui, "titleText", messageFlyout )
	RuiSetBool( flyoutRui, "isVisible", true )
	RuiSetResolutionToScreenSize( flyoutRui )
	wait displayTimeBeforeComplete

	wait completeWaitTimeAdditional

	EmitSoundOnEntity( player, "UI_RankedSummary_CircleTick_Reached" )
	RuiSetString( flyoutRui, "descriptionText", "#TIMESHIFT_SCAN_CALLOUT_DESC_COMPLETE" )
	//waitthread FlickerRui( flyoutRui, 1.0, 0.0, 3, 5 )

	wait 1.5

	waitthread FlickerOut( flyoutRui )

	wait 1.25

	RuiDestroyIfAlive( flyoutRui )
}

void function CoreScreenGlitch( entity player )
{


	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int particleIdx = GetParticleSystemIndex( FX_CORE_GLITCH_SCREENFX )
	int screenFXHandle = StartParticleEffectOnEntity( player, particleIdx, FX_PATTACH_POINT_FOLLOW, player.GetCockpit().LookupAttachment( "CAMERA" ) )
	EffectSetIsWithCockpit( screenFXHandle, true )

	wait 2
	if ( screenFXHandle != -1 )
		EffectStop( screenFXHandle, true, false ) // stop particles, play end cap

	int particleIdx2 = GetParticleSystemIndex( FX_CORE_GLITCH_SCREENFX2 )
	int screenFXHandle2 = StartParticleEffectOnEntity( player, particleIdx2, FX_PATTACH_POINT_FOLLOW, player.GetCockpit().LookupAttachment( "CAMERA" ) )
	EffectSetIsWithCockpit( screenFXHandle2, true )

	wait 4
	if ( screenFXHandle2 != -1 )
		EffectStop( screenFXHandle2, true, false ) // stop particles, play end cap

	wait 1
	int particleIdx3 = GetParticleSystemIndex( FX_CORE_GLITCH_SCREENFX3 )
	int screenFXHandle3 = StartParticleEffectOnEntity( player, particleIdx3, FX_PATTACH_POINT_FOLLOW, player.GetCockpit().LookupAttachment( "CAMERA" ) )
	EffectSetIsWithCockpit( screenFXHandle3, true )

	wait 3
	if ( screenFXHandle3 != -1 )
		EffectStop( screenFXHandle3, true, false ) // stop particles, play end cap
}


void function ServerCallback_FlippingToFrozen()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return


	thread BackToTheFuture( player )
	delaythread ( 2 ) ArrivedInFrozenWorld( player )
}


void function ServerCallback_FanDropBlur()
{
	thread QuickBlur()
}

void function QuickBlur()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )

	SetScreenBlur( 1, 0, EASING_SINE_INOUT )
	wait 0.5
	SetScreenBlur( 0, 1.25, EASING_SINE_INOUT )
	//wait 3
	//SetScreenBlur( 0, 0, EASING_SINE_INOUT )
}

void function ArrivedInFrozenWorld( entity player )
{
	//DoF_LerpNearDepthToDefault( 0.1 )
	//DoF_LerpFarDepthToDefault( 0.1 )

	wait 0.1

	//DoF_SetNearDepth( 50, 150 )
	DoF_SetFarDepth( 300, 800 )

	wait 10.5

	DoF_LerpNearDepthToDefault( 3.0 )
	DoF_LerpFarDepthToDefault( 3.0 )

}

//////////////////////////////////////////////////////////////////////////////
void function BackToTheFuture( entity player )
{
	player.EndSignal( "OnDeath" )



	int index = GetParticleSystemIndex( FX_TIMESHIFT_PRE_EFFECT )
	entity cockpit = player.GetCockpit()
	if ( IsValid( cockpit ) )
	{
		int fxPreEffect = StartParticleEffectOnEntity( player, index, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
		EffectSetIsWithCockpit( fxPreEffect, true )
		thread TimeshiftPulseCleanup( fxPreEffect, 1.8 )
	}

	wait 1.9
	EmitSoundOnEntity( player, "Timeshift_Scr_InvoluntaryShift" )
	index = GetParticleSystemIndex( FX_TIMESHIFT_SWAP_EFFECT )
	level.timeZone = TIMEZONE_DAY
	if ( IsValid( cockpit ) )
	{
		//player.WaitSignal( "OnTimeFlipped" )
		int fxSwapEffect = StartParticleEffectOnEntity( player, index, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
		EffectSetIsWithCockpit( fxSwapEffect, true )
	}





	/*
	entity emitter_rings_spin_sound = GetEntByScriptName( "emitter_rings_spin_sound" )
	if ( IsValid( emitter_rings_spin_sound) )
		emitter_rings_spin_sound.Destroy()
	*/

}
//////////////////////////////////////////////////////////////////////////////
void function CoreScanTextDump( float xOffset )
{
	FlagEnd( "StopCoreTextDump" )
	while( true )
	{
		CreateCockpitHex( xOffset )
  		wait 0.05
	}
}

//////////////////////////////////////////////////////////////////////////////
void function CoreDecodingFinish()
{
	file.isCoreDataDownloadComplete = true
	wait 12
	FlagSet( "StopCoreTextDump" )

}
//////////////////////////////////////////////////////////////////////////////
void function FlickerOut( var rui, bool destroy = true )
{
	float baseAlpha = 0.2

	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "msgAlpha", baseAlpha )
	wait 0.05
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "msgAlpha", baseAlpha )
	wait 0.05
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "msgAlpha", baseAlpha )
	wait 0.05
	if ( destroy )
		RuiDestroy( rui )
}

void function BlinkRui( var rui )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	player.EndSignal( "OnDeath" )

	while( !Flag( "StopCoreTextDump") )
	{
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )
		wait 0.25
		RuiSetFloat( rui, "msgAlpha", 0.75 )
		wait 0.25
	}

}


void function BlinkScanComplete( var rui )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	player.EndSignal( "OnDeath" )

	float notSolidTime = 0.2
	float solidTime = 0.75

	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait notSolidTime
	RuiSetFloat( rui, "msgAlpha", 0.75 )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )

	wait solidTime

	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait notSolidTime
	RuiSetFloat( rui, "msgAlpha", 0.75 )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )

	wait solidTime

	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait notSolidTime
	RuiSetFloat( rui, "msgAlpha", 0.75 )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )


	wait solidTime

	RuiSetFloat( rui, "msgAlpha", 0.0 )
	wait notSolidTime
	RuiSetFloat( rui, "msgAlpha", 0.75 )
	EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )
}





void function BlinkRuiOld( var rui )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	player.EndSignal( "OnDeath" )


	while( !file.isCoreDataDownloadComplete )
	{
		RuiSetString( rui, "msgText2", "#HUD_DOWNLOADING" )
		EmitSoundOnEntity( player, "Timeshift_Scr_HelmetHUD_ProgressBlip" )
		wait 0.75
		RuiSetString( rui, "msgText2", "#BLANK_TEXT" )
		wait 0.75
	}

}


void function AnimateDots( var rui )
{
	while( !file.isCoreDataDownloadComplete )
	{
		RuiSetString( rui, "msgText", "#HUD_SCANNING_ASSIMILATING1" )
		wait 0.25
		RuiSetString( rui, "msgText", "#HUD_SCANNING_ASSIMILATING2" )
		wait 0.25
		RuiSetString( rui, "msgText", "#HUD_SCANNING_ASSIMILATING3" )
		wait 0.25
		RuiSetString( rui, "msgText", "#HUD_SCANNING_ASSIMILATING4" )
		wait 0.25
	}

}

void function CreateCockpitHex( float xOffset )
{
	var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 20 )
	vector textColor1 = <0.93, 0.53, 0.16>

	string hex = GenerateHexString( 4 )
	for ( int i=0; i<4; i++ )
	{
		hex += " " + GenerateHexString( 4 )
	}

	RuiSetString( rui, "msgText", hex )
	RuiSetFloat( rui, "msgFontSize", 26.0 )
	RuiSetFloat( rui, "lineHoldtime", 0.05 )
	RuiSetFloat( rui, "msgAlpha", 0.5 )
	RuiSetFloat3( rui, "msgColor", textColor1 )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.3,0.0> )
	RuiSetBool( rui, "autoMove", true )
}

string function GenerateHexString( int digits )
{
	int baseValue = RandomIntRange( 0, pow(10,digits-1) )
	string baseString = string( baseValue )
	for ( int i=digits-1; i>0; i-- )
	{
		if ( baseValue < pow(10,i) )
		{
			baseString = "0" + baseString
		}
	}
	return "0x" + baseString
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
void function EmitSoundAtPositionHack( int team, vector origin, var sound )
{
	//Need to delay 0.2 before playing at level start, Baker/Barb know this is a big but said will fix next game
	wait 0.2
	EmitSoundAtPosition( team, origin, sound )

}
////////////////////////////////////////////////////////////////////
void function EntitiesDidLoad()
{
	thread Weather()
}

////////////////////////////////////////////////////////////////////
function ServerCallback_FrozenLightStart()
{
	/*
	local clight = GetLightEnvironmentEntity()
    if ( clight )
        clight.ScaleSunSkyIntensity( 0, 0 )
	*/
}
////////////////////////////////////////////////////////////////////
function ServerCallback_PlayerIndoorsChanged( int state )
{
	file.playerIsIndoors = state
}

////////////////////////////////////////////////////////////////////
function ServerCallback_TimeFlipped( state )
{
	level.timeZone = state
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	//---------------------------
	// Color correction
	//----------------------------
	if ( level.timeZone == TIMEZONE_DAY )
	{
		ColorCorrection_SetExclusive( file.colorCorrectionOvergrown, false )
		ColorCorrection_SetWeight( file.colorCorrectionOvergrown, 0.0 )
		ColorCorrection_SetExclusive( file.colorCorrectionFrozen, false )
		ColorCorrection_SetWeight( file.colorCorrectionFrozen, 0.0 )

		ColorCorrection_SetExclusive( file.colorCorrectionPristine, true )
		ColorCorrection_SetWeight( file.colorCorrectionPristine, 1.0 )
	}
	else if ( level.timeZone == TIMEZONE_NIGHT )
	{
		ColorCorrection_SetExclusive( file.colorCorrectionPristine, false )
		ColorCorrection_SetWeight( file.colorCorrectionPristine, 0.0 )
		ColorCorrection_SetExclusive( file.colorCorrectionFrozen, false )
		ColorCorrection_SetWeight( file.colorCorrectionFrozen, 0.0 )

		ColorCorrection_SetExclusive( file.colorCorrectionOvergrown, true )
		ColorCorrection_SetWeight( file.colorCorrectionOvergrown, 1.0 )
	}
	else //Frozen world
	{
		ColorCorrection_SetExclusive( file.colorCorrectionPristine, false )
		ColorCorrection_SetWeight( file.colorCorrectionPristine, 0.0 )
		ColorCorrection_SetExclusive( file.colorCorrectionOvergrown, false )
		ColorCorrection_SetWeight( file.colorCorrectionOvergrown, 0.0 )

		ColorCorrection_SetExclusive( file.colorCorrectionFrozen, true )
		ColorCorrection_SetWeight( file.colorCorrectionFrozen, 1.0 )
	}

	//---------------------------
	// Rain sounds/effects
	//----------------------------
	if ( ( level.timeZone == TIMEZONE_DAY ) || ( file.playerIsIndoors == 1 ) || ( level.timeZone == TIMEZONE_FROZEN ) )
	{
		StopSoundOnEntity( player, SFX_RAIN_BG )
		if ( level.g_weatherFXHandle != null )
		{
			if ( EffectDoesExist( level.g_weatherFXHandle ) )
				EffectStop( level.g_weatherFXHandle, true, false ) // effect, doRemoveAllParticlesNow, doPlayEndCap
			level.g_weatherFXHandle = null
		}
	}

	//StopSoundOnEntity( player, "Pilot_Time_Shift_Activated" )
	//EmitSoundOnEntity( player, "Pilot_Time_Shift_Activated" )

	if ( state == TIMEZONE_DAY )
	{
		ResumeSoundOnEntity( player, "music_timeshift_14_pastloop" ) //Hack from code to make sure we don't get it playing in the pause menu or reloading from checkpoints
		player.Signal( "OnTimeFlippedTimezoneDay" ) //Client signals to handle dialogue pauses

	}
	else
	{
		if ( GetGlobalNetBool( "music14LoopPausable" ) )
			PauseSoundOnEntity( player, "music_timeshift_14_pastloop" ) //Hack from code to make sure we don't get it playing in the pause menu or reloading from checkpoints

		player.Signal( "OnTimeFlippedTimezoneNight" ) //Client signals to handle dialogue pauses
	}

	player.Signal( "OnTimeFlipped" )

	//-------------------------------
	//	Timeshift pulse effect
	//-------------------------------
	if ( Flag( "PlayerPickedUpTimeshiftDevice" ) )
	{
		vector titanOffset = Vector( 0, 0, 0 )
		if ( player.IsTitan() )
		{
			titanOffset = Vector( 0, 0, 200 )
		}


		//Effects when wearing wrist-mounted device
		int scanEffectIndex = GetParticleSystemIndex( FX_TIMESHIFT_PULSE_PLAYER )
		int particleIndex = StartParticleEffectInWorldWithHandle( scanEffectIndex, player.GetOrigin() + titanOffset, <0,0,0> )
		//EffectSetControlPointVector( particleIndex, 1, <2.5,50,0> )
	}
	else
	{
		//Effects when it's a random, scripted shift in the beginning
		int scanEffectIndex = GetParticleSystemIndex( FX_TIMESHIFT_PULSE_PLAYER )
		int particleIndex = StartParticleEffectInWorldWithHandle( scanEffectIndex, player.GetOrigin(), <0,0,0> )
		//EffectSetControlPointVector( particleIndex, 1, <2.5,50,0> )

	}

	//-------------------------------
	//	Timeshift viewmodel effects
	//-------------------------------
	if ( !Flag( "PlayerPickedUpTimeshiftDevice" ) )
		return

	entity timeShiftOffhand = player.GetOffhandWeapon( 1 )
	if ( !IsValid( timeShiftOffhand) )
		return


	PlayGloveGlow( level.timeZone )

	//{ "hero_mil_jack_gauntlet_timeshift_skn_01"} // present amber
	//{ "hero_mil_jack_gauntlet_timeshift_skn_01_v1"} // past blue
	//{ "hero_mil_jack_gauntlet_timeshift_skn_01_v2"} // error red
	//{ "hero_mil_jack_gauntlet_timeshift_skn_01_v3"} // off

	/*

	if ( level.timeZone == TIMEZONE_DAY )
	{
		timeShiftOffhand.SetWeaponSkin( 0 )
	}

	else if ( level.timeZone == TIMEZONE_NIGHT )
	{
		timeShiftOffhand.SetWeaponSkin( 1 )
	}

	*/

}

////////////////////////////////////////////////////////////////////
function ServerCallback_PlayGloveGlow( timeZone )
{
	PlayGloveGlow( timeZone )
}

////////////////////////////////////////////////////////////////////
function ServerCallback_LabRatLasers()
{
	entity laserMeshEmitter = GetEntByScriptName( "sound_emitter_labrat_lasermesh" )
	laserMeshEmitter.Destroy()
}


////////////////////////////////////////////////////////////////////
function PlayGloveGlow( timeZone )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	player.StopEffectOnPlayerHands()
	asset handGlowLoop

	if ( timeZone == TIMEZONE_DAY )
		handGlowLoop = FX_TIMESHIFT_GLOVE_BLUE_LOOP
	else if ( timeZone == TIMEZONE_NIGHT )
		handGlowLoop = FX_TIMESHIFT_GLOVE_ORANGE_LOOP
	else if ( timeZone == TIMEZONE_FROZEN )
		handGlowLoop = FX_TIMESHIFT_GLOVE_RED_LOOP

	player.StartEffectOnPlayerHands( handGlowLoop, "L_BACKHAND" )

}

////////////////////////////////////////////////////////////////////
function ServerCallback_StopGloveGlow()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	player.StopEffectOnPlayerHands()
}

////////////////////////////////////////////////////////////////////

void function TimeshiftPulseCleanup( int fxHandle, float time )
{
	wait time
	if ( IsValid( fxHandle ) )
		EffectStop( fxHandle, true, false )
}

function ServerCallback_TimeDeviceAcquired()
{
	FlagSet( "PlayerPickedUpTimeshiftDevice" )
}

////////////////////////////////////////////////////////////////////
function Weather()
{
	entity player = GetLocalClientPlayer()
	thread RandomLightningStrikes()
	if ( GetMapName() == "sp_timeshift_spoke02" )
		return

	while ( true )
	{
		WeatherRain( player )
		wait 0.5
	}
}
////////////////////////////////////////////////////////////////////
//	RAIN on player
/////////////////////////////////////////////////////////////////////
function WeatherRain( entity player )
{

	if ( GetBugReproNum() == 7896 )
	{
		if ( file.playerIsIndoors == 1 )
			printt( "'file.playerIsIndoors' is TRUE" )
		if ( file.playerIsIndoors == 0 )
			printt( "'file.playerIsIndoors' is FALSE" )
	}

	if ( !IsValid( player ) || !IsAlive( player ) )
		return



	if ( !ShouldDoOvergrownWeather() )
	{
		StopSoundOnEntity( player, SFX_RAIN_BG )
		if ( level.g_weatherFXHandle != null )
		{
			if ( EffectDoesExist( level.g_weatherFXHandle ) )
				EffectStop( level.g_weatherFXHandle, true, false ) // effect, doRemoveAllParticlesNow, doPlayEndCap
			level.g_weatherFXHandle = null
		}
		return
	}

	if ( level.g_weatherFXHandle != null && EffectDoesExist( level.g_weatherFXHandle ) )
		return

	int weatherID = GetParticleSystemIndex( FX_WEATHER_RAIN )

	vector offset = Vector( 0, 0, 800 )
	vector angles = Vector( 0, 0, 0 )

	int fxHandle = StartParticleEffectOnEntityWithPos( player, weatherID, FX_PATTACH_ABSORIGIN_FOLLOW, -1, offset, angles )

	EmitSoundOnEntity( player, SFX_RAIN_BG )

	level.g_weatherFXHandle = fxHandle
}

////////////////////////////////////////////////////////////////////
bool function ShouldDoOvergrownWeather()
{
	if ( !GetGlobalNetBool( "PlayerInOvergrownTimeline" ) )
		return false

	if ( level.timeZone == TIMEZONE_DAY )
		return false

	if ( level.timeZone == TIMEZONE_FROZEN )
		return false

	if ( file.playerIsIndoors == 1 )
		return false

	return true
}

////////////////////////////////////////////////////////////////////
//RAIN on player screen
function RainOnScreen( entity player )
{

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int fxID = GetParticleSystemIndex( FX_WEATHER_RAIN_SCREEN )
	int screenFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	level.g_screenFXHandle = screenFxHandle

	while ( IsValid( player ) && IsAlive( player ) )
	{
		wait 0.25
		//if ( level.timeZone == TIMEZONE_DAY || file.playerIsIndoors == 1 )
			//continue

		float WeatherCameraAngle = GraphCapped( player.CameraAngles().x, -88.0, 10.0, 1.0, 0.0 )
		vector CPvec = Vector( WeatherCameraAngle, 0, 0 )

		if ( !level.g_screenFXHandle )
			break

		if ( EffectDoesExist( level.g_screenFXHandle ) )
			EffectSetControlPointVector( level.g_screenFXHandle, 1, CPvec )
	}
}

////////////////////////////////////////////////////////////////////
// Lightning stirkes info_targets with targetname FX_LIGHTING_STRIKE, placed in LevelEd
////////////////////////////////////////////////////////////////////
function RandomLightningStrikes()
{
	//IN LEVEL
	array<entity> fxEnts = GetClientEntArray( "info_target_clientside", "lightning_strike_target" )
	int fxID = GetParticleSystemIndex( FX_WEATHER_LIGHTNING )

	foreach ( fxEnt in fxEnts )
	{
		//printt( "FX_ENT:", fxEnt )
		thread PlayLightningStrike( fxEnt, fxID, 12.0, 24.0,  SFX_LIGHTNING_STRIKE )
	}

	//SKYBOX
	array<entity> fxEntsSB = GetClientEntArray( "info_target_clientside", "skybox_lightning_target" )
	int fxID_SB = GetParticleSystemIndex( FX_WEATHER_LIGHTNING_SB )

	foreach ( fxEnt in fxEntsSB )
	{
		//printt( "FX_ENT_SB:", fxEnt )
		thread PlayLightningStrike( fxEnt, fxID_SB, 6.0, 12.0 )
	}
}

////////////////////////////////////////////////////////////////////
function PlayLightningStrike( fxEnt, fxID, minDelay, maxDelay, soundName = null )
{
	local origin = fxEnt.GetOrigin()
	//local angles = fxEnt.GetAngles()
	local angles = Vector( 0, 0, 0)

	// local minDelay = 1.0
	// local maxDelay = 6.0

	fxEnt.EndSignal( "OnDestroy" )

	while ( IsValid( fxEnt ) )
	{
		wait RandomFloatRange( minDelay, maxDelay )
		if ( level.timeZone == TIMEZONE_DAY )
			continue

		if ( level.timeZone == TIMEZONE_FROZEN )
			continue

		StartParticleEffectInWorld( fxID, origin, angles )
		if ( soundName != null )
			EmitSoundOnEntity( fxEnt, soundName )
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
function PlayerInRange( vector pos, float minDist )
{
	local player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return false

	float dist = Distance( pos, player.GetOrigin() )
	if ( dist < minDist )
		return true

	return false
}

////////////////////////////////////////////////////////////////////////////////////////////////////
function ServerCallback_ScriptedTimeshiftStart( state )
{
	thread ScriptedTimeshiftStartThread( state )

}
////////////////////////////////////////////////////////////////////////////////////////////////////
function ScriptedTimeshiftStartThread( state )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	int index = GetParticleSystemIndex( FX_TIMESHIFT_PRE_EFFECT )
	entity cockpit = player.GetCockpit()
	if ( IsValid( cockpit ) )
	{
		int fxPreEffect = StartParticleEffectOnEntity( player, index, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
		EffectSetIsWithCockpit( fxPreEffect, true )
		thread TimeshiftPulseCleanup( fxPreEffect, 1.8 )
	}

	//wait 0.8
							//(		 amplitude 	frequency 	duration
	//CreateShake( player.GetOrigin(), 10, 		50, 		1.4,     20000 )

	//wait 0.4

	//wait 0.1

	index = GetParticleSystemIndex( FX_TIMESHIFT_SWAP_EFFECT )
	if ( IsValid( cockpit ) )
	{
		player.WaitSignal( "OnTimeFlipped" )
		int fxSwapEffect = StartParticleEffectOnEntity( player, index, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
		EffectSetIsWithCockpit( fxSwapEffect, true )
	}


}


void function ServerCallback_ShowTitanTimeshiftHint()
{
	CreateButtonPressHint( "#HINT_TITAN_TIMESHIFT", OFFHAND_SPECIAL )
}


void function ServerCallback_ShowHologramTitles()
{
	entity entTitleWormholeOvergrown = GetEntByScriptName( "entTitleWormhole" )
	entity entTitleMoonOvergrown = GetEntByScriptName( "entTitleMoon" )
	entity entTitleRingsOvergrown = GetEntByScriptName( "entTitleRings" )
	entity entTitleStream1Overgrown = GetEntByScriptName( "entTitleStream1" )
	entity entTitleStream2Overgrown = GetEntByScriptName( "entTitleStream2" )

	/*
	entity entTitleWormhole = CreateScriptRef( entTitleWormholeOvergrown.GetOrigin() + Vector( 0, 0, TIME_ZOFFSET), entTitleWormholeOvergrown.GetAngles() )
	entity entTitleMoon = CreateScriptRef( entTitleMoonOvergrown.GetOrigin() + Vector( 0, 0, TIME_ZOFFSET), entTitleMoonOvergrown.GetAngles() )
	entity entTitleRings = CreateScriptRef( entTitleRingsOvergrown.GetOrigin() + Vector( 0, 0, TIME_ZOFFSET), entTitleRingsOvergrown.GetAngles() )
	entity entTitleStream1 = CreateScriptRef( entTitleStream1Overgrown.GetOrigin() + Vector( 0, 0, TIME_ZOFFSET), entTitleStream1Overgrown.GetAngles() )
	entity entTitleStream2 = CreateScriptRef( entTitleStream2Overgrown.GetOrigin() + Vector( 0, 0, TIME_ZOFFSET), entTitleStream2Overgrown.GetAngles() )


	thread CreateTimeshiftFloatingText( entTitleRings, "#TIMESHIFT_HOLOTEXT_RINGS_TITLE", "#TIMESHIFT_HOLOTEXT_RINGS_TXT1", "#TIMESHIFT_HOLOTEXT_RINGS_TXT2", "#TIMESHIFT_HOLOTEXT_RINGS_TXT3" )
	thread CreateTimeshiftFloatingText( entTitleMoon, "#TIMESHIFT_HOLOTEXT_MOON_TITLE", "#TIMESHIFT_HOLOTEXT_MOON_TXT1", "#TIMESHIFT_HOLOTEXT_MOON_TXT2" )
	thread CreateTimeshiftFloatingText( entTitleWormhole, "#TIMESHIFT_HOLOTEXT_WORMHOLE_TITLE" )
	thread CreateTimeshiftFloatingText( entTitleStream1, "#TIMESHIFT_HOLOTEXT_STREAM1_TITLE" )
	thread CreateTimeshiftFloatingText( entTitleStream2, "#TIMESHIFT_HOLOTEXT_STREAM2_TITLE" )
	*/

	thread CreateTimeshiftFloatingText( entTitleRingsOvergrown, "#TIMESHIFT_HOLOTEXT_RINGS_TITLE", "#TIMESHIFT_HOLOTEXT_RINGS_TXT1", "#TIMESHIFT_HOLOTEXT_RINGS_TXT2", "#TIMESHIFT_HOLOTEXT_RINGS_TXT3" )
	thread CreateTimeshiftFloatingText( entTitleMoonOvergrown, "#TIMESHIFT_HOLOTEXT_MOON_TITLE", "#TIMESHIFT_HOLOTEXT_MOON_TXT1", "#TIMESHIFT_HOLOTEXT_MOON_TXT2" )
	thread CreateTimeshiftFloatingText( entTitleWormholeOvergrown, "#TIMESHIFT_HOLOTEXT_WORMHOLE_TITLE" )
	thread CreateTimeshiftFloatingText( entTitleStream1Overgrown, "#TIMESHIFT_HOLOTEXT_STREAM1_TITLE" )
	thread CreateTimeshiftFloatingText( entTitleStream2Overgrown, "#TIMESHIFT_HOLOTEXT_STREAM2_TITLE" )

	/*
		"TIMESHIFT_HOLOTEXT_RINGS_TITLE"					"[ Fold Weapon Testbed ]"
		"TIMESHIFT_HOLOTEXT_RINGS_TXT1"						"Test fold technology at 1/6 scale"
		"TIMESHIFT_HOLOTEXT_RINGS_TXT2"						"Validate Ark casing final design"
		"TIMESHIFT_HOLOTEXT_RINGS_TXT3"						"Test fire: Sunder the lunar target"
		"TIMESHIFT_HOLOTEXT_STREAM1_TITLE"					"[ Hypergravity Wavestream ]"
		"TIMESHIFT_HOLOTEXT_STREAM2_TITLE"					"[ Redirected Wavestream ]"
		"TIMESHIFT_HOLOTEXT_WORMHOLE_TITLE"					"[ Spacefold Traversal ]"
		"TIMESHIFT_HOLOTEXT_MOON_TITLE"						"[ Lunar Target: Orthros ]"
		"TIMESHIFT_HOLOTEXT_MOON_TXT1"						"Primary moon of Typhon"
		"TIMESHIFT_HOLOTEXT_MOON_TXT2"						"Test mass proxy for Harmony"
	*/
}


void function CreateTimeshiftFloatingText( entity displayOrg, string txtTitle, string txtCopyText1 = "", string txtCopyText2 = "", string txtCopyText3 = "" )
{
	float width 	= 512
	float height 	= 256
	vector org = displayOrg.GetOrigin()
	vector ang = displayOrg.GetAngles()

	vector orgOvergrown = org
	vector orgPristine = org + Vector( 0, 0, TIME_ZOFFSET )

	var topologyFront = Timeshift_CreateRUITopology( org, ang, width, height )
	var topologyBack = Timeshift_CreateRUITopology( org, ang + Vector( 0, 180, 0 ), width, height )

	var topologyFrontOvergrown = topologyFront
	var topologyBackOvergrown = topologyBack

	var topologyFrontPristine = Timeshift_CreateRUITopology( orgPristine, ang, width, height )
	var topologyBackPristine = Timeshift_CreateRUITopology( orgPristine, ang + Vector( 0, 180, 0 ), width, height )


	asset ruiAsset = $"ui/floating_holotext.rpak"


	var floatingTextFront = RuiCreate( ruiAsset, topologyFront, RUI_DRAW_WORLD, 0 )
	var floatingTextRear = RuiCreate( ruiAsset, topologyBack, RUI_DRAW_WORLD, 0 )


	float holoBoxHeight = 150
	if( txtCopyText3 == "" )
		holoBoxHeight = 120
	if( txtCopyText2 == "" )
		holoBoxHeight = 75

	float waitTime = 0.1

	while( true )
	{
		wait waitTime

		RuiDestroyIfAlive( floatingTextFront )
		RuiDestroyIfAlive( floatingTextRear )


		if ( level.timeZone == TIMEZONE_DAY )
		{
			topologyFront = topologyFrontPristine
			topologyBack = topologyBackPristine
			waitTime = 0.2
		}
		else
		{
			topologyFront = topologyFrontOvergrown
			topologyBack = topologyBackOvergrown
			waitTime = 0.2
			wait RandomFloatRange( 0.01, 0.05 )
		}

		floatingTextFront = RuiCreate( ruiAsset, topologyFront, RUI_DRAW_WORLD, 0 )
		floatingTextRear = RuiCreate( ruiAsset, topologyBack, RUI_DRAW_WORLD, 0 )

		RuiSetString( floatingTextFront, "textTop", txtTitle )
		RuiSetString( floatingTextRear, "textTop", txtTitle )

		RuiSetString( floatingTextFront, "txtCopyText1", txtCopyText1 )
		RuiSetString( floatingTextRear, "txtCopyText1", txtCopyText1 )

		RuiSetString( floatingTextFront, "txtCopyText2", txtCopyText2 )
		RuiSetString( floatingTextRear, "txtCopyText2", txtCopyText2 )

		RuiSetString( floatingTextFront, "txtCopyText3", txtCopyText3 )
		RuiSetString( floatingTextRear, "txtCopyText3", txtCopyText3 )

		RuiSetFloat( floatingTextFront, "height", holoBoxHeight )
		RuiSetFloat( floatingTextRear, "height", holoBoxHeight )

	}
}


var function Timeshift_CreateRUITopology( vector org, vector ang, float width, float height )
{
	// adjust so the RUI is drawn with the org as its center point
	org += ( (AnglesToRight( ang )*-1) * (width*0.5) )
	org += ( AnglesToUp( ang ) * (height*0.5) )

	// right and down vectors that get added to base org to create the display size
	vector right = ( AnglesToRight( ang ) * width )
	vector down = ( (AnglesToUp( ang )*-1) * height )

	//DebugDrawAngles( org, ang, 10000 )
	//DebugDrawAngles( org + right, ang, 10000 )
	//DebugDrawAngles( org + down, ang, 10000 )

	var topo = RuiTopology_CreatePlane( org, right, down, true )
	return topo
}

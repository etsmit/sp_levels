untyped

global function ClientCodeCallback_MapInit
global function ScriptCallback_LevelIntroText
global function ServerCallback_BlurCamera
global function ServerCallback_SetNearDOF
global function ServerCallback_SetDOF
global function ServerCallback_ResetDOF
global function ServerCallback_Torture_BT_Transmission
global function ServerCallback_ShowStickHint
global function ServerCallback_ShowCrouchHint
global function ServerCallback_ShowTitanfallHint
global function ServerCallback_SetBurnColorCorrectionWeight
global function ServerCallback_SetTyphonColorCorrectionWeight
global function ServerCallback_FlickerCockpitOff
global function ServerCallback_StartCockpitLook
global function ServerCallback_StopCockpitLook
global function ServerCallback_StartPilotCockpitRebootSeq
global function ServerCallback_StopPilotCockpitRebootSeq
global function ServerCallback_SetRoomTemp
global function ServerCallback_ClearRoomTemp
global function ServerCallback_InjectorNextPhase
global function ServerCallback_BTSacrifice_Cockpit
global function ServerCallback_ShowMashHint
global function ServerCallback_HideMashHint
global function ServerCallback_LerpFOV
global function ServerCallback_ScreenFlickerToBlack
global function ServerCallback_BeginHelmetBlink
global function ServerCallback_CreateHelmet
global function ServerCallback_InjectorFired
global function ServerCallback_DoRumble

global function ServerCallback_CockpitThump

global function ServerCallback_GlowOff
global function ServerCallback_GlowOn
global function ServerCallback_GlowFlash

global function ServerCallback_CreateEvacIcon
global function ServerCallback_HideEvacIcon

global function ServerCallback_InjectorFireScreenFX

const SCREEN_HEAT = $"P_heat_screen_FP"
const asset SPEED_FX = $"P_bt_launch_screen"

struct
{
	int colorCorrection
	int typhonColorCorrection
	float currentCCWeight = 0.0

	float cockpitYaw = 0.0
	float cockpitPitch = 0.0
	float currentStickYaw = 0.0
	float currentStickPitch = 0.0

	bool isJumpkitOffline = false
	vector baseView = <0,0,0>
	var tempRUI
	int celcius
	string celciusTranslation
	float shelshockScale = 5

	array<var> screenTopos
	array<var> screens

	int currentPhase = 1
	bool holdingCore = false

	int cockpitFX
	int evacFX
	var evacIcon

	float fov = 70.0
	bool cockpitLookActive = false
	entity helmet
} file

const float YAW_MAX = 20.0
const float PITCH_MAX = 40.0
const float MOVE_MAX = 1.5

void function ClientCodeCallback_MapInit()
{
	//printt( "********* CLIENT SCRIPT *************" )
	PrecacheParticleSystem( SCREEN_HEAT )
	PrecacheParticleSystem( SPEED_FX )

	ShSpSkywayCommonInit()

	RegisterSignal( "shell_shock_end" )
	RegisterSignal( "EndDOFTrack" )
	RegisterSignal( "ColorCorrection_LerpWeight" )
	RegisterSignal( "LookAround" )
	RegisterSignal( "HideMashHint" )
	RegisterSignal( "LerpFOV" )
	RegisterSignal( "AnimateDotsOnTitanMessage" )
	RegisterSignal( "GlowFlash" )
	RegisterSignal( "StopRuiAlternateStrings" )

	file.colorCorrection = ColorCorrection_Register( "materials/correction/burning_room.raw" )
	ColorCorrection_SetExclusive( file.colorCorrection, true )
	file.typhonColorCorrection = ColorCorrection_Register( "materials/correction/sp_skyway_explosion.raw" )
	ColorCorrection_SetExclusive( file.typhonColorCorrection, true )
	RegisterConCommandTriggeredCallback( "+scriptCommand2", Pressed_RequestTitanfall )
	RegisterConCommandTriggeredCallback( "+use", Pressed_Use )
	RegisterConCommandTriggeredCallback( "+useandreload", Pressed_Use )
	RegisterConCommandTriggeredCallback( "+toggle_duck", Pressed_Crouch )
	RegisterConCommandTriggeredCallback( "+duck", Pressed_Crouch )
	RegisterConCommandTriggeredCallback( "+back", Pressed_Crouch )
	RegisterButtonPressedCallback( MOUSE_LEFT, Pressed_Use )

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	AddPlayerFunc( Skyway_AddPlayer )

	RegisterServerVarChangeCallback( "fireStage", SkywayFireSoundUpdate )
	RegisterServerVarChangeCallback( "coreSoundActive", SkywayCoreSoundUpdate )

	Credits_MapInit() //MUST BE THE LAST ENTRY
}

void function EntitiesDidLoad()
{
	InitInjectorRoom()
	ServerCallback_ShowHologramTitles()
}

void function SkywayCoreSoundUpdate()
{
	entity soundSource_normal = GetEntByScriptName( "core_soundsource" )
	entity soundSource_active = GetEntByScriptName( "core_soundsource_activated" )
	entity soundSource_overload = GetEntByScriptName( "core_soundsource_overloading" )

	if ( level.nv.coreSoundActive == 0 )
	{
		soundSource_overload.SetEnabled( false )
		soundSource_active.SetEnabled( false )
		soundSource_normal.SetEnabled( false )
	}
	else if ( level.nv.coreSoundActive == 1 )
	{
		soundSource_overload.SetEnabled( false )
		soundSource_active.SetEnabled( false )
		soundSource_normal.SetEnabled( true )
	}
	else if ( level.nv.coreSoundActive == 2 )
	{
		soundSource_overload.SetEnabled( false )
		soundSource_active.SetEnabled( true )
		soundSource_normal.SetEnabled( true )
	}
	else if ( level.nv.coreSoundActive == 3 )
	{
		soundSource_overload.SetEnabled( true )
		soundSource_active.SetEnabled( false )
		soundSource_normal.SetEnabled( false )
	}
}

void function SkywayFireSoundUpdate()
{
	array<entity> fireStage1 = GetEntArrayByScriptName( "fire_ambient_stage1" )
	array<entity> fireStage2 = GetEntArrayByScriptName( "fire_ambient_stage2" )

	if ( level.nv.fireStage == 0 )
	{
		foreach ( f in fireStage1 )
			f.SetEnabled( false )
		foreach ( f in fireStage2 )
			f.SetEnabled( false )
	}
	else if ( level.nv.fireStage == 1 )
	{
		foreach ( f in fireStage1 )
			f.SetEnabled( true )
		foreach ( f in fireStage2 )
			f.SetEnabled( false )
	}
	else if ( level.nv.fireStage == 2 )
	{
		foreach ( f in fireStage1 )
			f.SetEnabled( true )
		foreach ( f in fireStage2 )
			f.SetEnabled( true )
	}
}

void function Skyway_AddPlayer( entity player )
{
	if ( IsMenuLevel() )
		return

	if ( GetGlobalNetBool( "skywayBurningRoom" ) )
	{
		player.Signal( "CycleDofThread" )
		entity cockpit = GetLocalViewPlayer().GetCockpit()
		if ( IsValid( cockpit ) )
			file.cockpitFX = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( SCREEN_HEAT ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		file.isJumpkitOffline = true
		ServerCallback_SetBurnColorCorrectionWeight( 0.75, 0.0 )
		SetScreenBlur( 0.5, 0.0, 0.0 )
		DoF_SetFarDepth( 150, 350 )
		thread CockpitRebootLoadFromSave()
	}

	if ( GetGlobalNetInt( "titanRebootPhase" ) > skywayTitanCockpitStatus.DEFAULT )
	{
		thread TitanCockpitRebootLoadFromSave()
	}

	if ( IsValid( GetGlobalNetEnt( "evacPoint" ) ) )
	{
		var clight = GetLightEnvironmentEntity()
		clight.ScaleSunSkyIntensity( 0.0, 1.0 )
		DoF_SetFarDepth( 8000, 500000 )
		thread CreateEvacShipWorldFX( GetGlobalNetEnt( "evacPoint" ), 61, 200, 255 )
	}
}

void function TitanCockpitRebootLoadFromSave()
{
	waitthread ScreenBoot()
	thread RandomScreenFlicker()
	// thread TitanCockpitHex()
	thread DisplayProtocols_PilotLinkThread()
	ServerCallback_ShowStickHint()

	var rui
	int maxLines = 5
	vector msgPos = <0.37,0.68,0.0>
	float fontSize = 32.0
	array<string> messages = []
	array<var> ruis = []

	var promptRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	RuiSetInt( promptRUI, "maxLines", maxLines )
	RuiSetInt( promptRUI, "lineNum", 1 )
	RuiSetString( promptRUI, "msgText", "> " )
	RuiSetFloat( promptRUI, "msgFontSize", fontSize )
	RuiSetFloat( promptRUI, "msgAlpha", 0.8 )
	RuiSetFloat( promptRUI, "thicken", 0.0 )
	RuiSetFloat3( promptRUI, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( promptRUI, "msgPos", msgPos )

	for( int i=0; i<maxLines; i++ )
	{
		messages.append( "" )
		rui = RuiCreate( $"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
		RuiSetInt( rui, "maxLines", maxLines )
		RuiSetInt( rui, "lineNum", i+1 )
		RuiSetString( rui, "msgText", "" )
		RuiSetFloat( rui, "msgFontSize", fontSize )
		RuiSetFloat( rui, "msgAlpha", 0.8 )
		RuiSetFloat( rui, "thicken", 0.0 )
		RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
		RuiSetFloat2( rui, "msgPos", msgPos )
		ruis.append(rui)
	}

	thread TitanCockpitRebootPt2( messages, ruis, promptRUI )

	DoF_SetFarDepth( 600, 900 )
}

/*
	TIME SHIFT HOLOGRAMS
*/

void function ServerCallback_ShowHologramTitles()
{
	entity entTitleWormholeOvergrown = GetEntByScriptName( "entTitleWormhole" )
	entity entTitleMoonOvergrown = GetEntByScriptName( "entTitleMoon" )
	entity entTitleRingsOvergrown = GetEntByScriptName( "entTitleRings" )
	entity entTitleStream1Overgrown = GetEntByScriptName( "entTitleStream1" )
	entity entTitleStream2Overgrown = GetEntByScriptName( "entTitleStream2" )

	thread CreateTimeshiftFloatingText( entTitleRingsOvergrown, "#SKYWAY_HOLOTEXT_RINGS_TITLE", "#SKYWAY_HOLOTEXT_RINGS_TXT1", "#SKYWAY_HOLOTEXT_RINGS_TXT2", "#SKYWAY_HOLOTEXT_RINGS_TXT3" )
	thread CreateTimeshiftFloatingText( entTitleMoonOvergrown, "#SKYWAY_HOLOTEXT_MOON_TITLE", "#SKYWAY_HOLOTEXT_MOON_TXT1", "#SKYWAY_HOLOTEXT_MOON_TXT2" )
	thread CreateTimeshiftFloatingText( entTitleWormholeOvergrown, "#SKYWAY_HOLOTEXT_WORMHOLE_TITLE", "#SKYWAY_HOLOTEXT_WORMHOLE_TXT1"  )
	// thread CreateTimeshiftFloatingText( entTitleStream1Overgrown, "#SKYWAY_HOLOTEXT_STREAM1_TITLE" )
	// thread CreateTimeshiftFloatingText( entTitleStream2Overgrown, "#SKYWAY_HOLOTEXT_STREAM2_TITLE" )
}


void function CreateTimeshiftFloatingText( entity displayOrg, string txtTitle, string txtCopyText1 = "", string txtCopyText2 = "", string txtCopyText3 = "" )
{
	float width 	= 512
	float height 	= 256
	vector org = displayOrg.GetOrigin()
	vector ang = displayOrg.GetAngles()

	vector orgPristine = org

	var topologyFrontPristine = Timeshift_CreateRUITopology( orgPristine, ang, width, height )
	var topologyBackPristine = Timeshift_CreateRUITopology( orgPristine, ang + Vector( 0, 180, 0 ), width, height )

	asset ruiAsset = $"ui/floating_holotext_large.rpak"

	var floatingTextFront = RuiCreate( ruiAsset, topologyFrontPristine, RUI_DRAW_WORLD, 0 )
	var floatingTextRear = RuiCreate( ruiAsset, topologyBackPristine, RUI_DRAW_WORLD, 0 )

	float holoBoxHeight = 225
	if( txtCopyText3 == "" )
		holoBoxHeight = 180
	if( txtCopyText2 == "" )
		holoBoxHeight = 140

	float waitTime = 0.1

	{
		RuiSetString( floatingTextFront, "textTop", txtTitle )
		RuiSetString( floatingTextRear, "textTop", txtTitle )

		RuiSetString( floatingTextFront, "txtCopyText1", txtCopyText1 )
		RuiSetString( floatingTextRear, "txtCopyText1", txtCopyText1 )

		RuiSetString( floatingTextFront, "txtCopyText2", txtCopyText2 )
		RuiSetString( floatingTextRear, "txtCopyText2", txtCopyText2 )

		RuiSetString( floatingTextFront, "txtCopyText3", txtCopyText3 )
		RuiSetString( floatingTextRear, "txtCopyText3", txtCopyText3 )

		RuiSetFloat( floatingTextFront, "length", 1000 )
		RuiSetFloat( floatingTextRear, "length", 1000 )

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

void function ServerCallback_LerpFOV( float finalValue, float time )
{
	thread ServerCallback_LerpFOV_Internal( finalValue, time )
}

void function ServerCallback_ScreenFlickerToBlack()
{
	thread ServerCallback_ScreenFlickerToBlack_Internal()
}

void function ServerCallback_ScreenFlickerToBlack_Internal()
{
	var rui = RuiCreate( $"ui/sp_blackscreen.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 5000 )
	RuiSetFloat( rui, "alpha", 0.5 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.5 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.75 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.75 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 0.0 )
	wait 0.05
	RuiSetFloat( rui, "alpha", 1.0 )

	wait 0.7

	thread FadeOutRuiOverTime( rui, 1.0 )
}

void function FadeOutRuiOverTime( var rui, float fadeTime )
{
	float startTime = Time()
	while( startTime + fadeTime > Time() )
	{
		float elapsedTime = Time() - startTime
		float alpha = GraphCapped( elapsedTime, 0.0, fadeTime, 1.0, 0.0 )
		RuiSetFloat( rui, "alpha", alpha )
		WaitFrame()
	}
	RuiDestroy( rui )
}

void function ScriptCallback_LevelIntroText()
{
	BeginIntroSequence()
	var infoText2 = RuiCreate( $"ui/sp_level_title.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 100 )
	RuiSetGameTime( infoText2, "startTime", Time() )
	RuiSetString( infoText2, "txtLine1", "#SP_SKYWAY_V1_CAMPAIGN_LINE1" )
	RuiSetString( infoText2, "txtLine2", "#SP_SKYWAY_V1_CAMPAIGN_LINE2" )
	RuiSetString( infoText2, "txtLine3", "#SP_SKYWAY_V1_CAMPAIGN_LINE3" )
}

void function ServerCallback_LerpFOV_Internal( float finalValue, float time )
{
	clGlobal.levelEnt.Signal( "LerpFOV" )
	clGlobal.levelEnt.EndSignal( "LerpFOV" )

	float tick = 0.1
	float rate = (finalValue - file.fov) / time
	float secondsPerTick = tick / 1.0
	rate = rate * secondsPerTick

	float startTime = Time()
	while ( Time() - startTime < time )
	{
		printt( file.fov )
		file.fov += rate
		GetLocalViewPlayer().ClientCommand( "set fov " + file.fov )
		wait tick
	}

	GetLocalViewPlayer().ClientCommand( "set fov " + finalValue )
}

void function ServerCallback_ShowMashHint()
{
	var rui = CreateCockpitRui( $"ui/mash_hint_text.rpak", 0 )
	thread MashHintThink( rui, "HideMashHint" )
}

void function MashHintThink( var rui, string signal )
{
	clGlobal.levelEnt.EndSignal( signal )

	DoF_LerpNearDepth( 0, 20, 2 )
	DoF_LerpFarDepth( 100, 150, 2 )

	file.holdingCore = true

	OnThreadEnd(
	function() : ( rui )
		{
			file.holdingCore = false
			RuiDestroy( rui )
			DoF_LerpNearDepthToDefault( 3.0 )
			DoF_LerpFarDepthToDefault( 3.0 )
		}
	)

	WaitForever()
}

void function ServerCallback_HideMashHint()
{
	clGlobal.levelEnt.Signal( "HideMashHint" )
}

void function Pressed_RequestTitanfall( entity player )
{
	player.ClientCommand( "ClientCommand_RequestTitanFake" )
	HidePlayerHint( "#HUD_TITAN_READY_HINT" )
}

void function Pressed_Crouch( entity player )
{
	player.ClientCommand( "ClientCommand_StopPulldown" )
	ServerCallback_HideMashHint()
}

void function Pressed_Use( entity player )
{
	if ( file.holdingCore )
	{
		ClientScreenShake( 1.0, 5.0, 0.1, Vector( 0.0, 0.0, -1.0 ) )
		player.ClientCommand( "ClientCommand_Pulldown" )
	}
}

void function ServerCallback_SetBurnColorCorrectionWeight( float weight, float duration )
{
	thread ColorCorrection_LerpWeight( file.colorCorrection, weight, duration )
}

void function ServerCallback_SetTyphonColorCorrectionWeight( float weight, float duration )
{
	thread ColorCorrection_LerpWeight( file.typhonColorCorrection, weight, duration )
}

void function ColorCorrection_LerpWeight( int colorCorrection, float endWeight, float lerpTime = 0 )
{
	clGlobal.levelEnt.Signal( "ColorCorrection_LerpWeight" )
	clGlobal.levelEnt.EndSignal( "ColorCorrection_LerpWeight" )

	float startWeight = file.currentCCWeight
	float startTime = Time()
	float endTime = startTime + lerpTime

	while( Time() <= endTime )
	{
		WaitFrame()
		float weight = GraphCapped( Time(), startTime, endTime, startWeight, endWeight )
		ColorCorrection_SetWeight( colorCorrection, weight )

		file.currentCCWeight = weight
	}

	ColorCorrection_SetWeight( colorCorrection, endWeight )
}


void function ServerCallback_StartCockpitLook( bool cockpitReboot = false )
{
	file.cockpitLookActive = true
	if ( cockpitReboot )
		thread TitanCockpitReboot()
	thread ServerCallback_StartCockpitLook_Internal()
}

void function ServerCallback_StartCockpitLook_Internal()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()

	while ( !GetLocalViewPlayer().IsTitan() )
	{
		cockpit = GetLocalViewPlayer().GetCockpit()
		WaitFrame()
	}

	wait 0.25

	cockpit = GetLocalViewPlayer().GetCockpit()

	cockpit.Anim_NonScriptedPlay( "atpov_look_idle" )
	thread LookAround( cockpit )
	RegisterStickMovedCallback( ANALOG_RIGHT_X, CockpitLookRightStickX )
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, CockpitLookRightStickY )
	thread FlashCockpitLight( cockpit, Vector( 0.6, 0.06, 0 ), 70.0, -1, "FX_BR_PANEL" )
}

void function ServerCallback_StopCockpitLook()
{
	if ( !file.cockpitLookActive )
		return
	entity cockpit = GetLocalViewPlayer().GetCockpit()
	// cockpit.Anim_NonScriptedPlay( "atpov_cockpit_hatch_close_idle" )
	// Signal( clGlobal.levelEnt, "LookAround" )
	DeregisterStickMovedCallback( ANALOG_RIGHT_X, CockpitLookRightStickX )
	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, CockpitLookRightStickY )
	thread CenterView()
}

void function CenterView()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()

	while ( !GetLocalViewPlayer().IsTitan() )
	{
		cockpit = GetLocalViewPlayer().GetCockpit()
		WaitFrame()
	}

	cockpit.Anim_NonScriptedPlay( "atpov_cockpit_hatch_close_idle" )
	Signal( clGlobal.levelEnt, "LookAround" )
}

void function LookAround( entity body )
{
	body.EndSignal( "OnDestroy" )
	EndSignal( clGlobal.levelEnt, "LookAround" )

	thread SineBaseView( body )

	int dir = 1
	float angle = 0.0
	while( 1 )
	{
		if ( fabs( file.currentStickYaw ) < 0.2 )
			file.currentStickYaw = 0.0
		if ( fabs( file.currentStickPitch ) < 0.2 )
			file.currentStickPitch = 0.0

		file.cockpitYaw = clamp( file.cockpitYaw - (file.currentStickYaw * MOVE_MAX), -1*YAW_MAX, YAW_MAX )
		file.cockpitPitch = clamp( file.cockpitPitch + (file.currentStickPitch * MOVE_MAX), -1*PITCH_MAX, PITCH_MAX )

		// printt( "---------------" )
		// printt( file.cockpitYaw )
		// printt( file.cockpitPitch )
		// printt( "---------------" )

		body.SetPoseParameter( "aim_yaw", file.baseView.x + file.cockpitYaw )
		body.SetPoseParameter( "aim_pitch", file.baseView.y + file.cockpitPitch )
		WaitFrame()
	}
}

void function SineBaseView( entity body )
{
	body.EndSignal( "OnDestroy" )
	EndSignal( clGlobal.levelEnt, "LookAround" )

	float startTime = Time()
	float speedScale = 0.5

	while ( 1 )
	{
		float baseX = cos( (Time()-startTime) * speedScale ) * file.shelshockScale
		float baseY = cos( (Time()-startTime) * 2 * speedScale ) * file.shelshockScale

		file.baseView = <baseX,baseY,0>

		WaitFrame()
	}
}

void function CockpitLookRightStickX( entity player, float val )
{
	file.currentStickYaw = val
}

void function CockpitLookRightStickY( entity player, float val )
{
	float multiplier = GetConVarBool( INVERT_CONVAR_GAMEPAD ) ? -1.0 : 1.0
	file.currentStickPitch = val * multiplier
}

void function ServerCallback_ShowStickHint()
{
	var rui = CreatePermanentCockpitRui( $"ui/big_button_hint.rpak", 0 )
	if ( GetConVarInt( "joy_movement_stick" ) == 0 )
		RuiSetString( rui, "msgText", "#FORWARD_CONSOLE" )
	else
		RuiSetString( rui, "msgText", "#FORWARD_CONSOLE_SOUTHPAW" )
	RuiSetString( rui, "msgTextPC", "#FORWARD_PC" )
	RuiSetFloat2( rui, "msgPos", <0.5,0.65,0.0> )
	RuiSetFloat( rui, "duration", 2.5 )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetResolutionToScreenSize( rui )
}

void function ServerCallback_ShowCrouchHint()
{
	if ( !GetLocalViewPlayer().IsTitan() )
		return

	OnscreenHint hintInfo
	hintInfo.locStringGamepad = "#HINT_CROUCH"
	thread DisplayOnscreenHint( hintInfo, 8.0 )

	thread TryHideHint( GetLocalViewPlayer(), 8.0, "#HINT_CROUCH" )
}

void function TryHideHint( entity player, float time, string hint )
{
	player.EndSignal( "OnDeath" )
	float startTime = Time()
	while ( Time() - startTime < time )
	{
		if ( player.IsCrouched() || !player.IsTitan() )
		{
			ScriptCallback_ClearOnscreenHint()
			break
		}

		wait 0.1
	}

}

void function ServerCallback_ShowTitanfallHint()
{
	AnnouncementMessage( GetLocalViewPlayer(), "#HUD_TITAN_READY", "#HUD_TITAN_READY_HINT", TEAM_COLOR_YOU )
	thread RepeatHint()
}

void function RepeatHint()
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDeath" )

	while ( GetTitanFromPlayer( player ) == null )
	{
		wait 10.0
		if ( GetTitanFromPlayer( player ) == null )
			AddPlayerHint( 8.0, 0.25, $"", "#HUD_TITAN_READY_HINT" )
	}

	HidePlayerHint( "#HUD_TITAN_READY_HINT" )
}

void function ServerCallback_BlurCamera( float amount, float duration, int easingType )
{
	SetScreenBlur( amount, duration, easingType )
}

void function ServerCallback_SetNearDOF( float near, float far, float interval )
{
	DoF_LerpNearDepth( near, far, interval )
}

void function ServerCallback_SetDOF( float near, float far, float interval )
{
	DoF_LerpFarDepth( near, far, interval )
}

void function ServerCallback_ResetDOF()
{
	ResetDOF()
}

void function ResetDOF()
{
	// reset Blur
	DoF_LerpFarDepthToDefault( 1.5 )
	DoF_LerpNearDepthToDefault( 1.5 )
}

void function ShellShockBlur()
{
	//EASING_LINEAR
	//EASING_SINE_IN
	//EASING_SINE_OUT
	//EASING_SINE_INOUT
	//EASING_CIRC_IN
	//EASING_CIRC_OUT
	//EASING_CIRC_INOUT
	//EASING_CUBIC_IN
	//EASING_CUBIC_OUT
	//EASING_CUBIC_INOUT
	//EASING_BACK_IN
	//EASING_BACK_OUT
	//EASING_BACK_INOUT

	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	EndSignal( level, "shell_shock_end" )

	OnThreadEnd(
		function() : ()
		{
			// reset Blur
			DoF_LerpFarDepthToDefault( 1.5 )
			DoF_LerpNearDepthToDefault( 1.5 )

			SetScreenBlur( 0, 0.25, EASING_SINE_INOUT )
		}
	)

	DoF_LerpFarDepth( 2000, 8000, 1.0 )
	DoF_LerpNearDepth( 1, 50, 1.0 )

	float waitTime
	int inNOut = 1
	while( true )
	{

		// blur screen stuff
		if ( inNOut == 1 )
		{
			// blur
			float blurAmount = RandomFloatRange( 0.25, 1 )
			float blurTime = RandomFloatRange( blurAmount, blurAmount + 1.0 )

			SetScreenBlur( blurAmount, blurTime, EASING_SINE_INOUT )

			waitTime = RandomFloatRange( 0.25, 0.75 ) + blurTime
		}
		else
		{
			// clear
			float clearTime = RandomFloatRange( 0.5, 3 )
			SetScreenBlur( 0, clearTime, EASING_SINE_INOUT )

			waitTime = RandomFloatRange( 1, 4 ) + clearTime
		}

		wait waitTime

		inNOut = inNOut^1
	}
}

/*
--------------------------------------------------------------
--------------------------------------------------------------
					COCKPIT REBOOT
--------------------------------------------------------------
--------------------------------------------------------------
*/

void function ServerCallback_StartPilotCockpitRebootSeq()
{
	if ( !file.isJumpkitOffline )
	{
		file.isJumpkitOffline = true
		thread CockpitRebootStart()
	}
}

void function ServerCallback_StopPilotCockpitRebootSeq()
{
	file.isJumpkitOffline = false
}

void function CockpitRebootLoadFromSave()
{
	float xOffset = 0.05

	array<var> ruis = []

	var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 0 )
	RuiSetString( rui, "msgText", "#HUD_WARNING_LABEL" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	RuiSetFloat3( rui, "msgColor", <1.0,0.0,0.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 1 )
	RuiSetString( rui, "msgText", "#HUD_JUMPKIT_STATUS" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	var messageRui = rui
	RuiSetString( rui, "msgText2", "#HUD_OFFLINE" )

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 2 )
	RuiSetString( rui, "msgText", "#HUD_JUMPKIT_REBOOTING" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )

	thread CockpitRebootingThread( xOffset, ruis, messageRui )
}

void function CockpitRebootStart()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()
	if ( IsValid( cockpit ) )
		file.cockpitFX = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( SCREEN_HEAT ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	while ( !GetGlobalNetBool( "skywayBurningRoom" ) )
		wait 0.1

	GetLocalViewPlayer().Signal( "CycleDofThread" )
	ServerCallback_SetDOF( 150, 350, 1.5 )

	float xOffset = 0.05

	array<var> ruis = []

	var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 0 )
	RuiSetString( rui, "msgText", "#HUD_WARNING_LABEL" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	RuiSetFloat3( rui, "msgColor", <1.0,0.0,0.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )

	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 0.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 1.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 0.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 1.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 0.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 1.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 0.0 )
	// wait 0.5
	// RuiSetFloat( rui, "msgAlpha", 1.0 )
	// wait 0.5


	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 1 )
	RuiSetString( rui, "msgText", "#HUD_JUMPKIT_STATUS" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	var messageRui = rui

	wait 1.5

	RuiSetString( rui, "msgText2", "#HUD_OFFLINE" )
	thread BlinkRui( rui )

	wait 5.0

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 2 )
	RuiSetString( rui, "msgText", "#HUD_JUMPKIT_REBOOTING" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.0 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	// thread AnimateDots( rui )
	ruis.append( rui )

	wait 0.1

	thread CockpitRebootingThread( xOffset, ruis, messageRui )
}

void function CockpitRebootingThread( float xOffset, array<var> ruis, var messageRui )
{
	while( file.isJumpkitOffline )
	{
		// CreateCockpitHex( xOffset, 0.35, 4, 10 )
  		wait 0.05
	}

	thread PlayerADSDof( GetLocalViewPlayer(), 0, 0 )

	if ( EffectDoesExist( file.cockpitFX ) )
		EffectStop( file.cockpitFX, true, false )

	wait 0.5

	foreach ( r in ruis )
	{
		// thread FlickerOut( r )
		RuiDestroy( r )
	}

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_smartpistolrun_UI_jumpkit_status" )
	FlickerIn( messageRui )
	RuiSetString( messageRui, "msgText", "#HUD_JUMPKIT_INITIALIZING" )

	int progress = 0

	for ( int i=0; i<=100; i+=2 )
	{
		RuiSetString( messageRui, "msgText2", string(i) )
		wait 0.05
	}

	RuiSetString( messageRui, "msgText", "#HUD_JUMPKIT_ONLINE" )
	RuiSetString( messageRui, "msgText2", "" )
	FlickerOut( messageRui, 3, false )
	RuiSetFloat( messageRui, "msgAlpha", 1.0 )
	GetLocalViewPlayer().ClientCommand( "enable_jumpkit" )

	wait 5.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_smartpistolrun_UI_jumpkit_online_disappear" )
	FlickerOut( messageRui )
}


void function FlickerIn( var rui, int times = 3 )
{
	float baseAlpha = 0.2

	for ( int i=0; i<times; i++ )
	{
		RuiSetFloat( rui, "msgAlpha", baseAlpha )
		wait 0.05
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		wait 0.05
	}
	RuiSetFloat( rui, "msgAlpha", 1.0 )
}

void function FlickerOut( var rui, int times = 3, bool destroy = true )
{
	float baseAlpha = 0.2

	for ( int i=0; i<times; i++ )
	{
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		wait 0.05
		RuiSetFloat( rui, "msgAlpha", baseAlpha )
		wait 0.05
	}

	if ( destroy )
		RuiDestroy( rui )
	else
		RuiSetFloat( rui, "msgAlpha", 0.0 )
}

void function BlinkRui( var rui )
{
	while( file.isJumpkitOffline )
	{
		RuiSetString( rui, "msgText2", "OFFLINE" )
		wait 0.75
		RuiSetString( rui, "msgText2", "" )
		wait 0.75
	}

}

void function AnimateDots( var rui )
{
	string baseString = "Rebooting Jumpkit"
	while( file.isJumpkitOffline )
	{
		RuiSetString( rui, "msgText2", "" )
		wait 0.25
		RuiSetString( rui, "msgText2", "." )
		wait 0.25
		RuiSetString( rui, "msgText2", ".." )
		wait 0.25
		RuiSetString( rui, "msgText2", "..." )
		wait 0.25
	}

}

void function CreateCockpitHex( float xOffset, float yOffset = 0.3, int hexLengtth = 4, int maxLines = 30, asset ruiFile = $"ui/cockpit_console_text_top_left.rpak", int lineNum = 0 )
{
	var rui = RuiCreate( ruiFile, clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	RuiSetInt( rui, "maxLines", maxLines )

	string hex = GenerateHexString( 4 )
	for ( int i=0; i<hexLengtth; i++ )
	{
		hex += " " + GenerateHexString( 4 )
	}

	RuiSetString( rui, "msgText", hex )
	RuiSetFloat( rui, "msgFontSize", 22.0 )
	RuiSetFloat( rui, "lineHoldtime", 0.05 )
	RuiSetFloat( rui, "msgAlpha", 0.075 )
	RuiSetFloat2( rui, "msgPos", <xOffset,yOffset,0.0> )
	RuiSetBool( rui, "autoMove", true )
	RuiSetInt( rui, "lineNum", lineNum )
	RuiSetResolutionToScreenSize( rui )
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

string function GetCelciusTranslation( int celcius )
{
	string msg = "#SKYWAY_TEMP_1"

	if ( celcius > 85 )
		msg = "#SKYWAY_TEMP_2"

	if ( celcius > 95 )
		msg = "#SKYWAY_TEMP_3"

	return msg
}

void function ServerCallback_SetRoomTemp( int celcius )
{
	if ( file.tempRUI == null )
	{
		var rui = CreateCockpitRui( $"ui/skyway_cockpit_temperature.rpak", 0 )
		RuiSetInt( rui, "maxLines", 30 )
		RuiSetInt( rui, "lineNum", 2 )
		// RuiSetString( rui, "msgText", "#HUD_TEMPERATURE_WARN" )
		RuiSetString( rui, "msgText2", string(66) )
		RuiSetFloat( rui, "msgFontSize", 40.0 )
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
		RuiSetFloat2( rui, "msgPos", <0.90,0.08,0.0> )
		file.tempRUI = rui
		thread TempWarnSounds()
	}

	file.celcius = celcius
	string celciusTranslation = GetCelciusTranslation( celcius )
	RuiSetString( file.tempRUI, "msgText", celciusTranslation )

	if ( celcius > 50 )
	{
		RuiSetFloat( file.tempRUI, "msgAlpha", 0.8 )
	}
	else
	{
		RuiSetFloat( file.tempRUI, "msgAlpha", 0.0 )
	}

	file.celciusTranslation = celciusTranslation

	// if ( GetGlobalNetBool( "roomTempManageBlur" ) == false )
	// 	return

	// float amount = GraphCapped( celcius, 70, 90, 0.65, 1.0 )
	// SetScreenBlur( amount, 0.5, 0 )
}

void function TempWarnSounds()
{
	while ( file.tempRUI != null )
	{
		EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_anim_tortureroom_temperature_increment_hud" )
		float waitTime = GraphCapped( float( file.celcius ), 70, 97, 2.5, 0.1 )
		wait waitTime
	}
}

void function ServerCallback_ClearRoomTemp()
{
	thread ServerCallback_ClearRoomTemp_Internal()
}

void function ServerCallback_ClearRoomTemp_Internal()
{
	SetScreenBlur( 0.0, 3, 0 )

	// while( file.celcius > 50 )
	// {
	// 	RuiSetString( file.tempRUI, "msgText2", string(file.celcius - 25) )
	// 	file.celcius -= 1
	// 	wait 0.05
	// }

	RuiDestroy( file.tempRUI )
	file.tempRUI = null
}

void function InitInjectorRoom()
{
	array<entity> screens = GetEntArrayByScriptName( "injector_room_screen" )
	foreach ( screen in screens )
		file.screenTopos.append( AddInjectorRoomScreen( screen ) )

	foreach ( screen in file.screenTopos )
	{
		var rui = RuiCreate( $"ui/skyway_injector_screen.rpak", screen, RUI_DRAW_WORLD, 0 )
		RuiSetInt( rui, "phaseNum", GetGlobalNetInt( "injectorRoomPhase" ) )
		file.screens.append( rui )
	}
}

var function AddInjectorRoomScreen( entity ent )
{
	// entity rightOrg = ent.GetLinkEnt()
	// entity downOrg = rightOrg.GetLinkEnt()

	float width = 376
	float height = 248

	vector ang = ent.GetAngles()
	vector right = ( (AnglesToRight( ang )*-1) * width )
	vector down = ( (AnglesToUp( ang )*-1) * height )

	vector org = ent.GetOrigin()

	// vector right = rightOrg.GetOrigin() - org
	// vector down = downOrg.GetOrigin() - org

	var topo = RuiTopology_CreatePlane( org, right, down, true )
	return topo
}

void function ServerCallback_InjectorNextPhase()
{
	int newValue = GetGlobalNetInt( "injectorRoomPhase" )
	foreach ( rui in file.screens )
	{
		RuiSetInt( rui, "phaseNum", newValue )
	}
}

void function ServerCallback_GlowOn( float scale = 2.5 )
{
	AutoExposureSetMaxExposureMultiplier( 500 ) // allow exposure to actually go bright, even if it's clamped in the level.
	AutoExposureSetExposureCompensationBias( scale )
}

void function ServerCallback_GlowOff()
{
	AutoExposureSetMaxExposureMultiplier( 1 ) // allow exposure to actually go bright, even if it's clamped in the level.
	AutoExposureSetExposureCompensationBias( 0.5 )
}


void function ServerCallback_GlowFlash( float min, float max )
{
	thread ServerCallback_GlowFlash_Internal( min, max )
}

void function ServerCallback_GlowFlash_Internal( float min, float max )
{
	clGlobal.levelEnt.Signal( "GlowFlash" )
	clGlobal.levelEnt.EndSignal( "GlowFlash" )

	float START_DURATION = 4.0
	float TONEMAP_MAX = max
	float TONEMAP_MIN = min

	//SetCockpitLightingEnabled( 0, false );
	AutoExposureSetMaxExposureMultiplier( 500 )
	AutoExposureSetExposureCompensationBias( TONEMAP_MAX )
	// AutoExposureSnap()

	wait 0.15

	local startTime = Time()
	while( 1 )
	{
		local time = Time() - startTime
		float factor = GraphCapped( time, 0, START_DURATION, 1, 0 )
		local toneMapScale = TONEMAP_MIN + (TONEMAP_MAX - TONEMAP_MIN) * factor
		AutoExposureSetExposureCompensationBias( toneMapScale )
		AutoExposureSnap()
		wait  0
		if ( factor == 0 )
			break;
	}

	AutoExposureSetExposureCompensationBias( 0 )

	// Ramp the exposure max multiplier back down to 1
	const TONEMAP_3_START_DURATION = 5
	const TONEMAP_3_MAX = 10
	const TONEMAP_3_MIN = 1
	startTime = Time()
	while( 1 )
	{
		local time = Time() - startTime
		float factor = GraphCapped( time, 0, TONEMAP_3_START_DURATION, 1, 0 )
		local scale = TONEMAP_3_MIN + (TONEMAP_3_MAX - TONEMAP_3_MIN) * factor
		AutoExposureSetMaxExposureMultiplier( scale );
		wait  0
		if ( factor == 0 )
			break;
	}
}

/*
------------------------------------------------------------
------------------------------------------------------------
BLISK FAREWELL COCKPIT REBOOT
------------------------------------------------------------
------------------------------------------------------------
*/

void function ScreenBoot()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()

	while ( !GetLocalViewPlayer().IsTitan() )
	{
		cockpit = GetLocalViewPlayer().GetCockpit()
		WaitFrame()
	}

	while ( !IsValid( cockpit ) )
	{
		cockpit = GetLocalViewPlayer().GetCockpit()
		WaitFrame()
	}

	cockpit = GetLocalViewPlayer().GetCockpit()
	cockpit.SetSkin( 1 )

	for ( int i=0; i<5; i++ )
	{
		cockpit.SetCockpitPanelTransparency( i, 0 )
		float maxChroma = RandomFloatRange( 0.1, 0.2 )
		float minChroma = 0.0
		if ( i == 2 )
		{
			maxChroma = 0.075
		}
		if ( i == 0 || i == 3 )
		{
			minChroma = 0.6
			maxChroma = 0.8
		}
		thread ManipulateCockpitChroma( cockpit, i, minChroma, maxChroma )
	}
	thread PermaShakeScreen( cockpit, 1 )


	wait 0.25

	thread ScreenFlickerOn( cockpit, 2, 15, 0.3 )

	wait 0.5

	thread ScreenFlickerOn( cockpit, 0, 15, 0.3 )

	wait 0.15

	thread ScreenFlickerOn( cockpit, 4, 15, 0.3 )

	wait 0.1

	thread ScreenFlickerOn( cockpit, 3, 15, 0.3 )

	wait 0.05

	thread ScreenFlickerOn( cockpit, 1, 15, 0.3 )

	wait 0.25

	thread ScreenFlickerOn( cockpit, 2, 15, 0.85, 0.3, 0.8 )

	wait 0.5

	thread ScreenFlickerOn( cockpit, 0, 15, 0.85, 0.3, 0.8 )

	wait 0.15

	thread ScreenFlickerOn( cockpit, 4, 15, 0.85, 0.3, 0.8 )

	wait 0.1

	thread ScreenFlickerOn( cockpit, 3, 15, 0.85, 0.3, 0.8 )

	wait 0.05

	thread ScreenFlickerOn( cockpit, 1, 15, 0.85, 0.3, 0.8 )
}

void function ManipulateCockpitChroma( entity cockpit, int screenNum, float minChroma, float maxChroma )
{
	cockpit.EndSignal( "OnDestroy" )

	float startTime = Time() + RandomFloatRange( 0, 15 )
	float diff = maxChroma - minChroma

	while ( 1 )
	{
		float chromaScale = (sin( (Time() - startTime) )*diff) + minChroma
		cockpit.SetCockpitPanelChroma( screenNum, chromaScale )
		wait 0.05
	}
}

void function ScreenFlickerOn( entity cockpit, int screenNum, int times, float maxAlpha, float lowAlpha = 0.0, float highAlpha = 0.05 )
{
	ScreenFlicker( cockpit, screenNum, times, lowAlpha, highAlpha )

	cockpit.SetCockpitPanelTransparency( screenNum, maxAlpha )
}

void function ScreenFlicker( entity cockpit, int screenNum, int times, float lowAlpha, float highAlpha )
{
	cockpit.EndSignal( "OnDestroy" )

	array<vector> screenOffsets = [
	<50,-30,0>,
	<50,0,26>,
	<50,0,0>,
	<50,0,-26>,
	<50,30,0>
	]

	if ( times >= 3 )
	{
		int maxFlickerSound = 15
		int flickerNum = minint( times, maxFlickerSound )
		entity player = GetLocalViewPlayer()
		vector origin = player.CameraPosition()
		vector angles = player.CameraAngles()
		vector fwd = AnglesToForward( angles )
		vector rgt = AnglesToRight( angles )
		vector up = AnglesToUp( angles )
		string sound = "skyway_scripted_BTscreenglitch_" +flickerNum+ "flicker"
		origin = origin + fwd*screenOffsets[screenNum].x + rgt*screenOffsets[screenNum].y + up*screenOffsets[screenNum].z
		entity mover = CreateClientsideScriptMover( $"models/dev/empty_model.mdl", origin, <0,0,0> )
		mover.SetParent( player.GetFirstPersonProxy(), "CAMERA", true )
		EmitSoundOnEntity( mover, sound )

		OnThreadEnd(
		function() : ( mover )
			{
				mover.Destroy()
			}
		)
	}

	for ( int i=0; i<times; i++ )
	{
		cockpit.SetCockpitPanelTransparency( screenNum, lowAlpha )
		wait 0.02
		cockpit.SetCockpitPanelTransparency( screenNum, highAlpha )
		wait 0.02
	}
}

void function PermaShakeScreen( entity cockpit, int screenNum )
{
	cockpit.EndSignal( "OnDestroy" )

	while ( 1 )
	{
		ShakeScreen( cockpit, screenNum, RandomFloatRange( 0.4, 0.6 ), 0.0, 0.5, 0.0 )
		wait RandomFloatRange( 0.1, 0.2 )
	}
}

void function ShakeScreen( entity cockpit, int screenNum, float shakeDuration, float baseOffset = 0.0, float xScale = 0.1, float yScale = 0.1 )
{
	cockpit.EndSignal( "OnDestroy" )

	float startTime = Time()

	while ( Time() - startTime < shakeDuration )
	{
		float xOff = baseOffset + RandomFloatRange( -0.02, 0.02 )*xScale
		float yOff = baseOffset + RandomFloatRange( -0.02, 0.02 )*yScale

		cockpit.SetCockpitPanelOffsetXY( screenNum, xOff, yOff )
		wait 0.01
	}

	cockpit.SetCockpitPanelOffsetXY( screenNum, 0, 0 )
}

void function RandomScreenFlicker()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()

	while ( cockpit == null )
	{
		cockpit = GetLocalViewPlayer().GetCockpit()
		wait 0.1
	}

	cockpit.EndSignal( "OnDestroy" )

	float lastDoubleFlickerTime = 0.0
	int lastScreenUsed = -1

	while ( 1 )
	{
		// if ( Time() - lastDoubleFlickerTime > 3.0 && CoinFlip() )
		// {
		// 	wait RandomFloatRange( 0.1, 0.2 )
		// 	lastDoubleFlickerTime = Time()
		// }
		// else
		// {
		// 	wait RandomFloatRange( 0.5, 0.75 )
		// }
		wait 0.2
		int screen = [ 1, 3, 4 ].getrandom()

		if ( screen == lastScreenUsed )
		{
			WaitFrame()
			continue
		}

		if ( screen != 2 ) // not the center
		{
			if ( screen != 3 && CoinFlip() )
				thread ScreenFlickerOn( cockpit, screen, RandomIntRange(3,12), 0.7, 0.2, 0.4 )
			if ( CoinFlip() && screen != 1 )
				thread ShakeScreen( cockpit, screen, RandomFloatRange( 0.1, 0.4 ), 0.0, 1.0, 0.0 )
			if ( CoinFlip() )
			{
				thread PlayCockpitSparkFX( cockpit, 1 )
				EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_bt_interior_orange_spark" )
			}
			lastScreenUsed = screen
		}
	}
}

void function ServerCallback_FlickerCockpitOff()
{
	thread ServerCallback_FlickerCockpitOff_Internal()
}

void function ServerCallback_FlickerCockpitOff_Internal()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()
	cockpit.EndSignal( "OnDestroy" )

	thread ScreenFlickerOn( cockpit, 1, 3, 0.0, 0.4, 0.7 )
	wait 0.2
	thread ScreenFlickerOn( cockpit, 0, 3, 0.0, 0.4, 0.7 )
	wait 0.2
	thread ScreenFlickerOn( cockpit, 3, 3, 0.0, 0.4, 0.7 )
	wait 0.1
	thread ScreenFlickerOn( cockpit, 4, 3, 0.0, 0.4, 0.7 )
	wait 0.1
	thread ScreenFlickerOn( cockpit, 2, 8, 0.0, 0.4, 0.7 )
}

void function TitanCockpitReboot()
{
	var rui
	int maxLines = 5
	vector msgPos = <0.37,0.68,0.0>
	float fontSize = 32.0
	array<string> messages = []
	array<var> ruis = []

	var promptRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	RuiSetInt( promptRUI, "maxLines", maxLines )
	RuiSetInt( promptRUI, "lineNum", 1 )
	RuiSetString( promptRUI, "msgText", "> " )
	RuiSetFloat( promptRUI, "msgFontSize", fontSize )
	RuiSetFloat( promptRUI, "msgAlpha", 0.8 )
	RuiSetFloat( promptRUI, "thicken", 0.0 )
	RuiSetFloat3( promptRUI, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( promptRUI, "msgPos", msgPos )

	for( int i=0; i<maxLines; i++ )
	{
		messages.append( "" )
		rui = RuiCreate( $"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
		RuiSetInt( rui, "maxLines", maxLines )
		RuiSetInt( rui, "lineNum", i+1 )
		RuiSetString( rui, "msgText", "" )
		RuiSetFloat( rui, "msgFontSize", fontSize )
		RuiSetFloat( rui, "msgAlpha", 0.8 )
		RuiSetFloat( rui, "thicken", 0.0 )
		RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
		RuiSetFloat2( rui, "msgPos", msgPos )
		ruis.append(rui)
	}

	RuiSetFloat( ruis[ maxLines-1 ], "msgAlpha", 0.05 )
	RuiSetFloat( ruis[ maxLines-2 ], "msgAlpha", 0.05 )
	RuiSetFloat( ruis[ maxLines-3 ], "msgAlpha", 0.05 )

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_0", true )

	waitthread ScreenBoot()
	thread RandomScreenFlicker()

	wait 1.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_coresystemsonline" )

	// wait 2.0

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_1", true )

	wait 1.0

	thread TitanCockpitHex()

	wait 2.5

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_2" )

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_3" )
	// RuiSetFloat3( ruis[1], "msgColor", <1.0,1.0,1.0> )

	wait 3.0

	messages[0] = "#SKYWAY_HUD_MESSAGE_3b"
	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_4" )

	// wait 2.0

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_5" )
	// RuiSetFloat3( ruis[1], "msgColor", <1.0,1.0,1.0> )

	wait 3.5

	// messages[0] = "#SKYWAY_HUD_MESSAGE_4b"

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_warning_hostile_titan_disappear" )
	thread FlickerOut( promptRUI, 3, false )

	foreach( rui in ruis )
		FlickerOut( rui, 3, false )
	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_6", true )

	// wait 5.0

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_7" )

	// wait 2.0

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_8", true )

	// wait 5.0

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_9" )

	// wait 1.0

	// AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_10" )

	// wait 5.0

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.REBOOT )
		WaitFrame()

	thread FlickerIn( promptRUI, 3 )

	foreach( rui in ruis )
	{
		RuiSetString( rui, "msgText", "" )
		thread FlickerIn( rui, 3 )
		messages.insert( 0, "" )
		messages.remove( messages.len()-1 )
	}

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_initializing_emer_restart_appear" )
	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_11", true, 0 )
	thread BlinkTitanCockpitRui( ruis[0], 0.6, 0.35 )

	wait 7.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_rerouting_auxpower_appear" )
	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_12", true, 0 )
	thread BlinkTitanCockpitRui( ruis[0], 0.35, 0.2 )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.BEGIN_PROTOCOLS )
		WaitFrame()

	wait 0.5

	clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )
	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_auxpower_online_appear" )
	ServerCallback_DoRumble( 2 )

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_12b", false, 12 )
	RuiSetFloat3( ruis[0], "msgColor", <1.0,0.5,0.0> )

	wait 4.0

	thread TitanCockpitRebootPt2( messages, ruis, promptRUI )
	wait 1.0

	thread BTSacrifice_Cockpit( messages, ruis )
}

void function TitanCockpitRebootPt2( array<string> messages, array<var> ruis, var promptRUI )
{
	var rui
	int maxLines = 5
	vector msgPos = <0.37,0.68,0.0>
	float fontSize = 32.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_validatingneurallink" )
	messages[0] = "#SKYWAY_HUD_MESSAGE_12c"
	RuiSetFloat3( ruis[0], "msgColor", <1.0,1.0,1.0> )
	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_13", true )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.COMPLETE_PROTOCOL_1 )
		WaitFrame()

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_validatingneurallink_success_appear" )
	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_14" )

	wait 0.5

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_14b" )
	thread BlinkTitanCockpitRui( ruis[0], 0.5, 0.3, "skyway_scripted_injector_UI_motionlinkrestored_blip" )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.GOT_PLAYER_INPUT )
		WaitFrame()

	wait 1.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_rebooting_comm_array" )
	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_15", true )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.BEGIN_PROTOCOL_2 )
		WaitFrame()

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_16" )

	wait 1.0

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_17", true )

	wait 5.0

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_18" )

	wait 1.0

	AddNewLine( messages, ruis, "#SKYWAY_HUD_MESSAGE_19", true )

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_uploading_loop" )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.BEGIN_PROTOCOL_3 )
		WaitFrame()

	StopSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_uploading_loop" )

	clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )

	foreach( rui in ruis )
		RuiDestroy( rui )

	RuiDestroy( promptRUI )
}

void function ServerCallback_BTSacrifice_Cockpit()
{
	var rui
	int maxLines = 5
	vector msgPos = <0.37,0.68,0.0>
	float fontSize = 35.0
	array<string> messages = []
	array<var> ruis = []

	var promptRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	RuiSetInt( promptRUI, "maxLines", maxLines )
	RuiSetInt( promptRUI, "lineNum", 1 )
	RuiSetString( promptRUI, "msgText", "> " )
	RuiSetFloat( promptRUI, "msgFontSize", fontSize )
	RuiSetFloat( promptRUI, "msgAlpha", 0.8 )
	RuiSetFloat( promptRUI, "thicken", 0.0 )
	RuiSetFloat3( promptRUI, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( promptRUI, "msgPos", msgPos )

	for( int i=0; i<maxLines; i++ )
	{
		messages.append( "" )
		rui = RuiCreate( $"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
		RuiSetInt( rui, "maxLines", maxLines )
		RuiSetInt( rui, "lineNum", i+1 )
		RuiSetString( rui, "msgText", "" )
		RuiSetFloat( rui, "msgFontSize", fontSize )
		RuiSetFloat( rui, "msgAlpha", 0.8 )
		RuiSetFloat( rui, "thicken", -1.0 )
		RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
		RuiSetFloat2( rui, "msgPos", msgPos )
		ruis.append(rui)
	}

	thread BTSacrifice_Cockpit( messages, ruis )

	RuiDestroy( promptRUI )
}

void function BTSacrifice_Cockpit( array<string> messages, array<var> ruis )
{
	thread DisplayProtocols_PilotLinkThread()

	// while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.END )
	// 	WaitFrame()
}

void function AddNewLine( array<string> messages, array<var> ruis, string newMessage, bool animateDots = false, int flickerTimes = 4 )
{
	messages.insert( 0, newMessage )
	messages.remove( messages.len()-1 )

	clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )

	for( int i=0; i<ruis.len(); i++ )
	{
		RuiSetString( ruis[i], "msgText", messages[i] )
		if ( i != 0 )
			RuiSetFloat3( ruis[i], "msgColor", <0.3,0.3,0.3> )
	}

	if ( flickerTimes > 0 )
		FlickerIn( ruis[0], flickerTimes )
	if ( animateDots )
		thread AnimateDotsOnTitanMessage( ruis[0], messages[0] )
}

void function BlinkTitanCockpitRui( var rui, float delay1, float delay2, string sound = "" )
{
	clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )
	clGlobal.levelEnt.EndSignal( "AnimateDotsOnTitanMessage" )
	while ( 1 )
	{
		if ( sound != "" )
		{
			EmitSoundOnEntity( GetLocalViewPlayer(), sound )
		}
		RuiSetFloat( rui, "msgAlpha", 1.0 )
		wait delay1
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		wait delay2
	}
}

void function AnimateDotsOnTitanMessage( var rui, string baseString )
{
	clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )
	clGlobal.levelEnt.EndSignal( "AnimateDotsOnTitanMessage" )

	while ( 1 )
	{
		RuiSetString( rui, "msgText2", "" )
		wait 0.25
		RuiSetString( rui, "msgText2", "." )
		wait 0.25
		RuiSetString( rui, "msgText2", ".." )
		wait 0.25
		RuiSetString( rui, "msgText2", "..." )
		wait 0.25
	}
}

void function TitanCockpitHex()
{
	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.BEGIN_PROTOCOLS )
	{
		CreateCockpitHex( 0.05, 0.4, 5, 20, $"ui/cockpit_console_text_top_left.rpak" )
		CreateCockpitHex( 0.95, 0.4, 5, 20, $"ui/cockpit_console_text_top_right.rpak" )
  		wait 0.05
	}
}

void function RuiAlternateStrings( var rui, string ruiArg, array<string> strings )
{
	clGlobal.levelEnt.Signal( "StopRuiAlternateStrings" )
	clGlobal.levelEnt.EndSignal( "StopRuiAlternateStrings" )

	int i = 0
	while ( 1 )
	{
		RuiSetString( rui, ruiArg, strings[i] )
		i = (i+1)%strings.len()
		wait RandomFloatRange( 0.01, 0.5 )
	}
}

void function DisplayProtocols_PilotLinkThread()
{
	float duration = 10.0
	int i=3
	float delay = 0.0
	float endTime = Time() + 10000 // far in the future

	array<var> ruiArray = []
	array<var> protocolRui = []

	var rui = RuiCreate( $"ui/titan_protocol_text_center.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	ruiArray.append( rui )
	RuiSetString( rui, "displayString", "#SKYWAY_HUD_TITAN_PROTOCOL_TITLE1" )
	RuiSetGameTime( rui, "startTime", Time() + delay )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetInt( rui, "lineNum", i++ )
	RuiSetFloat( rui, "fontAdjust", -10.0 )
	RuiSetFloat3( rui, "msgColor", <0.3,0.3,0.3> )


	wait 1.15

	rui = RuiCreate( $"ui/titan_protocol_text_center.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	ruiArray.append( rui )
	RuiSetString( rui, "displayString", "#SKYWAY_HUD_TITAN_PROTOCOL_TITLE2" )
	RuiSetGameTime( rui, "startTime", Time() + delay )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetInt( rui, "lineNum", i++ )
	RuiSetFloat( rui, "fontAdjust", 0.0 )
	RuiSetFloat3( rui, "msgColor", <0.3,0.3,0.3> )

	wait 1.25

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_protocol1_appear_and_compute" )

	i++
	rui = RuiCreate( $"ui/titan_protocol_text_garbled.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	ruiArray.append( rui )
	protocolRui.append( rui )
	thread RuiAlternateStrings( rui, "displayString", [ "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_0", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_0b", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_0c" ] )
	RuiSetGameTime( rui, "startTime", Time() + delay )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetInt( rui, "lineNum", i++ )
	RuiSetFloat( rui, "fontAdjust", -5.0 )


	wait 4.0

	thread RuiAlternateStrings( rui, "displayString", [ "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_1", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_1b", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_1c" ] )

	FlickerIn( rui, 2 )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.COMPLETE_PROTOCOL_1 )
		wait 0.1

	clGlobal.levelEnt.Signal( "StopRuiAlternateStrings" )
	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_2" ) // done

	FlickerIn( rui, 2 )

	wait 1.0

	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_3" )

	FlickerIn( rui, 8 )

	// while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.HIDE_PROTOCOL_1 )
	// 	wait 0.1
	wait 4.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_protocolsdisappear_duringmotionlink" )

	foreach( r in ruiArray )
		FlickerOut( r, 1, false )

	wait 1.0

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.BEGIN_PROTOCOL_2 )
		wait 0.1

	RuiSetString( protocolRui[0], "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE1_PILOTLINK_3_FINAL" )

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_protocolsreappear_thrudestroyfoldweapon" )
	foreach( r in ruiArray )
	{
		FlickerIn( r, 1 )
		RuiSetFloat3( r, "msgColor", <0.4,0.4,0.4> )
	}

	rui = RuiCreate( $"ui/titan_protocol_text_garbled.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	ruiArray.append( rui )
	protocolRui.append( rui )

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_small_computing_loop" )
	thread RuiAlternateStrings( rui, "displayString", [ "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_0", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_0b", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_0c" ] )
	RuiSetGameTime( rui, "startTime", Time() + delay )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetInt( rui, "lineNum", i++ )
	RuiSetFloat( rui, "fontAdjust", -5.0 )

	wait 2.0

	clGlobal.levelEnt.Signal( "StopRuiAlternateStrings" )
	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_1" )

	FlickerIn( rui, 2 )

	wait 3.0

	thread RuiAlternateStrings( rui, "displayString", [ "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_2", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_2b", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_2c" ] )

	FlickerIn( rui, 2 )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.COMPLETE_PROTOCOL_2 )
		wait 0.1


	StopSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_small_computing_loop" )
	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_destroyfoldweapon" )

	clGlobal.levelEnt.Signal( "StopRuiAlternateStrings" )
	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_3" ) // done

	// FlickerIn( rui, 2 )

	// wait 1.0

	// RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_4" )

	FlickerIn( rui, 8 )

	// while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.HIDE_PROTOCOL_2 )
	// 	wait 0.1

	wait 4.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_protocolsdisappear_duringuploading" )
	foreach( r in ruiArray )
		FlickerOut( r, 1, false )

	wait 1.0

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.BEGIN_PROTOCOL_3 )
		wait 0.1

	RuiSetString( protocolRui[1], "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE2_PILOTLINK_4_FINAL" )
	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_protocolsreappear_withprotectthepiloterror" )

	foreach( r in ruiArray )
	{
		FlickerIn( r, 1 )
		RuiSetFloat3( r, "msgColor", <0.4,0.4,0.4> )
	}

	rui = RuiCreate( $"ui/titan_protocol_text_garbled.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0 )
	ruiArray.append( rui )
	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE3_PILOTLINK_1" )
	RuiSetGameTime( rui, "startTime", Time() + delay )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetInt( rui, "lineNum", i++ )
	RuiSetFloat( rui, "fontAdjust", -5.0 )

	wait 1.0

	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE3_PILOTLINK_2" )

	FlickerIn( rui, 2 )

	wait 1.0

	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_small_computing_loop" )
	thread RuiAlternateStrings( rui, "displayString", [ "#SKYWAY_TITAN_PROTOCOL_LINE3_PILOTLINK_3", "#SKYWAY_TITAN_PROTOCOL_LINE3_PILOTLINK_3b", "#SKYWAY_TITAN_PROTOCOL_LINE3_PILOTLINK_3c" ] )

	FlickerIn( rui, 2 )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.COMPLETE_PROTOCOL_3 )
		wait 0.1

	wait 2.5

	clGlobal.levelEnt.Signal( "StopRuiAlternateStrings" )
	RuiSetString( rui, "displayString", "#SKYWAY_TITAN_PROTOCOL_LINE3_PILOTLINK_4" )

	StopSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_small_computing_loop" )
	EmitSoundOnEntity( GetLocalViewPlayer(), "skyway_scripted_injector_UI_protectthepilot" )

	FlickerIn( rui, 6 )
	// thread BlinkTitanCockpitRui( rui, 0.8, 0.2 )

	// wait 3.0

	// clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )
	// RuiSetFloat( rui, "msgAlpha", 1.0 )

	while ( GetGlobalNetInt( "titanRebootPhase" ) < skywayTitanCockpitStatus.END )
		WaitFrame()


	foreach( rui in ruiArray )
		RuiSetBool( rui, "shouldDie", true )
}


/* ---------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------
RISING WORLD RUN
------------------------------------------------------------------
------------------------------------------------------------------*/


void function ServerCallback_CreateEvacIcon( int eHandle )
{
	var clight = GetLightEnvironmentEntity()
	clight.ScaleSunSkyIntensity( 0.0, 1.0 )
	entity mover = GetEntityFromEncodedEHandle( eHandle )
	thread CreateEvacShipWorldFX( mover, 61, 200, 255 )
}

void function ServerCallback_HideEvacIcon()
{
	var clight = GetLightEnvironmentEntity()
	clight.ScaleSunSkyIntensity( 1.0, 1.0 )
	HideEvacShipWorldFX()
}

void function CreateEvacShipWorldFX( entity mover, int r, int g, int b )
{
	int fxId = GetParticleSystemIndex( $"P_ar_titan_droppoint" )
	int fx = StartParticleEffectOnEntity( mover, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetControlPointVector( fx, 1, Vector( r, g, b ) )

	var icon 	= CreatePermanentCockpitRui( $"ui/overhead_icon_evac.rpak" )
	RuiSetBool( icon, "isVisible", true )
	RuiTrackFloat3( icon, "pos", mover, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetImage( icon, "icon", $"rui/hud/common/evac_location_friendly" )
	RuiSetString( icon, "statusText", "#EVAC_ARRIVAL" )
	RuiSetGameTime( icon, "finishTime", RUI_BADGAMETIME )

	file.evacIcon = icon
	file.evacFX = fx

	// while ( IsValid( mover ) )
	// {
	// 	RuiSetFloat3( icon, "pos", mover.GetOrigin() )
	// 	wait 0.01
	// }
}


void function HideEvacShipWorldFX()
{
	if ( EffectDoesExist( file.evacFX ) )
		EffectStop( file.evacFX, true, false )

	if ( file.evacIcon != null )
	{
		RuiDestroy( file.evacIcon )
		file.evacIcon = null
	}
}

void function ServerCallback_CockpitThump()
{
	printt( "THUMP" )
	entity cockpit = GetLocalViewPlayer().GetCockpit()
	thread ShakeScreen( cockpit, 2, 0.2, 0.0, 0.8, 0.8 )
}

void function ServerCallback_BeginHelmetBlink()
{
	thread BeginHelmetBlink()
}

void function BeginHelmetBlink()
{
	entity helmet = file.helmet

	//Jack are you there
	//string message = "01001010 01100001 01100011 01101011 00100000 01100001 01110010 01100101 00100000 01111001 01101111 01110101 00100000 01110100 01101000 01100101 01110010 01100101"
	//Jack?
	string message = "01001010 01100001 01100011 0110101100111111"

	int len = message.len()

	var readout = CreateRuiHelmetReadout( helmet )
	bool resetWord = true
	string word = ""
	string print = ""
	int padding = 8
	//float time = 0.05// * 5
	int timeIndex = 0
	array<float> times = [ 0.05, 0.05, 0.04, 0.02 ]
	float breaks = 3.0

	EmitSoundOnEntity( helmet, "skyway_scripted_credits_helmet_flashes_and_outro" )

	for ( int i=0; i<len; i++ )
	{
		//string char = message[i]
		string char = message.slice(i,i+1)
		if ( resetWord )
		{
			word = " "
			print = ""
			padding = 8
			resetWord = false
		}
		padding--
		word += char
		print = word
		for( int i = 0; i <= padding; i++ )
			print += " "

	//	RuiSetString( readout, "readout", print )

		float time = times[timeIndex]

		switch ( char )
		{
			case "0":
				SetTeam( helmet, TEAM_MILITIA )
				helmet.SetSkin( 1 )
				wait time
				SetTeam( helmet, TEAM_UNASSIGNED )
				helmet.SetSkin( 0 )
				RuiSetFloat( readout, "readoutAlpha", 0.5 )
				// EmitSoundOnEntity( helmet, "menu_back" )
				break
			case "1":
				SetTeam( helmet, TEAM_MILITIA )
				wait time
				SetTeam( helmet, TEAM_UNASSIGNED )
				RuiSetFloat( readout, "readoutAlpha", 1.0 )
				// EmitSoundOnEntity( helmet, "menu_back" )
				break
			case " ":
				SetTeam( helmet, TEAM_UNASSIGNED )
				RuiSetFloat( readout, "readoutAlpha", 0.2 )
				resetWord = true
				//wait time * 2
				wait breaks
				breaks *= 0.2
				timeIndex++
				break
		}

		wait 0.05
	}

	RuiSetString( readout, "readout", "" )


	//cut to black - then go back to main menu
	wait 1.5

	var rui = RuiCreate( $"ui/sp_blackscreen.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 5000 )
	RuiSetFloat( rui, "alpha", 1.0 )

	wait 3

	entity player = GetLocalClientPlayer()
	player.ClientCommand( "disconnect" )
}

var function CreateRuiHelmetReadout( entity helmet )
{
	vector origin = <7.97, 0, -0.35>
	vector angles = < -9,180,0>

	float scale = 0.01
	float width = 1920 * scale
	float height = 1080 * scale

	// adjust so the RUI is drawn with the org as its center point
	origin += ( (AnglesToRight( angles )*-1) * (width*0.5) )
	origin += ( AnglesToUp( angles ) * (height*0.5) )

	// right and down vectors that get added to base org to create the display size
	vector right = ( AnglesToRight( angles ) * width )
	vector down = ( (AnglesToUp( angles )*-1) * height )

	var topo = RuiTopology_CreatePlane( origin, right, down, false )
	RuiTopology_SetParent( topo, helmet )

	var readout = RuiCreate( $"ui/credits_helmet_readout.rpak", topo, RUI_DRAW_WORLD, 0 )
	return readout
}

void function ServerCallback_CreateHelmet( float x, float y, float z, float p, float ya, float r )
{
	asset model = HELMET_MODEL

	vector origin = <x,y,z>
	vector angles = <p,ya,r>

	entity prop = CreateClientSidePropDynamic( origin, angles, model )
	prop.SetFadeDistance( 80000 )
	prop.EnableRenderAlways()

	file.helmet = prop
}

void function ServerCallback_InjectorFired()
{
	AnnouncementMessage( GetLocalViewPlayer(), "#SKYWAY_INJECTOR_FIRED", "" )
}

void function ServerCallback_Torture_BT_Transmission()
{
	thread ServerCallback_Torture_BT_Transmission_Thread()
}

void function ServerCallback_Torture_BT_Transmission_Thread()
{
	entity player = GetLocalViewPlayer()
	float xOffset = 0.05

	array<var> ruis = []

	EmitSoundOnEntity( player, "skyway_anim_tortureroom_torture_intro_receivingmessage_hud" )

	var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 0 )
	RuiSetString( rui, "msgText", "#HUD_INCOMING_TRANSMISSION" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )
	FlickerIn( rui, 4 )

	RuiSetFloat( rui, "msgAlpha", 0.2 )
	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 1 )
	RuiSetString( rui, "msgText", "#HUD_DECRYPTING" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	thread AnimateDotsOnTitanMessage( rui, "#HUD_DECRYPTING" )
	ruis.append( rui )
	FlickerIn( rui, 4 )

	float startTime = Time()
	while ( Time() - startTime < 0.5 )
	{
		CreateCockpitHex( xOffset, 0.2, 4, 8, $"ui/cockpit_console_text_top_left.rpak", 3 )
  		wait 0.05
	}

	FlickerOut( rui, 4, false )
	RuiSetString( rui, "msgText", "" )

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 2 )
	RuiSetString( rui, "msgText", "#SKYWAY_HUD_TORTURE_MESSAGE" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )
	FlickerIn( rui, 4 )

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 3 )
	RuiSetString( rui, "msgText", "#SKYWAY_HUD_TORTURE_MESSAGE_BODY" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )
	FlickerIn( rui, 4 )

	wait 6.0

	clGlobal.levelEnt.Signal( "AnimateDotsOnTitanMessage" )

	foreach ( r in ruis )
	{
		FlickerOut( r, 2 )
	}
}

void function ServerCallback_DoRumble( int rumble )
{
	entity player = GetLocalViewPlayer()

	switch ( rumble )
	{
		case 0:
			Rumble_Play( "rumble_skyway_01", { position = player.GetOrigin() } )
		break

		case 1:
			Rumble_Play( "rumble_skyway_02", { position = player.GetOrigin() } )
		break

		case 2:
			Rumble_Play( "rumble_skyway_03", { position = player.GetOrigin() } )
		break
	}
}

void function ServerCallback_InjectorFireScreenFX()
{
	entity cockpit = GetLocalViewPlayer().GetCockpit()
	if ( IsValid( cockpit ) )
		StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( SPEED_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	ServerCallback_DoRumble( 2 )
}
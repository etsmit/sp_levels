// -------------------------------------------------------------------------------------------------------------------------
//
// ██████╗ ███████╗ ██████╗██╗      █████╗ ███╗   ███╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
// ██╔══██╗██╔════╝██╔════╝██║     ██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
// ██████╔╝█████╗  ██║     ██║     ███████║██╔████╔██║███████║   ██║   ██║██║   ██║██╔██╗ ██║
// ██╔══██╗██╔══╝  ██║     ██║     ██╔══██║██║╚██╔╝██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
// ██║  ██║███████╗╚██████╗███████╗██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
// ╚═╝  ╚═╝╚══════╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
//
// -------------------------------------------------------------------------------------------------------------------------

global function ClientCodeCallback_MapInit
global function ServerCallback_SewersHideDoomFX
global function ServerCallback_LevelIntroText
global function ServerCallback_SewersRadioInterfaceSeq
global function ServerCallback_SewersToxicSludgeAlarmSeq


const vector textColor				= <0.96, 0.96, 0.96>
const vector textYellow				= <1.0, 0.75, 0.0>
const float titleAlpha				= 1.0	//0.75
const float textAlpha				= 0.75	//0.5
const float xOffset					= 0.03
const float yOffset					= 0.1

const float fullWidth				= 1920
const float fullHeight				= 1080


struct hexSetStruct
{
	float msgFontSize =		24.0
	int maxLines = 			8
	int lineNum	=			2
	int colums	=			4
	int alignment =			0
	float lineHoldtime =	0.05
	float msgAlpha =		0.5
	vector msgColor =		<0.5, 0.5, 0.5>
	vector msgPos =			<xOffset,yOffset,0.0>
}


void function ClientCodeCallback_MapInit()
{
	RegisterSignal( "stop_animate_dots")

	AddCreateCallback( "npc_dropship", CreateCallback_SewerDropship )

	Sewers1_VO_Init()
	ShSpSewersCommonInit()
}


void function ServerCallback_SewersHideDoomFX( int eHandle )
{
	entity titan = GetEntityFromEncodedEHandle( eHandle )

	if ( titan == null )
		return

	thread HideDoomFX( titan )
}


void function HideDoomFX( entity titan )
{
	titan.EndSignal( "OnDeath" )
	wait 0.1
	ModelFX_DisableGroup( titan, "titanDoomed" )
}


void function ServerCallback_LevelIntroText()
{
	BeginIntroSequence()
	var infoText = RuiCreate( $"ui/sp_level_title.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 100 )
	RuiSetGameTime( infoText, "startTime", Time() )
	RuiSetString( infoText, "txtLine1", "#SEWERS_INTRO_TEXT_LINE1" )
	RuiSetString( infoText, "txtLine2", "#SEWERS_INTRO_TEXT_LINE2" )
}


void function CreateCallback_SewerDropship( entity ent )
{
	ent.SetGroundEffectTable( "" )
}


void function ServerCallback_SewersRadioInterfaceSeq()
{
	thread Sewers_ShowRadioInterfaceHUD()
}


void function ServerCallback_SewersToxicSludgeAlarmSeq()
{
	thread Sewers_ShowToxicSludgeHUD()
}


void function Sewers_ShowRadioInterfaceHUD()
{
	array<var> ruis = []
	array<var> ruiTextArray
	entity player = GetLocalViewPlayer()

	ToggleHudIcons( false )

	// HUD overlay
	var borderRui = CreateCockpitRui( $"ui/helmet_border.rpak", 100 )
	ruis.append( borderRui )

	wait 1.5

	// LINE 1
	var titleRui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( titleRui, "maxLines", 30 )
	RuiSetInt( titleRui, "lineNum", 0 )
	RuiSetString( titleRui, "msgText", Localize( "#SEWERS_RADIO_HUD_TITLE", "" ) )
	RuiSetFloat( titleRui, "msgFontSize", 30.0 )
	RuiSetFloat( titleRui, "msgAlpha", textAlpha )
	RuiSetFloat3( titleRui, "msgColor", textColor )
	RuiSetFloat2( titleRui, "msgPos", < 0.75, 0.1, 0.0 > )
	ruis.append( titleRui )

	RuiSetString( titleRui, "msgText", "#SEWERS_RADIO_HUD_TITLE" )
	Sewers_RuiFlickerIn( titleRui )

	wait 1.5

	// LINE 2
	var line2Rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( line2Rui, "maxLines", 30 )
	RuiSetInt( line2Rui, "lineNum", 2 )
	RuiSetString( line2Rui, "msgText", Localize( "#SEWERS_RADIO_HUD_DESC1a", "" ) )
	RuiSetFloat( line2Rui, "msgFontSize", 28.0 )
	RuiSetFloat( line2Rui, "msgAlpha", textAlpha )
	RuiSetFloat3( line2Rui, "msgColor", textColor )
	RuiSetFloat2( line2Rui, "msgPos", < 0.75, 0.1, 0.0 > )
	ruis.append( line2Rui )

	Sewers_BlinkRui( line2Rui, "#SEWERS_RADIO_HUD_DESC1a", 8 )
	RuiSetString( line2Rui, "msgText", "#SEWERS_RADIO_HUD_DESC1b" )

	wait 2.0

	// LINE 3
	var line3Rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( line3Rui, "maxLines", 30 )
	RuiSetInt( line3Rui, "lineNum", 3 )
	RuiSetString( line3Rui, "msgText", Localize( "#SEWERS_RADIO_HUD_DESC2a", "" ) )
	RuiSetFloat( line3Rui, "msgFontSize", 28.0 )
	RuiSetFloat( line3Rui, "msgAlpha", textAlpha )
	RuiSetFloat3( line3Rui, "msgColor", textColor )
	RuiSetFloat2( line3Rui, "msgPos", < 0.75, 0.1, 0.0 > )
	ruis.append( line3Rui )

	thread AnimateDots( line3Rui, "#SEWERS_RADIO_HUD_DESC2a", "msgText", 2.0, "#SEWERS_RADIO_HUD_DESC2b" )

	// HEX DUMP
	hexSetStruct hexSet
	hexSet.lineNum = 0
	hexSet.msgFontSize = 18
	hexSet.msgColor = <0.1, 0.23, 0.4>
	hexSet.msgAlpha = 0.75

	for( int i=0; i<10; i++ )
	{
		var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 200 )
		RuiSetInt( rui, "maxLines", 30 )
		RuiSetInt( rui, "lineNum", i )
		RuiSetString( rui, "msgText", "#BLANK_TEXT" )
		RuiSetFloat( rui, "msgFontSize", 28.0 )
		RuiSetFloat( rui, "msgAlpha", textAlpha )
		RuiSetFloat3( rui, "msgColor", textColor )
		RuiSetFloat2( rui, "msgPos", < 0.75, 0.1, 0.0 >  )
		ruiTextArray.append(rui)
	}
	ruis.extend( ruiTextArray )

	wait 0.5

	// top right
	hexSet.maxLines = 12
	hexSet.colums = 6
	hexSet.alignment = 1
	hexSet.msgPos = < 0.94, 0.25, 0.0 >
	HexDump( clone hexSet, 2.0 )

	//wait 2

	StopAnimateDots()

	wait 1

	//wait 0.2
	thread Sewers_ToxicSludgeHUD_FlickerOut( titleRui )
	//wait 0.2
	thread Sewers_ToxicSludgeHUD_FlickerOut( line2Rui )
	//wait 0.2
	thread Sewers_ToxicSludgeHUD_FlickerOut( line3Rui )

	wait 0.5

	// LINE 4
	var line4Rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( line4Rui, "maxLines", 30 )
	RuiSetInt( line4Rui, "lineNum", 4 )
	RuiSetString( line4Rui, "msgText", Localize( "#SEWERS_RADIO_HUD_DESC3", "" ) )
	RuiSetFloat( line4Rui, "msgFontSize", 28.0 )
	RuiSetFloat( line4Rui, "msgAlpha", textAlpha )
	RuiSetFloat3( line4Rui, "msgColor", <0.96, 0.0, 0.0> )
	RuiSetFloat2( line4Rui, "msgPos", < 0.75, 0.1, 0.0 > )
	ruis.append( line4Rui )

	Sewers_BlinkRui( line4Rui, "#SEWERS_RADIO_HUD_DESC3", 3, "", 0.4 )
	wait 0.5
	Sewers_ToxicSludgeHUD_FlickerOut( line4Rui )

	wait 1

	foreach( rui in ruis )
	{
		RuiDestroyIfAlive( rui )
	}

	wait 1

	ToggleHudIcons( true )
}


void function ToggleHudIcons( bool showIcon )
{
	entity player = GetLocalClientPlayer()

	ClWeaponStatus_SetOffhandVisible( OFFHAND_LEFT, showIcon )
	ClWeaponStatus_SetOffhandVisible( OFFHAND_RIGHT, showIcon )
	ClWeaponStatus_SetOffhandVisible( OFFHAND_INVENTORY, showIcon )
	if ( player.IsTitan() )
		ClWeaponStatus_SetOffhandVisible( OFFHAND_TITAN_CENTER, showIcon )
	ClWeaponStatus_SetWeaponVisible( showIcon )
}


void function HexDump( hexSetStruct hexSet, float duration = 1.0 )
{
	entity player = GetLocalClientPlayer()
	Assert( IsValid( player ) )
	player.EndSignal( "OnDestroy" )

	//EmitSoundOnEntity( player, "Wilds_Scr_HelmetHUDText_Print" )

	float endTime = Time() + duration
	while( Time() < endTime )
	{
		CreateCockpitHex( hexSet )
		wait 0.05
	}

	//StopSoundOnEntity( player, "Wilds_Scr_HelmetHUDText_Print" )
	//EmitSoundOnEntity( player, "Wilds_Scr_HelmetHUDText_Finish" )
}


void function CreateCockpitHex( hexSetStruct hexSet )
{
	var rui
	switch( hexSet.alignment )
	{
		case 1: //right
			rui = CreateCockpitRui( $"ui/cockpit_console_text_top_right.rpak", 0 )
			break
		case 2: //center
			rui = CreateCockpitRui( $"ui/cockpit_console_text_center.rpak", 0 )
			break
		default: //left
			rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
			break

	}

	string hex = GenerateHexString( 4 )
	for ( int i=0; i < hexSet.colums - 1; i++ )
	{
		hex += " " + GenerateHexString( 4 )
	}

	RuiSetInt( rui, "maxLines", hexSet.maxLines )
	RuiSetString( rui, "msgText", hex )
	RuiSetFloat( rui, "msgFontSize", hexSet.msgFontSize )
	RuiSetInt( rui, "lineNum", hexSet.lineNum )
	RuiSetFloat( rui, "lineHoldtime", hexSet.lineHoldtime )
	RuiSetFloat( rui, "msgAlpha", hexSet.msgAlpha )
	RuiSetFloat3( rui, "msgColor", hexSet.msgColor )
	RuiSetFloat2( rui, "msgPos", hexSet.msgPos )
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


void function FlickerRui( var rui, float baseAlpha = 1.0, float altAlpha = 0.0, float duration = 2, int speed = 5 )
{
	clGlobal.levelEnt.EndSignal( "end_flicker" )

	OnThreadEnd(
		function() : ( rui, baseAlpha )
		{
			RuiSetFloat( rui, "msgAlpha", baseAlpha )
		}
	)

	float endTime = Time() + duration
	bool flicker = true

	while( Time() < endTime )
	{
		if ( !flicker )
			RuiSetFloat( rui, "msgAlpha", altAlpha )
		else
			RuiSetFloat( rui, "msgAlpha", baseAlpha )

		flicker = !flicker
		wait 1.0 / speed
	}
}


void function AnimateDots( var rui, string msgText, string varName = "msgText", float duration = 999999, string capString = "" )
{
	clGlobal.levelEnt.EndSignal( "stop_animate_dots" )

	OnThreadEnd(
		function() : ( rui, varName, msgText, capString )
		{
			RuiSetString( rui, varName, Localize( msgText, Localize( capString ) ) )
		}
	)

	float endTime = Time() + duration

	array<string> dotArr = ["",".","..","..."]
	int index = 0
	while( Time() < endTime )
	{
		RuiSetString( rui, varName, Localize( msgText, dotArr[index] ) )
		wait 0.25
		index = (index + 1) % dotArr.len()
	}
}



void function Sewers_RuiFlickerIn( var rui )
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


void function Sewers_BlinkRui( var rui, string msg, int blinkCount, string finalMsg = "", float blinkWait = 0.2 )
{
	for( int i = 0; i < blinkCount; i++ )
	{
		wait blinkWait
		RuiSetString( rui, "msgText", "" )
		wait blinkWait
		RuiSetString( rui, "msgText", msg )
	}

	if ( finalMsg != "" )
		RuiSetString( rui, "msgText", finalMsg )
}



void function StopAnimateDots()
{
	clGlobal.levelEnt.Signal( "stop_animate_dots" )
}


void function Sewers_ShowToxicSludgeHUD()
{
	float xOffset = 0.05

	array<var> ruis = []

	var rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 0 )
	RuiSetString( rui, "msgText", "#HUD_WARNING_LABEL" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,0.0,0.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	ruis.append( rui )
	var titleRui = rui

	thread Sewers_ToxicSludgeHUD_BlinkRui( rui, "#HUD_WARNING_LABEL", 8 )
	wait 0.1

	rui = CreateCockpitRui( $"ui/cockpit_console_text_top_left.rpak", 0 )
	RuiSetInt( rui, "maxLines", 30 )
	RuiSetInt( rui, "lineNum", 1 )
	RuiSetString( rui, "msgText", "#SEWERS_SLUDGE_WARN_DESC" )
	RuiSetFloat( rui, "msgFontSize", 30.0 )
	RuiSetFloat( rui, "msgAlpha", 0.8 )
	RuiSetFloat3( rui, "msgColor", <1.0,1.0,1.0> )
	RuiSetFloat2( rui, "msgPos", <xOffset,0.2,0.0> )
	var messageRui = rui

	//thread Sewers_ToxicSludgeHUD_BlinkRui( messageRui, "#SEWERS_SLUDGE_WARN_DESC", 1 )

	wait 3

	Sewers_ToxicSludgeHUD_FlickerOut( messageRui )
	wait 0.1
	Sewers_ToxicSludgeHUD_FlickerOut( titleRui )
}


void function Sewers_ToxicSludgeHUD_FlickerOut( var rui, bool destroy = true )
{
	float baseAlpha = 0.2

	int flickerCount = 4
	for( int i = 0; i < flickerCount; i++ )
	{
		wait 0.05
		RuiSetFloat( rui, "msgAlpha", 0.0 )
		wait 0.05
		RuiSetFloat( rui, "msgAlpha", baseAlpha )
	}

	if ( destroy )
		RuiDestroy( rui )
}


void function Sewers_ToxicSludgeHUD_BlinkRui( var rui, string msg, int blinkCount )
{
	for( int i = 0; i < blinkCount; i++ )
	{
		wait 0.2
		RuiSetString( rui, "msgText", "" )
		wait 0.2
		RuiSetString( rui, "msgText", msg )
	}
}



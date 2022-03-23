global function ClientCodeCallback_MapInit

global function ServerCallback_IntroScreenShakes
global function ServerCallback_DropLaunchScreenShake
global function ServerCallback_LandingImpactScreenShake
global function ServerCallback_LevelIntroText
global function ServerCallback_ElevatorRumble
global function ServerCallback_BlastedBackRumble

struct
{
	entity draconisShip
	entity draconisShip1000x
} file

void function ClientCodeCallback_MapInit()
{
	ClCarrier_Init()
	ShSpTdayCommonInit()
	RegisterServerVarChangeCallback( "netvar_draconis_flying_status", DraconisFlying )
	RegisterSignal( "DraconisFlyingChanged" )
	SetupDraconis1000xFX()
	ExtendedDebounceForEnemyTitanDownBTDialogue()
}

void function ServerCallback_LevelIntroText()
{
	BeginIntroSequence()
	var infoText = RuiCreate( $"ui/sp_level_title.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 100 )
	RuiSetGameTime( infoText, "startTime", Time() )
	RuiSetString( infoText, "txtLine1", "#TDAY_INTRO_TEXT_LINE1" )
	RuiSetString( infoText, "txtLine2", "#TDAY_INTRO_TEXT_LINE2" )
	RuiSetString( infoText, "txtLine3", "#TDAY_INTRO_TEXT_LINE3" )


}

void function ServerCallback_IntroScreenShakes()
{
	thread IntroScreenShakes()
}

void function IntroScreenShakes()
{
	// 0 - light, 1 - medium, 2 - heavy
	array<int> shakes = [ 0, 1, 1, 2, 0, 1, 2, 0, 2 ]
	array<float> delays = [ 1.8, 2.0, 1.6, 1.8, 1.2, 1.2, 1.5, 1.0, 0.5 ]
	Assert( shakes.len() == delays.len() )

	wait 2.5

	for ( int i = 0 ; i < shakes.len() ; i++ )
	{
		string soundAlias
		float amplitude
		float frequency
		float duration

		switch( shakes[i] )
		{
			case 0:
				soundAlias = "TDay_Intro_ShipImpact_Rumble4_Light"
				amplitude = 1.0
				frequency = 1.0
				duration = 1.0
				break
			case 1:
				soundAlias = "TDay_Intro_ShipImpact_Rumble2_Medium"
				amplitude = 2.0
				frequency = 2.0
				duration = 2.0
				break
			case 2:
				soundAlias = "TDay_Intro_ShipImpact_Rumble1_Heavy"
				amplitude = 5.0
				frequency = 4.0
				duration = 2.0
				break
		}

		vector soundPos = GetLocalClientPlayer().GetOrigin() + ( GetRandomVector() * 250 )
		EmitSoundAtPosition( TEAM_UNASSIGNED, soundPos, soundAlias )
		ClientScreenShake( amplitude, frequency, duration, < 0, 0, 0 > )
		wait duration

		wait delays[i]
	}
}

vector function GetRandomVector()
{
	return Normalize( < RandomFloatRange(-1.0,1.0), RandomFloatRange(-1.0,1.0), RandomFloatRange(-1.0,1.0) > )
}

void function ServerCallback_DropLaunchScreenShake()
{
	entity player = GetLocalClientPlayer()
	Rumble_Play( "tday_drop_release", {} )
	player.JoltCockpitAngles( 0, 0, 0, 50, 0, 0 )
	player.JoltCockpitOrigin( <0, 0, 0>, <0, 0, 50> )
}

void function ServerCallback_LandingImpactScreenShake()
{
	entity player = GetLocalClientPlayer()
	Rumble_Play( "tday_drop_landing", {} )
	player.JoltCockpitAngles( 0, 0, 0, 100, 0, 0 )
	player.JoltCockpitOrigin( <0, 0, 0>, <0, 0, -100> )
}

void function ServerCallback_ElevatorRumble( int state )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	switch( state )
	{
		case 1:
		case 3:
			Rumble_Play( "tday_elevator_start", { position = player.GetOrigin() } )
			return
		case 2:
			Rumble_Play( "tday_elevator_move", { position = player.GetOrigin() } )
			return
		default:
			Assert(0)
			return
	}
}

void function ServerCallback_BlastedBackRumble()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return
	Rumble_Play( "tday_blasted_back", { position = player.GetOrigin() } )
}

void function DraconisFlying()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	player.Signal( "DraconisFlyingChanged" )
	entity camera = GetEntByScriptName( "sky_camera" )
	vector cameraOrigin = camera.GetOrigin()
	entity serverShip = GetEntByScriptName( "hero_ola" )
	vector origin = serverShip.GetOrigin()
	vector angles = serverShip.GetAngles()

	vector sceneOrg = <6454, 13052, 2440>
	vector sceneAng = <0, -39.9902, 0>
	vector sceneOrgSkybox = sceneOrg * 0.001 + cameraOrigin
	vector originSkybox = origin * 0.001 + cameraOrigin

	switch ( level.nv.netvar_draconis_flying_status )
	{
		case 0:
			if ( IsValid( file.draconisShip1000x ) )
				file.draconisShip1000x.Destroy()

			if ( IsValid( file.draconisShip ) )
				file.draconisShip.Destroy()
			break

		case DRACONIS_IDLING:
		case DRACONIS_THRUSTERS:
		case DRACONIS_AFTERBURNERS:
		case DRACONIS_FLYING:
			if ( !IsValid( file.draconisShip ) )
			{
				file.draconisShip1000x = CreateClientSidePropDynamic( originSkybox, angles, DRACONIS_SKYBOX )
				file.draconisShip1000x.Hide()
				thread PlayAnim( file.draconisShip1000x, "ve_arc_loading_draconis_idle", sceneOrgSkybox, sceneAng )

				file.draconisShip = CreateClientSidePropDynamic( origin, angles, DRACONIS_INLEVEL )
				//file.draconisShip.Hide()
				thread PlayAnim( file.draconisShip, "ve_arc_loading_draconis_idle", sceneOrg, sceneAng )
			}
			break
	}

	switch ( level.nv.netvar_draconis_flying_status )
	{
		case DRACONIS_IDLING:
			break

		case DRACONIS_THRUSTERS:
			//ModelFX_EnableGroup( file.draconisShip, "thrusters" )
			break

		case DRACONIS_AFTERBURNERS:
			//ModelFX_EnableGroup( file.draconisShip, "thrusters" )
			thread AfterburnersFireUp( file.draconisShip )
			break

		case DRACONIS_FLYING:
			thread PlayAnim( file.draconisShip1000x, "ve_arc_loading_draconis", sceneOrgSkybox, sceneAng )
			thread PlayAnim( file.draconisShip, "ve_arc_loading_draconis", sceneOrg, sceneAng )
			thread SwapDraconis()
			break
	}

}

void function AfterburnersFireUp( entity ship )
{
	ship.EndSignal( "OnDestroy" )
	ModelFX_EnableGroup( file.draconisShip, "thrusters1" )
	wait 0.6
	ModelFX_EnableGroup( file.draconisShip, "thrusters2" )
	wait 0.4
	ModelFX_EnableGroup( file.draconisShip, "thrusters3" )
	wait 0.6
	ModelFX_EnableGroup( file.draconisShip, "afterburners1" )
	wait 0.5
	ModelFX_EnableGroup( file.draconisShip, "afterburners2" )
	wait 0.5
	ModelFX_EnableGroup( file.draconisShip, "afterburners3" )
	wait 0.2
	ModelFX_EnableGroup( file.draconisShip, "afterburners4" )
	wait 0.2
	ModelFX_EnableGroup( file.draconisShip, "afterburners5" )
	wait 14.5
	ModelFX_EnableGroup( file.draconisShip, "boost" )
}

void function SwapDraconis()
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "DraconisFlyingChanged" )

	OnThreadEnd(
	function() : ( )
		{
			if ( level.nv.netvar_draconis_flying_status == DRACONIS_FLYING )
			{
				file.draconisShip1000x.Show()
				ModelFX_EnableGroup( file.draconisShip1000x, "afterburners_sky" )
			}
			else
			{
				if ( IsValid( file.draconisShip1000x ) )
					file.draconisShip1000x.Destroy()
			}

			if ( IsValid( file.draconisShip ) )
				file.draconisShip.Destroy()
		}
	)

	float startTime = Time()
//	float endTime = Time() + 1
	float endTime = Time() + DRACONIS_ESCAPE_TIME
	for ( ;; )
	{
		//printt( "flying time " + ( Time() - startTime ) )
		if ( Time() >= endTime )
			break
		WaitFrame()
	}
}

void function SetupDraconis1000xFX()
{
	//----------------------------------------------------------------------------------------
	// AFTERBURNERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "afterburners_sky", $"models/vehicle/draconis/vehicle_draconis_hero_animated_1000x.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_01", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_03", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_05", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_07", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_09", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_11", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_02", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_04", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_06", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_08", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_10", $"P_veh_draconis_exhaust_box_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_box_12", $"P_veh_draconis_exhaust_box_sky" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_01", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_02", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_03", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_04", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_05", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_06", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_07", $"P_veh_draconis_exhaust_rear_sky" )
		ModelFX_AddTagSpawnFX( "exhaust_round_08", $"P_veh_draconis_exhaust_rear_sky" )

		//----------------------
		// Side Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_01", $"P_veh_draconis_exhaust_side_sky" )
		ModelFX_AddTagSpawnFX( "L_exhaust_02", $"P_veh_draconis_exhaust_side_sky" )
		ModelFX_AddTagSpawnFX( "L_exhaust_03", $"P_veh_draconis_exhaust_side_sky" )
		ModelFX_AddTagSpawnFX( "L_exhaust_04", $"P_veh_draconis_exhaust_side_sky" )

		ModelFX_AddTagSpawnFX( "R_exhaust_01", $"P_veh_draconis_exhaust_side_sky" )
		ModelFX_AddTagSpawnFX( "R_exhaust_02", $"P_veh_draconis_exhaust_side_sky" )
		ModelFX_AddTagSpawnFX( "R_exhaust_03", $"P_veh_draconis_exhaust_side_sky" )
		ModelFX_AddTagSpawnFX( "R_exhaust_04", $"P_veh_draconis_exhaust_side_sky" )

	ModelFX_EndData()
}

void function ExtendedDebounceForEnemyTitanDownBTDialogue() //JFS: Too many Titans in TDay, BT says "Enemy Titan down"
{
	ConversationStruct convStruct = GetConversationStruct( "elimEnemyTitan" )
	convStruct.debounceTime = 45.0
}
global function ClientCodeCallback_MapInit
global function CreateBeaconSkyShip
global function ServerCallback_CallInTheFleet
global function ServerCallback_LevelIntroText
global function ServerCallback_ControlRoomBattleAmbient

//const FX_SKYBOX_BERMINGHAM_WARP_IN = $"veh_birm_warp_in_FULL"
//const SKYBOX_ARMADA_SHIP_MODEL_BERMINGHAM = $"models/vehicle/capital_ship_Birmingham/birmingham_space.mdl"

const FX_CARRIER_WARPIN = $"veh_carrier_warp_FULL"

//const FLEET_MOVE_SPEED_MIN = 9
//const FLEET_MOVE_SPEED_MAX = 12

struct
{
} file

void function ClientCodeCallback_MapInit()
{
	ShBeaconCommonInit()

	ShSpBeaconHubCommonInit()
	PrecacheParticleSystem( FX_CARRIER_WARPIN )

	AddCreateCallback( "player", PlayerCreateCallback )

	//RegisterSignal( "talk_glow" )

	//PrecacheParticleSystem( FX_SKYBOX_BERMINGHAM_WARP_IN )
	//PrecacheModel( SKYBOX_ARMADA_SHIP_MODEL_BERMINGHAM )

	//ClBirmingham_Init()
}

void function PlayerCreateCallback( entity player )
{
	ServerCallback_ControlRoomBattleAmbient( GetGlobalNetBool( "controlRoomBattleAmbient" ) )
}

void function ServerCallback_ControlRoomBattleAmbient( bool active )
{
	entity ambGeneric
	if ( active )
	{
		ambGeneric = GetEntByScriptName( "control_room_battle_emitter" )
		ambGeneric.SetEnabled( true )
	}
	else
	{
		ambGeneric = GetEntByScriptName( "control_room_battle_emitter" )
		ambGeneric.SetEnabled( false )
	}
}
/*
function ServerCallback_WarpInFleet()
{
	entity skybox_center = GetEntByScriptName( "skybox_center" )
	Assert( IsValid( skybox_center ) )
	vector centerPos = skybox_center.GetOrigin() + <0,0,200>
	vector centerAng = skybox_center.GetAngles()

	vector forward = AnglesToForward( centerAng )
	vector right = AnglesToRight( centerAng )
	vector up = AnglesToUp( centerAng )

	array<vector> firstWaveOffsets
	firstWaveOffsets.append( < -100,100,0> )
	firstWaveOffsets.append( < -200,200,0> )
	firstWaveOffsets.append( < -150,350,0> )
	firstWaveOffsets.append( < -350,300,0> )
	firstWaveOffsets.append( < -400,600,0> )
	firstWaveOffsets.append( < -200,0,0> )
	firstWaveOffsets.append( < -600,0,0> )
	foreach( vector offset in firstWaveOffsets )
	{
		// One off ships so we dont have to wait for them to reach us
		vector startPos = centerPos + (forward * offset.x) + (right * offset.y) + (up * offset.z)
		vector endPos = startPos + (forward * -offset.x)
		thread ShipFlyby( startPos, endPos, centerAng, false, RandomFloatRange( 0.0, 3.0 ) )
	}

	// Looping Ships
	array<vector> shipOffsets
	shipOffsets.append( < -1000, -1000, -30> )
	shipOffsets.append( < -1000, -800, -100> )
	shipOffsets.append( < -1000, -600, 0> )
	shipOffsets.append( < -1000, -400, 40> )
	shipOffsets.append( < -1000, -200, -20> )
	shipOffsets.append( < -1000, -100, -80> )
	shipOffsets.append( < -1000, 0, 100> )
	shipOffsets.append( < -1000, 200, 20> )
	shipOffsets.append( < -1000, 400, -100> )
	shipOffsets.append( < -1000, 600, -50> )
	shipOffsets.append( < -1000, 800, 10> )
	shipOffsets.append( < -1000, 1000, 30> )
	foreach( vector offset in shipOffsets )
	{
		// One off ships so we dont have to wait for them to reach us
		vector startPos = centerPos + (forward * offset.x) + (right * offset.y) + (up * offset.z)
		vector endPos = startPos + (forward * -offset.x * 2)
		thread ShipFlyby( startPos, endPos, centerAng, true, RandomFloatRange( 5.0, 15.0 ) )
	}
}

function ShipFlyby( vector startPos, vector endPos, vector startAng, bool loop, float delay )
{

	wait delay

	int fxID = GetParticleSystemIndex( FX_SKYBOX_BERMINGHAM_WARP_IN )
	StartParticleEffectInWorld( fxID, startPos, startAng )
	wait 0.2

	entity ship = CreateClientsideScriptMover( SKYBOX_ARMADA_SHIP_MODEL_BERMINGHAM, startPos, startAng )

	float moveTime = Distance( startPos, endPos ) / RandomFloatRange( FLEET_MOVE_SPEED_MIN, FLEET_MOVE_SPEED_MAX )
	ship.NonPhysicsMoveTo( endPos, moveTime, 0, 0 )

	if ( loop )
	{
		float timeTillLoop = moveTime * RandomFloatRange( 0.3, 0.5 )
		delaythread(timeTillLoop) ShipFlyby( startPos, endPos, startAng, loop, 0.0 )
	}

	wait moveTime
	ship.Destroy()
}
*/

//CreateBeaconSkyShip( < -36637, 62749.9, 17009.6>, <0, -12.294, 0> )
//CreateBeaconSkyShip( < -13211.3, 9248.92, 9793.6>, <0, -20.407, 0> )
//CreateBeaconSkyShip( < -15889.2, 6368.8, 9720.8>, <0, 7.6362, 0> )

void function CreateBeaconSkyShip( vector origin, vector angles, float forwardMotion = 0, float forwardOffset = 0 )
{
	vector forward = AnglesToForward( angles )
	origin += forward * forwardOffset

	entity ship = CreateClientSidePropDynamic( origin, angles, TRINITY_MDL )
	ship.SetFadeDistance( 80000 )
	ship.EnableRenderAlways()

	float startTime = Time()

	for ( ;; )
	{
		float progress = Graph( Time(), startTime, startTime + 1.0, 0.0, 1.0 )
		vector newOrigin = origin + forward * progress * forwardMotion
		if ( LegalOrigin( newOrigin ) )
			ship.SetOrigin( origin + forward * progress * forwardMotion )
		WaitFrame()
	}
}


void function CreateBeaconSkyShip_WarpIn( vector origin, vector angles, float forwardMotion = 0, float forwardOffset = 0 )
{
	vector forward = AnglesToForward( angles )
	origin += forward * forwardOffset

	//EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "dropship_warpin" )
//	wait 2.0

//	int explosionID = GetParticleSystemIndex( FX_CARRIER_WARPIN )
//	for ( int i = 0; i < 8; i++ )
//	{
//		StartParticleEffectInWorld( explosionID, origin + forward * i * 1000, angles )
//	}

//	wait 1.1

	float startOffset = 0
	entity ship = CreateClientSidePropDynamic( origin + forward * startOffset, angles, TRINITY_MDL )
	ship.SetFadeDistance( 80000 )
	ship.EnableRenderAlways()

//	for ( ;; )
//	{
//		WaitFrame()
//		if ( fabs( startOffset ) <= 100 )
//			break
//		startOffset *= 0.5
//		ship.SetOrigin( origin + forward * startOffset )
//	}
//
//	ship.SetOrigin( origin )

	float startTime = Time()

	for ( ;; )
	{
		float progress = Graph( Time(), startTime, startTime + 1.0, 0.0, 1.0 )
		vector newOrigin = origin + forward * progress * forwardMotion
		if ( LegalOrigin( newOrigin ) )
			ship.SetOrigin( origin + forward * progress * forwardMotion )
		WaitFrame()
	}
}

void function CreateBeaconShipAnim( asset model, string sequence, vector origin, vector angles )
{
	printt( "started " + model + " doing " + sequence + " at " + Time() )
	entity ship = CreateClientSidePropDynamic( origin, angles, model )
	ship.SetFadeDistance( 80000 )
	ship.EnableRenderAlways()
	PlayAnimTeleport( ship, sequence, origin, angles )
	ship.Destroy()
}

void function ServerCallback_CallInTheFleet()
{
	thread ServerCallback_CallInTheFleet_Thread()
}

void function ServerCallback_CallInTheFleet_Thread()
{
	DoF_SetNearDepth( 32, 47 )
	delaythread( 0.0 ) CreateBeaconSkyShip( <2064.1, 23133.5, 35684.3>, <0, 0.2504, 0>, 500 )
	wait 0.2 // sv/cl view delay

//	delaythread( 0.0 ) CreateBeaconSkyShip_WarpIn( <13543.1, 9522.5, 11612.3>, <0, -165.02, 0>, 500 )
//	delaythread( 0.8 ) CreateBeaconSkyShip_WarpIn( <15354.1, 28362.5, 18404.3>, <0, -165.02, 0>, 500 )
	delaythread( 0.0 ) CreateBeaconSkyShip_WarpIn( <8268.26, 24633.5, 25574.1>, <0, 4.0003, 0>, 500 )
	delaythread( 0.4 ) CreateBeaconSkyShip_WarpIn( < -2173.9, 38428.5, 27131.3>, <0, 7.924, 0>, 500 )

	delaythread( 0.0 ) CreateBeaconShipAnim( $"models/humans/grunts/mlt_grunt_rifle.mdl", "pt_arc_mine_activate_idle", <2699.39, -2898.57, 674.725>, <0, -111.18, 0> )
	delaythread( 0.0 ) CreateBeaconShipAnim( $"models/humans/grunts/mlt_grunt_rifle.mdl", "pt_bored_overseer", <2244.98, -1245.77, 672.003>, <0, 73.125, 0> )
	delaythread( 0.0 ) CreateBeaconShipAnim( $"models/humans/grunts/mlt_grunt_smg.mdl", "pt_bored_check_crate_B", <2221.46, -1761.56, 672.962>, <0, -106.875, 0> )

	wait 0.4 // sv/cl view delay

	delaythread( 2.0 ) CreateBeaconShipAnim( HORNET_MDL, "st_Dogfight_Persuer_1", <1873.53, 5166.08, 2571.99>, <0, 26.0577, 0> )
	delaythread( 2.0 ) CreateBeaconShipAnim( HORNET_MDL, "st_Dogfight_Persuer_2", <165.384, 3740.03, -4591.01>, <0, 49.1291, 0> )
	delaythread( 2.2 ) CreateBeaconShipAnim( CROW_MDL, "dropship_corporate_flyin_imc_R_FAST", < -1090.73, -61.36, 2571.99>, <0, 26.0577, 0> )
	delaythread( 33.1 ) CreateBeaconShipAnim( HORNET_MDL, "st_Dogfight_Persuer_3", < -6901.5, -1713.79, -1337.01>, <0, 49.129, 0> )
	delaythread( 55.6 ) CreateBeaconShipAnim( $"models/humans/grunts/mlt_grunt_lmg.mdl", "pt_armory_walkers_gruntB", <1780.76, -1368.11, 671.999>, <0, -111.18, 0> )
}


void function ServerCallback_LevelIntroText()
{
	BeginIntroSequence()
	var infoText = RuiCreate( $"ui/sp_level_title.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 100 )
	RuiSetGameTime( infoText, "startTime", Time() )
	RuiSetString( infoText, "txtLine1", "#BEACON_INTRO_TEXT_LINE1" )
	RuiSetString( infoText, "txtLine2", "#BEACON_INTRO_TEXT_LINE2" )
	RuiSetString( infoText, "txtLine3", "#BEACON_INTRO_TEXT_LINE3" )
}
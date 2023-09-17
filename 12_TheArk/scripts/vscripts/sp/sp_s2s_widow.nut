global const array<string> WIDOW_RACKCONFIG_12A = [ "ATTACH_L_BOT_SEAT_1", "ATTACH_L_BOT_SEAT_2", "ATTACH_L_TOP_SEAT_1", "ATTACH_L_TOP_SEAT_2",
													"ATTACH_R_BOT_SEAT_1", "ATTACH_R_BOT_SEAT_2", "ATTACH_R_TOP_SEAT_1", "ATTACH_R_TOP_SEAT_2",
													"ATTACH_L_BOT_SEAT_4", "ATTACH_L_BOT_SEAT_5", "ATTACH_L_TOP_SEAT_4", "ATTACH_L_TOP_SEAT_5",
													"ATTACH_R_BOT_SEAT_4", "ATTACH_R_BOT_SEAT_5", "ATTACH_R_TOP_SEAT_4", "ATTACH_R_TOP_SEAT_5",
													"ATTACH_L_BOT_SEAT_7", "ATTACH_L_BOT_SEAT_8", "ATTACH_L_TOP_SEAT_7", "ATTACH_L_TOP_SEAT_8",
													"ATTACH_R_BOT_SEAT_7", "ATTACH_R_BOT_SEAT_8", "ATTACH_R_TOP_SEAT_7", "ATTACH_R_TOP_SEAT_8" ]

global function S2S_WidowInit
global function SpawnWidow
global function SpawnWidowLight
global function Event_WidowAnimOpenDoor
global function WidowAnimateOpen
global function WidowAnimateClose
global function WidowSetupSpawners
global function WidowDeploySpectre

const asset DROPSHIP_WIDOW_MODEL = $"models/vehicle/widow/widow.mdl"
const asset MODEL_SPECTRE_RACK	= $"models/commercial/rack_spectre_wall.mdl"
const float WIDOW_HEALTH = 4500

struct
{
	array<ShipStruct> widowTemplates
}file

void function S2S_WidowInit()
{
	PrecacheModel( MODEL_SPECTRE_RACK )
	PrecacheModel( DROPSHIP_WIDOW_MODEL )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}

void function EntitiesDidLoad()
{
	array<entity> templates = GetEntArrayByScriptName( "widowTemplate" )
	foreach ( entity template in templates )
	{
		template.kv.CollisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS//this makes the goblin shootable but not have phys collision
		template.SetTouchTriggers( false )

		ShipStruct ship = ShipTemplateSetup( template, null, WidowSetupLinks )
		file.widowTemplates.append( ship )
		WidowDefaultDataSettings( ship )
	}
}

void function WidowDefaultDataSettings( ShipStruct ship )
{
	ship.defaultBehaviorFunc 	= DefaultBehavior_Widow
	ship.defaultEventFunc 		= DefaultEventCallbacks_Widow
	ship.DEV_hullSize 			= <275, 550, 300>
	ship.DEV_hullOffset 		= <0, 0, 350>
	ship.defAccMax 				= 100
	ship.defSpeedMax 			= 500
	ship.defRollMax 			= 15
	ship.defPitchMax 			= 20

	Highlight_SetFriendlyHighlight( ship.model, "sp_s2s_crow_outline" )
}

float function GetBankMagnitudeWidow( float dist )
{
	return GraphCapped( dist, 10, 100, 0.0, 1.0 )
}

/************************************************************************************************\

███████╗███████╗████████╗██╗   ██╗██████╗
██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
███████╗█████╗     ██║   ██║   ██║██████╔╝
╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
███████║███████╗   ██║   ╚██████╔╝██║
╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

\************************************************************************************************/
ShipStruct function SpawnWidow( LocalVec ornull origin = null, vector angles = CONVOYDIR )
{
	if ( origin == null )
		origin = CLVec( <0,0,0> )
	expect LocalVec( origin )

	ShipStruct ship = GetFreeTemplate( file.widowTemplates )
	entity mover = ship.mover
	SetOriginLocal( mover, origin )
	mover.SetAngles( angles )

	ResetWidowTemplate( ship )
	thread PlayAnim( ship.model, "wd_doors_closed_idle", mover )
	SetTeam( ship.model, TEAM_MILITIA )

	//common
	thread ShipCommonFuncs( ship )
	return ship
}

ShipStruct function SpawnWidowLight( LocalVec ornull origin = null, vector angles = CONVOYDIR, bool animating = false )
{
	if ( origin == null )
		origin = CLVec( <0,0,0> )
	expect LocalVec( origin )

	ShipStruct ship
	entity mover
	if ( !animating )
		mover = CreateScriptMoverModel( DROPSHIP_WIDOW_MODEL, LocalToWorldOrigin( origin ), angles, 6, 100000 )
	else
		mover = CreateExpensiveScriptMoverModel( DROPSHIP_WIDOW_MODEL, LocalToWorldOrigin( origin ), angles, 6, 100000 )

	ship.model = mover
	ship.mover = mover
	SetTeam( mover, TEAM_MILITIA )

	SetOriginLocal( mover, origin )
	mover.SetAngles( angles )

	thread PlayAnim( ship.model, "wd_doors_closed_idle", mover )

	WidowDefaultDataSettings( ship )

	ResetWidowTemplate( ship )

	ship.engineDamage = false
	ship.model.SetTakeDamageType( DAMAGE_YES )
	ship.model.SetDamageNotifications( true )
	//ship.model.SetMaxHealth( WIDOW_HEALTH )
	//ship.model.SetHealth( ship.model.GetMaxHealth() )
	//AddEntityCallback_OnDamaged( ship.model, WidowOnDamaged )

	ship.localVelocity.v = <0,0,0>
	ship.goalRadius = SHIPGOALRADIUS
	ship.boundsMinRatio = 0.5

	ResetAllEventCallbacksToDefault( ship )
	ResetAllBehaviorsToDefault( ship )
	ship.behavior 		= eBehavior.IDLE
	ship.prevBehavior 	= [ eBehavior.IDLE ]
	ship.free 			= false

	thread RunBehaviorFiniteStateMachine( ship )
	thread WidowEngineFailureThink( ship )

	ResetMaxSpeed( ship )
	ResetMaxAcc( ship )
	ResetMaxRoll( ship )
	ResetMaxPitch( ship )
	ResetBankTime( ship )

	//ship.bug_reproNum = 10

//	int eHandle = ship.model.GetEncodedEHandle()
//	Remote_CallFunction_NonReplay( GetPlayerArray()[0], "ServerCallback_DisableDropshipLights", eHandle )

	return ship
}

void function WidowSetupSpawners( ShipStruct ship, array<entity> spawners, array<string> ornull configuration = null )
{
	if ( configuration == null )
		configuration = WIDOW_RACKCONFIG_12A
	expect array<string>( configuration )

	#if DEV
		Assert( configuration.len() >= spawners.len() )
		foreach( ent in spawners )
			Assert( IsSpawner( ent ) )
	#endif

	entity model = ship.model
	vector rightVec = model.GetRightVector()
	int spawnerIndex = 0

	foreach ( index, attachment in configuration )
	{
		entity rack = CreatePropDynamic( MODEL_SPECTRE_RACK, null, null, 6 )
		rack.LinkToEnt( spawners[ spawnerIndex ] )
		SetupSpectreRack( rack )

		if ( ++spawnerIndex >= spawners.len() )
			spawnerIndex = 0

		rack.SetParent( model, attachment )

		if( DotProduct( rightVec, rack.GetForwardVector() ) > 0 )
			ship.spectreRacksR.append( rack )
		else
			ship.spectreRacksL.append( rack )

		SpectreRack spectreRack = GetSpectreRackFromEnt( rack )
		foreach ( spectreRackSpectre in spectreRack.spectreRackSpectres )
			spectreRackSpectre.dummyModel.SetParent( rack, spectreRackSpectre.attachName )
	}
}

void function WidowSetupLinks( ShipStruct ship, entity mover, entity ent )
{
	entity model = ship.model
	switch( ent.kv.script_noteworthy )
	{
		case "BotDoorL":
				ent.SetParent( model, "L_DOOR_BOT_ATTACH", true )
				break

		case "BotDoorR":
			ent.SetParent( model, "R_DOOR_BOT_ATTACH", true )
			break

		case "TopDoorL":
			ent.SetParent( model, "L_DOOR_TOP_ATTACH", true )
			break

		case "TopDoorR":
			ent.SetParent( model, "R_DOOR_TOP_ATTACH", true )
			break

		case "backWingL":
			ent.SetParent( model, "ATTACH_L_REAR_WING", true )
			break

		case "backWingR":
			ent.SetParent( model, "ATTACH_R_REAR_WING", true )
			break

		default:
			Assert( 0, "linked template ent missing valid script_noteworthy" )
			break
	}
}

void function ResetWidowTemplate( ShipStruct ship )
{
	foreach ( rackModel in ship.spectreRacksR )
	{
		if ( IsValid( rackModel ) )
			rackModel.Destroy()
	}
	foreach ( rackModel in ship.spectreRacksL )
	{
		if ( IsValid( rackModel ) )
			rackModel.Destroy()
	}
	ship.spectreRacksR = []
	ship.spectreRacksL = []

	ship.doorState = eDoorState.CLOSED
	ship.behavior = eBehavior.NONE

	ship.FuncGetBankMagnitude 	= GetBankMagnitudeWidow
}

void function DefaultBehavior_Widow( ShipStruct ship, int behavior )
{
	switch ( behavior )
	{
		case eBehavior.ENEMY_CHASE:
		case eBehavior.ENEMY_ONBOARD:
			AddShipBehavior( ship, behavior, Behavior_ChaseEnemy )
			//right, forward, up
			SetFlyOffset( ship, behavior, < 500, 0, -200 > )
			SetFlyBounds( ship, behavior, < 50, 200, 50 > )
			SetSeekAhead( ship, behavior, 700 )
			break

		case eBehavior.DEPLOY:
			AddShipBehavior( ship, behavior, Behavior_Deploy )
			//right, forward, up
			SetFlyOffset( ship, behavior, < 550, 0, -85 > )
			SetFlyBounds( ship, behavior, < 50, 200, 50 > )
			SetSpawnDelay( ship, behavior, 0.1, 0.25 )
			SetSquadDelay( ship, behavior, 0.25, 0.5 )
			SetSquadSize( ship, behavior, 4 )
			break

		case eBehavior.DEATH_ANIM:
			AddShipBehavior( ship, behavior, Behavior_DeathAnim )
			break
	}
}

void function DefaultEventCallbacks_Widow( ShipStruct ship, int event )
{
	switch ( event )
	{
		case eShipEvents.SHIP_ATDEPLOYPOS:
			AddShipEventCallback( ship, event, Event_WidowAnimOpenDoor )
			break

		case eShipEvents.SHIP_ONOPENDOOR:
			AddShipEventCallback( ship, event, Event_WidowOnOpenDoor )
			break
	}
}

/************************************************************************************************\

██████╗ ███████╗██╗  ██╗ █████╗ ██╗   ██╗██╗ ██████╗ ██████╗
██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║██║██╔═══██╗██╔══██╗
██████╔╝█████╗  ███████║███████║██║   ██║██║██║   ██║██████╔╝
██╔══██╗██╔══╝  ██╔══██║██╔══██║╚██╗ ██╔╝██║██║   ██║██╔══██╗
██████╔╝███████╗██║  ██║██║  ██║ ╚████╔╝ ██║╚██████╔╝██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝

\************************************************************************************************/
void function Behavior_ChaseEnemy( ShipStruct ship )
{
	int behavior 	= ship.behavior
	vector bounds 	= ship.flyBounds[ behavior ]
	vector offset 	= ship.flyOffset[ behavior ]
	float seekAhead = ship.seekAhead[ behavior ]
	__ShipFlyAlongEdge( ship, bounds, offset, seekAhead, eShipEvents.SHIP_ATNEWEDGE )
}

void function Behavior_Deploy( ShipStruct ship )
{
	ShipStruct ornull followShip = GetDeployShip( ship )
	expect ShipStruct( followShip )
	entity targetEnt = followShip.mover
	vector pos 		= GetDeployPos( ship )
	int behavior 	= ship.behavior
	vector offset 	= ship.flyOffset[ behavior ]
	vector bounds 	= ship.flyBounds[ behavior ]

	__ShipFollowShip( ship, targetEnt, pos, bounds, offset, eShipEvents.SHIP_ATDEPLOYPOS )
}

/************************************************************************************************\

██████╗ ███████╗ █████╗ ████████╗██╗  ██╗
██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██║  ██║
██║  ██║█████╗  ███████║   ██║   ███████║
██║  ██║██╔══╝  ██╔══██║   ██║   ██╔══██║
██████╔╝███████╗██║  ██║   ██║   ██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝

\************************************************************************************************/
void function WidowOnDamaged( entity ent, var damageInfo )
{
	float damage = DamageInfo_GetDamage( damageInfo )
	entity inflictor = DamageInfo_GetInflictor( damageInfo )

	if ( IsValid( inflictor ) && inflictor.GetTeam() == ent.GetTeam() )
		DamageInfo_SetDamage( damageInfo, 0 )

	//make sure this entity NEVER dies
	if ( damage >= ent.GetHealth() )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		ent.SetHealth( 1 )
		Signal( ent, "OnDamaged" )
	}
}

void function WidowEngineFailureThink( ShipStruct ship )
{
	ship.model.EndSignal( "OnDestroy" )
	EndSignal( ship, "FakeDeath" )
	EndSignal( ship, "FakeDestroy" )

	entity model = ship.model

	OnThreadEnd(
	function() : ( model )
		{
			model.SetTakeDamageType( DAMAGE_NO )
			model.SetDamageNotifications( false )
		}
	)

	while( 1 )
	{
		WaitSignal( model, "OnDamaged" )
		if ( model.GetHealth() <= 1 )
			break
	}

	Signal( ship, "engineFailure_Complete" )
}

void function Behavior_DeathAnim( ShipStruct ship )
{
	thread Behavior_DeathAnimThread( ship )
}

void function Behavior_DeathAnimThread( ShipStruct ship )
{
	Signal( ship, "FakeDeath" )
	EndSignal( ship, "FakeDestroy" )

	entity mover 	= ship.mover
	mover.EndSignal( "OnDestroy" )
	entity enemy = ship.chaseEnemy

	if ( IsAlive( ship.pilot ) )
	{
		if ( IsValid( enemy ) && enemy.IsPlayer() )
		{
		//	Dev_PrintMessage( enemy, "", "Mayday! Mayday! Vector 3-2 is going down!", 5 )//hack
		}
	}
	else if ( IsValid( enemy ) && enemy.IsPlayer() )
	{
		foreach ( entity guy in ship.guys )
		{
			if ( IsAlive( guy ) )
			{
			//	Dev_PrintMessage( ship.chaseEnemy, "", "Our Pilot's Down! Mayday! Mayday! Our Pilot's down!", 5 )//hack
				break
			}
		}
	}

	OnThreadEnd(
	function() : ( ship )
		{
			thread FakeDestroy( ship )
		}
	)

	SetMaxSpeed( ship, 100, 1.0 )
	SetMaxAcc( ship, 50, 1.0 )
	ship.goalRadius = 1000
	float rightOfTarget = GetBestRightOfTargetForLeaving( ship )
	entity noFollowTarget = null

	float x = RandomFloatRange( 1300, 1500 ) * 2
	float y = RandomFloatRange( -800, -600 ) * 2
	float z = RandomFloatRange( -1100, -900 ) * 2

	//if we can fly along the edge - then do so for the first part
	if ( CanGetEdgeData( ship, ship.chaseEnemy ) )
	{
		vector bounds = <0,0,0>
		float seekAhead = 0
		vector offset = <x,y,z>

		thread __ShipFlyAlongEdge( ship, bounds, offset, seekAhead, eShipEvents.NONE )
	}
	else
	{
		LocalVec pos = CLVec( GetOriginLocal( mover ).v + < x * rightOfTarget,y,z > )
		vector offset = <0,0,0>
		thread __ShipFlyToPosInternal( ship, noFollowTarget, pos, offset, CONVOYDIR )
	}

	wait 0.2
	ship.chaseEnemy = null // do this so it doesn't constantly try to update with the player pos

	WaitSignal( ship, "Goal" )

	SetMaxSpeed( ship, 500, 1.0 )

	LocalVec pos = CLVec( GetOriginLocal( mover ).v + < 10000 * rightOfTarget, -30000, -40000 > )
	pos.v *= 1.5
	vector offset = <0,0,0>
	thread __ShipFlyToPosInternal( ship, noFollowTarget, pos, offset, CONVOYDIR )

	ship.goalRadius = 15000
	WaitSignal( ship, "Goal" )
	thread FakeDestroy( ship )
}

/************************************************************************************************\

██████╗  ██████╗  ██████╗ ██████╗ ███████╗
██╔══██╗██╔═══██╗██╔═══██╗██╔══██╗██╔════╝
██║  ██║██║   ██║██║   ██║██████╔╝███████╗
██║  ██║██║   ██║██║   ██║██╔══██╗╚════██║
██████╔╝╚██████╔╝╚██████╔╝██║  ██║███████║
╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝

\************************************************************************************************/
void function Event_WidowAnimOpenDoor( ShipStruct ship, entity player, int eventID )
{
	if ( IsDoorOpenOrOpening( ship ) )
		return

	string side = GetBestSideFromEvent( ship, player, eventID )
	WidowAnimateOpen( ship, side )
}

void function WidowAnimateOpen( ShipStruct ship, string side )
{
	entity mover = ship.mover

	ship.model.EndSignal( "OnDestroy" )
	EndSignal( ship, "FakeDeath" )
	mover.EndSignal( "OnDestroy" )

	int openingState, openState
	string anim, idle

	switch( side )
	{
		case "left":
			openState = eDoorState.OPEN_L
			openingState = eDoorState.OPENING_L
			anim = "wd_doors_opening_L"
			idle = "wd_doors_open_idle_L"
			break

		case "right":
			openState = eDoorState.OPEN_R
			openingState = eDoorState.OPENING_R
			anim = "wd_doors_opening_R"
			idle = "wd_doors_open_idle_R"
			break

		case "both":
			openState = eDoorState.OPEN
			openingState = eDoorState.OPENING
			anim = "wd_doors_opening"
			idle = "wd_doors_open_idle"
			break
	}

	ship.doorState = openingState
	Signal( ship, "DoorsOpening" )
	EndSignal( ship, "DoorsClosing" )

	entity player = ship.chaseEnemy
	RunShipEventCallbacks( ship, eShipEvents.SHIP_ONOPENDOOR, player )

	waitthread PlayAnim( ship.model, anim, mover )
	ship.doorState = openState
	Signal( ship, "DoorsOpened" )

	thread PlayAnim( ship.model, idle, mover )
}

void function WidowAnimateClose( ShipStruct ship, string side )
{
	entity mover = ship.mover

	ship.model.EndSignal( "OnDestroy" )
	EndSignal( ship, "FakeDeath" )
	mover.EndSignal( "OnDestroy" )

	int closingState, closeState
	string anim, idle

	if ( side == "" )
	{
		switch ( ship.doorState )
		{
			case eDoorState.OPEN_L:
			case eDoorState.OPENING_L:
				side = "left"
				break

			case eDoorState.OPEN_R:
			case eDoorState.OPENING_R:
				side = "right"
				break

			case eDoorState.OPEN:
			case eDoorState.OPENING:
				side = "both"
				break

			default:
				Assert( 0 )
				break
		}
	}

	switch( side )
	{
		case "left":
			closeState = eDoorState.CLOSED
			closingState = eDoorState.CLOSING_L
			anim = "wd_doors_closing_L"
			idle = "wd_doors_closed_idle"
			break

		case "right":
			closeState = eDoorState.CLOSED
			closingState = eDoorState.CLOSING_R
			anim = "wd_doors_closing_R"
			idle = "wd_doors_closed_idle"
			break

		case "both":
			closeState = eDoorState.CLOSED
			closingState = eDoorState.CLOSING_R
			anim = "wd_doors_closing"
			idle = "wd_doors_closed_idle"
			break
	}

	ship.doorState = closingState
	Signal( ship, "DoorsClosing" )
	EndSignal( ship, "DoorsOpening" )

	entity player = ship.chaseEnemy
	RunShipEventCallbacks( ship, eShipEvents.SHIP_ONCLOSEDOOR, player )

	waitthread PlayAnimTeleport( ship.model, anim, mover )
	ship.doorState = closeState
	Signal( ship, "DoorsClosed" )

	thread PlayAnim( ship.model, idle, mover )
}

/************************************************************************************************\

██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗
██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝
██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝
██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝
██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║
╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝

\************************************************************************************************/
void function Event_WidowOnOpenDoor( ShipStruct ship, entity player, int eventID )
{
	EndSignal( ship, "DoorsClosing" )
	EndSignal( ship, "FakeDeath" )
	EndSignal( ship, "FakeDestroy" )

	wait 2.0 // time for doors to animate

	array<entity> racks
	switch ( ship.doorState )
	{
		case eDoorState.OPEN_R:
		case eDoorState.OPENING_R:
			racks = ship.spectreRacksR
			break

		case eDoorState.OPEN_L:
		case eDoorState.OPENING_L:
			racks = ship.spectreRacksL
			break

		case eDoorState.OPEN:
		case eDoorState.OPENING:
			racks = ship.spectreRacksL
			racks.extend( ship.spectreRacksR )
			break
	}

	int behavior = ship.behavior
	int count = 0

	racks.randomize()

	for ( int i = 0; i < racks.len(); i++ )
	{
		wait GetSpawnDelay( ship, behavior )
		SpectreRack spectreRack = GetSpectreRackFromEnt( racks[ i ] )
		thread SpectreRackActivationEffects( spectreRack )
		thread WidowDeploySpectre( ship, spectreRack, spectreRack.spectreRackSpectres[0] )

		count++
		if ( count >= GetSquadSize( ship, behavior ) )
		{
			wait GetSquadDelay( ship, behavior )
			count = 0
		}
	}
}

void function WidowDeploySpectre( ShipStruct ship, SpectreRack spectreRack, SpectreRackSpectre spectreRackSpectre )
{
	entity dummy = spectreRackSpectre.dummyModel
	Assert( IsValid ( dummy ) )

	entity spawner = spectreRackSpectre.spawner
	Assert( IsValid ( spawner ) )

	entity mover = CreateScriptMover()
	entity link = CreateScriptMover()

	OnThreadEnd(
	function() : ( mover, link )
		{
			mover.Destroy()
			link.Destroy()
		}
	)

	EndSignal( spectreRack, "OnDestroy" )
	EndSignal( spectreRack.rackEnt, "OnDestroy" )

	table spawnerKeyValues = spawner.GetSpawnEntityKeyValues()
	if ( "script_delay" in spawnerKeyValues )
		wait float( spawnerKeyValues[ "script_delay" ] )

	entity spectre = spawner.SpawnEntity()
	spectre.SetEfficientMode( true )
	DispatchSpawn( spectre )

	string deployAnim = "sp_traverse_across_256_back"
	if( DotProduct( spectreRack.rackEnt.GetOrigin() - ( ship.model.GetOrigin() - <0,0,16> ), ship.model.GetUpVector() ) > 0 )
		deployAnim = "sp_traverse_across_256_down_128"

	EndSignal( spectre, "OnDeath" )

	string attachment = spectreRackSpectre.attachName

	thread PlayAnimTeleport( spectre, "sp_med_bay_dropidle_A", spectreRack.rackEnt, attachment )

	mover.SetOrigin( spectre.GetOrigin() )
	mover.SetAngles( spectre.GetAngles() )

	if ( CoinFlip() )
		EmitSoundOnEntity( spectre, "diag_imc_spectre_gs_deployedRack_01_1" )

	spectre.SetParent( mover )

	ShipStruct ornull followShip = GetDeployShip( ship )
	expect ShipStruct( followShip )
	vector up = followShip.model.GetUpVector()

	vector flatForward = mover.GetForwardVector()
	vector newRight = Normalize( CrossProduct( flatForward, up ) )
	vector newForward = Normalize( CrossProduct( up, newRight ) )
	vector newAngles = VectorToAngles( newForward )

	int behavior 	= ship.behavior
	float x 		= ship.flyOffset[ behavior ].x + ship.flyBounds[ behavior ].x - 450 //450 is the length of travel in the anim
	vector pos 		= mover.GetOrigin() + ( newForward * x ) + < RandomFloatRange( -32, 32 ), RandomFloatRange( -32, 32 ), 0 >

	float time 			= spectre.GetSequenceDuration( deployAnim )
	float initialTime 	= 0.4
	float travelTime 	= time - ( 0.65 + initialTime )

	dummy.ClearParent()
	dummy.Hide()
	dummy.SetOrigin( pos )
	dummy.SetAngles( newAngles )

	Attachment landing = dummy.Anim_GetAttachmentAtTime( deployAnim, "ORIGIN", time )
	vector landPos = landing.position
	dummy.Destroy()

	thread PlayAnim( spectre, deployAnim, mover, null, DEFAULT_SCRIPTED_ANIMATION_BLEND_TIME, initialTime )

	vector endPos
	TraceResults result = TraceLine( landPos + ( up * 100 ), landPos - ( up * 550 ), [], TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_NPC )
	if ( result.fraction != 1.0 )
	{
		//spectre falls and maybe lands
		vector delta = result.endPos - landPos
		endPos = pos + delta
	}
	else
		endPos = pos

	link.SetOrigin( endPos )
	link.SetAngles( newAngles )
	link.SetParent( followShip.model, "ORIGIN", true )
	mover.SetParent( link, "", false, travelTime )

	#if DEV
		if ( DEV_DRAWDEPLOY )
		{
			thread DevDrawSpectreDeploy( followShip, spectre, mover, link, pos, landPos, result.endPos, newAngles )
		}
	#endif

	if ( result.fraction == 1.0 )
	{
		//spectre falls and maybe lands
		wait travelTime - 0.2

		vector oldOrigin = spectre.GetOrigin()
		wait 0.1
		vector vel = ( spectre.GetOrigin() - oldOrigin ) * 10

		//spectre.Anim_Stop()
		spectre.ClearParent()
		spectre.Anim_ScriptedPlay( "st_skyfall_lean" )
		spectre.Anim_EnablePlanting()
		spectre.SetVelocity( vel )

		while( 1 )
		{
			vector origin 	= spectre.GetOrigin()
			vector vel 		= spectre.GetVelocity()
			float mag 		= Length( vel )

			if ( mag < 5 ) //he planted
				break

			vector endFall 	= origin + ( vel * FRAME_INTERVAL )
			result = TraceLine( origin, endFall, [spectre], TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_NPC )

			if ( result.fraction < 1.0)
				break
			WaitFrame()
		}

		spectre.Anim_ScriptedPlay( "st_widow_spawner_land" )
		spectre.Anim_EnablePlanting()
	}
	else
	{
		WaittillAnimDone( spectre )
		spectre.ClearParent()
	}

	spectre.SetEfficientMode( false )
	DeployFuncWrapper( ship, spectre )
}

void function DevDrawSpectreDeploy( ShipStruct ship, entity spectre, entity mover, entity link, vector ogPos, vector landPos, vector endPos, vector endAngles )
{
	spectre.EndSignal( "OnDeath" )
	mover.EndSignal( "OnDestroy" )
	link.EndSignal( "OnDestroy" )

	entity startEnt = CreateScriptMover( mover.GetOrigin(), endAngles )
	entity landEnt = CreateScriptMover( landPos )
	entity traceEnt = CreateScriptMover( endPos, endAngles )
	entity animEnt = CreateScriptMover( ogPos, endAngles )

	startEnt.SetParent( ship.model, "ORIGIN", true )
	landEnt.SetParent( ship.model, "ORIGIN", true )
	traceEnt.SetParent( ship.model, "ORIGIN", true )
	animEnt.SetParent( ship.model, "ORIGIN", true )

	OnThreadEnd(
	function() : ( startEnt, landEnt, traceEnt, animEnt )
		{
			startEnt.Destroy()
			landEnt.Destroy()
			traceEnt.Destroy()
			animEnt.Destroy()
		}
	)

	while( 1 )
	{
		DebugDrawLine( landEnt.GetOrigin(), startEnt.GetOrigin(), 255, 120, 0, true, FRAME_INTERVAL )
		DebugDrawLine( landEnt.GetOrigin(), traceEnt.GetOrigin(), 0, 202, 255, true, FRAME_INTERVAL )
		DebugDrawCircle( landEnt.GetOrigin(), traceEnt.GetAngles(), 12, 255, 120, 0, true, FRAME_INTERVAL, 4 )
		DebugDrawCircle( traceEnt.GetOrigin(), traceEnt.GetAngles(), 12, 0, 202, 255, true, FRAME_INTERVAL, 3 )

	//	DebugDrawLine( animEnt.GetOrigin(), startEnt.GetOrigin(), 0, 0, 255, true, FRAME_INTERVAL )
	//	DebugDrawLine( animEnt.GetOrigin(), link.GetOrigin(), 0, 202, 255, true, FRAME_INTERVAL )
	//	DebugDrawCircle( animEnt.GetOrigin(), animEnt.GetAngles(), 8, 0,0,255, true, FRAME_INTERVAL, 4)
		DebugDrawCircle( link.GetOrigin(), link.GetAngles(), 8, 0, 0, 255, true, FRAME_INTERVAL, 5)
		DebugDrawCircle( mover.GetOrigin(), mover.GetAngles(), 8, 255,0,0, true, FRAME_INTERVAL, 3)

		WaitFrame()
	}
}
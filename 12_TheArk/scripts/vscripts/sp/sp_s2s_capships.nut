global function SpawnGibraltar
global function SpawnBarkerShip
global function SpawnMalta
global function SpawnOLA
global function SpawnTrinity
global function SpawnGruntFromLiftBottomLocked
global function SpawnGruntFromHatch
global function GruntRidesUpLift
global function GruntRidesDownLift
global function SpawnSpectreFromLiftBottomLocked
global function SpawnSpectreFromHatch
global function SpawnGruntSpectreComboFromHatch
global function LiftSetup
global function LiftUnLock
global function LiftOpenTop
global function LiftCloseTop
global function LiftOpenBottom
global function LiftCloseBottom
global function LiftSendUp
global function LiftSendDown
global function WaittillLiftNotBusy
global function GruntUsesSpectreAsShield
global function SpawnOnShip
global function SpawnOnShipFromScriptName
global function InitScript
global function EnableScript
global function CleanupScript
global function DisableScript
global function ShipGeoHide
global function ShipGeoShow
global function Ship_WorldToSkybox
global function Ship_SkyboxToWorld
global function Ship_SkyboxToWorldInstant

global function GetBankMagnitudeCapShip
global function GetBankMagnitudeMalta

global const float CARGOTIME = 5.0
global const float SLIDEDOORTIME = 1.75
global const float CAGEDOORTIME = 1.5
global const float CAGEDOORDELAY = 1.0
global const float LIFTDOORTIME = 0.5

global function S2S_CapShipsInit

struct DistEntryTurret
{
	float distanceSqr
	HullTurret& turret
}

struct DistEntryLift
{
	float distanceSqr
	LiftStruct& lift
}

struct
{
	table<string, array<ShipStruct> > capShipTemplates
	array<string> liftExitAnims = [ "stand_2_run_180L", "stand_2_run_180R" ]
}file

void function S2S_CapShipsInit()
{
	SpWeaponMegaTurrets2s_Init()
	SpWeaponMegaTurrets2s_ion_Init()

	RegisterSignal( "StopShieldBehavior" )
	RegisterSignal( "EndedShieldBehavior" )
	RegisterSignal( "HullTurretOff" )
	RegisterSignal( "UpdateLiftState" )
	RegisterSignal( "LiftDoneMoving" )

	FlagInit( "LiftShowUsePrompt" )
	FlagInit( "LiftPressedUse" )

	AddCallback_OnPlayerRespawned( PlayerSpawned )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}

void function PlayerSpawned( entity player )
{
	AddPlayerHeldButtonEventCallback( player, IN_USE, LiftButtonUsed, 0.3 )
	AddPlayerHeldButtonEventCallback( player, IN_USE_AND_RELOAD, LiftButtonUsed, 0.3 )
}

void function EntitiesDidLoad()
{
	entity template
	ShipStruct ship

	template = GetEntByScriptName( "gibraltarTemplate" )
	template.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	ship = ShipTemplateSetup( template, null, CapShipSetup )
	file.capShipTemplates[ "gibraltar" ] <- [ ship ]

	template = GetEntByScriptName( "maltaTemplate" )
	template.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	ship = ShipTemplateSetup( template, null, CapShipSetup )
	file.capShipTemplates[ "malta" ] <- [ ship ]

	template = GetEntByScriptName( "draconisTemplate" )
	template.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	ship = ShipTemplateSetup( template, null, CapShipSetup )
	file.capShipTemplates[ "OLA" ] <- [ ship ]

	template = GetEntByScriptName( "trinityTemplate" )
	template.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	SetTeam( template, TEAM_MILITIA )
	ship = ShipTemplateSetup( template, null, CapShipSetup )
	file.capShipTemplates[ "trinity" ] <- [ ship ]

	foreach( shipArray in file.capShipTemplates )
	{
		foreach ( ship in shipArray )
		{
			ship.defaultBehaviorFunc 	= DefaultBehavior_CapShip
			ship.defaultEventFunc 		= DefaultEmptyFunc
			ship.defAccMax 				= 13 	//50
			ship.defSpeedMax 			= 120 	//200
			ship.defRollMax 			= 35
			ship.defPitchMax 			= 5
			ship.defBankTime			= 15
			ship.model.Hide()
		}
	}

	template = GetEntByScriptName( "lewTemplate" )
	template.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	ship = ShipTemplateSetup( template, null, CapShipSetup )
	file.capShipTemplates[ "LEW" ] <- [ ship ]
	ship.defaultBehaviorFunc 	= DefaultBehavior_CapShip
	ship.defaultEventFunc 		= DefaultEmptyFunc
	ship.defAccMax 				= 75	//150
	ship.defSpeedMax 			= 400	//400
	ship.defRollMax 			= 35
	ship.defPitchMax 			= 15
	ship.defBankTime			= 3
}

void function DefaultBehavior_CapShip( ShipStruct ship, int behavior )
{

}

void function DefaultEmptyFunc( ShipStruct ship, int id )
{

}

/************************************************************************************************\

███████╗███████╗████████╗██╗   ██╗██████╗
██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
███████╗█████╗     ██║   ██║   ██║██████╔╝
╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
███████║███████╗   ██║   ╚██████╔╝██║
╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝

\************************************************************************************************/
ShipStruct function SpawnGibraltar( LocalVec ornull origin = null, vector angles = CONVOYDIR )
{
	return __SpawnCapShipGeneric( origin, angles, "gibraltar" )
}

ShipStruct function SpawnMalta( LocalVec ornull origin = null, vector angles = CONVOYDIR )
{
	ShipStruct ship = __SpawnCapShipGeneric( origin, angles, "malta" )
	ship.bug_reproNum = 1

	return ship
}

ShipStruct function SpawnOLA( LocalVec ornull origin = null, vector angles = CONVOYDIR )
{
	ShipStruct ship = __SpawnCapShipGeneric( origin, angles, "OLA" )
	ship.bug_reproNum = 66
	return ship
}

ShipStruct function SpawnTrinity( LocalVec ornull origin = null, vector angles = CONVOYDIR )
{
	ShipStruct ship = __SpawnCapShipGeneric( origin, angles, "trinity" )

	EmitSoundOnEntity( ship.model, "scr_s2s_seyar_flight_lp_01" )

	InitScript( "scr_trinity_node_1b" )
	EnableScript( ship, "scr_trinity_node_1b" ) //the doors

	ship.mover.SetPusher( false )

	return ship
}

ShipStruct function __SpawnCapShipGeneric( LocalVec ornull origin, vector angles, string name )
{
	if ( origin == null )
		origin = CLVec( <0,0,0> )
	expect LocalVec( origin )

	ShipStruct ship = GetFreeTemplate( file.capShipTemplates[ name ] )
	entity mover = ship.mover
	SetOriginLocal( mover, origin )
	mover.SetAngles( angles )

	//common
	ship.FuncGetBankMagnitude 	= GetBankMagnitudeCapShip

	thread ShipCommonFuncs( ship )
	ship.model.Hide()
	return ship
}

ShipStruct function SpawnBarkerShip( LocalVec ornull origin = null, vector angles = CONVOYDIR )
{
	if ( origin == null )
		origin = CLVec( <0,0,0> )
	expect LocalVec( origin )

	ShipStruct ship = GetFreeTemplate( file.capShipTemplates[ "LEW" ] )
	entity mover = ship.mover
	SetOriginLocal( mover, origin )
	mover.SetAngles( angles )

	//common
	ship.FuncGetBankMagnitude 	= GetBankMagnitudeLEW

	thread ShipCommonFuncs( ship )
	ship.model.Hide()

	InitScript( "scr_lew_node" )
	EnableScript( ship, "scr_lew_node" )
	EmitSoundOnEntity( ship.model, "scr_s2s_baker_flight_lp_01" )

	return ship
}

float function GetBankMagnitudeCapShip( float dist )
{
	return GraphCapped( dist, 300, 1500, 0.0, 1.0 )
}

float function GetBankMagnitudeMalta( float dist )
{
	return GraphCapped( dist, 0, 500, 0.0, 1.0 )
}

float function GetBankMagnitudeLEW( float dist )
{
	return GraphCapped( dist, 100, 1000, 0.0, 1.0 )
}

void function CapShipSetup( ShipStruct ship, entity mover, entity ent )
{
	switch( ent.kv.script_noteworthy )
	{
		case "launchHangardummy":
			RecursivePropParenter( ship.model, ent )
			break

		case "hullHatch":
		case "lift":
			LiftSetup( ship, ent )
			break

		case "hullHatch_group":
		case "liftHatch_group":
		case "lift_group":
		case "cargoLift_group":
			array<entity> liftEnts = ent.GetLinkEntArray()
			foreach( entity liftEnt in liftEnts )
				LiftSetup( ship, liftEnt )
			break

		case "sideGuns":
			entity node = CreateScriptMover( ent.GetOrigin(), ent.GetAngles() )
			node.SetParent( ship.model, "", true, 0 )
			ent.SetParent( node, "REF", false, 0 )

			entity clip = ent.GetLinkEnt()
			clip.SetPusher( true )
			clip.SetParent( ent, "muzzle_flash", true, 0 )
			break

		case "bullets":
			entity node = CreateScriptMover( ent.GetOrigin(), ent.GetAngles() )
			node.SetParent( ship.model, "", true, 0 )
			ent.SetParent( node, "REF", false, 0 )
			break

		default:
			Assert( 0, "linked template ent missing valid script_noteworthy" )
			break
	}
}


/************************************************************************************************\

███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗██╗███╗   ██╗ ██████╗
██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║██║████╗  ██║██╔════╝
███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗
╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║██║██║╚██╗██║██║   ██║
███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║██║██║ ╚████║╚██████╔╝
╚══════╝╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝

\************************************************************************************************/
entity function SpawnGruntFromHatch( LiftStruct liftData, entity spawner, void functionref( entity ) ornull spawnFunc = null )
{
	Assert( IsValid( liftData.hatch ) )
	entity guy = spawner.SpawnEntity()
	DispatchSpawn( guy )
	thread GruntRidesUpLift( liftData, guy, spawnFunc )

	return guy
}

void function GruntRidesUpLift( LiftStruct liftData, entity guy, void functionref( entity ) ornull spawnFunc = null )
{
	guy.EndSignal( "OnDeath" )

	guy.SetParent( liftData.lift )
	thread PlayAnimTeleport( guy, "CQB_Idle_MP", liftData.lift, "" )
	thread LiftSendUp( liftData )

	wait LIFTDOORTIME
	wait liftData.travelTime

	waitthread PlayAnim( guy, "Jump_land_MP", liftData.lift, "" )
	guy.ClearParent()

	if ( spawnFunc != null )
	{
		expect void functionref( entity )( spawnFunc )
		thread spawnFunc( guy )
	}
}

entity function SpawnSpectreFromHatch( LiftStruct liftData, entity spawner, void functionref( entity ) ornull spawnFunc = null )
{
	if ( !( liftData.liftState == eLiftState.TOP || liftData.liftState == eLiftState.MOVING ) )
		LiftSendUp( liftData )

	wait 0.25

	entity spectre 	= spawner.SpawnEntity()
	DispatchSpawn( spectre )
	vector angles 	= liftData.hatch.GetAngles() + <0,180,0 >
	vector forward 	= AnglesToForward( angles )
	vector origin 	= liftData.hatch.GetOrigin() + ( forward * -80 )

	thread PlayAnimTeleport( spectre, "sp_traverse_up_512", origin, angles )

	if ( spawnFunc != null )
	{
		expect void functionref( entity )( spawnFunc )
		thread spawnFunc( spectre )
	}

	return spectre
}

void function SpawnGruntSpectreComboFromHatch( LiftStruct liftData, entity gruntSpawner, entity spectreSpawner, entity player, void functionref( entity ) ornull spawnFuncGrunt = null, void functionref( entity ) ornull spawnFuncSpectre = null )
{
	entity grunt 	= SpawnGruntFromHatch( liftData, gruntSpawner, spawnFuncGrunt )
	entity spectre 	= SpawnSpectreFromHatch( liftData, spectreSpawner, spawnFuncSpectre )

	grunt.EndSignal( "OnDeath" )
	spectre.EndSignal( "OnDeath" )
	grunt.EndSignal( "StopShieldBehavior" )
	spectre.EndSignal( "StopShieldBehavior" )

	wait liftData.travelTime + FRAME_INTERVAL

	WaittillAnimDone( grunt )

	thread PlayAnim( grunt, "React_signal_group", liftData.hatch )
	wait 0.75
	waitthread PlayAnim( grunt, "crouch_2_run_F", liftData.hatch )

	GruntUsesSpectreAsShield( grunt, spectre, player )
}


void function GruntRidesDownLift( LiftStruct liftData, entity guy, void functionref( entity ) ornull spawnFunc = null )
{
	guy.EndSignal( "OnDeath" )

	guy.SetParent( liftData.lift )
	thread PlayAnimTeleport( guy, "CQB_Idle_MP", liftData.lift, "" )
	thread LiftSendDown( liftData )

	wait liftData.travelTime

	waitthread PlayAnim( guy, file.liftExitAnims.getrandom(), liftData.lift, "" )
	guy.ClearParent()

	if ( spawnFunc != null )
	{
		expect void functionref( entity )( spawnFunc )
		thread spawnFunc( guy )
	}
}

entity function SpawnGruntFromLiftBottomLocked( LiftStruct liftData, entity spawner, void functionref( entity ) ornull spawnFunc = null )
{
	entity guy = spawner.SpawnEntity()
	DispatchSpawn( guy )
	thread __SpawnGruntFromLiftBottomLockedThread( liftData, guy, spawnFunc )

	return guy
}

void function __SpawnGruntFromLiftBottomLockedThread( LiftStruct liftData, entity guy, void functionref( entity ) ornull spawnFunc = null )
{
	guy.EndSignal( "OnDeath" )

	guy.SetParent( liftData.lift )
	thread LiftUnLock( liftData )


	waitthread PlayAnimTeleport( guy, file.liftExitAnims.getrandom(), liftData.lift, "" )
	guy.ClearParent()

	if ( spawnFunc != null )
	{
		expect void functionref( entity )( spawnFunc )
		thread spawnFunc( guy )
	}
}

entity function SpawnSpectreFromLiftBottomLocked( LiftStruct liftData, entity spawner, void functionref( entity ) ornull spawnFunc = null )
{
	entity guy = spawner.SpawnEntity()
	DispatchSpawn( guy )
	thread __SpawnSpectreFromLiftBottomLockedThread( liftData, guy, spawnFunc )

	return guy
}

void function __SpawnSpectreFromLiftBottomLockedThread( LiftStruct liftData, entity guy, void functionref( entity ) ornull spawnFunc = null )
{
	guy.EndSignal( "OnDeath" )

	entity node = CreateScriptMover( liftData.lift.GetOrigin(), AnglesCompose( liftData.lift.GetAngles(), <0,180,0> ) )
	node.SetParent( liftData.lift, "", true )
	guy.SetParent( node )

	OnThreadEnd(
	function() : ( node )
		{
			if ( IsValid( node ) )
				node.Destroy()
		}
	)

	thread LiftUnLock( liftData )

	waitthread PlayAnimTeleport( guy, "st_shieldwalk", node, "" )
	guy.ClearParent()

	if ( spawnFunc != null )
	{
		expect void functionref( entity )( spawnFunc )
		thread spawnFunc( guy )
	}
}

/************************************************************************************************\

███████╗██╗  ██╗██╗███████╗██╗     ██████╗     ███████╗████████╗ █████╗ ██╗     ██╗  ██╗███████╗██████╗
██╔════╝██║  ██║██║██╔════╝██║     ██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗██║     ██║ ██╔╝██╔════╝██╔══██╗
███████╗███████║██║█████╗  ██║     ██║  ██║    ███████╗   ██║   ███████║██║     █████╔╝ █████╗  ██████╔╝
╚════██║██╔══██║██║██╔══╝  ██║     ██║  ██║    ╚════██║   ██║   ██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
███████║██║  ██║██║███████╗███████╗██████╔╝    ███████║   ██║   ██║  ██║███████╗██║  ██╗███████╗██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚═════╝     ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

\************************************************************************************************/
void function GruntUsesSpectreAsShield( entity grunt, entity spectre, entity player )
{
	grunt.EndSignal( "OnDeath" )
	spectre.EndSignal( "OnDeath" )
	grunt.EndSignal( "StopShieldBehavior" )
	spectre.EndSignal( "StopShieldBehavior" )

	entity mover

	OnThreadEnd(
	function() : ( grunt, spectre, mover )
		{
			if ( IsAlive( grunt ) )
			{
				grunt.ClearParent()
				grunt.Anim_Stop()
				grunt.Signal( "EndedShieldBehavior" )
			}
			if ( IsAlive( spectre ) )
			{
				spectre.ClearParent()
				spectre.Anim_Stop()
				spectre.Signal( "EndedShieldBehavior" )
			}
			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	thread EndingSpectreShieldThread( grunt, spectre, player )

	while( 1 )
	{
		mover = CreateScriptMover( spectre.GetOrigin(), spectre.GetAngles() )
		mover.SetOrigin( spectre.GetOrigin() )
		grunt.SetParent( mover )
		spectre.SetParent( mover )

		thread TurnMoverTowardsPlayer( mover, grunt, spectre, player )
		thread PlayAnim( grunt, "pt_shieldwalk_test", mover )
		spectre.Anim_Play( "sp_shieldwalk_test" )
		grunt.Anim_EnablePlanting()
		spectre.Anim_EnablePlanting()

		WaittillAnimDone( spectre )

		grunt.ClearParent()
		spectre.ClearParent()
		mover.Destroy()
	}
}

const float SPECTRESHIELDTOOCLOSE = 160
void function EndingSpectreShieldThread( entity grunt, entity spectre, entity player )
{
	grunt.EndSignal( "OnDeath" )
	spectre.EndSignal( "OnDeath" )
	grunt.EndSignal( "StopShieldBehavior" )
	spectre.EndSignal( "StopShieldBehavior" )

	OnThreadEnd(
	function() : ( grunt, spectre )
		{
			if ( IsAlive( grunt ) )
				grunt.Signal( "StopShieldBehavior" )
			if ( IsAlive( spectre ) )
				spectre.Signal( "StopShieldBehavior" )
		}
	)

	while( 1 )
	{
		//damaged spectre
		if ( IsCrawling( spectre ) )
			return

		//too close
		float dist1 = Distance( player.GetOrigin(), spectre.GetOrigin() )
		if ( dist1 < SPECTRESHIELDTOOCLOSE )
			return

		float dist2 = Distance( player.GetOrigin(), grunt.GetOrigin() )
		if ( dist2 < SPECTRESHIELDTOOCLOSE )
			return

		//past them
		vector dir 	= spectre.GetForwardVector()
		vector dir2 = Normalize( player.GetOrigin() - spectre.GetOrigin() )
		float dot 	= DotProduct( dir, dir2 )
		if ( dot < 0.25 )
			return

		wait FRAME_INTERVAL - 0.001
	}
}

void function TurnMoverTowardsPlayer( entity mover, entity grunt, entity spectre, entity player )
{
	grunt.EndSignal( "OnDeath" )
	spectre.EndSignal( "OnDeath" )
	grunt.EndSignal( "StopShieldBehavior" )
	spectre.EndSignal( "StopShieldBehavior" )
	mover.EndSignal( "OnDestroy" )

	while( 1 )
	{
		vector specOg = spectre.GetOrigin()
		vector origin = player.GetOrigin()
		origin = < origin.x, origin.y, mover.GetOrigin().z >

		vector dir = Normalize( origin - mover.GetOrigin() )
		vector dir2 = specOg - mover.GetOrigin()
		float dist = Length( dir2 )

		vector angles = VectorToAngles( dir )

		vector newOrigin = specOg - ( dir * dist )

		TraceResults result = TraceLine( specOg + Vector(0,0,500), specOg - Vector(0,0,1000), [ spectre, player ], TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_NPC )
		newOrigin = < newOrigin.x, newOrigin.y, result.endPos.z >

		mover.NonPhysicsRotateTo( angles, 0.5, 0, 0 )
		mover.NonPhysicsMoveTo( newOrigin, 0.5, 0, 0 )

		wait FRAME_INTERVAL - 0.001
	}
}

/************************************************************************************************\

██╗     ██╗███████╗████████╗███████╗
██║     ██║██╔════╝╚══██╔══╝██╔════╝
██║     ██║█████╗     ██║   ███████╗
██║     ██║██╔══╝     ██║   ╚════██║
███████╗██║██║        ██║   ███████║
╚══════╝╚═╝╚═╝        ╚═╝   ╚══════╝

\************************************************************************************************/
void function LiftUseTrigger( LiftStruct liftData )
{
	entity trigger = liftData.useTrigger
	trigger.EndSignal( "OnDestroy" )
	entity player

	table result
	while( 1 )
	{
		wait FRAME_INTERVAL //to handle infinite loops

		if ( !trigger.IsTouched() )
		{
			result = trigger.WaitSignal( "OnStartTouch" )
			player = expect entity( result.activator )
		}
		else
		{
			player = trigger.GetTouchingEntities()[0]
		}

		if ( liftData.liftState == eLiftState.MOVING )
			continue

		Assert( player.IsPlayer() )

		thread LiftWaitForUse( liftData )

		waitthread LiftTriggerWaitUntouch( trigger )

		FlagClear( "LiftShowUsePrompt" )
	}
}

void function WaittillLiftNotBusy( LiftStruct liftData )
{
	while( liftData.liftState == eLiftState.MOVING )
		WaitSignal( liftData, "UpdateLiftState" )
}

void function LiftTriggerWaitUntouch( entity trigger )
{
	FlagClearEnd( "LiftShowUsePrompt" )

	while ( trigger.IsTouched() )
		trigger.WaitSignal( "OnEndTouchAll" )
}

void function LiftWaitForUse( LiftStruct liftData )
{
	FlagSet( "LiftShowUsePrompt" )
	FlagClearEnd( "LiftShowUsePrompt" )

	liftData.lift.SetUsable()
	liftData.lift.AddUsableValue( USABLE_NO_FOV_REQUIREMENTS )

	OnThreadEnd(
	function() : ( liftData )
		{
			liftData.lift.UnsetUsable()
		}
	)

	FlagWait( "LiftPressedUse" )
	thread PlayerRidesLift( liftData )
}

void function PlayerRidesLift( LiftStruct liftData )
{
	OnThreadEnd(
	function() : ( liftData )
		{
			liftData.lift.UnsetUsable()
		}
	)

	FlagClear( "LiftPressedUse" )

	if ( liftData.liftState == eLiftState.TOP )
		thread LiftSendDown( liftData )
	else
	{
		Assert( liftData.liftState == eLiftState.BOTTOM )
		thread LiftSendUp( liftData )
	}

	WaitSignal( liftData.lift, "LiftDoneMoving" )
}

void function LiftButtonUsed( entity player )
{
	if ( Flag( "LiftPressedUse" ) )
		return

	if ( Flag( "LiftShowUsePrompt" ) )
		FlagSet( "LiftPressedUse" )
}

void function LiftSendUp( LiftStruct liftData )
{
	Assert( liftData.liftState != eLiftState.TOP )
	_LiftPreMoveCheck( liftData )

	LiftCloseBottom( liftData )
	thread LiftOpenHatch( liftData )

	float travelTime = liftData.travelTime
	float acc = 0
	float dec = 0
	if ( travelTime > 3 )
	{
		acc = 2.0
		dec = 1.0
	}
	liftData.lift.NonPhysicsMoveTo( liftData.upPos.GetLocalOrigin(), travelTime, acc, dec )
	EmitSoundOnEntity( liftData.lift, "s2s_elevator_loop" )
	wait travelTime
	EmitSoundOnEntity( liftData.lift, "s2s_elevator_loop_end" )
	Signal( liftData.lift, "LiftDoneMoving" )

	LiftOpenTop( liftData )

	liftData.liftState = eLiftState.TOP
	_LiftPostMoveCheck( liftData )
}

void function LiftSendDown( LiftStruct liftData )
{
	Assert( liftData.liftState != eLiftState.BOTTOM )
	_LiftPreMoveCheck( liftData )

	LiftCloseTop( liftData )
	thread LiftCloseHatch( liftData )

	float travelTime = liftData.travelTime
	float acc = 0
	float dec = 0
	if ( travelTime > 3 )
	{
		acc = 2.0
		dec = 1.0
	}
	liftData.lift.NonPhysicsMoveTo( liftData.downPos.GetLocalOrigin(), travelTime, acc, dec )
	EmitSoundOnEntity( liftData.lift, "s2s_elevator_loop" )
	wait travelTime
	EmitSoundOnEntity( liftData.lift, "s2s_elevator_loop_end" )
	Signal( liftData.lift, "LiftDoneMoving" )

	LiftOpenBottom( liftData )

	liftData.liftState = eLiftState.BOTTOM
	_LiftPostMoveCheck( liftData )
}

void function _LiftPreMoveCheck( LiftStruct liftData )
{
	Assert( liftData.liftState != eLiftState.MOVING )

	if ( IsValid( liftData.useTrigger ) )
		liftData.useTrigger.Disable()
	FlagClear( "LiftShowUsePrompt" )

	liftData.liftState = eLiftState.MOVING
	Signal( liftData, "UpdateLiftState" )
}

void function _LiftPostMoveCheck( LiftStruct liftData )
{
	Signal( liftData, "UpdateLiftState" )
	if ( IsValid( liftData.useTrigger ) )
		liftData.useTrigger.Enable()
}

void function LiftUnLock( LiftStruct liftData )
{
	Assert( liftData.liftState == eLiftState.LOCKED )

	liftData.liftState = eLiftState.MOVING
	Signal( liftData, "UpdateLiftState" )

	waitthread LiftOpenBottom( liftData )

	liftData.liftState = eLiftState.BOTTOM
	Signal( liftData, "UpdateLiftState" )
}

void function LiftCloseBottom( LiftStruct liftData )
{
	if ( IsValid( liftData.doorBotC ) )
	{
		liftData.doorBotC.SetParent( liftData.closeBotC, "", false, CAGEDOORTIME )
		EmitSoundOnEntity( liftData.doorBotC, "s2s_elevator_gate" )
		wait CAGEDOORDELAY
		liftData.doorBotS.SetParent( liftData.closeBotS, "", false, SLIDEDOORTIME )
		EmitSoundOnEntity( liftData.doorBotS, "s2s_elevator_door" )
		EmitSoundOnEntityAfterDelay( liftData.doorBotS, "s2s_elevator_door_SWT", 1.4 )
		wait SLIDEDOORTIME
	}
	else if ( IsValid( liftData.doorBotR ) )
	{
		liftData.doorBotR.SetParent( liftData.downPos, "", false, LIFTDOORTIME )
		liftData.doorBotL.SetParent( liftData.downPos, "", false, LIFTDOORTIME )
		wait LIFTDOORTIME
	}
}

void function LiftOpenBottom( LiftStruct liftData )
{
	if ( IsValid( liftData.doorBotC ) )
	{
		liftData.doorBotS.SetParent( liftData.openBotS, "", false, SLIDEDOORTIME )
		EmitSoundOnEntity( liftData.doorBotS, "s2s_elevator_door" )
		EmitSoundOnEntityAfterDelay( liftData.doorBotS, "s2s_elevator_door_SWT", 1.4 )
		wait CAGEDOORDELAY
		liftData.doorBotC.SetParent( liftData.openBotC, "", false, CAGEDOORTIME )
		EmitSoundOnEntity( liftData.doorBotC, "s2s_elevator_gate" )
		wait CAGEDOORTIME
	}
	else if ( IsValid( liftData.doorBotR ) )
	{
		liftData.doorBotR.SetParent( liftData.openBotR, "", false, LIFTDOORTIME )
		liftData.doorBotL.SetParent( liftData.openBotL, "", false, LIFTDOORTIME )
		wait LIFTDOORTIME
	}
}

void function LiftCloseTop( LiftStruct liftData )
{
	if ( IsValid( liftData.doorTopC ) )
	{
		liftData.doorTopC.SetParent( liftData.closeTopC, "", false, CAGEDOORTIME )
		EmitSoundOnEntity( liftData.doorTopC, "s2s_elevator_gate" )
		wait CAGEDOORDELAY
		liftData.doorTopS.SetParent( liftData.closeTopS, "", false, SLIDEDOORTIME )
		EmitSoundOnEntity( liftData.doorTopS, "s2s_elevator_door" )
		EmitSoundOnEntityAfterDelay( liftData.doorTopS, "s2s_elevator_door_SWT", 1.4 )
		wait SLIDEDOORTIME
	}
	else if ( IsValid( liftData.doorTopR ) )
	{
		Assert( !IsValid( liftData.hatch ) )
		liftData.doorTopR.SetParent( liftData.upPos, "", false, LIFTDOORTIME )
		liftData.doorTopL.SetParent( liftData.upPos, "", false, LIFTDOORTIME )
		wait LIFTDOORTIME
	}
}

void function LiftOpenTop( LiftStruct liftData )
{
	if ( IsValid( liftData.doorTopC ) )
	{
		liftData.doorTopS.SetParent( liftData.openTopS, "", false, SLIDEDOORTIME )
		EmitSoundOnEntity( liftData.doorTopS, "s2s_elevator_door" )
		EmitSoundOnEntityAfterDelay( liftData.doorTopS, "s2s_elevator_door_SWT", 1.4 )
		wait CAGEDOORDELAY
		liftData.doorTopC.SetParent( liftData.openTopC, "", false, CAGEDOORTIME )
		EmitSoundOnEntity( liftData.doorTopC, "s2s_elevator_gate" )
		wait CAGEDOORTIME
	}
	else if ( IsValid( liftData.doorTopR ) )
	{
		Assert( !IsValid( liftData.hatch ) )
		liftData.doorTopR.SetParent( liftData.openTopR, "", false, LIFTDOORTIME )
		liftData.doorTopL.SetParent( liftData.openTopL, "", false, LIFTDOORTIME )
		wait LIFTDOORTIME
	}
}

void function LiftCloseHatch( LiftStruct liftData )
{
	if ( IsValid( liftData.hatch ) )
		waitthread PlayAnimTeleport( liftData.hatch, "S2S_hatch_cover_close", liftData.upPos )

	if( IsValid( liftData.separator ) )
		ToggleNPCPathsForEntity( liftData.separator, true )
}

void function LiftOpenHatch( LiftStruct liftData )
{
	if ( IsValid( liftData.hatch ) )
		waitthread PlayAnimTeleport( liftData.hatch, "S2S_hatch_cover_open", liftData.upPos )

	if ( IsValid( liftData.separator ) )
		ToggleNPCPathsForEntity( liftData.separator, false )
}

void function LiftSetup( ShipStruct ship, entity startEnt )
{
	LiftStruct liftData
	array<entity> links = startEnt.GetLinkEntArray()
	Assert( startEnt.kv.script_noteworthy == "lift" )
	links.append( startEnt )

	entity model = ship.model
	string tag = "ORIGIN"
	entity topPos

	foreach( ent in links )
	{
		ent.SetParent( model, tag, true )
		ent.MarkAsNonMovingAttachment()

		switch( ent.kv.script_noteworthy )
		{
			case "hullHatch":
				liftData.hatch = ent
				break

			case "clip":
				liftData.clip = ent
				break

			case "nav_separator":
				liftData.separator = ent
				ent.NotSolid()
				break

			case "lift":
				ent.SetParent( model, tag, true )
				liftData.lift = ent

				liftData.lift.SetUsableByGroup( "pilot" )
				liftData.lift.SetUsePrompts( "#HOLD_TO_USE_LIFT" , "#PRESS_TO_USE_LIFT" )
				liftData.lift.UnsetUsable()
				liftData.lift.AddUsableValue( USABLE_NO_FOV_REQUIREMENTS )
				break

			case "useTrigger":
				liftData.useTrigger = ent
				break

			case "doorTopL":
				liftData.doorTopL = ent
				break

			case "doorTopR":
				liftData.doorTopR = ent
				break

			case "doorL":
			case "doorBotL":
				liftData.doorBotL = ent
				break

			case "doorR":
			case "doorBotR":
				liftData.doorBotR = ent
				break

			case "doorTopCage":
				liftData.doorTopC = ent
				break

			case "doorTopSlide":
				liftData.doorTopS = ent
				break

			case "doorBotCage":
				liftData.doorBotC = ent
				break

			case "doorBotSlide":
				liftData.doorBotS = ent
				break

			case "topPos":
				topPos = ent
				break

			default:
				Assert( 0, "lift template ent missing valid script_noteworthy" )
				break
		}
	}
	Assert( IsValid( liftData.lift ) )

	//downPos
	entity downRef
	if ( IsValid( liftData.doorBotR ) )
	{
		downRef = liftData.doorBotR
	}
	else
	{
		downRef = liftData.lift
	}
	Assert( IsValid( downRef ) )
	liftData.downPos = CreateScriptMover( downRef.GetOrigin(), downRef.GetAngles() )
	liftData.downPos.SetParent( model, tag, true )

	//upPos
	entity upRef
	if ( IsValid( liftData.hatch ) )
	{
		upRef = liftData.hatch
	}
	else if ( IsValid( topPos ) )
	{
		upRef = topPos
	}
	else
	{
		Assert( IsValid( liftData.doorTopL) )
		Assert( IsValid( liftData.doorTopR) )
		upRef = liftData.doorTopR
	}
	Assert( IsValid( upRef ) )
	liftData.upPos  = CreateScriptMover( upRef.GetOrigin(), upRef.GetAngles() )
	liftData.upPos.SetParent( model, tag, true )
	Assert( liftData.upPos.GetOrigin().z > liftData.downPos.GetOrigin().z )
	if ( IsValid( topPos ) )
		topPos.Destroy()

	//hatch
	if ( IsValid( liftData.hatch ) )
		liftData.hatch.SetParent( liftData.upPos )

	//useTrigger
	if ( IsValid( liftData.useTrigger ) )
	{
		liftData.useTrigger.SetParent( liftData.lift, "", true )
		thread LiftUseTrigger( liftData )
	}

	//clip brush for the hatch door
	if ( IsValid( liftData.clip ) )
	{
		Assert( IsValid( liftData.hatch ) )
		liftData.clip.SetParent( liftData.hatch, "hatch", true )
		liftData.clip.Solid()
	}

	//openBotL, openBotR
	if( IsValid( liftData.doorBotL ) )
	{
		liftData.doorBotL.SetParent( liftData.downPos )
		liftData.openBotL = CreateScriptMover( liftData.downPos.GetOrigin(), liftData.downPos.GetAngles() )
		liftData.openBotL.SetAngles( AnglesCompose( liftData.downPos.GetAngles(), <0,50,0> ) )
		liftData.openBotL.SetParent( model, tag, true )
	}
	if( IsValid( liftData.doorBotR ) )
	{
		liftData.doorBotR.SetParent( liftData.downPos )
		liftData.openBotR = CreateScriptMover( liftData.downPos.GetOrigin(), liftData.downPos.GetAngles() )
		liftData.openBotR.SetAngles( AnglesCompose( liftData.downPos.GetAngles(), <0,-50,0> ) )
		liftData.openBotR.SetParent( model, tag, true )
	}

	//openTopL, openTopR
	if( IsValid( liftData.doorTopL ) )
	{
		liftData.doorTopL.SetParent( liftData.upPos )
		liftData.openTopL = CreateScriptMover( liftData.upPos.GetOrigin(), liftData.upPos.GetAngles() )
		liftData.openTopL.SetAngles( AnglesCompose( liftData.upPos.GetAngles(), <0,50,0> ) )
		liftData.openTopL.SetParent( model, tag, true )
	}
	if( IsValid( liftData.doorTopR ) )
	{
		liftData.doorTopR.SetParent( liftData.upPos )
		liftData.openTopR = CreateScriptMover( liftData.upPos.GetOrigin(), liftData.upPos.GetAngles() )
		liftData.openTopR.SetAngles( AnglesCompose( liftData.upPos.GetAngles(), <0,-50,0> ) )
		liftData.openTopR.SetParent( model, tag, true )
	}

	//cages
	if( IsValid( liftData.doorBotC ) )
	{
		//specific to s2s
		liftData.doorBotC.ClearParent()
		liftData.doorBotC.SetOrigin( liftData.doorBotC.GetOrigin() + ( liftData.doorBotC.GetForwardVector() * -256 ) )

		liftData.openBotC = CreateScriptMover( liftData.doorBotC.GetOrigin(), liftData.doorBotC.GetAngles() )
		liftData.closeBotC = CreateScriptMover( liftData.doorBotC.GetOrigin(), liftData.doorBotC.GetAngles() )
		liftData.openBotC.SetOrigin( liftData.openBotC.GetOrigin() + ( liftData.doorBotC.GetUpVector() * 196 ) )
		liftData.openBotC.SetParent( model, tag, true )
		liftData.closeBotC.SetParent( model, tag, true )
		liftData.doorBotC.SetParent( liftData.closeBotC )
	}
	if( IsValid( liftData.doorTopC ) )
	{
		liftData.openTopC = CreateScriptMover( liftData.doorTopC.GetOrigin(), liftData.doorTopC.GetAngles() )
		liftData.closeTopC = CreateScriptMover( liftData.doorTopC.GetOrigin(), liftData.doorTopC.GetAngles() )
		liftData.openTopC.SetOrigin( liftData.openTopC.GetOrigin() + ( liftData.openTopC.GetUpVector() * 196 ) )
		liftData.openTopC.SetParent( model, tag, true )
		liftData.closeTopC.SetParent( model, tag, true )
		liftData.doorTopC.SetParent( liftData.closeTopC )
	}

	//slides
	if( IsValid( liftData.doorBotS ) )
	{
		//specific to s2s
		liftData.doorBotS.ClearParent()
		liftData.doorBotS.SetOrigin( liftData.doorBotS.GetOrigin() + ( liftData.doorBotS.GetForwardVector() * -256 ) )

		liftData.openBotS = CreateScriptMover( liftData.doorBotS.GetOrigin(), liftData.doorBotS.GetAngles() )
		liftData.closeBotS = CreateScriptMover( liftData.doorBotS.GetOrigin(), liftData.doorBotS.GetAngles() )
		liftData.openBotS.SetOrigin( liftData.openBotS.GetOrigin() + ( liftData.doorBotS.GetForwardVector() * 152 ) )
		liftData.openBotS.SetParent( model, tag, true )
		liftData.closeBotS.SetParent( model, tag, true )
		liftData.doorBotS.SetParent( liftData.closeBotS )
	}
	if( IsValid( liftData.doorTopS ) )
	{
		liftData.openTopS = CreateScriptMover( liftData.doorTopS.GetOrigin(), liftData.doorTopS.GetAngles() )
		liftData.closeTopS = CreateScriptMover( liftData.doorTopS.GetOrigin(), liftData.doorTopS.GetAngles() )
		liftData.openTopS.SetOrigin( liftData.openTopS.GetOrigin() + ( liftData.doorTopS.GetForwardVector() * 152 ) )
		liftData.openTopS.SetParent( model, tag, true )
		liftData.closeTopS.SetParent( model, tag, true )
		liftData.doorTopS.SetParent( liftData.closeTopS )
	}

	liftData.travelTime = 2.0
	liftData.lift.NonPhysicsSetMoveModeLocal( true )

	//organize it into the ship struct
	string name = startEnt.GetScriptName()
	if ( !( name in ship.lifts ) )
	{
		array<LiftStruct> newArray
		ship.lifts[ name ] <- newArray
	}

	ship.lifts[ name ].append( liftData )
	vector testOrigin = liftData.lift.GetOrigin() + model.GetRightVector() * -5000
	ship.lifts[ name ] = ArrayClosestLift( ship.lifts[ name ], testOrigin )
}


/************************************************************************************************\

██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗   ██╗
██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝╚██╗ ██╔╝
██║   ██║   ██║   ██║██║     ██║   ██║    ╚████╔╝
██║   ██║   ██║   ██║██║     ██║   ██║     ╚██╔╝
╚██████╔╝   ██║   ██║███████╗██║   ██║      ██║
 ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝

\************************************************************************************************/
array<entity> function SpawnOnShipFromScriptName( string name, ShipStruct ship )
{
	array<entity> guys
	array<entity> spawners = GetEntArrayByScriptName( name )
	foreach ( entity spawner in spawners )
		guys.append( SpawnOnShip( spawner, ship ) )

	return guys
}

entity function SpawnOnShip( entity spawner, ShipStruct ship )
{
	entity npc = SpawnFromSpawner( spawner )

	vector delta = npc.GetOrigin() - ship.templateOrigin
	entity mover = ship.mover

	vector right 	= mover.GetRightVector() 	* delta.x
	vector forward 	= mover.GetForwardVector() 	* delta.y
	vector up 		= mover.GetUpVector() 		* ( delta.z + 0.25 ) //quarter inch up to garauntee not in solid ( floating point error )

	npc.SetOrigin( mover.GetOrigin() + right + forward + up )

	return npc
}

vector function InitScript( string name, entity ent = null, string tag = "" )
{
	array<entity> nodes = GetEntArrayByScriptName( name )
	Assert( nodes.len() )
	entity anchor 	= GetEntByScriptName( "GEO_CHUNK_HIDE_POS" )

	vector offset = <0,0,0>

	foreach ( node  in nodes )
	{
		if ( IsValid( ent ) )
		{
			Assert( tag != "" )

			offset = GetRelativeDelta( node.GetOrigin(), ent, tag )
		}

		array<entity> scriptEnts = node.GetLinkEntArray()
		Assert( scriptEnts.len() )

		foreach( ent in scriptEnts )
		{
			if ( IsValid( ent ) )
			{
				ent.SetParent( node, "", true )
				ent.Hide()
			}
		}

		node.SetOrigin( anchor.GetOrigin() )
		node.SetAngles( anchor.GetAngles() )
	}

	return offset
}

void function EnableScript( ShipStruct ship, string name, string tag = "", vector offset = <0,0,0> )
{
	array<entity> nodes = GetEntArrayByScriptName( name )
	entity mover = ship.model
	vector origin, angles

	if ( tag != "" )
	{
		int attachID 	= mover.LookupAttachment( tag )
		angles 			= mover.GetAttachmentAngles( attachID )
		vector pos 		= mover.GetAttachmentOrigin( attachID )
		vector right 	= AnglesToRight( angles )
		vector forward 	= AnglesToForward( angles )
		vector up 		= AnglesToUp( angles )

		origin = pos + ( right * offset.x ) + ( forward * offset.y ) + ( up * offset.z )
	}

	foreach ( node  in nodes )
	{
		if ( node.GetParent() == mover )
			continue

		array<entity> scriptEnts = node.GetLinkEntArray()

/*		#if DEV
			Assert( scriptEnts.len() )
			Assert( scriptEnts[0].GetParent() == node )
		#endif*/

		foreach( ent in scriptEnts )
		{
			if ( IsValid( ent ) )
				ent.Show()
		}

		if ( tag != "" )
		{
			node.SetOrigin( origin )
			node.SetAngles( angles )
			node.SetParent( mover, tag, true, 0 )
		}
		else
			node.SetParent( mover, "", false )

		node.Show()
	}
}

void function DisableScript( string name )
{
	array<entity> nodes = GetEntArrayByScriptName( name )
	Assert( nodes.len() )
	entity anchor 	= GetEntByScriptName( "GEO_CHUNK_HIDE_POS" )

	foreach ( node  in nodes )
	{
		node.ClearParent()
		node.SetOrigin( anchor.GetOrigin() )
	}
}

void function CleanupScript( string name )
{
	array<entity> nodes = GetEntArrayByScriptName( name )
	foreach ( node  in nodes )
	{
		node.Destroy() //it will take it's children with it
	}
}

array<HullTurret> function ArrayClosestTurret( array<HullTurret> entArray, vector origin )
{
	array<DistEntryTurret> allResults = ArrayDistanceResultsTurret( entArray, origin )

	allResults.sort( DistanceCompareClosestTurret )

	array<HullTurret> returnEntities

	foreach ( result in allResults )
		returnEntities.append( result.turret )

	return returnEntities
}

array<DistEntryTurret> function ArrayDistanceResultsTurret( array<HullTurret> entArray, vector origin )
{
	array<DistEntryTurret> allResults

	foreach ( turret in entArray )
	{
		DistEntryTurret entry

		entry.distanceSqr = DistanceSqr( turret.turret.GetOrigin(), origin )
		entry.turret = turret

		allResults.append( entry )
	}

	return allResults
}

int function DistanceCompareClosestTurret( DistEntryTurret a, DistEntryTurret b )
{
	if ( a.distanceSqr > b.distanceSqr )
		return 1
	else if ( a.distanceSqr < b.distanceSqr )
		return -1

	return 0;
}

array<LiftStruct> function ArrayClosestLift( array<LiftStruct> entArray, vector origin )
{
	array<DistEntryLift> allResults = ArrayDistanceResultsLift( entArray, origin )

	allResults.sort( DistanceCompareClosestLift )

	array<LiftStruct> returnEntities

	foreach ( result in allResults )
		returnEntities.append( result.lift )

	return returnEntities
}

array<DistEntryLift> function ArrayDistanceResultsLift( array<LiftStruct> entArray, vector origin )
{
	array<DistEntryLift> allResults

	foreach ( lift in entArray )
	{
		DistEntryLift entry

		entry.distanceSqr = DistanceSqr( lift.lift.GetOrigin(), origin )
		entry.lift = lift

		allResults.append( entry )
	}

	return allResults
}

int function DistanceCompareClosestLift( DistEntryLift a, DistEntryLift b )
{
	if ( a.distanceSqr > b.distanceSqr )
		return 1
	else if ( a.distanceSqr < b.distanceSqr )
		return -1

	return 0;
}

void function ShipGeoHide( ShipStruct ship, string chunkName )
{
	entity chunk = GetEntByScriptName( chunkName )

	Assert( chunk.GetParent() == ship.model )

	entity anchor 	= CreateScriptMover( ship.model.GetOrigin(), ship.model.GetAngles() )
	entity node 	= GetEntByScriptName( "GEO_CHUNK_HIDE_POS" )

	chunk.SetParent( anchor, "", true, 0 )
	chunk.DontIncludeParentBbox()
	chunk.MarkAsNonMovingAttachment()

	anchor.SetOrigin( node.GetOrigin() )
	anchor.SetAngles( node.GetAngles() )
	chunk.Hide()
	chunk.NotSolid()
}

void function ShipGeoShow( ShipStruct ship, string chunkName )
{
	entity chunk = GetEntByScriptName( chunkName )

	Assert( chunk.GetParent() != ship.model )

	entity anchor = chunk.GetParent()
	entity model = ship.model

	anchor.SetOrigin( model.GetOrigin() )
	anchor.SetAngles( model.GetAngles() )

	chunk.SetParent( model, "", true, 0 )
	chunk.DontIncludeParentBbox()
	chunk.MarkAsNonMovingAttachment()

	chunk.Show()
	chunk.Solid()

	anchor.Destroy()
}

void function Ship_WorldToSkybox( ShipStruct ship, entity skyboxModel )
{
	Assert( !IsValid( ship.skyboxModel ) )
	ship.skyboxModel = skyboxModel

	ship.model.Hide()

	skyboxModel.SetParent( ship.mover, "REF", false, 0 )
	skyboxModel.DisableHibernation()

	entity skycam = GetEnt( "skybox_cam_level" )
	ship.mover.l.skyboxOffset = skycam.GetOrigin()
	ship.mover.l.skyboxScale = 0.001
}

void function Ship_SkyboxToWorldInstant( ShipStruct ship )
{
	Assert( IsValid( ship.skyboxModel ) )

	vector origin = ship.skyboxModel.GetOrigin()
	vector delta = ( origin - ship.mover.l.skyboxOffset ) * 1000
	ship.mover.NonPhysicsStop()
	ship.mover.SetOrigin( delta )

	Ship_SkyboxToWorld( ship )
}

void function Ship_SkyboxToWorld( ShipStruct ship )
{
	Assert( IsValid( ship.skyboxModel ) )
	ship.skyboxModel.Destroy()

	ship.model.Show()

	ship.mover.l.skyboxOffset = <0,0,0>
	ship.mover.l.skyboxScale = 1.0
}
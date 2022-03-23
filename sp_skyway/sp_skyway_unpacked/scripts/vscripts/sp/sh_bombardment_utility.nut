//Ship Bombardment Wrapper Functions
global function Init_Bombardment
global function BombardTargetOnFlag_ShipCannon
global function BombardTarget_ShipCannon
global function BombardTargetOnFlag_Mortar
global function BombardTarget_Mortar
global function BombardTargetOnFlag_ClusterMortar
global function BombardTarget_ClusterMortar

global function CreateRockBurst

//BOMBARDMENT VARS
const float FRAME_INTERVAL = .1

//Ship Cannon FX
const asset FX_BOMBARDMENT_BEAM 		= $"P_rail_fire_beam_1"
const asset FX_BOMBARDMENT_BEAM_TRAIL	= $"rail_fire_linger_energy_1"
const asset FX_BOMBARDMENT_BEAM_IMPACT 	= $"exp_blowout_fire_1"
const asset FX_BOMBARDMENT_EXPLOSION 	= $"P_sw_rock_impact_XL"
const asset FX_BOMBARDMENT_SHOCKWAVE 	= $"dpod_impact_CH_thick"
const asset FX_BOMBARDMENT_SMOKE		= $"env_smoke_plume_XLG_dark"
const asset FX_BOMBARDMENT_FIRE 		= $"fire_LG_lick_1"
const asset FX_BOMBARDMENT_FIRE_GLOW	= $"fire_LG_glow_loop"

//Mortar FX
const asset FX_BOMBARDMENT_EXPLOSION_SMALL = $"P_sw_impact_exp_flak"
const asset FX_BOMBARDMENT_SHOCKWAVE_SMALL = $"xo_impact_exp_XLG_ring"
const asset FX_BOMBARDMENT_MORTAR_TRAIL	   = $"P_Ship_Rocket_Smoke"

const asset PHYS_ROCK_TRAIL				= $"Rocket_Smoke_Trail_Large"
// const asset PHYS_ROCK_GLOW				= $"Rocket_Smoke_Trail_Large"

const asset MFLASH = $"P_muzzleflash_MaltaGun_Low_NoTracer"

const SFX_BOMBARDMENT_EXPLOSION			 = "skyway_scripted_titanhill_mortar_explode"

const asset MORTAR_ROUND  = $"models/Weapons/bullets/projectile_rocket_launcher_sram.mdl"

const asset SMALL_ROCK_01 = $"models/rocks/rock_jagged_granite_small_01_phys.mdl"
const asset SMALL_ROCK_02 = $"models/rocks/rock_jagged_granite_small_02_phys.mdl"
const asset SMALL_ROCK_03 = $"models/rocks/rock_jagged_granite_small_03_phys.mdl"
const asset SMALL_ROCK_04 = $"models/rocks/rock_jagged_granite_small_04_phys.mdl"
const asset SMALL_ROCK_05 = $"models/rocks/rock_jagged_granite_small_05_phys.mdl"
const asset SMALL_ROCK_06 = $"models/rocks/rock_jagged_granite_small_06_phys.mdl"
const asset SMALL_ROCK_07 = $"models/rocks/rock_jagged_granite_small_07_phys.mdl"

/*
   _____ _     _           ____                  _                   _                      _      _                 _
  / ____| |   (_)         |  _ \                | |                 | |                    | |    | |               (_)
 | (___ | |__  _ _ __     | |_) | ___  _ __ ___ | |__   __ _ _ __ __| |_ __ ___   ___ _ __ | |_   | |     ___   __ _ _  ___
  \___ \| '_ \| | '_ \    |  _ < / _ \| '_ ` _ \| '_ \ / _` | '__/ _` | '_ ` _ \ / _ \ '_ \| __|  | |    / _ \ / _` | |/ __|
  ____) | | | | | |_) |   | |_) | (_) | | | | | | |_) | (_| | | | (_| | | | | | |  __/ | | | |_   | |___| (_) | (_| | | (__
 |_____/|_| |_|_| .__/    |____/ \___/|_| |_| |_|_.__/ \__,_|_|  \__,_|_| |_| |_|\___|_| |_|\__|  |______\___/ \__, |_|\___|
                | |                                                                                             __/ |
                |_|                                                                                            |___/
*/

//WRAPPER FUNCTIONS
void function BombardTargetOnFlag_ShipCannon( entity gun, entity target, string flag, float delay = 0 )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	FlagInit( flag )
	FlagWait( flag )

	if( delay > 0 )
		wait( delay )

	thread BombardEntity_ShipCannon( gun, target )
}

void function BombardTarget_ShipCannon( entity gun, entity target, float delay = 0)
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	if( delay > 0 )
		wait( delay )

	thread BombardEntity_ShipCannon( gun, target )
}

// scripted targets
void function BombardTargetOnFlag_Mortar( entity gun, entity target, string flag, float delay = 0 )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	FlagInit( flag )
	FlagWait( flag )

	if( delay > 0 )
		wait( delay )

	thread BombardEntity_Mortar( gun, target, false )
}

void function BombardTarget_Mortar( entity gun, entity target, float delay = 0 )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	if( delay > 0 )
		wait( delay )

	thread BombardEntity_Mortar( gun, target )
}

void function BombardTargetOnFlag_ClusterMortar( entity gun, entity target, string flag, float delay = 0 )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	FlagInit( flag )
	FlagWait( flag )

	if( delay > 0 )
		wait( delay )

	thread BombardEntity_ClusterMortar( gun, target )
}

void function BombardTarget_ClusterMortar( entity gun, entity target, float delay = 0 )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	if( delay > 0 )
		wait( delay )

	thread BombardEntity_ClusterMortar( gun, target )
}

//BOMBARDMENT FUNCTIONS
void function Init_Bombardment()
{
	PrecacheParticleSystem( FX_BOMBARDMENT_BEAM )
	PrecacheParticleSystem( FX_BOMBARDMENT_BEAM_TRAIL )
	PrecacheParticleSystem( FX_BOMBARDMENT_BEAM_IMPACT )
	PrecacheParticleSystem( FX_BOMBARDMENT_EXPLOSION )
	PrecacheParticleSystem( FX_BOMBARDMENT_SHOCKWAVE )
	PrecacheParticleSystem( FX_BOMBARDMENT_SMOKE )
	PrecacheParticleSystem( FX_BOMBARDMENT_FIRE )
	PrecacheParticleSystem( FX_BOMBARDMENT_FIRE_GLOW )

	PrecacheParticleSystem( FX_BOMBARDMENT_EXPLOSION_SMALL )
	PrecacheParticleSystem( FX_BOMBARDMENT_SHOCKWAVE_SMALL )
	PrecacheParticleSystem( FX_BOMBARDMENT_MORTAR_TRAIL )

	PrecacheParticleSystem( PHYS_ROCK_TRAIL )
	// PrecacheParticleSystem( PHYS_ROCK_GLOW )

	PrecacheParticleSystem( MFLASH )

	PrecacheModel( MORTAR_ROUND )
	PrecacheModel( SMALL_ROCK_01 )
	PrecacheModel( SMALL_ROCK_02 )
	PrecacheModel( SMALL_ROCK_03 )
	PrecacheModel( SMALL_ROCK_04 )
	PrecacheModel( SMALL_ROCK_05 )
	PrecacheModel( SMALL_ROCK_06 )
	PrecacheModel( SMALL_ROCK_07 )

	PrecacheImpactEffectTable( "exp_artillery_lg" )
}

void function BombardEntity_ShipCannon( entity gun, entity target )
{
	Assert( IsNewThread(), "Must be threaded off." )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	vector targetOrigin = target.GetOrigin()
	vector gunOrigin = gun.GetOrigin()
	vector dir = Normalize( gunOrigin - targetOrigin )

	entity beamFX = PlayFX( FX_BOMBARDMENT_BEAM, gunOrigin )
	beamFX.FXEnableRenderAlways()
	beamFX.SetForwardVector( dir )
	beamFX.SetForwardVector( beamFX.GetUpVector() )

	entity energyFX = PlayFX( FX_BOMBARDMENT_BEAM_TRAIL, gunOrigin )
	energyFX.SetForwardVector( beamFX.GetForwardVector() )

	wait ( .5 )

	Explosion(
		targetOrigin,
		gun,								// attacker
		gun,								// inflictor
		5000, 						// normal damage
		45000, 						// heavy armor damage
		512, 			// inner radius
		512,  			// outer radius
		SF_ENVEXPLOSION_NO_DAMAGEOWNER,
		gunOrigin,
		85000,						// force
		damageTypes.explosive,
		eDamageSourceId.burn,
		"" )

	// Push players
	// Push radially - not as a sphere
	// Test LOS before pushing
	int flags = 0
	vector impactOrigin = targetOrigin //+ Vector( 0,0,10 )
	float impactRadius = 512
	CreatePhysExplosion( impactOrigin, impactRadius, PHYS_EXPLOSION_LARGE, flags )

	entity beamImpactFX = PlayFX( FX_BOMBARDMENT_BEAM_IMPACT, targetOrigin )
	beamImpactFX.SetForwardVector( dir )
	PlayFX( FX_BOMBARDMENT_EXPLOSION, targetOrigin )
	PlayFX( FX_BOMBARDMENT_SHOCKWAVE, targetOrigin )
	// PlayLoopFX( FX_BOMBARDMENT_FIRE, targetOrigin )
	// PlayLoopFX( FX_BOMBARDMENT_FIRE_GLOW, targetOrigin )
	// PlayLoopFX( FX_BOMBARDMENT_SMOKE, targetOrigin )
	EmitSoundAtPosition( TEAM_UNASSIGNED, targetOrigin, SFX_BOMBARDMENT_EXPLOSION )

	//Create Rock Burst From Shell Impact
	CreateRockBurst( targetOrigin, 10, 0, dir, 45, 4000, "", 10 )
	entity shake = CreateShake( targetOrigin, 5, 150, 1, 12000 )
	shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
	shake.Destroy()
}

void function BombardEntity_Mortar( entity gun, entity target, bool previsFX = true )
{

	Assert( IsNewThread(), "Must be threaded off." )
	EndSignal( gun, "OnDestroy" )
	// EndSignal( target, "OnDestroy" )

	float duration = 2.5
	array<vector> targetOrigins = NavMesh_RandomPositions_LargeArea( target.GetOrigin(), HULL_TITAN, 1, 0, 300 )
	vector targetOrigin = targetOrigins.len() > 0 ? targetOrigins[0] : target.GetOrigin()
	vector gunOrigin = gun.GetOrigin()
	vector dir = Normalize( gunOrigin - targetOrigin )

	StartParticleEffectInWorld( GetParticleSystemIndex( MFLASH ), gun.GetOrigin(), <0,0,0> )

	entity mortarRound = CreateExpensiveScriptMover( gunOrigin, < 0, 0, 0 >, 0 )
	mortarRound.SetModel( MORTAR_ROUND )
	mortarRound.Show()
	mortarRound.DisableHibernation()
	entity fx
	fx = PlayFXOnEntity( FX_BOMBARDMENT_MORTAR_TRAIL, mortarRound )
	fx.FXEnableRenderAlways()
	mortarRound.SetForwardVector( -dir )

	int index = GetParticleSystemIndex( $"P_ar_titan_droppoint" )
	entity targetEffect
	if ( previsFX )
	{
		targetEffect = StartParticleEffectInWorld_ReturnEntity( index, targetOrigin, <0,0,1> )
		EffectSetControlPointVector( targetEffect, 1, <BURN_R, BURN_G, BURN_B> )

		foreach ( player in GetPlayerArray() )
		{
			EmitSoundOnEntity( targetEffect, "skyway_scripted_bombardment_ping" )
		}
	}

	EmitSoundAtPosition( TEAM_ANY, targetOrigin, "Weapon_FlightCore_Incoming_Projectile" )

	OnThreadEnd(
	function() : ( mortarRound, targetEffect )
		{
			if ( IsValid( mortarRound ) )
			{
				mortarRound.Destroy()
			}
			if ( IsValid( targetEffect ) )
				EffectStop( targetEffect )
		}
	)

	float endTime = Time() + duration

	while ( 1 )
	{
		float timeRemaining = endTime - Time()
		vector mortarRoundOrigin = mortarRound.GetOrigin()
		// vector endPos = target.GetOrigin() + ( target.GetVelocity() * max( 0, timeRemaining - FRAME_INTERVAL ) )
		vector velocity = GetPlayerVelocityForDestOverTime( mortarRoundOrigin, targetOrigin, timeRemaining )

		if ( timeRemaining <= 0 )
			break

		mortarRound.SetForwardVector( targetOrigin - mortarRoundOrigin )

		vector endPos = mortarRoundOrigin + ( velocity * .1 )
		if ( Length( velocity * .1 ) > Length( targetOrigin - mortarRoundOrigin ) )
			endPos = mortarRoundOrigin

		mortarRound.NonPhysicsMoveTo( endPos, .1, 0, 0 )

		WaitFrame()
	}

	Explosion(
		targetOrigin,
		gun,								// attacker
		gun,								// inflictor
		5000, 						// normal damage
		5000, 						// heavy armor damage
		500, 			// inner radius
		600,  			// outer radius
		SF_ENVEXPLOSION_NO_DAMAGEOWNER,
		gunOrigin,
		45000,						// force
		damageTypes.explosive,
		eDamageSourceId.bombardment,
		"exp_artillery_lg" )

	// Push players
	// Push radially - not as a sphere
	// Test LOS before pushing
	int flags = 0
	vector impactOrigin = targetOrigin //+ Vector( 0,0,10 )
	float impactRadius = 128
	CreatePhysExplosion( impactOrigin, impactRadius, PHYS_EXPLOSION_LARGE, flags )

	// PlayFX( FX_BOMBARDMENT_EXPLOSION_SMALL, targetOrigin )
	// PlayFX( FX_BOMBARDMENT_SHOCKWAVE_SMALL, targetOrigin )
	// PlayFX( FX_BOMBARDMENT_SMOKE, targetOrigin )
	EmitSoundAtPosition( TEAM_UNASSIGNED, targetOrigin, SFX_BOMBARDMENT_EXPLOSION )

	//CreateRockBurst( targetOrigin, 10, 0, dir, 45, 4000, "", 10 )
	entity shake = CreateShake( targetOrigin, 5, 150, 1, 12000 )
	shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
	shake.Destroy()

	WaitFrame()
}

void function BombardEntity_ClusterMortar( entity gun, entity target )
{
	Assert( IsNewThread(), "Must be threaded off." )
	EndSignal( gun, "OnDestroy" )
	EndSignal( target, "OnDestroy" )

	float duration = .5
	vector targetOrigin = target.GetOrigin()
	vector gunOrigin = gun.GetOrigin()
	vector dir = Normalize( gunOrigin - targetOrigin )

	entity mortarRound = CreateExpensiveScriptMover( gunOrigin, < 0, 0, 0 >, 0 )
	mortarRound.SetModel( MORTAR_ROUND )
	mortarRound.Show()
	PlayFXOnEntity( FX_BOMBARDMENT_MORTAR_TRAIL, mortarRound )
	mortarRound.SetForwardVector( -dir )

	float endTime = Time() + duration

	while ( 1 )
	{

		float timeRemaining = endTime - Time()
		vector mortarRoundOrigin = mortarRound.GetOrigin()
		vector endPos = target.GetOrigin() + ( target.GetVelocity() * max( 0, timeRemaining - FRAME_INTERVAL ) )
		vector velocity = GetPlayerVelocityForDestOverTime( mortarRoundOrigin, target.GetOrigin(), timeRemaining )

		if ( timeRemaining < .2 )
			break

		mortarRound.SetForwardVector( targetOrigin - mortarRoundOrigin )
		mortarRound.NonPhysicsMoveTo( mortarRoundOrigin + ( velocity * .1 ), .1, 0, 0 )

		WaitFrame()
	}

	thread GenerateClusterMortarScatter( mortarRound, target, 3 )

	Explosion(
		mortarRound.GetOrigin(),
		gun,								// attacker
		gun,								// inflictor
		5000, 						// normal damage
		5000, 						// heavy armor damage
		128, 			// inner radius
		256,  			// outer radius
		SF_ENVEXPLOSION_NO_DAMAGEOWNER,
		gunOrigin,
		45000,						// force
		damageTypes.explosive,
		eDamageSourceId.burn,
		"" )

	// Push players
	// Push radially - not as a sphere
	// Test LOS before pushing
	int flags = 0
	vector impactOrigin = mortarRound.GetOrigin() //+ Vector( 0,0,10 )
	float impactRadius = 128
	CreatePhysExplosion( impactOrigin, impactRadius, PHYS_EXPLOSION_LARGE, flags )

	PlayFX( FX_BOMBARDMENT_EXPLOSION_SMALL, impactOrigin )
	//PlayFX( FX_BOMBARDMENT_SHOCKWAVE_SMALL, impactOrigin )
	//PlayFX( FX_BOMBARDMENT_SMOKE, targetOrigin )
	EmitSoundAtPosition( TEAM_UNASSIGNED, impactOrigin, SFX_BOMBARDMENT_EXPLOSION )

	//CreateRockBurst( targetOrigin, 10, 0, dir, 45, 4000, "", 10 )
	entity shake = CreateShake( impactOrigin, 5, 150, 1, 12000 )
	shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
	shake.Destroy()
	mortarRound.Destroy()
}

void function GenerateClusterMortarScatter( entity mortarRound, entity target, int count )
{

	int mortarsSpawned = 0
	array<entity> tempMortarTargets

	entity clusterOrigin = CreateEntity( "info_target" )
	clusterOrigin.SetOrigin( mortarRound.GetOrigin() )
	DispatchSpawn( clusterOrigin )
	tempMortarTargets.append( clusterOrigin )

	while ( mortarsSpawned < count )
	{
		vector targetOrigin = target.GetOrigin()
		entity clusterTarget = CreateEntity( "info_target" )

		float randX = RandomFloatRange( 64, 256 * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )
		float randY = RandomFloatRange( 64, 256 * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )

		clusterTarget.SetOrigin( targetOrigin + < randX, randY, 128 > )
		//float randZ = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )

		DispatchSpawn( clusterTarget )
		DropToGround( clusterTarget )

		thread BombardEntity_Mortar( clusterOrigin, clusterTarget )

		mortarsSpawned += 1
		tempMortarTargets.append( clusterTarget )
	}

	CleanupEntsAfterTime( tempMortarTargets, 5.0 )


}

//NOTE: THIS SAME FUNCTIONALITY IS IN THE RISING WORLD RUN SECTION OF SKYWAY, WE SHOULD PROBABLY PUT THIS IN A SHARED UTILITY SCRIPT
void function CreateRockBurst( vector origin, int smallCount, int largeCount, vector dir, float arc, float speed = 2000, string flag = "", float lifeTime = 5 )
{

	if ( flag != "" )
		FlagWait( flag )

	int count = 0

	array<entity> rocks

	while ( count < smallCount )
	{
		count += 1
		float speedMod = RandomFloatRange( speed / 2, speed )
		entity smallPhysRock = CreatePropPhysicsDebris( GetRandomSmallRockModel(), origin, < 0, 0, 0 > )
		smallPhysRock.MinimizeHibernation()
		rocks.append( smallPhysRock )

		vector angles = VectorToAngles( dir )

		float randX = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )
		float randY = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )
		float randZ = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )

		vector velAngles = angles - < randX, randY, randZ >
		velAngles = < ClampAngle( velAngles.x ), ClampAngle( velAngles.y ), ClampAngle( velAngles.z ) >

		vector forward = AnglesToForward( velAngles )
		vector right = AnglesToRight( velAngles )
		vector up = AnglesToUp( velAngles )

		vector physVel = < 0, 0, 0 >
		physVel += forward
		physVel.Norm()
		physVel = physVel * speedMod
		//DebugDrawLine( origin,  origin + physVel, 255, 0, 0, true, 30 )
		//DebugDrawLine( origin,  origin + ( Normalize( dir ) * speed ), 255, 255, 0, true, 30 )
		smallPhysRock.SetVelocity( physVel )

		PlayFXOnEntity( PHYS_ROCK_TRAIL, smallPhysRock )
		//PlayFXOnEntity( PHYS_ROCK_GLOW, smallPhysRock )

		//CreateShake( origin, 5, 150, 1, 12000 ).kv.spawnflags = 4 // SF_SHAKE_INAIR
	}

	count = 0

	while ( count < largeCount )
	{
		count += 1
		float speedMod = RandomFloatRange( speed / 2, speed )
		entity largePhysRock = CreatePropPhysicsDebris( GetRandomLargeRockModel(), origin, < 0, 0, 0 > )
		largePhysRock.MinimizeHibernation()
		rocks.append( largePhysRock )

		vector angles = VectorToAngles( dir )

		float randX = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )
		float randY = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )
		float randZ = RandomFloatRange( 0, arc * ( RandomInt( 2 ) == 1 ? 1 : -1 ) )

		vector velAngles = angles - < randX, randY, randZ >
		velAngles = < ClampAngle( velAngles.x ), ClampAngle( velAngles.y ), ClampAngle( velAngles.z ) >

		vector forward = AnglesToForward( velAngles )
		vector right = AnglesToRight( velAngles )
		vector up = AnglesToUp( velAngles )

		vector physVel = < 0, 0, 0 >
		physVel += forward
		physVel.Norm()
		physVel = physVel * speedMod
		//DebugDrawLine( origin,  origin + physVel, 255, 0, 0, true, 30 )
		//DebugDrawLine( origin,  origin + ( Normalize( dir ) * speed ), 255, 255, 0, true, 30 )
		largePhysRock.SetVelocity( physVel )

		PlayFXOnEntity( PHYS_ROCK_TRAIL, largePhysRock )
		//PlayFXOnEntity( PHYS_ROCK_GLOW, largePhysRock )
	}

	EmitSoundAtPosition( TEAM_ANY, origin, "Switchback_building_explosion" )

	thread CleanupEntsAfterTime( rocks, lifeTime )

}

asset function GetRandomLargeRockModel()
{

	int randInt = RandomInt( 2 )

	switch ( randInt )
	{
		case 0:
			return SMALL_ROCK_05
		break

		case 1:
			return SMALL_ROCK_06
		break

		case 2:
			return SMALL_ROCK_07
		break
	}

	unreachable
}

asset function GetRandomSmallRockModel()
{

	int randInt = RandomInt( 3 )

	switch ( randInt )
	{
		case 0:
			return SMALL_ROCK_01
		break

		case 1:
			return SMALL_ROCK_02
		break

		case 2:
			return SMALL_ROCK_03
		break

		case 3:
			return  SMALL_ROCK_04
		break
	}

	unreachable
}

void function CleanupEntsAfterTime( array<entity> ents, float delay )
{
	wait( delay )

	foreach( ent in ents )
	{
		if( IsValid( ent ) )
			ent.Destroy()
	}
}

entity function CreatePropPhysicsDebris( asset model, vector origin, vector angles )
{
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( model )
	prop_physics.kv.spawnflags = 4
	prop_physics.kv.fadedist = -1
	prop_physics.kv.physdamagescale = 0.1
	prop_physics.kv.inertiaScale = 1.0
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	SetTeam( prop_physics, TEAM_BOTH )	// need to have a team other then 0 or it won't take impact damage

	prop_physics.SetOrigin( origin )
	prop_physics.SetAngles( angles )
	DispatchSpawn( prop_physics )

	return prop_physics
}
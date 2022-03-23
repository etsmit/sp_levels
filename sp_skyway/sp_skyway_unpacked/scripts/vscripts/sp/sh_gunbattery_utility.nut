
//Gun Battery Wrapper Functions
global function Init_GunBattery
global function AimGunAtTarget
global function FireGunAtTarget
global function GunCeaseFire
global function FireGunAtArrayOfTargets
global function FireGunAtArrayOfTargets_Looping
global function PackTargets
global function StartFireSequence

global struct GunBatteryData
{
	entity base
	entity barrel
	entity barrelMover
	entity baseMover
	array<entity> thermalDrums
	array<string> thermalDrumAttachments = [ "def_l_generator1", "def_l_generator2", "def_2_generator1", "def_r_generator2" ]
}

//GUN VARS
const asset FX_CANNON_BEAM 				= $"P_rail_fire_beam_scale"
const asset FX_CANNON_PREFIRE_SKY 		= $"P_rail_charge_SB_1"
const asset FX_CANNON_BEAM_SKY 			= $"P_rail_fire_beam_scale_SB"
const asset FX_CANNON_MUZZLEFLASH_SKY 	= $"P_rail_fire_flash_SB"
const asset FX_CANNON_THERMAL_DRUM_GLOW = $"P_rail_thermal_drum_glow_1"

const asset GUN_HEATSINK_GLOW 			= $"models/levels_terrain/mp_outpost207/outpost_207_gun_heatsink_glow.mdl"

const SFX_CANNON_ROTATE_LOOP 		= "amb_outpost_cannon_servo"

const float GUN_BASE_ROT_RATE = 5 //degrees per second
const float GUN_BARREL_ROT_RATE = 5 //degrees per second
const float GUN_LERP_IN = .2
const float GUN_LERP_OUT = .2

const float GUN_POST_AIM_FIRE_DELAY_MIN = 3.0
const float GUN_POST_AIM_FIRE_DELAY_MAX = 5.0
const float GUN_FIRE_SHAKE_DELAY = .3
const float GUN_WARM_UP_TIME = 8.0
const float GUN_COOL_DOWN_TIME = 8.0
const float GUN_FIRE_DURATION = 3.0

struct
{
	bool gunInUse = false
	float lastFireTime = 0.0
} file

/*
  ___   ___ ______      _____                 ____        _   _                      _                 _
 |__ \ / _ \____  |    / ____|               |  _ \      | | | |                    | |               (_)
    ) | | | |  / /    | |  __ _   _ _ __     | |_) | __ _| |_| |_ ___ _ __ _   _    | |     ___   __ _ _  ___
   / /| | | | / /     | | |_ | | | | '_ \    |  _ < / _` | __| __/ _ \ '__| | | |   | |    / _ \ / _` | |/ __|
  / /_| |_| |/ /      | |__| | |_| | | | |   | |_) | (_| | |_| ||  __/ |  | |_| |   | |___| (_) | (_| | | (__
 |____|\___//_/        \_____|\__,_|_| |_|   |____/ \__,_|\__|\__\___|_|   \__, |   |______\___/ \__, |_|\___|
                                                                            __/ |                 __/ |
                                                                           |___/                 |___/
*/

//////////////////////////////
// GUN BATTERY SET UP FUNCTION
//////////////////////////////
GunBatteryData function Init_GunBattery( entity base, entity barrel )
{

	RegisterSignal( "StopFiring" )

	PrecacheParticleSystem( FX_CANNON_BEAM )
	PrecacheParticleSystem( FX_CANNON_PREFIRE_SKY )
	PrecacheParticleSystem( FX_CANNON_BEAM_SKY )
	PrecacheParticleSystem( FX_CANNON_MUZZLEFLASH_SKY )
	PrecacheParticleSystem( FX_CANNON_THERMAL_DRUM_GLOW )

	PrecacheModel( $"models/dev/editor_ref.mdl" )
	PrecacheModel( $"models/Weapons/railgun_outpost_207/railgun_outpost_01_barrel_skyway.mdl" )
	//PrecacheModel( GUN_HEATSINK_GLOW )

	entity barrelMover = CreateScriptMover( barrel.GetOrigin(), < 0, 0, 0 >, 0 )
	barrelMover.SetForwardVectorWithUp( barrel.GetForwardVector(), barrel.GetUpVector() )
	barrelMover.NonPhysicsSetRotateModeLocal( true )

	entity baseMover = CreateScriptMover( base.GetOrigin(), < 0, 0, 0 >, 0 )
	baseMover.SetForwardVector( base.GetForwardVector() )

	barrel.SetModel( $"models/Weapons/railgun_outpost_207/railgun_outpost_01_barrel_skyway.mdl" )
	barrel.SetParent( barrelMover, "", true )
	barrelMover.SetParent( baseMover, "", true )
	base.SetParent( baseMover, "", true )

	GunBatteryData gunBatteryData
	gunBatteryData.base = base
	gunBatteryData.barrel = barrel
	gunBatteryData.barrelMover = barrelMover
	gunBatteryData.baseMover = baseMover

	//CannonThermalDrumsSetup( gunBatteryData )

	entity collision = barrel.GetLinkEnt()
	if ( IsValid( collision ) )
	{
		string classname = collision.GetClassName()
		if ( classname == "func_brush" )
		{
			collision.SetParent( barrelMover, "", true )
		}
	}

	return gunBatteryData
}

///////////////////
//WRAPPER FUNCTIONS
///////////////////
void function FireGunAtTarget( GunBatteryData gunBatteryData, entity target )
{
	GunCeaseFire( gunBatteryData )
	ShootTarget( gunBatteryData, target )
}

void function GunCeaseFire( GunBatteryData gunBatteryData )
{
	Signal( gunBatteryData, "StopFiring" )
}

void function FireGunAtArrayOfTargets( GunBatteryData gunBatteryData, array<entity> targets )
{
	GunCeaseFire( gunBatteryData )
	EndSignal( gunBatteryData, "StopFiring" )
	Assert( IsNewThread(), "Must be threaded off." )

	foreach ( entity target in targets )
	{
		if ( !IsValid( target ) )
			continue

		waitthread ShootTarget( gunBatteryData, target )
	}
}

void function FireGunAtArrayOfTargets_Looping( GunBatteryData gunBatteryData, array<entity> targets )
{
	GunCeaseFire( gunBatteryData )
	EndSignal( gunBatteryData, "StopFiring" )
	Assert( IsNewThread(), "Must be threaded off." )

	while ( true )
	{
		foreach ( entity target in targets )
		{
			if ( !IsValid( target ) )
				continue

			waitthread ShootTarget( gunBatteryData, target )
		}
	}
}

array<entity> function PackTargets( array<string> targetNames )
{
	Assert( targetNames.len() > 0, "Target Name Array is Empty." )
	array<entity> targets
	foreach ( string name in targetNames )
	{
		entity target = GetEntByScriptName( name )
		if ( IsValid( target ) )
			targets.push( target )
	}

	Assert( targets.len() > 0, "Target Array is Empty." )

	return targets
}

/////////////////
// FIRE FUNCTIONS
/////////////////

void function ShootTarget( GunBatteryData gunBatteryData, entity target )
{
	waitthread AimGunAtTarget( gunBatteryData, target )
	waitthread StartFireSequence( gunBatteryData, target )
	wait ( GUN_COOL_DOWN_TIME )
}

void function AimGunAtTarget( GunBatteryData gunBatteryData, entity target )
{
	EndSignal( gunBatteryData, "StopFiring" )
	Assert( IsNewThread(), "Must be threaded off." )

	entity baseMover = gunBatteryData.baseMover
	entity barrelMover = gunBatteryData.barrelMover

	Assert( IsValid( baseMover ), "Base mover is invalid" )
	Assert( IsValid( barrelMover ), "Barrel mover is invalid" )

	vector targetOrigin = target.GetOrigin()
	vector baseOrigin = baseMover.GetOrigin()
	vector barrelOrigin = barrelMover.GetOrigin()

	//Rotate base to aim at target
	vector baseAimAngle = VectorToAngles( Normalize( baseOrigin - targetOrigin ) )
	baseAimAngle = FlattenAngles( baseAimAngle )
	float baseAngleDifToTarget = ShortestRotation( baseMover.GetAngles(), baseAimAngle ).y
	if ( baseAngleDifToTarget < 0 )
		baseAngleDifToTarget *= -1
	float baseRotTime = ( baseAngleDifToTarget / GUN_BASE_ROT_RATE )

	//Raise or lower barrel to aim at target
	vector barrelAimAngle = VectorToAngles( Normalize( barrelOrigin - targetOrigin ) )
	barrelAimAngle = < barrelAimAngle.x, 0, 0 >
	float barrelAngleDifToTarget = ShortestRotation( barrelMover.GetAngles(), barrelAimAngle ).x
	if ( barrelAngleDifToTarget < 0 )
		barrelAngleDifToTarget *= -1
	float barrelRotTime = ( barrelAngleDifToTarget / GUN_BARREL_ROT_RATE )

	float rotTime

	//Use the rotation that takes the longest time.
	if ( baseRotTime < barrelRotTime )
	{
		rotTime = barrelRotTime
	}
	else
	{
		rotTime = baseRotTime
	}

	baseMover.NonPhysicsRotateTo( baseAimAngle, rotTime, rotTime * GUN_LERP_IN, rotTime * GUN_LERP_OUT )
	barrelMover.NonPhysicsRotateTo( barrelAimAngle, rotTime, rotTime * GUN_LERP_IN, rotTime * GUN_LERP_OUT )

	//UNCOMMENT WHEN WE GET A ROTATIONS SOUND FOR THE GUN SERVO


	EmitSoundOnEntity( baseMover, "skyway_scripted_railgun_turn" )

	OnThreadEnd (
	   	function () : ( baseMover )
	 	{
	 		StopSoundOnEntity( baseMover, "skyway_scripted_railgun_turn" )
	 	}
	 )

	wait ( rotTime )

	//StopSoundOnEntity( baseMover, SFX_CANNON_ROTATE_LOOP )

	wait RandomFloatRange( GUN_POST_AIM_FIRE_DELAY_MIN, GUN_POST_AIM_FIRE_DELAY_MAX  )

	//wait ( GUN_POST_AIM_FIRE_DELAY )


}

void function StartFireSequence( GunBatteryData gunBatteryData, entity target )
{
	EndSignal( gunBatteryData, "StopFiring" )
	Assert( IsNewThread(), "Must be threaded off." )

	while ( file.gunInUse || Time() - file.lastFireTime < 1.0 )
		wait 0.1

	file.gunInUse = true

	OnThreadEnd(
		function () : ( gunBatteryData )
		{
			file.gunInUse = false
			file.lastFireTime = Time()
			//CannonRefPose( gunBatteryData )
			CannonFlapsClose( gunBatteryData )
		}
	)

	CannonFlapsOpen( gunBatteryData )

	//wait 2.3

	//thread CannonThermalDrumsStart( gunBatteryData )

	wait ( GUN_WARM_UP_TIME )

	CannonFire( gunBatteryData )
	delaythread( 1.05 ) FireCannon_CooldownSound( gunBatteryData )  // cooldown sound is authored to start during the firing animation

	wait (GUN_FIRE_SHAKE_DELAY )
	CannonFireShake( gunBatteryData )
	//GunFireFX( gunBatteryData )

	wait ( GUN_FIRE_DURATION )
}

///////////////////////
//GUN FIRE FX FUNCTIONS
///////////////////////
/*
void function GunFireFX( GunBatteryData gunBatteryData )
{
	thread GunFireFX_Threaded( gunBatteryData )
}

void function GunFireFX_Threaded( GunBatteryData gunBatteryData )
{

	entity barrel = gunBatteryData.barrel

	if ( !IsValid( barrel ) )
		return

	int cannonAttach = barrel.LookupAttachment( "rail_flap_01" )
	vector cannonAttachOrg = barrel.GetAttachmentOrigin( cannonAttach )
	vector cannonAttachAng = barrel.GetAttachmentAngles( cannonAttach )

	entity beamFX = PlayFX( FX_CANNON_BEAM, cannonAttachOrg, cannonAttachAng )
	beamFX.FXEnableRenderAlways()
}
*/

void function CannonFireShake( GunBatteryData gunBatteryData )
{
	entity base = gunBatteryData.base
	entity shake = CreateShake( base.GetOrigin(), 15, 255, 0.75, 5000000 )
	shake.kv.spawnflags = 29 // SF_SHAKE_INAIR
	shake.Destroy()
}

////////////////////
//GUN ANIM FUNCTIONS
////////////////////
void function CannonRefPose( GunBatteryData gunBatteryData )
{
	gunBatteryData.barrel.Anim_Stop()
	gunBatteryData.barrel.Anim_Play( "flaps_close_idle" )
}

void function CannonFlapsOpen( GunBatteryData gunBatteryData )
{
	gunBatteryData.barrel.Anim_Stop()
	gunBatteryData.barrel.Anim_Play( "flaps_open" )
}

void function CannonFire( GunBatteryData gunBatteryData )
{
	gunBatteryData.barrel.Anim_Stop()
	gunBatteryData.barrel.Anim_Play( "fire" )
}

void function CannonFlapsClose( GunBatteryData gunBatteryData )
{
	gunBatteryData.barrel.Anim_Stop()
	gunBatteryData.barrel.Anim_Play( "flaps_close" )
}

//SOUNDS

void function FireCannon_CooldownSound( GunBatteryData gunBatteryData )
{
	EmitSoundOnEntity( gunBatteryData.barrel, "skyway_scripted_railgun_cooldown" )
}


// ---- CANNON THERMAL DRUMS ----
void function CannonThermalDrumsSetup( GunBatteryData gunBatteryData )
{
//	array<entity> props = GetEntArrayByClassAndTargetname( "prop_dynamic", "cannon_rotating_drum" )
//	Assert( props.len() )

	// convert to script_movers so we can rotate them
	//foreach ( enitity prop in props )
	//CannonThermalDrumSetup( prop )
	Init_ThermalDrum( gunBatteryData, "def_l_generator1" )
}

//function CannonThermalDrumSetup( entity prop, GunBatteryData gunBatteryData )
void function Init_ThermalDrum( GunBatteryData gunBatteryData, string attachment )
	{
		//expect entity( prop )
		//asset modelname = prop.GetModelName()

		entity barrel = gunBatteryData.barrel

		int attachID = barrel.LookupAttachment( attachment )
		vector attachOrigin = barrel.GetAttachmentOrigin( attachID )
  		vector attachAngles = barrel.GetAttachmentAngles( attachID )

		//entity drum = CreateScriptMover( modelname, prop.GetOrigin(), prop.GetAngles() )
		entity drum = CreateExpensiveScriptMover( attachOrigin, attachAngles, 0 )
		//drum.SetModel( $"models/dev/editor_ref.mdl" )
		drum.SetModel( GUN_HEATSINK_GLOW )
		drum.Show()
		//drum.SetForwardVector( barrel.GetForwardVector() )
		drum.SetParent( barrel, attachment, true )

//		drum.s.ogAng <- drum.GetAngles()
		gunBatteryData.thermalDrums.append( drum )
		//prop.Kill_Deprecated_UseDestroyInstead()
	}

/*
function Outpost_CannonDrumsSpinChange()
{
	if ( level.nv.cannonThermalDrumsSpin )
		CannonThermalDrumsStart()
}
*/

void function CannonThermalDrumsStart( GunBatteryData gunBatteryData )
{
	foreach ( entity drum in gunBatteryData.thermalDrums )
		thread CannonThermalDrumSpin( gunBatteryData )
}

//void function CannonThermalDrumSpin( entity drum )
void function CannonThermalDrumSpin( GunBatteryData gunBatteryData )
{

	entity barrel = gunBatteryData.barrel

//	drum.Signal( "CannonThermalDrumSpinStart" )
//	drum.EndSignal( "CannonThermalDrumSpinStart")

//	float halfRotationTime = 0.35
//	float halfRotationRoll = 180

//	drum.SetAngles( drum.s.ogAng )

	//if ( !( "glowFxHandle" in drum.s ) )
	//	drum.s.glowFxHandle <- null

//	vector offsetVec = AnglesToRight( drum.GetAngles() ) * -1
//	vector glowOrg = drum.GetOrigin() + ( offsetVec * 40 )
//	vector glowAng = drum.GetAngles() + Vector( 0, -90, 0 )

	//drum.s.glowFxHandle = StartParticleEffectInWorldWithHandle( FX_CANNON_THERMAL_DRUM_GLOW, glowOrg, glowAng )
//	entity glowFX = PlayFXOnEntity( FX_CANNON_THERMAL_DRUM_GLOW, drum, "def_l_generator1"  )
	entity glowFX_l1 = PlayFXOnEntity( FX_CANNON_THERMAL_DRUM_GLOW, barrel, "def_l_generator1", < 0, 0, 0 >  )
	entity glowFX_l2 = PlayFXOnEntity( FX_CANNON_THERMAL_DRUM_GLOW, barrel, "def_l_generator2", < 0, 0, 0 >  )
	entity glowFX_r1 = PlayFXOnEntity( FX_CANNON_THERMAL_DRUM_GLOW, barrel, "def_r_generator1", < 0, 0, 0 >  )
	entity glowFX_r2 = PlayFXOnEntity( FX_CANNON_THERMAL_DRUM_GLOW, barrel, "def_r_generator2", < 0, 0, 0 >  )




	/*
	OnThreadEnd(
		function() : ( drum, glowFX )
		{
			if ( IsValid( glowFX) )
				EffectStop( glowFX )
		}
	)
	*/

	//while ( level.nv.cannonThermalDrumsSpin )
	/*
	while( true )
	{
		vector newAng = drum.GetAngles() + < 0, 0, halfRotationRoll >
		//if ( newAng.z >= 360 )
		//{
			//drum.SetAngles( drum.s.ogAng )
		//	continue
		//}

		drum.NonPhysicsRotateTo( newAng, halfRotationTime, 0, 0 )
		wait ( halfRotationTime )
		//drum.SetAngles( Vector( 0, 0, 0 ) )
	}

	// slow down before stopping
	vector lastAng = drum.GetAngles() + < 0, 0, halfRotationRoll >
	if ( lastAng.z >= 360 )
	{
		//drum.SetAngles( drum.s.ogAng )
		lastAng = drum.GetAngles() + < 0, 0, halfRotationRoll >
	}

	float lastRotateTime = 5.0
	float decelTime = lastRotateTime * 0.9
	drum.NonPhysicsRotateTo( lastAng, lastRotateTime, 0, decelTime )
	*/
}
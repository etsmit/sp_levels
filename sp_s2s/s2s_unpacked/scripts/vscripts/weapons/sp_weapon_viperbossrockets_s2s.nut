
global function SPWeaponViperBossRockets_S2S_Init
global function ScriptOnlyWeapon

#if SERVER
global function NPCScriptOnlyWeapon
global function OnWeaponScriptPrimaryAttack_ViperSwarmRockets_s2s
global function OnWeaponScriptAttack_s2s_BossIntro
global function OnWeaponScriptAttack_s2s_ViperDead
global function ViperSwarmRockets_SetupAttackParams
#endif

global const VIPERMAXVOLLEY 				= 24

global struct WeaponViperAttackParams
{
	vector pos
	vector dir
	bool firstTimePredicted
	int burstIndex
	int barrelIndex
	vector relativeDelta
	entity movingGeo
}

const VIPERMISSILE_SFX_LOOP					= "Weapon_Sidwinder_Projectile"
const VIPERMISSILE_MISSILE_SPEED_SCALE				= 1.0
const VIPERMISSILE_MISSILE_SPEED_SCALE_BOSSINTRO	= 1.5
const DEBUG_DRAW_PATH 						= false

void function SPWeaponViperBossRockets_S2S_Init()
{
	PrecacheParticleSystem( $"wpn_mflash_xo_rocket_shoulder_FP" )
	PrecacheParticleSystem( $"wpn_mflash_xo_rocket_shoulder" )
	#if DEV
		RegisterSignal( "DebugMissileTarget" )
	#endif
}

var function ScriptOnlyWeapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//not meant for player use
	return
}

#if SERVER
var function OnWeaponScriptPrimaryAttack_ViperSwarmRockets_s2s( entity weapon, WeaponViperAttackParams viperParams )
{
	#if DEV
		if ( GetBugReproNum() == 101 )
			return
	#endif

	entity owner = weapon.GetWeaponOwner()
	vector origin 	= GetWorldOriginFromRelativeDelta( viperParams.relativeDelta, viperParams.movingGeo )
	WeaponPrimaryAttackParams attackParams = PlayViperMissileFX( owner, weapon, viperParams.burstIndex, origin )

	entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, VIPERMISSILE_MISSILE_SPEED_SCALE, DF_GIB | DF_IMPACT, damageTypes.explosive, false, PROJECTILE_NOT_PREDICTED )
	InitMissile( missile, owner )

	thread HomingMissileThink( weapon, missile, viperParams )
}

void function OnWeaponScriptAttack_s2s_BossIntro( entity weapon, int burstIndex, entity target, vector offset, float homingSpeedScalar = 1.0, float missileSpeedScalar = 1.0 )
{
	entity owner = weapon.GetWeaponOwner()
	WeaponPrimaryAttackParams attackParams = PlayViperMissileFX( owner, weapon, burstIndex, target.GetOrigin() )

	entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, VIPERMISSILE_MISSILE_SPEED_SCALE_BOSSINTRO * missileSpeedScalar, DF_GIB | DF_IMPACT, damageTypes.explosive, false, PROJECTILE_NOT_PREDICTED )
	missile.DisableHibernation()
	InitMissileBossIntro( missile, owner )

	thread HomingMissileThinkTarget( weapon, missile, target, offset, homingSpeedScalar )
}

void function OnWeaponScriptAttack_s2s_ViperDead( entity weapon, int burstIndex, entity target, vector offset, float homingSpeedScalar = 1.0, float missileSpeedScalar = 1.0 )
{
	entity owner = weapon.GetWeaponOwner()
	WeaponPrimaryAttackParams attackParams = PlayViperMissileFXHigh( owner, weapon, burstIndex, target.GetOrigin() )

	entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, VIPERMISSILE_MISSILE_SPEED_SCALE_BOSSINTRO * missileSpeedScalar, DF_GIB | DF_IMPACT, damageTypes.explosive, false, PROJECTILE_NOT_PREDICTED )
	InitMissileBossIntro( missile, owner )

	delaythread( 0.3 ) HomingMissileThinkTargetLate( weapon, missile, target, offset, homingSpeedScalar )
}

void function InitMissile( entity missile, entity owner )
{
	missile.SetOwner( owner )
	missile.DamageAliveOnly( true )
	missile.kv.lifetime = RandomFloatRange( 4.0, 6.0 )
	SetTeam( missile, owner.GetTeam() )

	EmitSoundOnEntity( missile, VIPERMISSILE_SFX_LOOP )
}

void function InitMissileBossIntro( entity missile, entity owner )
{
	missile.SetOwner( owner )
	missile.DamageAliveOnly( true )
	missile.kv.lifetime = RandomFloatRange( 8.0, 10.0 )
	SetTeam( missile, owner.GetTeam() )

	EmitSoundOnEntity( missile, VIPERMISSILE_SFX_LOOP )
}

WeaponPrimaryAttackParams function PlayViperMissileFXHigh( entity owner, entity weapon, int burstIndex, vector origin )
{
	int fxId 			= GetParticleSystemIndex( $"wpn_mflash_xo_rocket_shoulder" )
	string attachment 	= IsEven( burstIndex ) ? "SCRIPT_POD_L" : "SCRIPT_POD_R"
	int attachId 		= owner.LookupAttachment( attachment )

	int adjustIndex = burstIndex
	float range = 45.0
	float add = 7.0
	float interval = ( range / VIPERMAXVOLLEY.tofloat() )

	if ( burstIndex > 0 && IsOdd( burstIndex ) )
	{
		adjustIndex = ( burstIndex - 1 ) * -1
		add *= -1
	}

	float degree = ( adjustIndex + add ) * interval
	vector angles = < 0,degree,0 >

	vector finalVec = AnglesToForward( AnglesCompose( owner.GetAttachmentAngles( attachId ), angles ) )
	//vector finalVec = AnglesToForward( AnglesCompose( < -90, 90, 0 >, angles ) )

	StartParticleEffectOnEntity( owner, fxId, FX_PATTACH_POINT_FOLLOW, attachId )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	WeaponPrimaryAttackParams attackParams

	attackParams.pos = owner.GetAttachmentOrigin( attachId )
	attackParams.dir = finalVec

	return attackParams
}

WeaponPrimaryAttackParams function PlayViperMissileFX( entity owner, entity weapon, int burstIndex, vector origin )
{
	int fxId 			= GetParticleSystemIndex( $"wpn_mflash_xo_rocket_shoulder" )
	string attachment 	= IsEven( burstIndex ) ? "SCRIPT_POD_R" : "SCRIPT_POD_L"
	int attachId 		= owner.LookupAttachment( attachment )

	int adjustIndex = burstIndex
	float range = 45.0
	float add = 7.0
	float interval = ( range / VIPERMAXVOLLEY.tofloat() )

	if ( burstIndex > 0 && IsEven( burstIndex ) )
	{
		adjustIndex = ( burstIndex - 1 ) * -1
		add *= -1
	}

	float degree = ( adjustIndex + add ) * interval
	vector angles = < 0,degree,0 >


	float distMin 	= pow( 1000, 2 )
	float distMax 	= pow( 2500, 2 )
	float distSqr 	= DistanceSqr( origin, owner.GetOrigin() )

	float launchFrac = GraphCapped( distSqr, distMin, distMax, 0, 1.0 )
	float attackFrac = 1.0 - launchFrac

	vector launchVec = AnglesToForward( AnglesCompose( owner.GetAttachmentAngles( attachId ), angles ) )
	vector attackVec = Normalize( origin - owner.GetOrigin() )
	vector finalVec = ( launchVec * launchFrac ) + ( attackVec * attackFrac )

	StartParticleEffectOnEntity( owner, fxId, FX_PATTACH_POINT_FOLLOW, attachId )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	WeaponPrimaryAttackParams attackParams

	attackParams.pos = owner.GetAttachmentOrigin( attachId )
	attackParams.dir = finalVec

	return attackParams
}

void function HomingMissileThinkTarget( entity weapon, entity missile, entity target, vector offset, float homingSpeedScalar )
{
	Assert( IsValid( missile ) )

	missile.EndSignal( "OnDestroy" )
	missile.EndSignal( "OnDeath" )

	missile.SetMissileTarget( target, offset )

	float timeMin = 0
	float timeMax = 3
	float timeStart = Time()
	float speedMin = 75
	float speedMax = 150

	while( 1 )
	{
		float deltaTime = Time() - timeStart
		float value = GraphCapped( deltaTime, timeMin, timeMax, speedMin, speedMax ) * homingSpeedScalar

		missile.SetHomingSpeeds( value, 0 )

		wait 0.2

		if ( value == speedMax )
			return
	}
}

void function HomingMissileThinkTargetLate( entity weapon, entity missile, entity target, vector offset, float homingSpeedScalar )
{
	if ( !IsValid( missile ) )
		return

	missile.EndSignal( "OnDestroy" )
	missile.EndSignal( "OnDeath" )

	missile.SetMissileTarget( target, offset )

	missile.SetHomingSpeeds( 150 * homingSpeedScalar, 0 )
}

void function HomingMissileThink( entity weapon, entity missile, WeaponViperAttackParams viperParams )
{
	Assert( IsValid( missile ) )
	if ( !IsValid( viperParams.movingGeo ) )
		return

	viperParams.movingGeo.EndSignal( "OnDestroy" )
	missile.EndSignal( "OnDestroy" )
	missile.EndSignal( "OnDeath" )

	missile.SetHomingSpeeds( 50, 0 )

	vector origin 		= GetWorldOriginFromRelativeDelta( viperParams.relativeDelta, viperParams.movingGeo )
	vector dir 			= missile.GetOrigin() - origin
	vector baseAngles 	= FlattenAngles( VectorToAngles( Normalize( dir ) ) )

	bool playedIncomingSound = false
	while( 1 )
	{
		vector origin 	= GetWorldOriginFromRelativeDelta( viperParams.relativeDelta, viperParams.movingGeo )
		vector vec1 	= origin - missile.GetOrigin()
		float dist 		= vec1.Length()
		vector offset 	= <0,0,0>

		if ( DotProduct( Normalize( vec1 ), <0,90,0> ) < 0.0 )
		{
			vector angles 	= baseAngles

			//always pitch up
			float x = RandomFloatRange( -45, -90 )
			float y = RandomFloatRange( -45, 45 )

			angles = AnglesCompose( angles, < -20,0,0 > )
			angles = AnglesCompose( angles, <0,y,0> )

			dir = AnglesToForward( angles )
			float mag = GraphCapped( dist, 500, 5000, 0, 0.5 )
			offset = dir * ( dist * mag )
		}

		if ( dist < 2500 && !playedIncomingSound )
		{
			EmitSoundAtPosition( TEAM_ANY, origin, "northstar_rocket_flyby" )
			playedIncomingSound = true
		}

		missile.SetMissileTargetPosition( origin + offset )

		#if DEV
			thread DebugMissileTarget( missile, origin, offset )
		#endif

		wait RandomFloatRange( 0.25, 0.5 )
	}
}
#if DEV
void function DebugMissileTarget( entity missile, vector origin, vector offset )
{
	missile.Signal( "DebugMissileTarget" )

	missile.EndSignal( "OnDestroy" )
	missile.EndSignal( "DebugMissileTarget" )

	int r = RandomIntRange( 100, 255 )
	int g = RandomIntRange( 100, 255 )
	int b = RandomIntRange( 100, 255 )
	while( 1 )
	{
		WaitFrame()

		if ( GetBugReproNum() != 5 )
			continue
		DebugDrawLine( origin + offset, origin, 255,0,0, true, 0.1 )
		DebugDrawLine( origin + offset, missile.GetOrigin(), r, g, b, true, 0.1 )
		DebugDrawCircle( origin + offset, <0,0,0>, 8, r, g, b, true, 0.1, 4 )
	}
}
#endif

WeaponViperAttackParams function ViperSwarmRockets_SetupAttackParams( vector targetPos, entity movingGeo )
{
	WeaponViperAttackParams viperParams

	viperParams.relativeDelta 	= GetRelativeDelta( targetPos, movingGeo )
	viperParams.movingGeo 		= movingGeo

	return viperParams
}

var function NPCScriptOnlyWeapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//if the AI tries to call - return
	return
}

#endif
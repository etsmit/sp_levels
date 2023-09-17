untyped

global function SPWeaponSwarmRockets_S2S_Init

global function OnWeaponPrimaryAttack_swarm_rockets_s2s

#if SERVER
global function OnWeaponNPCPrimaryAttack_swarm_rockets_s2s
#endif

const SWARMROCKET_MISSILE_SFX_LOOP			= "Weapon_Sidwinder_Projectile"
const SWARMROCKET_DEBUG_DRAW_PATH 			= false

void function SPWeaponSwarmRockets_S2S_Init()
{
	PrecacheParticleSystem( $"wpn_mflash_xo_rocket_shoulder_FP" )
	PrecacheParticleSystem( $"wpn_mflash_xo_rocket_shoulder" )
}

var function OnWeaponPrimaryAttack_swarm_rockets_s2s( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "AccurateMissiles" ) )
	{
		MOD_Accurate_swarm_rockets_s2s( weapon, attackParams )
		return
	}
	if ( weapon.HasMod( "HomingMissiles" ) )
	{
		MOD_Homing_swarm_rockets_s2s( weapon, attackParams )
		return
	}

	bool shouldPredict = weapon.ShouldPredictProjectiles()

	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	entity owner 		= weapon.GetWeaponOwner()
	vector attackDir 	= attackParams.dir
	vector attackPos 	= attackParams.pos
	attackParams.burstIndex = RandomInt( 12 )

	float life 		= RandomFloatRange( 1.5, 5.0 )
	float outAng 	= RandomFloatRange( 25, 30 )
	float inAng 	= outAng * -1.4

	float outTime 	= RandomFloatRange( 0.75, 1.0 ) + 0.5
	float inLerp 	= outTime
	float inTime 	= outTime
	float strLerp 	= 0.5

	bool randomSpread = true
	float speed 	= 1800

	FireMissileLogic( weapon, attackParams, attackPos, attackDir, shouldPredict, speed, outAng, outTime, inAng, inTime, inLerp, strLerp, randomSpread, life )
}

var function MOD_Homing_swarm_rockets_s2s( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool shouldPredict = weapon.ShouldPredictProjectiles()

	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	float speed = 2500

	if ( !( "initialized" in weapon.s ) )
	{
		//weapon.s.missileThinkThread <- MissileThink
		weapon.s.initialized <- true

		SmartAmmo_SetMissileSpeedLimit( weapon, 9000 )
		SmartAmmo_SetMissileSpeed( weapon, speed )
		SmartAmmo_SetMissileHomingSpeed( weapon, speed )
	}

	entity weaponOwner = weapon.GetWeaponOwner()

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, speed, damageTypes.projectileImpact | DF_IMPACT, damageTypes.explosive, false, shouldPredict )

	if ( missile )
	{
		missile.s.guidedMissile <- true
		missile.kv.lifetime = 10
		missile.SetSpeed( speed )
		missile.SetHomingSpeeds( speed, 0 )

		if ( IsValid( weaponOwner.GetEnemy() ) )
			missile.SetMissileTarget( weaponOwner.GetEnemy(), <0,0,0> )

		#if SERVER
			missile.SetOwner( weaponOwner )
		#endif
	}
}

var function MOD_Accurate_swarm_rockets_s2s( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool shouldPredict = weapon.ShouldPredictProjectiles()

	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	entity owner 		= weapon.GetWeaponOwner()
	vector attackDir 	= attackParams.dir
	vector attackPos 	= attackParams.pos + ( attackDir * 64 )
	attackParams.burstIndex = RandomInt( 12 )

	float life		= RandomFloatRange( 3.0, 5.0 )
	float outAng 	= RandomFloatRange( 5, 10 )
	float inAng 	= outAng * -1.25

	float outTime 	= 0.5
	float inLerp 	= 1.0
	float inTime 	= 0.5
	float strLerp 	= 1.0

	bool randomSpread = true
	float speed 	= 1500

	FireMissileLogic( weapon, attackParams, attackPos, attackDir, shouldPredict, speed, outAng, outTime, inAng, inTime, inLerp, strLerp, randomSpread, life )
}

void function FireMissileLogic( entity weapon, WeaponPrimaryAttackParams attackParams, vector attackPos, vector attackDir, bool shouldPredict, float speed, float outAng, float outTime, float inAng, float inTime, float inLerp, float strLerp, bool randomSpread, float life )
{
	entity owner 		= weapon.GetWeaponOwner()
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	array<entity> firedMissiles = FireExpandContractMissiles_S2S( weapon, attackParams, attackPos, attackDir, shouldPredict, 1, speed, outAng, outTime, inAng, inTime, inLerp, strLerp, randomSpread, -1, SWARMROCKET_DEBUG_DRAW_PATH )
	foreach( missile in firedMissiles )
	{
		#if SERVER
			missile.SetOwner( owner )
			EmitSoundOnEntity( missile, SWARMROCKET_MISSILE_SFX_LOOP )
		#endif
		missile.kv.lifetime = life
		SetTeam( missile, owner.GetTeam() )
	}
}

/*
var function OnWeaponPrimaryAttack_swarm_rockets_s2s( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool shouldPredict = weapon.ShouldPredictProjectiles()

	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	entity owner = weapon.GetWeaponOwner()
	vector attackPos = attackParams.pos
	vector attackDir = attackParams.dir

	float SWARMROCKET_MISSILE_LIFE 		= RandomFloatRange( 1.5, 6.0 )
	float SWARMROCKET_LAUNCH_OUT_ANG 	= RandomFloatRange( 5, 8 )
	float SWARMROCKET_LAUNCH_IN_ANG 	= SWARMROCKET_LAUNCH_OUT_ANG * -1.4

	float SWARMROCKET_LAUNCH_OUT_TIME 			= RandomFloatRange( 0.3, 0.5 )
	float SWARMROCKET_LAUNCH_IN_LERP_TIME 		= SWARMROCKET_LAUNCH_OUT_TIME
	float SWARMROCKET_LAUNCH_IN_TIME 			= SWARMROCKET_LAUNCH_OUT_TIME

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	array<entity> firedMissiles = FireExpandContractMissiles_S2S( weapon, attackParams, attackPos, attackDir, shouldPredict, SWARMROCKET_NUM_ROCKETS_PER_SHOT, SWARMROCKET_MISSILE_SPEED, SWARMROCKET_LAUNCH_OUT_ANG, SWARMROCKET_LAUNCH_OUT_TIME, SWARMROCKET_LAUNCH_IN_ANG, SWARMROCKET_LAUNCH_IN_TIME, SWARMROCKET_LAUNCH_IN_LERP_TIME, SWARMROCKET_LAUNCH_STRAIGHT_LERP_TIME, SWARMROCKET_APPLY_RANDOM_SPREAD, -1, SWARMROCKET_DEBUG_DRAW_PATH )
	foreach( missile in firedMissiles )
	{
		#if SERVER
			missile.SetOwner( owner )
			EmitSoundOnEntity( missile, SWARMROCKET_MISSILE_SFX_LOOP )
		#endif
		missile.kv.lifetime = SWARMROCKET_MISSILE_LIFE
		SetTeam( missile, owner.GetTeam() )
	}
}*/


#if SERVER
var function OnWeaponNPCPrimaryAttack_swarm_rockets_s2s( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_swarm_rockets_s2s( weapon, attackParams )
}
#endif
untyped

global function SpWeaponMegaTurrets2s_Init
global function OnWeaponPrimaryAttack_s2s_mega_turret
global function OnWeaponActivate_s2s_mega_turret
global function OnWeaponDeactivate_s2s_mega_turret

#if SERVER
global function OnWeaponNpcPrimaryAttack_s2s_mega_turret

struct
{
	table<int,entity> shellEject
	int barrelIndex = 0
}file

#endif // #if SERVER

const asset ModelMT = $"models/turrets/turret_imc_lrg.mdl"  // the return value for turretEnt.GetModelName()
const asset CANNON_FX		= $"P_muzzleflash_MaltaGun"
const asset CANNON_FX_LIGHT = $"mflash_maltagun_tracer_fake"

// this list has to match the order that the barrels are set up in the QC file
const WeaponBarrelInfo = {
	[ ModelMT ] = [
		{
			muzzleFlashTag	= "MUZZLE_LEFT_UPPER"
			shellEjectTag 	= "SHELL_LEFT_UPPER"
		}
		{
			muzzleFlashTag	= "MUZZLE_LEFT_LOWER"
			shellEjectTag	= "SHELL_LEFT_LOWER"
		}
		{
			muzzleFlashTag	= "MUZZLE_RIGHT_UPPER"
			shellEjectTag	= "SHELL_RIGHT_UPPER"
		}
		{
			muzzleFlashTag	= "MUZZLE_RIGHT_LOWER"
			shellEjectTag	= "SHELL_RIGHT_LOWER"
		}
	]
}

function SpWeaponMegaTurrets2s_Init()
{
	PrecacheParticleSystem( CANNON_FX )
	PrecacheParticleSystem( CANNON_FX_LIGHT )

	RegisterSignal( "shoot" )
}

var function OnWeaponPrimaryAttack_s2s_mega_turret( entity weapon, WeaponPrimaryAttackParams attackParams )
{

}

#if SERVER
var function OnWeaponNpcPrimaryAttack_s2s_mega_turret( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	entity turretOwner = weapon.GetOwner()
	turretOwner.Signal( "shoot" )

	if ( !IsAlive( turretOwner ) )
		return

	int barrelIndex = file.barrelIndex// RandomInt( 4 )
	file.barrelIndex++
	if ( file.barrelIndex >= 4 )
		file.barrelIndex = 0

	table<string,string> barrelInfo = WeaponBarrelInfo[ turretOwner.GetModelName() ][ barrelIndex ]

	int fxID
	if ( !Flag( "BridgeClear" ) )
	{
		if ( IsEven( barrelIndex ) )
			return
		fxID = GetParticleSystemIndex( CANNON_FX_LIGHT )
	}
	else
	{
		fxID = GetParticleSystemIndex( CANNON_FX )
	}

	int attachID = turretOwner.LookupAttachment(  barrelInfo.muzzleFlashTag )
	StartParticleEffectOnEntity( turretOwner, fxID, FX_PATTACH_POINT_FOLLOW, attachID )
}

#endif

void function OnWeaponActivate_s2s_mega_turret( entity weapon )
{

}

void function OnWeaponDeactivate_s2s_mega_turret( entity weapon )
{

}


untyped

global function SpWeaponMegaTurrets2s_ion_Init
global function OnWeaponActivate_s2s_mega_turret_ion
global function OnWeaponDeactivate_s2s_mega_turret_ion

#if SERVER
global function OnWeaponNpcPrimaryAttack_s2s_mega_turret_ion

struct
{
	table<int,entity> shellEject
}file

#endif // #if SERVER

const asset ModelMT = $"models/turrets/turret_imc_lrg.mdl"  // the return value for turretEnt.GetModelName()
const asset SHELL_CASING = $"models/containers/titan_bullet_casing_01.mdl"

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

function SpWeaponMegaTurrets2s_ion_Init()
{
	PrecacheModel( SHELL_CASING )
	PrecacheParticleSystem( $"P_wpn_muzzleflash_sspectre" )
	PrecacheParticleSystem( $"P_ion_moving_proj" )
	PrecacheParticleSystem( $"wpn_shelleject_40mm" )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_s2s_mega_turret_ion( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity turretOwner 	= weapon.GetOwner()
	asset ownerModel 	= turretOwner.GetModelName()
	float speed	= 2000.0

	int barrelIndex = attackParams.barrelIndex
	table<string,string> barrelInfo = WeaponBarrelInfo[ ownerModel ][ barrelIndex ]
	int muzzleTagIdx = turretOwner.LookupAttachment( barrelInfo.muzzleFlashTag )
	vector origin = turretOwner.GetAttachmentOrigin( muzzleTagIdx )
	vector dir = attackParams["dir"]
	int fxID = GetParticleSystemIndex( $"P_ion_moving_proj" )

//	entity missile 		= weapon.FireWeaponMissile( origin, dir, speed, 0, 0, false, PROJECTILE_NOT_PREDICTED )
//	if ( !missile )
//		return

//	missile.kv.lifetime = 3.0
	weapon.EmitWeaponSound( "Weapon_DaemonRocket_Launcher.Fire" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	//PlayFXOnEntity( $"P_wpn_muzzleflash_sspectre", turretOwner, barrelInfo.muzzleFlashTag )

	StartParticleEffectInWorld( fxID, origin, VectorToAngles( dir ) )

/*
	if ( !weapon.HasMod( "NOEJECTS" ) )
		thread CreateShellEject( file.shellEject[ turretOwner.GetTargetName() ] )
		*/
}

void function CreateShellEject( entity shellEject )
{
	vector origin = shellEject.GetOrigin()
	vector angles = shellEject.GetAngles()
	vector spawnAng = < 0,RandomFloatRange( 0, 359 ),90 >

	entity shell = CreateShellPhysicsModel( SHELL_CASING, origin, AnglesCompose( angles, spawnAng ) )

	shell.SetVelocity( shellEject.GetForwardVector() * RandomFloatRange( 200, 300 ) )

	float x = RandomFloatRange( -500, 500 )
	float y = RandomFloatRange( -500, 500 )
	float z = RandomFloatRange( -100, 100 )
	shell.SetAngularVelocity( x, y, z )

	shell.EndSignal( "OnDestroy" )
	wait 0.55
	shell.Destroy()
}

entity function CreateShellPhysicsModel( asset model, vector origin, vector angles )
{
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( model )
	prop_physics.kv.spawnflags = 1 //thought this would cause it to collide
	prop_physics.kv.fadedist = -1
	prop_physics.kv.physdamagescale = 0.1
	prop_physics.kv.inertiaScale = 1.0
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	prop_physics.kv.physicsmode = 1 //thought this would cause it to collide
	SetTeam( prop_physics, TEAM_BOTH )	// need to have a team other then 0 or it won't take impact damage

	prop_physics.SetOrigin( origin )
	prop_physics.SetAngles( angles )
	DispatchSpawn( prop_physics )

	return prop_physics
}
#endif

void function OnWeaponActivate_s2s_mega_turret_ion( entity weapon )
{
	#if SERVER
		entity turretNPC = weapon.GetOwner()
		Assert( IsValid( turretNPC ) )

		if ( turretNPC.GetTargetName() == "" )
		{
			string name = UniqueString( "hullTurret" )
			SetTargetName( turretNPC, name )
		}

		array<entity> linkedEnts = turretNPC.GetLinkEntArray()
		foreach( entity ent in linkedEnts )
		{
			if ( !( "kv" in ent ) )
				continue

			switch( ent.kv.script_noteworthy )
			{
				case "shell_eject":
					file.shellEject[ turretNPC.GetTargetName() ] <- ent
					break
			}
		}
	#endif
}

void function OnWeaponDeactivate_s2s_mega_turret_ion( entity weapon )
{

}


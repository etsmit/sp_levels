global function ShSpBeaconHubCommonInit
global const TRINITY_MDL = $"models/vehicles_r2/spacecraft/trinity/trinity.mdl"
global const CROW_MDL = $"models/vehicle/crow_dropship/crow_dropship.mdl"
global const HORNET_MDL = $"models/vehicle/Hornet/hornet_fighter.mdl"

void function ShSpBeaconHubCommonInit()
{
	// Precaching these weapons because they exist in the previous level, so you can carry them to this level
	PrecacheWeapon( "mp_weapon_autopistol" )
	PrecacheWeapon( "mp_weapon_car" )
	PrecacheWeapon( "mp_weapon_defender" )
	PrecacheWeapon( "mp_weapon_doubletake" )
	PrecacheWeapon( "mp_weapon_frag_drone" )
	PrecacheWeapon( "mp_weapon_frag_grenade" )
	PrecacheWeapon( "mp_weapon_hemlok" )
	PrecacheWeapon( "mp_weapon_hemlok_smg" )
	PrecacheWeapon( "mp_weapon_lmg" )
	PrecacheWeapon( "mp_weapon_lstar" )
	PrecacheWeapon( "mp_weapon_mastiff" )
	PrecacheWeapon( "mp_weapon_mgl" )
	PrecacheWeapon( "mp_weapon_r97" )
	PrecacheWeapon( "mp_weapon_rocket_launcher" )
	PrecacheWeapon( "mp_weapon_rspn101" )
	PrecacheWeapon( "mp_weapon_satchel" )
	PrecacheWeapon( "mp_weapon_semipistol" )
	PrecacheWeapon( "mp_weapon_shotgun" )
	PrecacheWeapon( "mp_weapon_sniper" )
	PrecacheWeapon( "mp_weapon_softball" )
	PrecacheWeapon( "mp_weapon_thermite_grenade" )
	PrecacheWeapon( "mp_weapon_vinson" )
	PrecacheWeapon( "mp_weapon_wingman" )

	PrecacheWeapon( "sp_weapon_arc_tool" )
	PrecacheModel( TRINITY_MDL )
	PrecacheModel( CROW_MDL )
	PrecacheModel( HORNET_MDL )
	SP_BEACON_AutoPrecache()
}

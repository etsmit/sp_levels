global function ShSpBoomtownEndCommonInit

void function ShSpBoomtownEndCommonInit()
{
	// Precaching these weapons because they exist in the previous level, so you can carry them to this level
	PrecacheWeapon( "mp_weapon_alternator_smg" )
	PrecacheWeapon( "mp_weapon_autopistol" )
	PrecacheWeapon( "mp_weapon_car" )
	PrecacheWeapon( "mp_weapon_dmr" )
	PrecacheWeapon( "mp_weapon_epg" )
	PrecacheWeapon( "mp_weapon_esaw" )
	PrecacheWeapon( "mp_weapon_frag_grenade" )
	PrecacheWeapon( "mp_weapon_g2" )
	PrecacheWeapon( "mp_weapon_grenade_electric_smoke" )
	PrecacheWeapon( "mp_weapon_grenade_gravity" )
	PrecacheWeapon( "mp_weapon_lmg" )
	PrecacheWeapon( "mp_weapon_lstar" )
	PrecacheWeapon( "mp_weapon_mgl" )
	PrecacheWeapon( "mp_weapon_r97" )
	PrecacheWeapon( "mp_weapon_rocket_launcher" )
	PrecacheWeapon( "mp_weapon_rspn101" )
	PrecacheWeapon( "mp_weapon_semipistol" )
	PrecacheWeapon( "mp_weapon_shotgun" )
	PrecacheWeapon( "mp_weapon_shotgun_pistol" )
	PrecacheWeapon( "mp_weapon_sniper" )
	PrecacheWeapon( "mp_weapon_thermite_grenade" )
	PrecacheWeapon( "mp_weapon_vinson" )

	SP_BOOMTOWN_END_AutoPrecache()

	PrecacheWeapon( "mp_weapon_epg" )  // manually added since it can be carried over from previous level
}

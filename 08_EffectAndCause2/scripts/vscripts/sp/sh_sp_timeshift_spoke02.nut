global function ShSpTimeshiftSpoke2CommonInit

void function ShSpTimeshiftSpoke2CommonInit()
{
	// Precaching these weapons because they exist in the previous level, so you can carry them to this level
	PrecacheWeapon( "mp_weapon_autopistol" )
	PrecacheWeapon( "mp_weapon_car" )
	PrecacheWeapon( "mp_weapon_defender" )
	PrecacheWeapon( "mp_weapon_esaw" )
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
	PrecacheWeapon( "mp_weapon_shotgun_pistol" )
	PrecacheWeapon( "mp_weapon_sniper" )
	PrecacheWeapon( "mp_weapon_thermite_grenade" )
	PrecacheWeapon( "mp_weapon_vinson" )
	PrecacheWeapon( "mp_weapon_wingman" )

	PrecacheWeapon( "mp_ability_timeshift" )
	SP_TIMESHIFT_SPOKE02_AutoPrecache()
}

global function ShSpSewersCommonInit
global const NEUTRAL_SPECTRE_MODEL = $"models/Robots/spectre/spectre_corporate.mdl"

void function ShSpSewersCommonInit()
{
	RegisterOnscreenHint( "disembark_hint", "#SEWERS_HINT_DISEMBARK" )
	RegisterOnscreenHint( "swap_titan_loadout", "#SEWERS_HINT_SWAP_LOADOUTS")

	// a super spectre is spawned from script. If an actually spawner was placed in the level then these lines would not be needed.
	#if SERVER && DEV
	MarkNPCForAutoPrecache( "npc_super_spectre" )
	#endif

	// Precaching these weapons because they exist in the previous level, so you can carry them to this level
	PrecacheWeapon( "mp_weapon_car" )
	PrecacheWeapon( "mp_weapon_dmr" )
	PrecacheWeapon( "mp_weapon_frag_grenade" )
	PrecacheWeapon( "mp_weapon_grenade_emp" )
	PrecacheWeapon( "mp_weapon_hemlok" )
	PrecacheWeapon( "mp_weapon_hemlok_smg" )
	PrecacheWeapon( "mp_weapon_lmg" )
	PrecacheWeapon( "mp_weapon_rocket_launcher" )
	PrecacheWeapon( "mp_weapon_rspn101" )
	PrecacheWeapon( "mp_weapon_semipistol" )
	PrecacheWeapon( "mp_weapon_shotgun" )
	PrecacheWeapon( "mp_weapon_smr" )
	PrecacheWeapon( "mp_weapon_vinson" )


	SP_SEWERS1_AutoPrecache()

 	PrecacheWeapon( "mp_weapon_vinson" )  // manually added since it can be carried over from previous level
}


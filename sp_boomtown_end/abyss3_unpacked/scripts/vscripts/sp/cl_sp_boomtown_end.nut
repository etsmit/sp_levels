global function ClientCodeCallback_MapInit
global function ServerCallback_StartProwlerSFX


void function ClientCodeCallback_MapInit()
{
	ShSpBoomtownEndCommonInit()
	ClBoomtownCommonInit()
}


void function ServerCallback_StartProwlerSFX()
{
	array<entity> prowlerCageSFXspots = GetEntArrayByScriptName( "prowlercage_prowler_loop_sfx" )

	foreach( spot in prowlerCageSFXspots )
		spot.SetEnabled( true )
}

global function RotateVector
global function Init_SkywayUtility
global function CleanupEnts
global function CreatePetTitan
global function HideAllInArray
global function NpcMoveToMark
global function NpcSetBullseye
global function PrepMoverToMoveWithAI
global function ReconnectMovingGeoToNavMesh
global function ShowAllInArray
global function SpawnDronePlatformAtInterval
global function SpawnToCount
global function StartPlatformSpawning
global function TeleportEntityRelativeToScriptRefs
global function TrackTargetAttachmentWithDOF
global function TrackTargetAttachmentWithDOF_ANIMATION
global function TrackTargetWithDOF

void function Init_SkywayUtility()
{
	RegisterSignal( "StopDOFTracking" )
}

///////////////////
//SPAWNING FUCTIONS
///////////////////

void function SpawnDronePlatformAtInterval( entity platform, float interval )
{
	while ( true )
	{
		entity newPlatform = platform.SpawnEntity()
		DispatchSpawn( newPlatform )
		wait interval
	}
}

void function SpawnToCount( array<entity> spawnArray, int spawnsPerSpawn )
{

	int spawnCount = 0

	while ( spawnCount < spawnsPerSpawn )
	{
		spawnCount += 1
		SpawnFromSpawnerArray( spawnArray )
	}

}

void function StartPlatformSpawning( string name, float interval )
{
	array<entity> platforms = GetSpawnerArrayByScriptName( name )

	foreach ( entity platform in platforms )
	{
		thread SpawnDronePlatformAtInterval( platform, interval )
	}
}

///////////////////////
//ENT CLEANUP FUNCTIONS
///////////////////////
void function CleanupEnts( string scriptName )
{
	array<entity> entArray = GetEntArrayByScriptName( scriptName )
	foreach( ent in entArray )
	{
		if( IsValid( ent ) )
			ent.Destroy()
	}

}

///////////////
//NPC FUNCTIONS
///////////////
void function NpcMoveToMark( entity npc, entity mark, bool faceAngles = true )
{
	npc.AssaultPoint( mark.GetOrigin() )
	if ( faceAngles )
		npc.AssaultSetAngles( mark.GetAngles(), true )
	npc.AssaultSetGoalRadius( 256 )
	npc.AssaultSetGoalHeight( 256 )
	npc.AssaultSetArrivalTolerance ( 0 )
	npc.AssaultSetFightRadius( 0 )
}

entity function NpcSetBullseye( entity npc, string name )
{
	npc.ClearAllEnemyMemory()
	npc.ClearEnemy()

	entity bullsEyeRef = GetEntByScriptName( name )
	entity bullsEye = SpawnBullseye( TEAM_MILITIA )
	bullsEye.SetOrigin( bullsEyeRef.GetOrigin() )
	npc.SetEnemy( bullsEye )

	return bullsEye
}

void function TeleportEntityRelativeToScriptRefs( entity ent, entity startRef, entity endRef )
{
	vector entOrigin = ent.GetOrigin()
	vector startRefOrigin = startRef.GetOrigin()
	vector endRefOrigin = endRef.GetOrigin()

	vector entOffset = entOrigin - startRefOrigin

	ent.SetOrigin( endRefOrigin + entOffset )
}

entity function CreatePetTitan( entity player, vector origin, vector angles )
{

	entity bt = SpawnBT( player, origin )
	entity soul = bt.GetTitanSoul()

	if ( IsValid( soul ) )
	{
		soul.soul.lastOwner = player
		SoulBecomesOwnedByPlayer( soul, player )
	}

	SetupAutoTitan( bt, player )
	return bt
}

entity function SpawnBT( entity player, vector origin )
{
	vector angles = < 0, 0, 0 >

	//	entity npcTitan = CreateAutoTitanForPlayer_FromTitanLoadout( player, loadout, origin, angles )
	TitanLoadoutDef loadout = GetTitanLoadoutForCurrentMap()
	entity npcTitan = CreateNPCTitan( loadout.setFile, TEAM_MILITIA, origin, angles, loadout.setFileMods )
	npcTitan.ai.titanSpawnLoadout = loadout

	npcTitan.EnableNPCFlag( NPC_IGNORE_FRIENDLY_SOUND )

	string settings = expect string( Dev_GetPlayerSettingByKeyField_Global( loadout.setFile, "sp_aiSettingsFile" ) )

	SetSpawnOption_AISettings( npcTitan, settings )
	npcTitan.SetAISettings( settings )

//	npcTitan.SetBossPlayer( player )
	DispatchSpawn( npcTitan )

	//npcTitan.EnableNPCFlag( NPC_IGNORE_ALL )
	//npcTitan.SetInvulnerable()
	//npcTitan.SetNoTarget( true )

	HideCrit( npcTitan )
	Highlight_ClearFriendlyHighlight( npcTitan )

//	file.oldBTTitle = npcTitan.GetTitle()
	npcTitan.SetTitle( "" )

	//thread CreateNearBTTrigger( npcTitan, player )
	return npcTitan
}

//////////////////////
//MOVING GEO FUNCTIONS
//////////////////////
void function PrepMoverToMoveWithAI( entity mover )
{
	mover.ChangeNPCPathsOnMove( true )
}

void function ReconnectMovingGeoToNavMesh( entity geo )
{
	TransitionNPCPathsForEntity( geo, geo.GetOrigin(), true )
}

///////////////
//VIS FUNCTIONS
///////////////
void function HideAllInArray( array<entity> ents )
{
	foreach( entity ent in ents )
	{
		ent.Hide()
	}
}

void function ShowAllInArray( array<entity> ents )
{
	foreach( entity ent in ents )
	{
		ent.Show()
	}
}

vector function GetWorldPositionInSkybox( vector origin )
{
	entity skyCam  = GetEntByScriptName( "skybox_cam" )
	vector skyOrigin = skyCam.GetOrigin()
	float skyboxScale = float ( skyCam.GetValueForKey( "skyscale" ) )

	float skyboxScaleMod = ( 1.0 / skyboxScale )

	vector position = ( skyOrigin - ( origin * skyboxScaleMod ) )

	return position
}

void function TrackTargetWithDOF( entity player, entity target, float minDistMod, float maxDistMod, float updateInterval )
{

	Assert( IsNewThread(), "Must be threaded off" )

	EndSignal( player, "OnDestroy" )
	EndSignal( player, "OnDeath" )
	EndSignal( target, "OnDestroy" )
	EndSignal( target, "OnDeath" )
	EndSignal( target, "StopDOFTracking" )
	EndSignal( level, "StopDOFTracking" )

	OnThreadEnd(
		function() : ( player )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_ResetDOF" )
		}
	)

	while( true )
	{
		vector playerOrigin = player.CameraPosition()
		vector targetOrigin = target.GetOrigin()

		float dist = Distance( targetOrigin, playerOrigin )

		//DebugDrawLine( playerOrigin, targetOrigin , 255, 0, 0, true, updateInterval )

		//printt( "PLAYER CAM ORIGIN: " + playerOrigin )
	//	printt( "TARGET CAM ORIGIN: " + targetOrigin )

		//printt( "Distance: " + dist )
		//printt( "Distance Min: " + ( dist + minDistMod ) )
		//printt( "Distance Max: " + ( dist + maxDistMod ) )

		Remote_CallFunction_NonReplay( player, "ServerCallback_SetDOF", dist + minDistMod, dist + maxDistMod, updateInterval )


		wait updateInterval
	}
}

void function TrackTargetAttachmentWithDOF( entity player, entity target, string attachment, float minDistMod, float maxDistMod, float updateInterval )
{

	Assert( IsNewThread(), "Must be threaded off" )

	EndSignal( player, "OnDestroy" )
	EndSignal( player, "OnDeath" )
	EndSignal( target, "OnDestroy" )
	EndSignal( target, "OnDeath" )
	EndSignal( target, "StopDOFTracking" )
	EndSignal( level, "StopDOFTracking" )

	OnThreadEnd(
		function() : ( player )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_ResetDOF" )
		}
	)

	int attachID = target.LookupAttachment( attachment )

	while( true )
	{
		vector playerOrigin = player.CameraPosition()
		vector targetOrigin = target.GetAttachmentOrigin( attachID )

		//DebugDrawLine( playerOrigin, targetOrigin , 255, 0, 0, true, updateInterval )

		float dist = Distance( targetOrigin, playerOrigin )
		//dist *= 7 //HACK FOR ANIMATION CAMERAS (THE CAMERA NEAR Z IS 1 INSTEAD OF 7)

		//printt( "Distance: " + dist )

		Remote_CallFunction_NonReplay( player, "ServerCallback_SetDOF", dist + minDistMod, dist + maxDistMod, updateInterval )

		wait updateInterval
	}
}

//This function is a hack the multiplies the dof by seven to account for the nearz plane of the camera moving from 7 to 1 during animations.
void function TrackTargetAttachmentWithDOF_ANIMATION( entity player, entity target, string attachment, float minDistMod, float maxDistMod, float updateInterval )
{

	Assert( IsNewThread(), "Must be threaded off" )

	EndSignal( player, "OnDestroy" )
	EndSignal( player, "OnDeath" )
	EndSignal( target, "OnDestroy" )
	EndSignal( target, "OnDeath" )
	EndSignal( target, "StopDOFTracking" )
	EndSignal( level, "StopDOFTracking" )

	OnThreadEnd(
		function() : ( player )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_ResetDOF" )
		}
	)

	int attachID = target.LookupAttachment( attachment )

	while( true )
	{
		vector playerOrigin = player.CameraPosition()
		vector targetOrigin = target.GetAttachmentOrigin( attachID )

		//DebugDrawLine( playerOrigin, targetOrigin , 255, 0, 0, true, updateInterval )

		float dist = Distance( targetOrigin, playerOrigin )
		dist *= 7 //HACK FOR ANIMATION CAMERAS (THE CAMERA NEAR Z IS 1 INSTEAD OF 7)

		//printt( "Distance: " + dist )

		Remote_CallFunction_NonReplay( player, "ServerCallback_SetDOF", dist + minDistMod, dist + maxDistMod, updateInterval )

		wait updateInterval
	}
}

vector function RotateVector( vector vec, vector rotateAngles )
{
	vector vectorAngles = VectorToAngles( vec )
	vectorAngles = AnglesCompose( vectorAngles, rotateAngles )
	return AnglesToForward( vectorAngles ) * Length( vec )
}
global function SpawnFromSpawner
global function SpawnFromScriptName
global function CreateTriggerRadiusFromEnt
global function GetNPCArrayByScriptName
global function DropOffAISide_GetIdleAnims
global function DropOffAISide_GetDeployAnims
global function DropOffAISide_GetDisperseAnims
global function DropOffAISide_GetSeekTimes
global function LocalPosToWorldPos
global function StopAnimOnAlert
global function GruntRunsToAndActivatesSpectreRack
global function	FlagSetOn_NumDead
global function	FlagSetOn_NumDeadWithTimeout
global function	FlagSetOn_AllDead
global function	FlagSetOn_AllDeadWithTimeout
global function	FlagSetOn_NumDeadOrLeeched
global function	FlagSetOn_NumDeadOrLeechedWithTimeout
global function	FlagSetOn_AllDeadOrLeeched
global function	FlagSetOn_AllDeadOrLeechedWithTimeout
global function GetEnemiesClosest
global function GetEnemiesFarthest
global function GetMoDevState
global function CheckPointLoop

global function PlayRecordedAnim
global function RunToRecordedAnimStart
global function AnimCallback_ActivateSpectreRack

global function Hack_StopMalta
global function Hack_StopDraconis
global function Hack_StopBarker
global function Hack_StopTrinity
global function Hack_StopGibraltar
global function MoUtilityInit

global const int DEV_DRAWMOVETARGET 	= 0

void function MoUtilityInit()
{
	RegisterSignal( "SpectreRack_RunningTo" )
	RegisterSignal( "SpectreRack_PoweringUp" )
	RegisterSignal( "SpectreRack_Online" )
	RegisterSignal( "CheckPointLoop" )
	RegisterSignal( "DevDrawMoveTarget" )
	RegisterSignal( "PlayNewRecordedAnim" )
	RegisterSignal( "RunToNewRecordedAnimStart" )
}

entity function SpawnFromSpawner( entity spawner, void functionref(entity) ornull spawnSettingsFunc = null  )
{
	entity npc = spawner.SpawnEntity()

	if ( spawnSettingsFunc != null )
	{
		expect void functionref(entity)( spawnSettingsFunc )
		spawnSettingsFunc( npc )
	}

	DispatchSpawn( npc )
	return npc
}

void function SpawnFromScriptName( string name )
{
	array<entity> spawners = GetEntArrayByScriptName( name )
	foreach ( entity ent in spawners )
		TriggerSpawnSpawner( ent )
}

entity function CreateTriggerRadiusFromEnt( string name, entity player )
{
	entity ent = GetEntByScriptName( name )
	float radius = float( ent.kv.script_goal_radius )
	return CreateTriggerRadiusMultiple( ent.GetOrigin(), radius, [ player ] )
}

void function DevDrawMoveTarget( entity npc, entity moveTarget )
{
	npc.EndSignal( "OnDeath" )
	npc.Signal( "DevDrawMoveTarget" )
	npc.EndSignal( "DevDrawMoveTarget" )

	int r = RandomIntRange( 100, 255 )
	int g = RandomIntRange( 100, 255 )
	int b = RandomIntRange( 100, 255 )

	while( 1 )
	{
		DebugDrawCircle( moveTarget.GetOrigin(), Vector(0,0,0), 8, r, g, b, true, 0.181 )
		DebugDrawLine( npc.GetOrigin(), moveTarget.GetOrigin(), r, g, b, true, 0.181 )
		wait FRAME_INTERVAL - 0.001
	}
}

array<entity> function GetNPCArrayByScriptName( string name, int team = 0 )
{
	array<entity> ents = GetEntArrayByScriptName( name )
	array<entity> npc

	foreach ( entity ent in ents )
	{
		if ( ent.IsNPC() && IsAlive( ent ) )
		{
			if ( team )
			{
				if ( team == ent.GetTeam() )
					npc.append( ent )
			}
			else
				npc.append( ent )
		}
	}

	return npc
}

string[4] function DropOffAISide_GetIdleAnims()
{
	string[4] anims = [
	"pt_ds_side_intro_gen_idle_A",	//standing right
	"pt_ds_side_intro_gen_idle_B",	//standing left
	"pt_ds_side_intro_gen_idle_C",	//sitting right
	"pt_ds_side_intro_gen_idle_D" ]	//sitting left

	return anims
}

string[4] function DropOffAISide_GetDeployAnims()
{
	string[4] anims = [
	"pt_generic_side_jumpLand_A",	//standing right
	"pt_generic_side_jumpLand_B",	//standing left
	"pt_generic_side_jumpLand_C",	//sitting right
	"pt_generic_side_jumpLand_D" ]	//sitting left

	return anims
}
string[4] function DropOffAISide_GetDisperseAnims()
{
	string[4] anims = [
	"React_signal_thatway",	//standing right
	"React_spot_radio2",	//standing left
	"stand_2_run_45R",		//sitting right
	"stand_2_run_45L" ]		//sitting left

	return anims
}

float[4] function DropOffAISide_GetSeekTimes()
{
	float[4] anims = [
	9.75,	//standing right
	10.0,	//standing left
	10.5,	//sitting right
	11.25 ]	//sitting left

	return anims
}

vector function LocalPosToWorldPos( vector pos, entity ent )
{
	vector r = ent.GetRightVector()
	vector f = ent.GetForwardVector()
	vector u = ent.GetUpVector()

	vector localPos = ent.GetOrigin()

	vector x =  r * pos.x
	vector y =  f * pos.y
	vector z =  u * pos.z

	vector worldPos = localPos + x + y + z

	return worldPos
}

void function StopAnimOnAlert( entity guy )
{
	guy.EndSignal( "OnDeath" )

	OnThreadEnd(
	function() : ( guy )
		{
			if ( !IsAlive( guy ) )
				guy.Anim_Stop()
		}
	)

	while( 1 )
	{
		table result = WaitSignal( guy, "OnStateChange", "OnNoticePotentialEnemy" )

		if ( result.signal != "OnStateChange" )
			return

		string state = guy.GetNPCState()
		switch( state )
		{
			case "alert":
			case "combat":
				return
				break

			default:
				//do nothing
				break
		}
	}
}

void function GruntRunsToAndActivatesSpectreRack( entity guy, entity button )
{
	guy.EndSignal( "OnDeath" )
	if ( !button.GetUsableValue() )
		return

	vector x = button.GetRightVector() * -60
	vector z = button.GetUpVector() * -64
	vector origin = button.GetOrigin() + x + z
	vector angles = AnglesCompose( button.GetAngles(), < 0,-90,0 > )

	entity node = CreateScriptMover( origin, angles )
	node.SetParent( button, "", true )

	button.EndSignal( "OnActivate" )
	button.EndSignal( "OnPlayerUse" )
	thread DeactivateButtonOnPlayerUse( button )

	OnThreadEnd(
	function() : ( guy, node )
		{
			if ( IsValid( guy ) )
			{
				guy.ClearParent()
				StopSoundOnEntity( guy, "s2s_grunt_enter_code" )
			}

			if ( IsValid( node ) )
				node.Destroy()

			if ( IsAlive( guy ) )
			{
				guy.DisableNPCFlag( NPC_IGNORE_ALL )
				guy.Anim_Stop()
				guy.ClearMoveAnim()
				guy.SetAngles( <0,guy.GetAngles().y,0> )
			}
		}
	)

	guy.EnableNPCFlag( NPC_IGNORE_ALL )
	guy.SetMoveAnim( "sprint" )
	guy.Signal( "SpectreRack_RunningTo" )

	// HACK: hijacking this variable that is used for marvins so we don't add a new one
	guy.ai.carryBarrel = node

	guy.AssaultPointToAnimSetCallback( "AnimCallback_ActivateSpectreRack" )
	waitthread RunToAndPlayAnim( guy, "pt_titan_activation_crew", node, false )

	float soundTime = 0.3
	wait soundTime
	EmitSoundOnEntity( guy, "s2s_grunt_enter_code" )

	//anim time to touch the button
	wait 1.6 - soundTime
	DeactivateButton( button )

	foreach ( entity linkedEnt in button.GetLinkEntArray() )
 	{
 		if ( IsStalkerRack( linkedEnt ) )
 			thread SpawnFromStalkerRack( linkedEnt )
 	}

 	//anim time to stop and go back to normal
 	guy.Signal( "SpectreRack_Online" )
 	wait 1.2
}

void function DeactivateButtonOnPlayerUse( entity button )
{
	button.EndSignal( "OnDeactivate" )

	WaitSignal( button, "OnPlayerUse", "OnActivate" )
	thread DeactivateButton( button )
}

void function DeactivateButton( entity button )
{
	bool usesSkins
	switch( button.GetModelName() )
	{
		case $"models/props/global_access_panel_button/global_access_panel_button_wall.mdl":
		case $"models/props/global_access_panel_button/global_access_panel_button_console.mdl":
			usesSkins = true
			break
		default:
			usesSkins = false
			break
	}

	ScriptedSwitchDeactivate( button )
	Entity_StopFXArray( button )
	if ( usesSkins )
		button.SetSkin( 1 )
}

void function AnimCallback_ActivateSpectreRack( entity guy )
{
	entity node = guy.ai.carryBarrel

	if ( IsValid( node ) )
		guy.SetParent( node )

	guy.ClearMoveAnim()
	guy.Signal( "SpectreRack_PoweringUp" )
}

void function FlagSetOn_NumDead( string _flag, array<entity> guys, int numDead )
{
	waitthread WaitUntilNumDead( guys, numDead )
	FlagSet( _flag )
}

void function FlagSetOn_NumDeadWithTimeout( string _flag, array<entity> guys, int numDead, float timeout )
{
	waitthread WaitUntilNumDeadWithTimeout( guys, numDead, timeout )
	FlagSet( _flag )
}

void function FlagSetOn_AllDead( string _flag, array<entity> guys )
{
	waitthread WaitUntilAllDead( guys )
	FlagSet( _flag )
}

void function FlagSetOn_AllDeadWithTimeout( string _flag, array<entity> guys, float timeout )
{
	waitthread WaitUntilAllDeadWithTimeout( guys, timeout )
	FlagSet( _flag )
}

void function FlagSetOn_NumDeadOrLeeched( string _flag, array<entity> guys, int numDead )
{
	waitthread WaitUntilNumDeadOrLeeched( guys, numDead )
	FlagSet( _flag )
}

void function FlagSetOn_NumDeadOrLeechedWithTimeout( string _flag, array<entity> guys, int numDead, float timeout )
{
	waitthread WaitUntilNumDeadOrLeechedWithTimeout( guys, numDead, timeout )
	FlagSet( _flag )
}

void function FlagSetOn_AllDeadOrLeeched( string _flag, array<entity> guys )
{
	waitthread WaitUntilAllDeadOrLeeched( guys )
	FlagSet( _flag )
}

void function FlagSetOn_AllDeadOrLeechedWithTimeout( string _flag, array<entity> guys, float timeout )
{
	waitthread WaitUntilAllDeadOrLeechedWithTimeout( guys, timeout )
	FlagSet( _flag )
}

array<entity> function GetEnemiesClosest( string _class, vector origin, float dist )
{
	return ArrayClosest( GetNPCArrayEx( _class, TEAM_IMC, TEAM_MILITIA, origin, dist ), origin )
}

array<entity> function GetEnemiesFarthest( string _class, vector origin, float dist )
{
	return ArrayFarthest( GetNPCArrayEx( _class, TEAM_IMC, TEAM_MILITIA, origin, dist ), origin )
}

bool function GetMoDevState()
{
	return ( GetBugReproNum() == 1 )
}

void function CheckPointLoop( float interval, string ender )
{
	Signal( svGlobal.levelEnt, "CheckPointLoop" )
	thread CheckPointLoopThread( interval, ender )
}

void function CheckPointLoopThread( float interval, string ender )
{
	FlagEnd( ender )
	EndSignal( svGlobal.levelEnt, "CheckPointLoop" )

	while( 1 )
	{
		wait interval
		CheckPoint()
	}
}

/************************************************************************************************\

██████╗ ███████╗ ██████╗ ██████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗
██╔══██╗██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝
██████╔╝█████╗  ██║     ██║   ██║██████╔╝██║  ██║██║██╔██╗ ██║██║  ███╗
██╔══██╗██╔══╝  ██║     ██║   ██║██╔══██╗██║  ██║██║██║╚██╗██║██║   ██║
██║  ██║███████╗╚██████╗╚██████╔╝██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝
╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝

\************************************************************************************************/
void function PlayRecordedAnim( entity guy, var recording, vector origin = <0,0,0>, vector angles = <0,0,0>, entity ref = null, float blendTime = DEFAULT_SCRIPTED_ANIMATION_BLEND_TIME, float blendOutTime = 0.1 )
{
	guy.Signal( "PlayNewRecordedAnim" )
	guy.EndSignal( "PlayNewRecordedAnim" )
	guy.EndSignal( "RunToNewRecordedAnimStart" )

	Assert( IsAlive( guy ) )
	guy.EndSignal( "OnDeath" )

	guy.SetNextThinkNow()

	guy.PlayRecordedAnimation( recording, <0,0,0>, <0,0,0>, blendTime, ref )
	float duration = GetRecordedAnimationDuration( recording )

	printt( "PlayRecordedAnim: " + guy + ", " + recording + " (duration " + duration + " - " + blendOutTime + ")" )

	wait duration - blendOutTime
	

	printt( "PlayRecordedAnim finished: " + guy + ", " + recording + " (duration " + duration + " - " + blendOutTime + ")" )

	guy.Anim_Stop()
	guy.EndSignal( "OnAnimationDone" )

	//kills the jump jet fx
	int eHandle = guy.GetEncodedEHandle()
	array<entity> players = GetPlayerArray()
	foreach( player in players )
		Remote_CallFunction_NonReplay( player, "ServerCallback_SignalAnimDone", eHandle )
}

void function RunToRecordedAnimStart( entity guy, var recording, vector origin = <0,0,0>, vector angles = <0,0,0>, entity ref = null, bool disableArrival = true )
{
	guy.Signal( "RunToNewRecordedAnimStart" )
	guy.EndSignal( "PlayNewRecordedAnim" )
	guy.EndSignal( "RunToNewRecordedAnimStart" )

	Assert( IsAlive( guy ) )
	guy.Anim_Stop() // in case we were doing an anim already
	guy.EndSignal( "OnDeath" )

	bool allowFlee 			= guy.GetNPCFlag( NPC_ALLOW_FLEE )
	bool allowHandSignal 	= guy.GetNPCFlag( NPC_ALLOW_HAND_SIGNALS )
	bool allowArrivals 		= guy.GetNPCMoveFlag( NPCMF_DISABLE_ARRIVALS )

	if ( disableArrival )
		guy.EnableNPCMoveFlag( NPCMF_DISABLE_ARRIVALS )

	guy.DisableNPCFlag( NPC_ALLOW_FLEE | NPC_ALLOW_HAND_SIGNALS )

	if ( ref != null )
	{
		origin = ref.GetOrigin() + origin
		angles = ref.GetAngles() + angles
	}

	vector animStartPos = GetRecordedAnimationStartForRefPoint( recording, origin, angles )

	float goalRadius 		= guy.AssaultGetGoalRadius()
	float fightRadius 		= guy.AssaultGetFightRadius()
	float arrivalTolerance 	= guy.AssaultGetArrivalTolerance()
	float runtoRadius = 71.16
	guy.AssaultSetGoalRadius( runtoRadius )
	guy.AssaultSetFightRadius( runtoRadius )
	guy.AssaultSetArrivalTolerance( runtoRadius )

	bool savedEnableFriendlyFollower 	= guy.ai.enableFriendlyFollower
	guy.ai.enableFriendlyFollower 		= false

	guy.AssaultPoint( animStartPos )

	//DebugDrawLine( guy.GetOrigin(), animStartPos, 255, 0, 0, true, 20.0 )
	WaitSignal( guy, "OnFinishedAssault" )

	guy.DisableBehavior( "Assault" )

	//in case the scripter reset during run, we want to honor the intended change
	if ( guy.AssaultGetGoalRadius() == runtoRadius )
		guy.AssaultSetGoalRadius( goalRadius )

	if ( guy.AssaultGetFightRadius() == runtoRadius )
		guy.AssaultSetFightRadius( fightRadius )

	if ( guy.AssaultGetArrivalTolerance() == runtoRadius )
		guy.AssaultSetArrivalTolerance( arrivalTolerance )

	guy.SetNPCFlag( NPC_ALLOW_FLEE, allowFlee )
	guy.SetNPCFlag( NPC_ALLOW_HAND_SIGNALS, allowHandSignal )
	guy.SetNPCMoveFlag( NPCMF_DISABLE_ARRIVALS, allowArrivals )

	guy.ai.enableFriendlyFollower = savedEnableFriendlyFollower
}


void function Hack_StopDraconis( vector angles = CONVOYDIR )
{
	ShipStruct ship = gf().OLA
	ship.customPos = angles
	DoCustomBehavior( ship, Hack_StopShip )
}

void function Hack_StopMalta( vector angles = CONVOYDIR )
{
	ShipStruct ship = gf().malta
	ship.customPos = angles
	DoCustomBehavior( ship, Hack_StopShip )
}

void function Hack_StopBarker( vector angles = CONVOYDIR )
{
	ShipStruct ship = gf().barkership
	ship.customPos = angles
	DoCustomBehavior( ship, Hack_StopShip )
}

void function Hack_StopTrinity( vector angles = CONVOYDIR )
{
	ShipStruct ship = gf().trinity
	ship.customPos = angles
	DoCustomBehavior( ship, Hack_StopShip )
}

void function Hack_StopGibraltar( vector angles = CONVOYDIR )
{
	ShipStruct ship = gf().gibraltar
	ship.customPos = angles
	DoCustomBehavior( ship, Hack_StopShip )
}

void function Hack_StopShip( ShipStruct ship )
{
	FlagClear( "DriftWorldCenter" )
	ship.mover.NonPhysicsStop()
	ship.mover.SetAngles( ship.customPos )
	SetOriginLocal( ship.mover, GetOriginLocal( ship.mover ) )
	WaitForever()
}

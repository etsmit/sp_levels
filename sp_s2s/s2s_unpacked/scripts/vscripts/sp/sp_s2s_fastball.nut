untyped

global function S2S_Fastball_AimingMode
global function GetFastBallTarget
global function BT_FastBall_Prompt
global function FastBallPlayerInit
global function BlackholePlayerToShip
global function GetMovingTargetFastballDuration
global function GetMovingTargetFastballVelocity
global function GraphTrajectory

global function S2S_FastballInit
void function S2S_FastballInit()
{
	RegisterSignal( "PME_TouchGround" )
	RegisterSignal( "PME_Mantle" )
	RegisterSignal( "PME_BeginWallrun" )
	RegisterSignal( "PME_BeginWallhang" )
	RegisterSignal( "PME_EndWallrun" )
	RegisterSignal( "PME_EndWallhang" )
	FlagInit( "PlayerWallRunning" )
}

void function PlayerMovementEvent_TouchGround( entity player )
{
	player.Signal( "PME_TouchGround" )
}

void function PlayerMovementEvent_Mantle( entity player )
{
	player.Signal( "PME_Mantle" )
}

void function PlayerMovementEvent_BeginWallrun( entity player )
{
	player.Signal( "PME_BeginWallrun" )
	FlagSet( "PlayerWallRunning" )
}

void function PlayerMovementEvent_BeginWallhang( entity player )
{
	player.Signal( "PME_BeginWallhang" )
	FlagSet( "PlayerWallRunning" )
}

void function PlayerMovementEvent_EndWallrun( entity player )
{
	player.Signal( "PME_EndWallrun" )
	FlagClear( "PlayerWallRunning" )
}

void function PlayerMovementEvent_EndWallhang( entity player )
{
	player.Signal( "PME_EndWallhang" )
	FlagClear( "PlayerWallRunning" )
}

void function FastBallPlayerInit( entity player )
{
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, 	PlayerMovementEvent_TouchGround )
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.MANTLE, 			PlayerMovementEvent_Mantle )
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLRUN, 	PlayerMovementEvent_BeginWallrun )
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLHANG, 	PlayerMovementEvent_BeginWallhang )
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.END_WALLRUN, 		PlayerMovementEvent_EndWallrun )
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.END_WALLHANG, 	PlayerMovementEvent_EndWallhang )
}

/************************************************************************************************\

########    ###     ######  ######## ########     ###    ##       ##
##         ## ##   ##    ##    ##    ##     ##   ## ##   ##       ##
##        ##   ##  ##          ##    ##     ##  ##   ##  ##       ##
######   ##     ##  ######     ##    ########  ##     ## ##       ##
##       #########       ##    ##    ##     ## ######### ##       ##
##       ##     ## ##    ##    ##    ##     ## ##     ## ##       ##
##       ##     ##  ######     ##    ########  ##     ## ######## ########

\************************************************************************************************/
void function BT_FastBall_Prompt( entity titan )
{
	titan.EndSignal( "OnDestroy" )

	while( 1 )
	{
		FlagWait( "FastballEnabled" )
			titan.SetUsePrompts( "#HOLD_TO_EMBARK_WITH_FASTBALL", "#PRESS_TO_EMBARK_WITH_FASTBALL" )
		FlagWaitClear( "FastballEnabled" )
			titan.SetUsePrompts( "#HOLD_TO_EMBARK", "#PRESS_TO_EMBARK" )
	}
}

void function S2S_Fastball_AimingMode( entity player, entity titan )
{
	EndSignal( player, "OnDeath" )
	EndSignal( titan, "OnDestroy" )
	EndSignal( player, "player_embarks_titan" )
	EndSignal( player, "FastballCancel" )

	int ogTitanMode = player.GetPetTitanMode()
	vector ogTitanOrg = titan.GetOrigin()
	vector playerViewVector = player.GetViewVector()
	float playerYaw = VectorToAngles( playerViewVector ).y

	titan.SetAngles( Vector( 0, playerYaw, 0 ) )
	entity mover = CreateScriptMover( titan.GetOrigin(), titan.GetAngles() )
	mover.SetAngles( Vector( 0, titan.GetAngles().y, 0 ) )
	titan.SetParent( mover )
	//titan.MarkAsNonMovingAttachment()
	player.SetParent( titan, "FASTBALL", false )
	thread PlayAnim( titan, "bt_FastBall_Pose", mover, "REF" )

	int attachID = titan.LookupAttachment( "FASTBALL" )
	vector tagAngles = titan.GetAttachmentAngles( attachID )

	player.PlayerCone_SetSpecific( AnglesToForward( tagAngles ) )
	player.PlayerCone_SetMinYaw( 0 )
	player.PlayerCone_SetMaxYaw( 0 )
	player.PlayerCone_SetMinPitch( 0 )
	player.PlayerCone_SetMaxPitch( 0 )
	wait 0.3
/*	player.PlayerCone_SetMinYaw( -10 )
	player.PlayerCone_SetMaxYaw( 10 )
	player.PlayerCone_SetMinPitch( -10 )
	player.PlayerCone_SetMaxPitch( 10 )*/
	player.PlayerCone_SetMinYaw( -180 )
	player.PlayerCone_SetMaxYaw( 180 )
	player.PlayerCone_SetMinPitch( -30 )
	player.PlayerCone_SetMaxPitch( 10 )

	OnThreadEnd(
		function() : ( player, titan, mover, ogTitanMode, ogTitanOrg )
		{
			if ( IsValid( player ) )
			{
				player.ClearParent()
				player.SetLocalAngles( player.EyeAngles() )
				player.PlayerCone_Disable()
				player.SetPetTitanMode( ogTitanMode )  // HACK he forgets about guard mode after anim stops
				player.EnableWeapon()
				//player.nv.drawFastballHud = false

				// clear help message
				Dev_PrintMessage( player, "", "", 0.1 )
			}

			if ( IsValid( titan ) )
			{
				titan.ClearParent()
				titan.Anim_Stop()

				// Watch the player as he flies
				if ( IsValid( player ) && IsAlive( titan ))
					thread AssaultOrigin( titan, ogTitanOrg )
			}

			if ( IsValid( mover ) )
			{
				mover.ClearParent()
				mover.Destroy()
			}
		}
	)

	if ( !( "helpShown_THROW" in player.s ) )
	{
		Dev_PrintMessage( player, "", "Aim where you want to be thrown, then pull the trigger." )
		player.s.helpShown_THROW <- true
	}

	// Draw the hud
	//player.nv.drawFastballHud = true

	// Disable weapon
	player.DisableWeapon()

	//if ( GetBugReproNum() == 110567 )
	//	thread TitanRotateForAiming( mover, titan, player )

	// Wait till player is thrown. Then this thread will end and the think function will resume
	while( 1 )
	{
		thread FastBallHud( player )
		WaitSignal( player, "FastballLaunch" )
		if ( GetFastBallTarget( player ) != null )
			break
	}

	thread FastballThrowPlayer( player )
}

ShipStruct ornull function GetFastBallTarget( entity player )
{
	array<ShipStruct> ships = GetActiveGoblins()
	if ( !ships.len() )
		return null

	vector viewVec 	= player.GetViewVector()
	vector eyePos 	= player.EyePosition()
	float  bestDot 	= -2.0

	vector dir
	float dot
	ShipStruct bestTarget
	foreach ( ship in ships )
	{
		dir = Normalize( ship.model.GetOrigin() - eyePos )
		dot = DotProduct( dir, viewVec )

		if ( dot > bestDot )
		{
			bestDot = dot
			bestTarget = ship
		}
	}

	if ( bestDot < 0.98 )
		return null

	return bestTarget
}

struct FBHUDStruct {
	ShipStruct ornull target
	ShipStruct ornull oldtarget
}

void function FastBallHud( entity player )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "player_embarks_titan" )
	EndSignal( player, "FastballCancel" )
	EndSignal( player, "FastballLaunch" )

	FBHUDStruct hud
	int contextId = 0

	OnThreadEnd(
	function() : ( contextId, hud )
		{
			if ( hud.oldtarget != null )
			{
				ShipStruct ornull oldtargetcopy = hud.oldtarget
				expect ShipStruct( oldtargetcopy )
				oldtargetcopy.model.Highlight_SetFunctions( contextId, 0, true, 0, 1, 0, false )

			}
		}
	)

	while ( 1 )
	{
		wait 0.1

		if ( hud.oldtarget != null )
		{
			ShipStruct ornull oldtargetcopy = hud.oldtarget
			expect ShipStruct( oldtargetcopy )
			oldtargetcopy.model.Highlight_SetFunctions( contextId, 0, true, 0, 1, 0, false )
		}

		hud.target = GetFastBallTarget( player )

		if ( hud.target == null )
			continue

		ShipStruct ornull targetcopy = hud.target
		expect ShipStruct( targetcopy )


		targetcopy.model.Highlight_SetFunctions( contextId, 103, true, 101, 4, 0, false )
		targetcopy.model.Highlight_SetParam( contextId, 0, HIGHLIGHT_COLOR_INTERACT )
		targetcopy.model.Highlight_SetParam( contextId, 1, HIGHLIGHT_COLOR_INTERACT )
		targetcopy.model.Highlight_SetCurrentContext( contextId )
		targetcopy.model.Highlight_ShowOutline( 0.0 )
		targetcopy.model.Highlight_ShowInside( 0.0 )


		hud.oldtarget = hud.target
	}
}

function FastballThrowPlayer( entity player )
{
	ShipStruct ornull target = GetFastBallTarget( player )
	Assert( target != null )
	expect ShipStruct( target )

	thread BlackholePlayerToShip( player, target.model )
}

vector function GetMovingTargetFastballVelocity( entity player, entity throwTarget )
{
	float throwDuration = GetMovingTargetFastballDuration( player, throwTarget )
	vector endPos = throwTarget.GetOrigin() + ( throwTarget.GetVelocity() * throwDuration )
	vector throwVelocity = GetPlayerVelocityForDestOverTime( player.GetOrigin(), endPos, throwDuration )

	return throwVelocity
}

float function GetMovingTargetFastballDuration( entity player, entity throwTarget )
{
	float speed = 1200 //1200 units / s
	float throwDist = Distance( player.GetOrigin(), throwTarget.GetOrigin() )
	float throwDuration = throwDist / speed

	vector targetVelocity = throwTarget.GetVelocity()
	throwDist = Distance( player.GetOrigin(), throwTarget.GetOrigin() + ( targetVelocity * throwDuration ) )
	throwDuration = throwDist / speed

	return throwDuration
}

void function BlackholePlayerToShip( entity player, entity target, float stopTime = 0.2 )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	target.EndSignal( "OnDeath" )
	target.EndSignal( "OnDestroy" )
	target.EndSignal( "FakeDestroy" )

	player.EndSignal( "PME_TouchGround" )
	player.EndSignal( "PME_Mantle" )
	player.EndSignal( "PME_BeginWallrun" )
	player.EndSignal( "PME_BeginWallhang" )

	array mods = [ "disable_doublejump" ]
	player.SetPlayerSettingsWithMods( DEFAULT_PILOT_SETTINGS, mods )

	OnThreadEnd(
	function() : ( player )
		{
			if ( IsValid( player ) )
				player.SetPlayerSettings( DEFAULT_PILOT_SETTINGS )
		}
	)

	float time 			= GetMovingTargetFastballDuration( player, target )
	float endTime 		= Time() + time

	while( 1 )
	{
		if ( player.GetParent() )
			return

		float timeLeft = endTime - Time()
		if ( timeLeft <= stopTime )
			return

		vector endPos = target.GetOrigin() + ( target.GetVelocity() * max( 0, ( timeLeft * 0.75 ) - FRAME_INTERVAL ) )
		vector velocity = GetPlayerVelocityForDestOverTime( player.GetOrigin(), endPos, timeLeft )
		player.SetVelocity( velocity )

		#if DEV
			if ( GetMoDevState() )
			{
				DebugDrawLine( target.GetOrigin(), endPos, 0, 0, 255, true, 0.15 )
				DebugDrawCircle( endPos, <0,0,0>, 32, 0, 0, 255, true, 0.15, 6  )
				DebugDrawText( endPos, "vel: " + target.GetVelocity(), true, 0.15 )
				GraphTrajectory( player.GetOrigin(), velocity )
			}
		#endif
		WaitFrame()
	}
}

vector function Fastball_GetThrowStartPos( entity player )
{
	return player.EyePosition() + Vector( 0, 0, -2 )
}

void function GraphTrajectory( vector startPos, vector velocity )
{
	vector oldpos = startPos

	float interval = 0.05
	int cycles = 50
	for ( int i = 0; i < cycles; i++ )
	{
		float time = interval * i
		float drop = GetFallDistanceAtTime( time )
		vector delta = ( velocity * time )
		vector pos = startPos + delta - Vector(0,0,drop)

		DebugDrawLine( oldpos, pos, 255, 150, 50, true, 0.15 )
		oldpos = pos
	}
}

const float GRAVITY = 750.0//750.0//384.0
float function GetFallDistanceAtTime( float time )
{
	return 0.5 * GRAVITY * ( pow( time, 2 ) )
}
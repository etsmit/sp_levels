global function S2S_FSMInit
global function RunBehaviorFiniteStateMachine
global function AddShipBehavior
global function ShipBehaviorExists
global function ClearShipBehavior
global function ClearAllShipBehaviors
global function ResetAllBehaviorsToDefault
global function ResetBehaviorToDefault
global function SetBehavior
global function SetPreviousBehavior
global function DevBehaviorPrint
global function Custom_FlyToPos
global function Custom_IdleAtTarget
global function Custom_IdleAtTarget_Method2
global function Custom_IdleUnderTarget
global function DoCustomBehavior
global function DoPreviousBehavior
global function Behavior_LeaveBattleField

void function S2S_FSMInit()
{

}

int function GetBehaviorPriority( int behavior )
{
	switch( behavior )
	{
		case eBehavior.NONE:
			return 0

		case eBehavior.IDLE:
		case eBehavior.ENEMY_CHASE:
		case eBehavior.DEPLOY:
		case eBehavior.DEPLOYZIP:
		case eBehavior.ENGINE_FAILURE:
			return 10

		case eBehavior.CREW_DEPLOYED:
		case eBehavior.CREW_DEAD:
		case eBehavior.LEAVING:
			return 30

		case eBehavior.ENEMY_ONBOARD:
			return 40

		case eBehavior.CUSTOM:
			return 50

		case eBehavior.DEATH_ANIM:
			return 100

		default:
			Assert( 0, "behavior does not exist" )
			return -1
	}
	unreachable
}

void function DefaultBehavior_Common( ShipStruct ship, int behavior )
{
	switch ( behavior )
	{
		case eBehavior.NONE:
			AddShipBehavior( ship, behavior, Behavior_None )
			break

		case eBehavior.IDLE:
			SetFlyBounds( ship, behavior, < 500, 500, 500 > )
			AddShipBehavior( ship, behavior, Behavior_Idle )
			break

		case eBehavior.CREW_DEPLOYED:
		case eBehavior.CREW_DEAD:
		case eBehavior.LEAVING:
			SetFlyOffset( ship, behavior, < 2100, -450, 800 > )
			AddShipBehavior( ship, behavior, Behavior_LeaveBattleField )
			break

		case eBehavior.CUSTOM:
			AddShipBehavior( ship, behavior, Behavior_Custom )
			break
	}
}

/************************************************************************************************\

███████╗███████╗███╗   ███╗
██╔════╝██╔════╝████╗ ████║
█████╗  ███████╗██╔████╔██║
██╔══╝  ╚════██║██║╚██╔╝██║
██║     ███████║██║ ╚═╝ ██║
╚═╝     ╚══════╝╚═╝     ╚═╝

\************************************************************************************************/
void function RunBehaviorFiniteStateMachine( ShipStruct ship )
{
	ship.model.EndSignal( "OnDestroy" )
	EndSignal( ship, "FakeDeath" )
	EndSignal( ship, "FakeDestroy" )

	while( 1 )
	{
		table result = WaitSignal( ship,	"engineFailure",
										"PlayerOnBoard",
										"PlayerOffBoard",
										"pilotDead",
										"engineFailure_Complete",
										"crewDead",
										"crewDeployed",
										"returnToPrevBehavior" )

		int setBehave = eBehavior.INVALID
		int curBehave = ship.behavior
		switch( result.signal )
		{
			case "pilotDead":
			case "engineFailure_Complete":
				setBehave = eBehavior.DEATH_ANIM
				break

			case "crewDead":
				setBehave = eBehavior.CREW_DEAD
				break

			case "crewDeployed":
				setBehave = eBehavior.CREW_DEPLOYED
				break

			case "engineFailure":
				setBehave = eBehavior.ENGINE_FAILURE
				break

			case "PlayerOnBoard":
				setBehave = eBehavior.ENEMY_ONBOARD
				break

			case "PlayerOffBoard":
				if ( ship.behavior == eBehavior.ENEMY_ONBOARD )
					setBehave = eBehavior.DOPREVIOUS
				else
					continue
				break

			case "returnToPrevBehavior":
				setBehave = eBehavior.DOPREVIOUS
				break

		}

		Assert( setBehave != eBehavior.INVALID, "invalid behavior for " + ship.model.GetScriptName() )
		if ( setBehave == eBehavior.DOPREVIOUS )
			DoPreviousBehavior( ship )
		else if ( ShipBehaviorExists( ship, setBehave ) )
			SetBehaviorBasedOnPriority( ship, setBehave )
	}
}

void function __UpdateFiniteStateMachineThread( ShipStruct ship )
{
	Signal( ship, "NewBehavior" )
	EndSignal( ship, "NewBehavior" )
	EndSignal( ship, "FakeDeath" )
	EndSignal( ship, "FakeDestroy" )

	Assert( ship.behavior in ship.behaviorTable, "behavior [ " + ship.behavior + " ] not setup" )
	void functionref( ShipStruct ) behaviorFunc = ship.behaviorTable[ ship.behavior ]
	behaviorFunc( ship )
}

void function DevBehaviorPrint( ShipStruct ship, entity mover )
{
	if ( !DEV_PRINTBEHAVIOR )
		return

	string strBehave = ""

	switch ( ship.behavior )
	{
		case eBehavior.NONE:
			strBehave += "eBehavior.NONE"
			break

		case eBehavior.IDLE:
			strBehave += "eBehavior.IDLE"
			break

		case eBehavior.CUSTOM:
			strBehave += string( ship.customBehaviorFunc )
			break

		case eBehavior.ENEMY_CHASE:
			strBehave += "eBehavior.ENEMY_CHASE"
			break

		case eBehavior.DEPLOY:
			strBehave += "eBehavior.DEPLOY"
			break

		case eBehavior.DEPLOYZIP:
			strBehave += "eBehavior.DEPLOYZIP"
			break

		case eBehavior.ENEMY_ONBOARD:
			strBehave += "eBehavior.ENEMY_ONBOARD"
			break

		case eBehavior.ENGINE_FAILURE:
			strBehave += "eBehavior.ENGINE_FAILURE"
			break

		case eBehavior.CREW_DEAD:
			strBehave += "eBehavior.CREW_DEAD"
			break

		case eBehavior.CREW_DEPLOYED:
			strBehave += "eBehavior.CREW_DEPLOYED"
			break

		case eBehavior.LEAVING:
			strBehave += "eBehavior.LEAVING"
			break

		case eBehavior.DEATH_ANIM:
			strBehave += "eBehavior.DEATH_ANIM"
			break

		default:
			strBehave += "eBehavior - NOT SETUP"
			break
	}
	DebugDrawText( mover.GetOrigin() + < 0,0,150>, "" + strBehave, true, FRAME_INTERVAL )

}

/************************************************************************************************\

██████╗ ███████╗██╗  ██╗ █████╗ ██╗   ██╗██╗ ██████╗ ██████╗
██╔══██╗██╔════╝██║  ██║██╔══██╗██║   ██║██║██╔═══██╗██╔══██╗
██████╔╝█████╗  ███████║███████║██║   ██║██║██║   ██║██████╔╝
██╔══██╗██╔══╝  ██╔══██║██╔══██║╚██╗ ██╔╝██║██║   ██║██╔══██╗
██████╔╝███████╗██║  ██║██║  ██║ ╚████╔╝ ██║╚██████╔╝██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝

\************************************************************************************************/
void function Behavior_None( ShipStruct ship )
{

}

void function Behavior_Idle( ShipStruct ship )
{
	int behavior 	= ship.behavior
	vector bounds 	= ship.flyBounds[ behavior ]
	vector pos 		= GetOriginLocal( ship.mover ).v
	vector offset 	= <0,0,0>
	entity target 	= null

	__ShipIdleAtTarget( ship, target, pos, bounds, offset )
}

void function Behavior_LeaveBattleField( ShipStruct ship )
{
	entity mover 	= ship.mover
	mover.EndSignal( "OnDestroy" )

	float rightOfTarget = GetBestRightOfTargetForLeaving( ship )

	int behavior 	= ship.behavior
	vector flyOffset = ship.flyOffset[ behavior ]

	LocalVec pos = CLVec( GetOriginLocal( mover ).v + < flyOffset.x * rightOfTarget,flyOffset.y,flyOffset.z > )
	entity noFollowTarget = null
	vector offset = <0,0,0>
	thread __ShipFlyToPosInternal( ship, noFollowTarget, pos, offset, CONVOYDIR )
	ship.goalRadius = 600
	WaitSignal( ship, "Goal" )

	SetMaxSpeed( ship, 3500, 1.0 )
	SetMaxAcc( ship, 400, 1.0 )
	pos = CLVec( GetOriginLocal( mover ).v + < flyOffset.x * rightOfTarget * 2, -50000, 2000 > )

	thread __ShipFlyToPosInternal( ship, noFollowTarget, pos, offset, CONVOYDIR )
	ship.goalRadius = 2000

	WaitSignal( ship, "Goal" )
	thread FakeDestroy( ship )
}

void function Behavior_Custom( ShipStruct ship )
{
	ship.customBehaviorFunc( ship )
	Signal( ship, "returnToPrevBehavior" )
}

void function Custom_FlyToPos( ShipStruct ship )
{
	entity target 	= ship.customEnt
	LocalVec pos 	= CLVec( ship.customPos )
	vector angles	= ship.customAng
	vector offset 	= ship.flyOffset[ eBehavior.CUSTOM ]

	__ShipFlyToPosInternal( ship, target, pos, offset, angles )
}

void function Custom_IdleAtTarget( ShipStruct ship )
{
	vector bounds 	= ship.flyBounds[ eBehavior.CUSTOM ]
	entity target 	= ship.customEnt
	vector pos 		= ship.customPos
	vector offset 	= ship.flyOffset[ eBehavior.CUSTOM ]

	__ShipIdleAtTarget( ship, target, pos, bounds, offset )
}

void function Custom_IdleAtTarget_Method2( ShipStruct ship )
{
	vector bounds 	= ship.flyBounds[ eBehavior.CUSTOM ]
	entity target 	= ship.customEnt
	vector pos 		= ship.customPos
	vector offset 	= ship.flyOffset[ eBehavior.CUSTOM ]

	__ShipIdleAtTarget_Method2( ship, target, pos, bounds, offset )
}

void function Custom_IdleUnderTarget( ShipStruct ship )
{
	vector bounds 	= ship.flyBounds[ eBehavior.CUSTOM ]
	entity target 	= ship.customEnt
	vector pos 		= ship.customPos

	__ShipIdleUnderTarget( ship, target, pos, bounds )
}

/************************************************************************************************\

██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗   ██╗
██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝╚██╗ ██╔╝
██║   ██║   ██║   ██║██║     ██║   ██║    ╚████╔╝
██║   ██║   ██║   ██║██║     ██║   ██║     ╚██╔╝
╚██████╔╝   ██║   ██║███████╗██║   ██║      ██║
 ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝

\************************************************************************************************/
void function AddShipBehavior( ShipStruct ship, int behavior, void functionref( ShipStruct ) behaviorFunc )
{
	Assert( !( behavior in ship.behaviorTable ), "behavior [ " + behavior + " ] already exists" )
	ship.behaviorTable[ behavior ] <- behaviorFunc
}

bool function ShipBehaviorExists( ShipStruct ship, int behavior )
{
	return ( behavior in ship.behaviorTable )
}

void function ClearShipBehavior( ShipStruct ship, int behavior )
{
	Assert( behavior in ship.behaviorTable, "behavior [ " + behavior + " ] does not exist" )
	delete ship.behaviorTable[ behavior ]
}

void function ClearAllShipBehaviors( ShipStruct ship )
{
	ship.behaviorTable = {}
}

void function ResetBehaviorToDefault( ShipStruct ship, int behavior )
{
	if ( ShipBehaviorExists( ship, behavior ) )
		ClearShipBehavior( ship, behavior )

	DefaultBehavior_Common( ship, behavior )
	ship.defaultBehaviorFunc( ship, behavior )
}

void function ResetAllBehaviorsToDefault( ShipStruct ship )
{
	ClearAllShipBehaviors( ship )

	for ( int behavior = 0; behavior < eBehavior.NUM_BEHAVIORS; behavior++ )
		ResetBehaviorToDefault( ship, behavior )
}

void function SetBehavior( ShipStruct ship, int behavior )
{
	Assert( ship.behavior != behavior )
	Assert( ShipBehaviorExists( ship, behavior ), "behavior: " + behavior + " does not exist for " + ship.model.GetScriptName() )

	__SetBehaviorInternal( ship, behavior )
}

void function SetBehaviorBasedOnPriority( ShipStruct ship, int behavior )
{
	if ( ship.behavior == behavior )
		return

	if ( GetBehaviorPriority( behavior ) < GetBehaviorPriority( ship.behavior ) )
	{
		//at least see if the priority of this behavior is heigher than the prev and replace that
		if ( GetBehaviorPriority( behavior ) > GetBehaviorPriority( ship.prevBehavior[0] ) && behavior != ship.prevBehavior[0] )
			ArrayPush( ship.prevBehavior, behavior )

		return
	}

	__SetBehaviorInternal( ship, behavior )
}

void function DoPreviousBehavior( ShipStruct ship )
{
	int behavior
	while( 1 )
	{
		Assert( ship.prevBehavior.len() )
		behavior = ArrayPop( ship.prevBehavior )

		if ( ship.behavior != behavior )
			break
	}

	__SetBehaviorInternal( ship, behavior )
}

void function __SetBehaviorInternal( ShipStruct ship, int behavior )
{
	if ( ship.behavior != eBehavior.CUSTOM )
		ArrayPush( ship.prevBehavior, ship.behavior )

	ship.behavior = behavior
	thread __UpdateFiniteStateMachineThread( ship )
}

void function SetPreviousBehavior( ShipStruct ship, int behavior )
{
	ArrayPush( ship.prevBehavior, behavior )
}

void function ArrayPush( array<int> list, int value )
{
	list.insert( 0, value )
}

int function ArrayPop( array<int> list )
{
	int value = list[ 0 ]
	list.remove( 0 )
	return value
}

void function DoCustomBehavior( ShipStruct ship, void functionref( ShipStruct ) customFunc )
{
	ship.customBehaviorFunc = customFunc
	__SetBehaviorInternal( ship, eBehavior.CUSTOM )
}
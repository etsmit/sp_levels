
global function ClientCodeCallback_MapInit
global function VMTCallback_HeatSinkGlow
global function VMTCallback_HeatSinkTemp

const float HEAT_SINK_COOL_TIME = 6.0
const float HEAT_SINK_COOL_DELAY = 3.0

const float HEAT_SINK_HEAT_TIME = 5.0
const float HEAT_SINK_HEAT_DELAY = 1.0

const float HEAT_SINK_TEMP_MIN = 89
const float HEAT_SINK_TEMP_MAX = 97

void function ClientCodeCallback_MapInit()
{
	ShSpBeaconSpoke0CommonInit()
	ShBeaconCommonInit()
	thread PlayerInFanRumble()
}

var function VMTCallback_HeatSinkGlow( entity player )
{
	return GetHeatSinkFrac()
}

var function VMTCallback_HeatSinkTemp( entity player )
{
	return GraphCapped( GetHeatSinkFrac(), 0.0, 1.0, HEAT_SINK_TEMP_MIN, HEAT_SINK_TEMP_MAX )
}

float function GetHeatSinkFrac()
{
	if ( level.nv.heatSinksCooling )
		return GraphCapped( Time(), expect float(level.nv.heatSinkStartTime) + HEAT_SINK_COOL_DELAY, expect float(level.nv.heatSinkStartTime) + HEAT_SINK_COOL_TIME + HEAT_SINK_COOL_DELAY, 1.0, 0.0 )
	else
		return GraphCapped( Time(), expect float(level.nv.heatSinkStartTime) + HEAT_SINK_HEAT_DELAY, expect float(level.nv.heatSinkStartTime) + HEAT_SINK_HEAT_TIME + HEAT_SINK_HEAT_DELAY, 0.0, 1.0 )
	unreachable
}

void function PlayerInFanRumble()
{
	entity player
	float strength
	while( true )
	{
		wait 0.1

		player = GetLocalClientPlayer()
		if ( !IsValid( player ) )
			continue

		strength = player.GetPlayerNetFloat( "FanRumbleStrength" )

		if ( strength >= 0.9 )
			Rumble_Play( "beacon_spoke0_fan_push_high", { position = player.GetOrigin() } )
		else if ( strength >= 0.5 )
			Rumble_Play( "beacon_spoke0_fan_push_med", { position = player.GetOrigin() } )
		else if ( strength > 0.2 )
			Rumble_Play( "beacon_spoke0_fan_push_low", { position = player.GetOrigin() } )
	}
}
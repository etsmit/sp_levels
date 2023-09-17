
global function ClBoomtownCommonInit
global function ServerCallback_BoomtownScreenShake
global function ServerCallback_BoomtownSetCSMStartDistance
global function ServerCallback_BoomtownSetCSMTexelScale
global function ServerCallback_ReaperTownTeleport


void function ClBoomtownCommonInit()
{
	InitBoomtownDialogue()
}


void function ServerCallback_BoomtownScreenShake( float amplitude, float frequency, float duration )
{
	entity player = GetLocalClientPlayer()

	if ( !IsAlive( player ) )
		return

	ClientScreenShake( amplitude, frequency, duration, Vector( 0,0,0 ) )
}


void function ServerCallback_BoomtownSetCSMStartDistance( float distance )
{
 	SetMapSetting_CsmStartDistance( distance )
}


void function ServerCallback_BoomtownSetCSMTexelScale( float nearScale, float farScale )
{
	printt("ServerCallback_BoomtownSetCSMTexelScale - nearScale:", nearScale, ", farScale:", farScale )

 	SetMapSetting_CsmTexelScale( nearScale, farScale )
}


void function ServerCallback_ReaperTownTeleport()
{
	thread DoTeleportExposureSequence()
}


void function DoTeleportExposureSequence()
{
	AdjustAutoExposureOverTime( 0, -10, 1.0 )
	wait 1.0
	AdjustAutoExposureOverTime( -10, -5, 1.0 )
	wait 3.0
	AdjustAutoExposureOverTime( -5, 0, 5.5 )
}


void function AdjustAutoExposureOverTime( float startTone = 1, float endTone = 0, float duration = 1.0 )
{
	AutoExposureSetMinExposureMultiplier(0)

	float START_DURATION = duration
	float TONEMAP_MAX = startTone
	float TONEMAP_MIN = endTone

	float startTime = Time()
	while( 1 )
	{
		float time = Time() - startTime
		float factor = GraphCapped( time, 0, START_DURATION, 1, 0 )
		float toneMapScale = TONEMAP_MIN + (TONEMAP_MAX - TONEMAP_MIN) * factor

		AutoExposureSetExposureCompensationBias( toneMapScale )
		AutoExposureSnap()

		WaitFrame()

		if ( factor == 0 )
			break;
	}
}

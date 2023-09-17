
global function Score_Init

global function AddPlayerScore

global function ScoreEvent_TitanDoomed
global function ScoreEvent_TitanKilled
global function ScoreEvent_PlayerKilled
global function ScoreEvent_NPCKilled

global function PreScoreEventUpdateStats
global function PostScoreEventUpdateStats

global function SavedFromRodeo

void function Score_Init()
{
}

void function AddPlayerScore( entity player, string scoreEventName, entity targetEnt = null, int pointValueOverride = 0 )
{
}

void function ScoreEvent_TitanDoomed( entity titan, entity attacker, var damageInfo )
{
}

void function ScoreEvent_TitanKilled( entity titan, entity attacker, var damageInfo )
{
}

void function ScoreEvent_PlayerKilled( entity player, entity attacker, var damageInfo )
{
}

void function ScoreEvent_NPCKilled( entity npc, entity attacker, var damageInfo )
{
}

void function PreScoreEventUpdateStats( entity victim, entity attacker )
{
}

void function PostScoreEventUpdateStats( entity victim, entity attacker )
{
}


bool function SavedFromRodeo( entity rodeoPlayer, entity attacker )
{
	return false
}
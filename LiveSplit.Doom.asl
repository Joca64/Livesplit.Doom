//gamestate - 0: playing level, 1: intermission, 2: episode/game end screen, 3: menu

state("glboom-plus")
{
	int gameState : "glboom-plus.exe", 0x18F210;
	int demoPlaying : "glboom-plus.exe", 0x22332C;
	int playerHealth : "glboom-plus.exe", 0x1C4C40;
	int onMenu : "glboom-plus.exe", 0x22398C;
	int paused : "glboom-plus.exe", 0x2233B8;
	int wipeInProgress : "glboom-plus.exe", 0x1B9F44;
}

init
{
	vars.timerRunning = 0;
}


start
{

	if(current.demoPlaying == 0 && current.gameState  == 0 && current.playerHealth != 0 && vars.timerRunning == 0 && 

current.wipeInProgress == 0)
	{
		vars.timerRunning = 1;
		return true;
	}
}

split
{
	if(old.gameState  == 0 && current.gameState  == 1)
		return true;
}

isLoading
{
	if(current.gameState  == 1 || current.gameState  == 2 || current.onMenu == 1 || current.paused != 0 || 

current.wipeInProgress == 1)
		return true;
	else
		return false;
}

reset
{
	if(current.playerHealth == 0)
	{
		vars.timerRunning = 0;
		return true;
	}
	else
		return false;
}

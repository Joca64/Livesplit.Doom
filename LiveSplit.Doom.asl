//gamestate - 0: playing level, 1: intermission, 2: episode/game end screen, 3: menu

state("glboom-plus", "v2.5.1.3")
{
	int gameState : "glboom-plus.exe", 0x18F210;
	int demoPlaying : "glboom-plus.exe", 0x22332C;
	int playerHealth : "glboom-plus.exe", 0x1C4C40;
	int levelTime : "glboom-plus.exe", 0x223310;
	int map : "glboom-plus.exe", 0x1B06F8;
}

state("glboom-plus", "v2.5.1.4")
{
	int gameState : "glboom-plus.exe", 0x180BC0;
	int demoPlaying : "glboom-plus.exe", 0x215798;
	int playerHealth : "glboom-plus.exe", 0x1B9180;
	int levelTime : "glboom-plus.exe", 0x215020;
	int map : "glboom-plus.exe", 0x1A2FD4;
}

init
{

	if (modules.First().ModuleMemorySize == 0x2320000)
        	version = "v2.5.1.3";
	else if (modules.First().ModuleMemorySize == 0x284000)
        	version = "v2.5.1.4";

	vars.timerRunning = 0;
	vars.splitsCurrent = 0;
	vars.splitsTemp = 0;
	vars.splitsTotal = 0;
}

start
{

	if(current.demoPlaying == 0 && current.gameState  == 0 && current.playerHealth != 0 && vars.timerRunning == 0)
	{
		vars.timerRunning = 1;
		vars.splitsCurrent = 0;
		vars.splitsTemp = 0;
		vars.splitsTotal = 0;
		return true;
	}
}

split
{
	if(old.gameState  == 0 && current.gameState  == 1)
	{
		vars.splitsTemp = vars.splitsTotal;
		return true;
	}
}

update
{
	vars.splitsCurrent = current.levelTime / 35;

	if(current.map == 1)
		vars.splitsTotal = current.levelTime/35;
	if(current.map != 1 && current.gameState == 0)
		vars.splitsTotal = vars.splitsTemp + current.levelTime / 35;
	
}

gameTime
{
	return new TimeSpan(0, 0, 0, vars.splitsTotal, 0);
}

reset
{
	if(current.playerHealth == 0)
	{
		vars.timerRunning = 0;
		return true;
	}
	
	if(current.map == 1 && current.levelTime < old.levelTime)
	{
		vars.timerRunning = 0;
		return true;
	}
	
	if(current.map < old.map)
	{
		vars.timerRunning = 0;
		return true;
	}
}

isLoading
{
	return true;
}

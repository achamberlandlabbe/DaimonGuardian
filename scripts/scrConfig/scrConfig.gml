//v25.5.2

global.Desktop = 0;
global.Windows = 0;
global.Linux = 0;
global.HTML = 0;
global.GX = 0;
global.CrazyGames = 0;
global.GamePix = 0;
global.GameJolt = 0;
global.Android = 0;
global.Console = 0;
global.PlayStation = 0;
global.PS4 = 0;
global.PS4_NA = 0;
global.PS4_EU = 0;
global.PS4_JP = 0;
global.PS4_AS = 0;
global.PS5 = 0;
global.PS5_NA = 0;
global.PS5_EU = 0;
global.PS5_JP = 0;
global.PS5_AS = 0;

/// @desc This script is intended to handle inheritance of certain parts of the code, for example Windows and Linux
/// are both children of Desktop, therefore any code that is intended for global.Desktop will also work for
/// Windows and Linux, but code that is intended for Windows will not work for Linux
function config(){
	switch (os_get_config())
	{
		case "Windows" : 
			global.Windows = 1;
			global.Desktop = 1;
			break;
		case "Linux" : 
			global.Linux = 1;
			global.Desktop = 1;
			break;
		case "Desktop" : 
			global.Desktop = 1;
			break;
		case "GX" : 
			global.GX = 1;
			global.HTML = 1;
			break;
		case "HTML" : 
			global.HTML = 1;
			break;
		case "Console" :
			global.Console = 1;
			break;
		case "PlayStation" :
			global.Console = 1;
			global.PlayStation = 1;
			break;
		case "PlayStation 5" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS5 = 1;
			break;
		case "PS5 NA" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS5 = 1;
			global.PS5_NA = 1;
			break;
		case "PS5 EU" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS5 = 1;
			global.PS5_EU = 1;
			break;
		case "PS5 JP" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS5 = 1;
			global.PS5_JP = 1;
			break;
		case "PS5 AS" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS5 = 1;
			global.PS5_AS = 1;
			break;
		case "PlayStation 4" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS4 = 1;
			break;
		case "PS4 NA" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS4 = 1;
			global.PS4_NA = 1;
		case "PS4 EU" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS4 = 1;
			global.PS4_EU = 1;
			break;
		case "PS4 JP" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS4 = 1;
			global.PS4_JP = 1;
			break;
		case "PS4 AS" :
			global.Console = 1;
			global.PlayStation = 1;
			global.PS4 = 1;
			global.PS4_AS = 1;
			break;
	}
}
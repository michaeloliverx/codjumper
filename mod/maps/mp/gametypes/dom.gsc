/**
 * Think of only adding the currently visible menu options to the menuOptions array.
 * This way we can keep the menuOptions array small and only have to update the menu when the player opens it.
 * Downsides are that the menu is rebuilt every time the user changes menu.
 */

#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	precacheShader("reticle_flechette"); // Precache the reticle shader for Forge

	level.DEVELOPER_MODE = true;

	// Virtual resolution for HUD elements; scaled to real monitor dimensions by the game engine
	level.SCREEN_MAX_WIDTH = 640;
	level.SCREEN_MAX_HEIGHT = 480;

	level.MENU_WIDTH = int(level.SCREEN_MAX_WIDTH * 0.25); // force int because hudelements / shaders dimensions won't work with floats
	level.MENU_SCROLL_TIME_SECONDS = 0.250;
	level.MENU_TEXT_PADDING_LEFT = 5;
	level.MENU_SCROLLER_ALPHA = 0.7;
	level.MENU_BORDER_WIDTH = 2;

	level.THEMES = [];
	level.THEMES["teal"] = rgbToNormalized((0, 128, 128));
	level.THEMES["pink"] = rgbToNormalized((255, 25, 127));
	level.THEMES["orangered"] = rgbToNormalized((255, 69, 0));
	level.THEMES["gold"] = rgbToNormalized((255, 215, 0));
	level.THEMES["blue"] = rgbToNormalized((0, 0, 255));
	level.THEMES["deepskyblue"] = rgbToNormalized((0, 191, 255));
	level.THEMES["purple"] = rgbToNormalized((90, 0, 208));
	level.THEMES["green"] = rgbToNormalized((0, 208, 98));
	level.THEMES["maroon"] = rgbToNormalized((128, 0, 0));
	level.THEMES["salmon"] = rgbToNormalized((250, 128, 114));
	level.THEMES["silver"] = rgbToNormalized((192, 192, 192));

	level.DVAR_INFO = [];

	level.DVAR_INFO["bg_bobMax"] = spawnstruct();
	level.DVAR_INFO["bg_bobMax"].dvar = "bg_bobMax";
	level.DVAR_INFO["bg_bobMax"].default_value = 8;
	level.DVAR_INFO["bg_bobMax"].options[0] = 8;
	level.DVAR_INFO["bg_bobMax"].options[1] = 0;

	level.DVAR_INFO["cg_drawGun"] = spawnstruct();
	level.DVAR_INFO["cg_drawGun"].dvar = "cg_drawGun";
	level.DVAR_INFO["cg_drawGun"].default_value = 1;
	level.DVAR_INFO["cg_drawGun"].options[0] = 0;
	level.DVAR_INFO["cg_drawGun"].options[1] = 1;

	level.DVAR_INFO["cg_drawSpectatorMessages"] = spawnstruct();
	level.DVAR_INFO["cg_drawSpectatorMessages"].dvar = "cg_drawSpectatorMessages";
	level.DVAR_INFO["cg_drawSpectatorMessages"].default_value = 1;
	level.DVAR_INFO["cg_drawSpectatorMessages"].options[0] = 0;
	level.DVAR_INFO["cg_drawSpectatorMessages"].options[1] = 1;

	level.DVAR_INFO["cg_fov"] = spawnstruct();
	level.DVAR_INFO["cg_fov"].dvar = "cg_fov";
	level.DVAR_INFO["cg_fov"].default_value = 65;
	level.DVAR_INFO["cg_fov"].options[0] = 65;
	level.DVAR_INFO["cg_fov"].options[1] = 70;
	level.DVAR_INFO["cg_fov"].options[2] = 75;
	level.DVAR_INFO["cg_fov"].options[3] = 80;

	level.DVAR_INFO["cg_thirdPerson"] = spawnstruct();
	level.DVAR_INFO["cg_thirdPerson"].dvar = "cg_thirdPerson";
	level.DVAR_INFO["cg_thirdPerson"].default_value = 0;
	level.DVAR_INFO["cg_thirdPerson"].options[0] = 0;
	level.DVAR_INFO["cg_thirdPerson"].options[1] = 1;

	level.DVAR_INFO["cg_thirdPersonAngle"] = spawnstruct();
	level.DVAR_INFO["cg_thirdPersonAngle"].dvar = "cg_thirdPersonAngle";
	level.DVAR_INFO["cg_thirdPersonAngle"].default_value = 0;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[0] = 0;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[1] = 45;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[2] = 90;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[3] = 135;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[4] = 180;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[5] = 225;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[6] = 270;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[7] = 315;
	level.DVAR_INFO["cg_thirdPersonAngle"].options[8] = 360;

	level.DVAR_INFO["cg_thirdPersonRange"] = spawnstruct();
	level.DVAR_INFO["cg_thirdPersonRange"].dvar = "cg_thirdPersonRange";
	level.DVAR_INFO["cg_thirdPersonRange"].default_value = 0; // find default value
	level.DVAR_INFO["cg_thirdPersonRange"].options[0] = 0;
	level.DVAR_INFO["cg_thirdPersonRange"].options[1] = 32;
	level.DVAR_INFO["cg_thirdPersonRange"].options[2] = 64;
	level.DVAR_INFO["cg_thirdPersonRange"].options[3] = 128;
	level.DVAR_INFO["cg_thirdPersonRange"].options[4] = 256;
	level.DVAR_INFO["cg_thirdPersonRange"].options[5] = 512;
	level.DVAR_INFO["cg_thirdPersonRange"].options[6] = 1024;

	level.DVAR_INFO["cg_overheadNamesSize"] = spawnstruct();
	level.DVAR_INFO["cg_overheadNamesSize"].dvar = "cg_overheadNamesSize";
	level.DVAR_INFO["cg_overheadNamesSize"].default_value = 0.65;
	level.DVAR_INFO["cg_overheadNamesSize"].options[0] = 0;
	level.DVAR_INFO["cg_overheadNamesSize"].options[1] = 0.65;

	level.DVAR_INFO["player_view_pitch_down"] = spawnstruct();
	level.DVAR_INFO["player_view_pitch_down"].dvar = "player_view_pitch_down";
	level.DVAR_INFO["player_view_pitch_down"].default_value = 70;
	level.DVAR_INFO["player_view_pitch_down"].options[0] = 70;
	level.DVAR_INFO["player_view_pitch_down"].options[1] = 89.9;

	level.DVAR_INFO["r_dof_enable"] = spawnstruct();
	level.DVAR_INFO["r_dof_enable"].dvar = "r_dof_enable";
	level.DVAR_INFO["r_dof_enable"].default_value = 1;
	level.DVAR_INFO["r_dof_enable"].options[0] = 0;
	level.DVAR_INFO["r_dof_enable"].options[1] = 1;

	level.DVAR_INFO["r_fog"] = spawnstruct();
	level.DVAR_INFO["r_fog"].dvar = "r_fog";
	level.DVAR_INFO["r_fog"].default_value = 1;
	level.DVAR_INFO["r_fog"].options[0] = 0;
	level.DVAR_INFO["r_fog"].options[1] = 1;

	level.DVAR_INFO["r_zfar"] = spawnstruct();
	level.DVAR_INFO["r_zfar"].dvar = "r_zfar";
	level.DVAR_INFO["r_zfar"].default_value = 0;
	level.DVAR_INFO["r_zfar"].options[0] = 0;
	level.DVAR_INFO["r_zfar"].options[1] = 2000;
	level.DVAR_INFO["r_zfar"].options[2] = 2500;
	level.DVAR_INFO["r_zfar"].options[3] = 3000;
	level.DVAR_INFO["r_zfar"].options[4] = 3500;

	// Set hardcore mode for a clean HUD
	level.hardcoreMode = true;

	setdvar("scr_" + level.gametype + "_timelimit", 0); // Disable the time limit
	setDvar("scr_game_perks", 0);						// Remove perks
	setDvar("scr_showperksonspawn", 0);					// Remove perks icons shown on spawn
	setDvar("scr_game_hardpoints", 0);					// Remove killstreaks

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	for (;;)
	{
		self waittill("spawned_player");
		self.menuOpen = false;
		self thread watchbuttons();
		self thread replenishammo();
		self initClientDvars();
		self initLoadout();
	}
}

/**
 * Set the player's loadout.
 */
initLoadout()
{
	self takeallweapons();
	self giveweapon("deserteagle_mp");
	self giveWeapon("rpg_mp");
	self setactionslot(3, "weapon", "rpg_mp");

	wait 0.05;
	self switchtoweapon("deserteagle_mp");
}

initClientDvars()
{
	if (level.DEVELOPER_MODE)
	{
		// Set developer dvars
		self setclientdvar("developer", 1);
		self setclientdvar("developer_script", 1);
		self setclientdvar("con_minicon", 1);
		self setclientdvar("con_miniconlines", 20);
		self setclientdvar("con_minicontime", 10);
	}

	self setClientDvars("loc_warnings", 0);					// Remove unlocalized text errors
	self setclientdvar("player_view_pitch_up", 89.9);		// look straight up
	self setClientDvar("ui_ConnectScreenTextGlowColor", 0); // Remove glow color applied to the mode and map name strings on the connect screen
	self setClientDvar("cg_descriptiveText", 0);			// Remove spectator button icons and text
	self setClientDvar("player_spectateSpeedScale", 1.5);	// Faster movement in spectator
	self setClientDvar("compassSize", 0.001);				// Remove compass
}

/**
 * Normalize RGB values (0-255) to (0-1).
 */
rgbToNormalized(rgb)
{
	return (rgb[0] / 255, rgb[1] / 255, rgb[2] / 255);
}

/**
 * Add a menu to the menuOptions array.
 * @param menuKey The key to identify the menu.
 * @param parentMenuKey The key of the parent menu.
 */
addMenu(menuKey, parentMenuKey)
{
	if (!isdefined(self.menuOptions))
		self.menuOptions = [];
	self.menuOptions[menuKey] = spawnstruct();
	self.menuOptions[menuKey].parent = parentMenuKey;
	self.menuOptions[menuKey].options = [];
}

/**
 * Add a menu option to the menuOptions array.
 * @param menuKey The menu key to add the option to.
 * @param label The text to display for the option.
 * @param func The function to call when the option is selected.
 * @param param1 The first parameter to pass to the function. (optional)
 * @param param2 The second parameter to pass to the function. (optional)
 * @param param3 The third parameter to pass to the function. (optional)
 */
addMenuOption(menuKey, label, func, param1, param2, param3)
{
	option = spawnstruct();
	option.label = label;
	option.func = func;
	option.inputs = [];

	if (isdefined(param1))
		option.inputs[0] = param1;
	if (isdefined(param2))
		option.inputs[1] = param2;
	if (isdefined(param3))
		option.inputs[2] = param3;

	self.menuOptions[menuKey].options[self.menuOptions[menuKey].options.size] = option;
}

/**
 * Generate the menu options.
 */
generateMenu()
{
	// DVAR menu
	self addMenu("dvar_menu", "main_menu");
	self addMenuOption("dvar_menu", "Reset All", ::resetClientDvars);
	dvars = getarraykeys(level.DVAR_INFO);
	for (i = dvars.size - 1; i >= 0; i--)
	{
		dvarinfo = level.DVAR_INFO[dvars[i]];
		self addMenuOption("dvar_menu", dvarinfo.dvar, ::toggleClientDvar, dvarinfo);
	}

	// Theme menu
	self addMenu("theme_menu", "main_menu");
	themes = getarraykeys(level.THEMES);
	for (i = 0; i < themes.size; i++)
		self addMenuOption("theme_menu", themes[i], ::menuAction, "CHANGE_THEME", themes[i]);

	// Main menu
	self addMenu("main_menu");
	self addMenuOption("main_menu", "DVAR Menu", ::menuAction, "CHANGE_MENU", "dvar_menu");
	self addMenuOption("main_menu", "Forge Mode", ::forgestart);
	self addMenuOption("main_menu", "Theme Menu", ::menuAction, "CHANGE_MENU", "theme_menu");
}

exampleOption1()
{
	self iprintln("Example Option 1 selected");
}

exampleOption2()
{
	self iprintln("Example Option 2 selected");
}

exampleOption3()
{
	self iprintln("Example Option 3 selected");
}

/**
 * Get the menu text for the current menu.
 */
getMenuText()
{
	string = "";
	for (i = 0; i < self.menuOptions[self.menuKey].options.size; i++)
		string += self.menuOptions[self.menuKey].options[i].label + "\n";

	// hud elements can have a maximum of 255 characters otherwise they disappear
	if (string.size > 255)
		self iprintln("^1menu text exceeds 255 characters. current size: " + string.size);

	return string;
}

/**
 * Initialize the menu HUD elements.
 */
initMenuHudElem()
{
	menuBackground = newClientHudElem(self);
	menuBackground.elemType = "icon";
	menuBackground.children = [];
	menuBackground.sort = 1;
	menuBackground.color = (0, 0, 0);
	menuBackground.alpha = 0.5;
	menuBackground setParent(level.uiParent);
	menuBackground setShader("white", level.MENU_WIDTH, level.SCREEN_MAX_HEIGHT);
	menuBackground.x = level.SCREEN_MAX_WIDTH - level.MENU_WIDTH;
	menuBackground.y = 0;
	menuBackground.alignX = "left";
	menuBackground.alignY = "top";
	menuBackground.horzAlign = "fullscreen";
	menuBackground.vertAlign = "fullscreen";
	self.menuBackground = menuBackground;

	menuBorderLeft = newClientHudElem(self);
	menuBorderLeft.elemType = "icon";
	menuBorderLeft.children = [];
	menuBorderLeft.sort = 2;
	menuBorderLeft.color = self.themeColor;
	menuBorderLeft.alpha = level.MENU_SCROLLER_ALPHA;
	menuBorderLeft setParent(level.uiParent);
	menuBorderLeft setShader("white", level.MENU_BORDER_WIDTH, level.SCREEN_MAX_HEIGHT);
	menuBorderLeft.x = (level.SCREEN_MAX_WIDTH - level.MENU_WIDTH);
	menuBorderLeft.y = 0;
	menuBorderLeft.alignX = "left";
	menuBorderLeft.alignY = "top";
	menuBorderLeft.horzAlign = "fullscreen";
	menuBorderLeft.vertAlign = "fullscreen";
	self.menuBorderLeft = menuBorderLeft;

	menuScroller = newClientHudElem(self);
	menuScroller.elemType = "icon";
	menuScroller.children = [];
	menuScroller.sort = 2;
	menuScroller.color = self.themeColor;
	menuScroller.alpha = level.MENU_SCROLLER_ALPHA;
	menuScroller setParent(level.uiParent);
	menuScroller setShader("white", level.MENU_WIDTH, int(level.fontHeight * 1.5));
	menuScroller.x = (level.SCREEN_MAX_WIDTH - level.MENU_WIDTH) + level.MENU_BORDER_WIDTH;
	menuScroller.y = int(level.SCREEN_MAX_HEIGHT * 0.15);
	menuScroller.alignX = "left";
	menuScroller.alignY = "top";
	menuScroller.horzAlign = "fullscreen";
	menuScroller.vertAlign = "fullscreen";
	self.menuScroller = menuScroller;

	menuTextFontElem = newClientHudElem(self);
	menuTextFontElem.elemType = "font";
	menuTextFontElem.font = "default";
	menuTextFontElem.fontscale = 1.5;
	menuTextFontElem.children = [];
	menuTextFontElem.sort = 3;
	menuTextFontElem setParent(level.uiParent);
	menuTextFontElem settext(getMenuText());
	menuTextFontElem.x = (level.SCREEN_MAX_WIDTH - level.MENU_WIDTH) + level.MENU_TEXT_PADDING_LEFT;
	menuTextFontElem.y = int(level.SCREEN_MAX_HEIGHT * 0.15);
	menuTextFontElem.alignX = "left";
	menuTextFontElem.alignY = "top";
	menuTextFontElem.horzAlign = "fullscreen";
	menuTextFontElem.vertAlign = "fullscreen";
	self.menuTextFontElem = menuTextFontElem;

	menuHeaderFontElem = newClientHudElem(self);
	menuHeaderFontElem.elemType = "font";
	menuHeaderFontElem.font = "objective";
	menuHeaderFontElem.fontscale = 2;
	menuHeaderFontElem.glowColor = self.themeColor;
	menuHeaderFontElem.glowAlpha = 1;
	menuHeaderFontElem.children = [];
	menuHeaderFontElem.sort = 3;
	menuHeaderFontElem setParent(level.uiParent);
	menuHeaderFontElem.x = (level.SCREEN_MAX_WIDTH - level.MENU_WIDTH) + level.MENU_TEXT_PADDING_LEFT;
	menuHeaderFontElem.y = int(level.SCREEN_MAX_HEIGHT * 0.025);
	menuHeaderFontElem.alignX = "left";
	menuHeaderFontElem.alignY = "top";
	menuHeaderFontElem.horzAlign = "fullscreen";
	menuHeaderFontElem.vertAlign = "fullscreen";
	menuHeaderFontElem settext("CodJumper");
	self.menuHeaderFontElem = menuHeaderFontElem;

	menuHeaderAuthorFontElem = newClientHudElem(self);
	menuHeaderAuthorFontElem.elemType = "font";
	menuHeaderAuthorFontElem.font = "default";
	menuHeaderAuthorFontElem.fontscale = 1.5;
	menuHeaderAuthorFontElem.glowColor = self.themeColor;
	menuHeaderAuthorFontElem.glowAlpha = 0.1;
	menuHeaderAuthorFontElem.children = [];
	menuHeaderAuthorFontElem.sort = 3;
	menuHeaderAuthorFontElem setParent(level.uiParent);
	menuHeaderAuthorFontElem.x = (level.SCREEN_MAX_WIDTH - level.MENU_WIDTH) + level.MENU_TEXT_PADDING_LEFT;
	menuHeaderAuthorFontElem.y = int(level.SCREEN_MAX_HEIGHT * 0.075);
	menuHeaderAuthorFontElem.alignX = "left";
	menuHeaderAuthorFontElem.alignY = "top";
	menuHeaderAuthorFontElem.horzAlign = "fullscreen";
	menuHeaderAuthorFontElem.vertAlign = "fullscreen";
	menuHeaderAuthorFontElem settext("v0.15.0    --> by mo");
	self.menuHeaderAuthorFontElem = menuHeaderAuthorFontElem;
}

/**
 * Handle menu actions.
 * @param action The action to perform.
 * @param param1 The action parameter. (optional)
 */
menuAction(action, param1)
{
	if (!isdefined(self.themeColor))
		self.themeColor = level.THEMES["teal"];

	if (!isdefined(self.menuKey))
		self.menuKey = "main_menu";

	if (!isdefined(self.menuCursor))
		self.menuCursor = [];

	if (!isdefined(self.menuCursor[self.menuKey]))
		self.menuCursor[self.menuKey] = 0;

	switch (action)
	{
	case "UP":
	case "DOWN":
		if (action == "UP")
			self.menuCursor[self.menuKey]--;
		else if (action == "DOWN")
			self.menuCursor[self.menuKey]++;

		if (self.menuCursor[self.menuKey] < 0)
			self.menuCursor[self.menuKey] = self.menuOptions[self.menuKey].options.size - 1;
		else if (self.menuCursor[self.menuKey] > self.menuOptions[self.menuKey].options.size - 1)
			self.menuCursor[self.menuKey] = 0;

		self.menuScroller moveOverTime(level.MENU_SCROLL_TIME_SECONDS);
		self.menuScroller.y = (level.SCREEN_MAX_HEIGHT * 0.15 + ((level.fontHeight * 1.5) * self.menuCursor[self.menuKey]));
		break;
	case "SELECT":
		cursor = self.menuCursor[self.menuKey];
		options = self.menuOptions[self.menuKey].options[cursor];
		if (options.inputs.size == 0)
			self [[options.func]] ();
		else if (options.inputs.size == 1)
			self [[options.func]] (options.inputs[0]);
		else if (options.inputs.size == 2)
			self [[options.func]] (options.inputs[0], options.inputs[1]);
		else if (options.inputs.size == 3)
			self [[options.func]] (options.inputs[0], options.inputs[1], options.inputs[2]);
		wait 0.1;
		break;
	case "CLOSE":
		// TODO: check can .children be used to destroy all at once
		self.menuBackground destroy();
		self.menuBorderLeft destroy();
		self.menuScroller destroy();
		self.menuTextFontElem destroy();
		self.menuHeaderFontElem destroy();
		self.menuHeaderAuthorFontElem destroy();
		self.menuOpen = false;
		self freezecontrols(false);
		break;
	case "BACK":
		// close menu if we don't have a parent
		if (!isdefined(self.menuOptions[self.menuKey].parent))
			self menuAction("CLOSE");
		else
			self menuAction("CHANGE_MENU", self.menuOptions[self.menuKey].parent);
		break;
	case "OPEN":
		self.menuOpen = true;
		self freezecontrols(true);
		self generateMenu();
		self initMenuHudElem();
		self.menuScroller.y = (level.SCREEN_MAX_HEIGHT * 0.15 + ((level.fontHeight * 1.5) * self.menuCursor[self.menuKey]));
		break;
	case "CHANGE_THEME":
		self.themeColor = level.THEMES[param1];
		self menuAction("REFRESH");
		break;
	case "CHANGE_MENU":
		self.menuKey = param1;
		self menuAction("REFRESH_TEXT");
		break;
	case "REFRESH_TEXT":
		self.menuTextFontElem settext(getMenuText());
		self.menuScroller moveOverTime(level.MENU_SCROLL_TIME_SECONDS);
		self.menuScroller.y = (level.SCREEN_MAX_HEIGHT * 0.15 + ((level.fontHeight * 1.5) * self.menuCursor[self.menuKey]));
		break;
	case "REFRESH":
		self menuAction("CLOSE");
		self menuAction("OPEN");
		break;
	default:
		self iprintln("^1unknown menu action " + action);
		break;
	}
}

/**
 * Main loop to watch for button presses.
 */
watchbuttons()
{
	self endon("disconnect");
	self endon("death");

	waittime = 0.1; // wait time between button presses. TODO: maybe match this with the menu scroll time

	for (;;)
	{
		if (!self.menuOpen)
		{
			if (self adsbuttonpressed() && self meleebuttonpressed())
			{
				menuAction("OPEN");
				wait waittime; // TODO: check if this is better suited inside the menuAction function
			}
		}
		else
		{
			if (self adsbuttonpressed())
			{
				menuAction("UP");
				wait waittime;
			}
			if (self attackbuttonpressed())
			{
				menuAction("DOWN");
				wait waittime;
			}
			if (self meleebuttonpressed())
			{
				menuAction("BACK");
				wait waittime;
			}
			if (self usebuttonpressed())
			{
				menuAction("SELECT");
				wait waittime;
			}
		}
		wait 0.05;
	}
}

/**
 * Constantly replace the players ammo.
 */
replenishammo()
{
	self endon("disconnect");
	self endon("death");

	for (;;)
	{
		currentWeapon = self getCurrentWeapon();
		// getCurrentWeapon returns undefined if the player is mantling or on a ladder
		if (isdefined(currentWeapon))
			self giveMaxAmmo(currentWeapon);
		wait 1;
	}
}

toggleClientDvar(dvarinfo)
{
	if (!isdefined(self.dvars) || !isdefined(self.dvars[dvarinfo.dvar]))
		self.dvars[dvarinfo.dvar] = dvarinfo.default_value;

	for (i = 0; i < dvarinfo.options.size; i++)
	{
		if (self.dvars[dvarinfo.dvar] == dvarinfo.options[i])
		{
			if (i == dvarinfo.options.size - 1)
				self.dvars[dvarinfo.dvar] = dvarinfo.options[0];
			else
				self.dvars[dvarinfo.dvar] = dvarinfo.options[i + 1];
			break;
		}
	}
	self setClientDvar(dvarinfo.dvar, self.dvars[dvarinfo.dvar]);
	self iprintln(dvarinfo.dvar + self.dvars[dvarinfo.dvar]);
}

resetClientDvars()
{
	dvars = getarraykeys(level.DVAR_INFO);
	for (i = 0; i < dvars.size; i++)
	{
		dvarinfo = level.DVAR_INFO[dvars[i]];
		self setClientDvar(dvarinfo.dvar, dvarinfo.default_value);
	}
	self iprintln("DVARS RESET");
}

forgestart()
{
	self menuAction("CLOSE");

	self setClientDvar("player_view_pitch_up", 89.9);	   // allow looking straight up
	self setClientDvar("player_view_pitch_down", 89.9);	   // allow looking straight down
	self setClientDvar("player_spectateSpeedScale", 0.75); // Slower movement in spectator for precision
	self setClientDvar("cg_descriptiveText", 0);		   // Show button icons and text

	// TODO: place compass (if needed)

	self allowSpectateTeam("freelook", true);
	self.sessionstate = "spectator";

	self.hud = [];

	self.hud["mode"] = createFontString("default", 1.4);
	self.hud["mode"] setPoint("TOPRIGHT", "TOPRIGHT", 0, 60);
	self.hud["mode"] setText("Rotate mode: " + "pitch");

	self.hud["pitch"] = createFontString("default", 1.4);
	self.hud["pitch"] setPoint("TOPRIGHT", "TOPRIGHT", 0, 80);
	self.hud["pitch"].label = &"pitch: &&1";
	self.hud["pitch"] SetValue(1);

	self.hud["yaw"] = createFontString("default", 1.4);
	self.hud["yaw"] setPoint("TOPRIGHT", "TOPRIGHT", 0, 100);
	self.hud["yaw"].label = &"yaw: &&1";
	self.hud["yaw"] SetValue(1);

	self.hud["roll"] = createFontString("default", 1.4);
	self.hud["roll"] setPoint("TOPRIGHT", "TOPRIGHT", 0, 120);
	self.hud["roll"].label = &"roll: &&1";
	self.hud["roll"] SetValue(1);

	self.hud["z"] = createFontString("default", 1.4);
	self.hud["z"] setPoint("TOPRIGHT", "TOPRIGHT", 0, 140);
	self.hud["z"].label = &"z: &&1";
	self.hud["z"] SetValue(1);

	self.hud["reticle"] = createIcon("reticle_flechette", 40, 40);
	self.hud["reticle"] setPoint("center", "center", "center", "center");

	self iprintln("Forge started");

	focusedColor = self.themeColor;
	unfocusedColor = (1, 1, 1);
	pickedUpColor = (1, 0, 0);

	focusedEnt = undefined;
	pickedUpEnt = undefined;

	mode = "pitch";
	unit = 1;

	for (;;)
	{
		// exit forge mode
		if (self secondaryoffhandbuttonpressed() && self fragbuttonpressed())
		{
			self setclientdvar("player_view_pitch_down", level.DVAR_INFO["player_view_pitch_down"].default_value);

			self allowSpectateTeam("freelook", false);
			self.sessionstate = "playing";

			huds = getarraykeys(self.hud);
			for (i = 0; i < huds.size; i++)
				self.hud[huds[i]] destroy();

			self iprintln("Forge ended");
			break;
		}

		// change mode
		if (self fragbuttonpressed() && self usebuttonpressed())
		{
			if (mode == "z")
				mode = "yaw";
			else if (mode == "yaw")
				mode = "roll";
			else if (mode == "roll")
				mode = "pitch";
			else if (mode == "pitch")
				mode = "z";

			self.hud["mode"] setText("mode: " + mode);

			wait 1.5;
			continue;
		}

		if (!isdefined(pickedUpEnt))
		{
			forward = anglestoforward(self getplayerangles());
			eye = self.origin + (0, 0, 10);
			start = eye;
			end = vectorscale(forward, 9999);
			trace = bullettrace(start, start + end, true, self);
			if (isdefined(trace["entity"]))
			{
				ent = trace["entity"];
				self.hud["reticle"].color = self.themeColor;
				focusedEnt = ent;
			}
			else
			{
				self.hud["reticle"].color = unfocusedColor;
				focusedEnt = undefined;
			}
		}
		else
		{
			self.hud["reticle"].color = pickedUpColor;
		}

		// 	obj["ent"] waittill("rotatedone");
		if (isdefined(focusedEnt))
		{
			self.hud["pitch"] SetValue(focusedEnt.angles[0]);
			self.hud["yaw"] SetValue(focusedEnt.angles[1]);
			self.hud["roll"] SetValue(focusedEnt.angles[2]);
			self.hud["pitch"].alpha = 1;
			self.hud["yaw"].alpha = 1;
			self.hud["roll"].alpha = 1;
			self.hud["z"].alpha = 1;
		}
		else
		{
			self.hud["pitch"].alpha = 0;
			self.hud["yaw"].alpha = 0;
			self.hud["roll"].alpha = 0;
			self.hud["z"].alpha = 0;
		}

		if (isdefined(focusedEnt) && self secondaryoffhandbuttonpressed() || self fragbuttonpressed())
		{
			if (self secondaryoffhandbuttonpressed())
			{
				if (mode == "pitch")
				{
					focusedEnt rotatepitch(unit, 0.01);
					self.hud["pitch"] SetValue(focusedEnt.angles[0]);
				}
				else if (mode == "yaw")
				{
					focusedEnt rotateyaw(unit, 0.01);
					self.hud["yaw"] SetValue(focusedEnt.angles[1]);
				}
				else if (mode == "roll")
				{
					focusedEnt rotateroll(unit, 0.01);
					self.hud["roll"] SetValue(focusedEnt.angles[2]);
				}
				else if (mode == "z")
				{
					focusedEnt movez(unit * -1, 0.01);
					self.hud["z"] SetValue(focusedEnt.origin[2]);
				}
			}
			else if (self fragbuttonpressed())
			{
				if (mode == "pitch")
				{
					focusedEnt rotatepitch(unit * -1, 0.01);
					self.hud["pitch"] SetValue(focusedEnt.angles[0]);
				}
				else if (mode == "yaw")
				{
					focusedEnt rotateyaw(unit * -1, 0.01);
					self.hud["yaw"] SetValue(focusedEnt.angles[1]);
				}
				else if (mode == "roll")
				{
					focusedEnt rotateroll(unit * -1, 0.01);
					self.hud["roll"] SetValue(focusedEnt.angles[2]);
				}
				else if (mode == "z")
				{
					focusedEnt movez(unit, 0.01);
					self.hud["z"] SetValue(focusedEnt.origin[2]);
				}
			}
		}

		// if (isdefined(focusedEnt) && rotateMode == "pitch")
		// {
		// 	if (self secondaryoffhandbuttonpressed())
		// 	{
		// 		focusedEnt rotatepitch(1, 0.01);
		// 		self iprintln(getdisplayname(focusedEnt) + " pitch: " + focusedEnt.angles[0]);
		// 	}

		// 	else if (self fragbuttonpressed())
		// 	{
		// 		focusedEnt rotatepitch(-1, 0.01);
		// 		self iprintln(getdisplayname(focusedEnt) + " pitch: " + focusedEnt.angles[0]);
		// 	}
		// }
		// else if (isdefined(focusedEnt) && rotateMode == "yaw")
		// {
		// 	if (self secondaryoffhandbuttonpressed())
		// 	{
		// 		focusedEnt rotateyaw(1, 0.01);
		// 		self iprintln(getdisplayname(focusedEnt) + " yaw: " + focusedEnt.angles[1]);
		// 	}

		// 	else if (self fragbuttonpressed())
		// 	{
		// 		focusedEnt rotateyaw(-1, 0.01);
		// 		self iprintln(getdisplayname(focusedEnt) + " yaw: " + focusedEnt.angles[1]);
		// 	}
		// }
		// else if (isdefined(focusedEnt) && rotateMode == "roll")
		// {
		// 	if (self secondaryoffhandbuttonpressed())
		// 	{
		// 		focusedEnt rotateroll(1, 0.01);
		// 		self iprintln(getdisplayname(focusedEnt) + " roll: " + focusedEnt.angles[2]);
		// 	}

		// 	else if (self fragbuttonpressed())
		// 	{
		// 		focusedEnt rotateroll(-1, 0.01);
		// 		self iprintln(getdisplayname(focusedEnt) + " roll: " + focusedEnt.angles[2]);
		// 	}
		// }

		if (!isdefined(pickedUpEnt) && isdefined(focusedEnt) && self usebuttonpressed())
		{
			ent = focusedEnt;
			ent linkto(self);
			pickedUpEnt = focusedEnt;
			self iprintln("Picked up " + getdisplayname(ent));
			wait 0.1;
		}
		// forge mode action buttons
		else if (isdefined(pickedUpEnt) && !isplayer(pickedUpEnt) && self usebuttonpressed())
		{
			ent = pickedUpEnt;
			ent unlink();
			pickedUpEnt = undefined;
			self iprintln("Dropped " + getdisplayname(ent));
			wait 0.1;
		}

		wait 0.05;
	}
}

getdisplayname(ent)
{
	if (isplayer(ent))
		return ent.name;
	else if (isdefined(ent.model) && ent.model != "")
		return ent.model;
	else
		return ent.classname;
}

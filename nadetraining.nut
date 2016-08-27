/* nadetraining.nut
 * Popflash Training Script
 * by S0lll0s, Bidj and Rurre
 * USAGE:
 *      script_execute nadetraining
 *	script nadeSetup()
 * 	bind "rctrl" "script nadeSavePos()"
 *	bind "ralt" "script nadePause()"
 * Press the key (right ctrl in this case) before every nade you want save, all following nades will fly the same path
 * regardless of how you throw them. To pause the script and throw nades freely use the other bind (right alt in this case).
 */

this.nadePos		<- null;
this.nadeVel		<- null;
this.nadeSaveMode	<- true;
this.nadeLastNade	<- null;
this.nadeIsPaused	<- false;

function nadeSetup() {
	printl( @"[NT] nadetraining.nut" );
	printl( @"[NT] Popflash Training Script" );
	printl( @"[NT] by S0lll0s, Bidj and Rurre" );
	printl( @"[NT] USAGE:" );
	printl( @"[NT] 	 bind ""ralt"" ""script nadeSavePos()""" );
	printl( @"[NT] 	 bind ""rctrl"" ""script nadePause()""" );
	printl( @"[NT] Press the key before every nade you save, all following nades will fly the same path" );

	printl( @"[NT] starting setup..." );
	SendToConsole( @"sv_cheats 1" );
	SendToConsole( @"ent_remove nadeTimer" );
	SendToConsole( @"ent_create logic_timer" );
	SendToConsole( @"ent_fire logic_timer addoutput ""targetname nadeTimer""" );
	SendToConsole( @"ent_fire nadeTimer toggle" );
	SendToConsole( @"ent_fire nadeTimer addoutput ""refiretime 0.05""" );
	SendToConsole( @"ent_fire nadeTimer enable" );
	SendToConsole( @"ent_fire nadeTimer addoutput ""startdisabled 0""" );
	SendToConsole( @"ent_fire nadeTimer addoutput ""UseRandomTime 0""" );
	SendToConsole( @"ent_fire nadeTimer addoutput ""ontimer nadeTimer,RunScriptCode,nadeThink()""" );
	printl( @"[NT] done. You can turn off sv_cheats now." );
}

function nadeSavePos() {
	nadeSaveMode = true;
	ScriptPrintMessageCenterAll( "Saving next Flashbang or Grenade" );
}
function nadeThink() {
	local nade = null;

	while ( Entities.FindByClassname(nade, "flashbang_projectile") != null ) {
		nade = Entities.FindByClassname(nade, "flashbang_projectile");
		saveRestore( nade );
	}
	
	nade = null;
	while ( Entities.FindByClassname(nade, "hegrenade_projectile") != null ) {
		nade = Entities.FindByClassname(nade, "hegrenade_projectile");
		saveRestore( nade );
	}
}
function nadePause()
{
	nadeIsPaused = !nadeIsPaused;
	if ( nadeIsPaused )
	{
		ScriptPrintMessageCenterAll( "Pausing script. You can now throw grenades freely." );
	} else {
		ScriptPrintMessageCenterAll( "Resuming script. Last saved grenade remembered." );
	}
}
function saveRestore( nade ) {
	if (!nadeIsPaused){	
		if ( nadeLastNade != nade ) {
			if ( nadeSaveMode ) {
				ScriptPrintMessageCenterAll( "Saved" );
				nadePos = nade.GetCenter();
				nadeVel = nade.GetVelocity();
				nadeSaveMode = false;
			} else {
				nade.SetAbsOrigin( nadePos );
				nade.SetVelocity( nadeVel );
			}
			nadeLastNade = nade;
		}
	}
}

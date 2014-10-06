/* nadetraining.nut
 * Popflash Training Script
 * by S0lll0s and Bidj
 * USAGE:
 *	script_execute nadetraining
 *	script nadeSetup()
 * 	bind "," "script nadeSavePos()"
 * Press the key before every nade you save, all following nades will fly the same path
 */

this.nadePos		<- null;
this.nadeVel		<- null;
this.nadeSaveMode	<- true;
this.nadeLastNade	<- null;

function nadeSetup() {
	printl( @"[NT] nadetraining.nut" );
	printl( @"[NT] Popflash Training Script" );
	printl( @"[NT] by S0lll0s and Bidj" );
	printl( @"[NT] USAGE:" );
	printl( @"[NT] 	 bind "","" ""script nadeSavePos()""" );
	printl( @"[NT] Press the key before every nade you save, all following nades will fly the same path" );

	printl( @"[NT] starting setup..." );
	SendToConsole( @"sv_cheats 1" );
	SendToConsole( @"ent_remove nadeTimer" );
	SendToConsole( @"ent_create logic_timer" );
	SendToConsole( @"ent_fire logic_timer addoutput ""targetname nadeTimer""" );
	SendToConsole( @"ent_fire nadeTimer toggle" );
	SendToConsole( @"ent_fire nadeTimer addoutput ""refiretime 0.05""" );
	SendToConsole( @"ent_fire nadeTimer enable" );
	SendToConsole( @" ent_fire nadeTimer addoutput ""startdisabled 0""" );
	SendToConsole( @" ent_fire nadeTimer addoutput ""UseRandomTime 0""" );
	SendToConsole( @" ent_fire nadeTimer addoutput ""ontimer nadeTimer,RunScriptCode,nadeThink()""" );
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

function saveRestore( nade ) {
	if ( lastNade != nade ) {
		handled.append( nade.GetScriptId() );
		if ( saveMode ) {
			ScriptPrintMessageCenterAll( "Saved" );
			pos = nade.GetCenter();
			vel = nade.GetVelocity();
			saveMode = false;
		} else {
			nade.SetAbsOrigin( pos );
			nade.SetVelocity( vel );
		}
		lastNade = nade;
	}
}

/*
File : fn_copShowLicense.sqf
Create : Black Lagoon
Edit : freakstone


Beschreibung : Fuegt einen 'Polizeiausweis' hinzu, den man ueber scrollen Zivilisten zeigen kann
*/

private["_target", "_message","_coplevel","_rang"];

_target = cursorTarget;

if(playerSide != west) exitWith
{
	hint "Du bist kein Cop!";
};

if( isNull _target) then {_target = player;};

if( !(_target isKindOf "Man") ) then {_target = player;};

if( !(alive _target) ) then {_target = player;};

_coplevel = call life_coplevel;

switch ( _coplevel ) do
{
	case 1: { _rang = "Dein Rang 1"; };
	case 2: { _rang = "Dein Rang 2"; };
	case 3: { _rang = "Dein Rang 3"; };
	case 4: { _rang = "Dein Rang 4"; };
	case 5: { _rang = "Dein Rang 5"; };
	case 6: { _rang = "Dein Rang 6"; };
	case 7: { _rang = "Dein Rang 7"; };
	default {_rank =  "Error";};
};

_message = format["<img size='10' color='#FFFFFF' image='textures\marke.paa'/><br/><br/><t size='2.5'>%1</t><br/><t size='1.8'>%2</t><br/><t size='1'>Polizei Altis</t>", name player, _rang];

[[player, _message],"life_fnc_copLicenseShown",_target,false] spawn life_fnc_MP;

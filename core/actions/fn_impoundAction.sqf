#include "..\..\script_macros.hpp"
/*
    File: fn_impoundAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Impounds the vehicle
*/
/*private["_vehicle","_type","_time","_value","_vehicleData","_upp","_ui","_progress","_pgText","_cP","_filters","_impoundValue","_price","_impoundMultiplier"];
_vehicle = param [0,ObjNull,[ObjNull]];
_filters = ["Car","Air","Ship"];
if (!((KINDOF_ARRAY(_vehicle,_filters)))) exitWith {};
if (player distance cursorObject > 10) exitWith {};
if (_vehicle getVariable "NPC") exitWith {hint localize "STR_NPC_Protected"};

_vehicleData = _vehicle getVariable ["vehicle_info_owners",[]];
if (_vehicleData isEqualTo 0) exitWith {deleteVehicle _vehicle}; //Bad vehicle.
_vehicleName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");
_price = M_CONFIG(getNumber,"LifeCfgVehicles",(typeOf _vehicle),"price");
[0,"STR_NOTF_BeingImpounded",true,[((_vehicleData select 0) select 1),_vehicleName]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
life_action_inUse = true;

_upp = localize "STR_NOTF_Impounding";
//Setup our progress bar.
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

for "_i" from 0 to 1 step 0 do {
    sleep 0.09;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_upp];
    if (_cP >= 1) exitWith {};
    if (player distance _vehicle > 10) exitWith {};
    if (!alive player) exitWith {};
};

5 cutText ["","PLAIN"];

if (player distance _vehicle > 10) exitWith {hint localize "STR_NOTF_ImpoundingCancelled"; life_action_inUse = false;};
if (!alive player) exitWith {life_action_inUse = false;};

if (count crew _vehicle isEqualTo 0) then {
    if (!(KINDOF_ARRAY(_vehicle,_filters))) exitWith {life_action_inUse = false;};
    _type = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");

    life_impound_inuse = true;

    if (life_HC_isActive) then {
        [_vehicle,true,player] remoteExec ["HC_fnc_vehicleStore",HC_Life];
    } else {
        [_vehicle,true,player] remoteExec ["TON_fnc_vehicleStore",RSERV];
    };

    waitUntil {!life_impound_inuse};
    if (playerSide isEqualTo west) then {
            _impoundMultiplier = LIFE_SETTINGS(getNumber,"vehicle_cop_impound_multiplier");
            _value = _price * _impoundMultiplier;
            [0,"STR_NOTF_HasImpounded",true,[profileName,((_vehicleData select 0) select 1),_vehicleName]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
            if (_vehicle in life_vehicles) then {
                hint format[localize "STR_NOTF_OwnImpounded",[_value] call life_fnc_numberText,_type];
                BANK = BANK - _value;
            } else {
                hint format[localize "STR_NOTF_Impounded",[_value] call life_fnc_numberText,_type];
                BANK = BANK + _value;
            };
            if (BANK < 0) then {BANK = 0;};
            [1] call SOCK_fnc_updatePartial;
    };
} else {
    hint localize "STR_NOTF_ImpoundingCancelled";
};

life_action_inUse = false;
*/

File: fn_impoundAction.sqf
Author: Bryan "Tonic" Boardwine
Description:
Impounds the vehicle
*/
private["_vehicle","_type","_time","_price","_vehicleData","_upp","_ui","_progress","_pgText","_cP"];
_vehicle = cursorTarget;
if(!((_vehicle isKindOf "Car") || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship"))) exitWith {};
if(player distance cursorTarget > 10) exitWith {};
if((_vehicle isKindOf "Car") || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship")) then
{
_vehicleData = _vehicle getVariable["vehicle_info_owners",[]];
if(count _vehicleData == 0) exitWith {deleteVehicle _vehicle}; //Bad vehicle.
_vehicleName = getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
[[0,format[localize "STR_NOTF_BeingImpounded",(_vehicleData select 0) select 1,_vehicleName]],"life_fnc_broadcast",true,false] spawn life_fnc_MP;
life_action_inUse = true;
_upp = localize "STR_NOTF_Impounding";
//Setup our progress bar.
disableSerialization;
5 cutRsc ["life_progress","PLAIN"];
_ui = uiNameSpace getVariable "life_progress";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;
while{true} do
{
sleep 0.09;
_cP = _cP + 0.01;
_progress progressSetPosition _cP;
_pgText ctrlSetText format["%3 (%1%2)...",round(_cP * 100),"%",_upp];
if(_cP >= 1) exitWith {};
if(player distance _vehicle > 10) exitWith {};
if(!alive player) exitWith {};
};
5 cutText ["","PLAIN"];
if(player distance _vehicle > 10) exitWith {hint localize "STR_NOTF_ImpoundingCancelled"; life_action_inUse = false;};
if(!alive player) exitWith {life_action_inUse = false;};
//_time = _vehicle getVariable "time";
//if(isNil {_time}) exitWith {deleteVehicle _vehicle; hint "This vehicle was hacked in"};
//if((time - _time) < 120) exitWith {hint "This is a freshly spawned vehicle, you have no right impounding it."};
if((count crew _vehicle) == 0) then
{
[_vehicle] call life_fnc_clearVehicleAmmo;
if(!((_vehicle isKindOf "Car") || (_vehicle isKindOf "Air") || (_vehicle isKindOf "Ship"))) exitWith {life_action_inUse = false;};
_type = getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
switch (true) do
{
case (_vehicle isKindOf "Car"): {_price = (call life_impound_car);};
case (_vehicle isKindOf "Ship"): {_price = (call life_impound_boat);};
case (_vehicle isKindOf "Air"): {_price = (call life_impound_air);};
};
life_impound_inuse = true;
[[_vehicle,true,player,true],"TON_fnc_vehicleStore",false,false] spawn life_fnc_MP;
waitUntil {!life_impound_inuse};
hint format[localize "STR_NOTF_Impounded",_type,_price];
[[0,format[localize "STR_NOTF_HasImpounded",player getVariable["realname",name player],(_vehicleData select 0) select 1,_vehicleName]],"life_fnc_broadcast",true,false] spawn life_fnc_MP;
life_atmcash = life_atmcash + _price;
}
else
{
hint localize "STR_NOTF_ImpoundingCancelled";
};
};
life_action_inUse = false;
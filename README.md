# ![image](https://github.com/Sqrl34/sqrl-nightclubs/assets/68661127/3cfc002a-66bb-4b22-b452-e6e608b9ad9b)

A script for fivem using the ESX framework that implements player owned nightclubs. This has been converted to ESX as the original script: https://github.com/Sqrl34/sqrl-nightclubs uses QBCore. All I did was the conversion of the QBCore functions to ESX and the Polyzone to Ox_lib Zones, and a few adjustments.

## INSTALL
1. Drag and drop the script into your files
2. Ensure you have ox_lib installed
3. If you have bob74_ipl follow below
  1 Go into bob74_ipl --> dlc_afterhours --> nightclubs.lua
  2 Remove around line 641, `AfterHoursNightclubs.Ipl.Interior.Load()`
4. Go into your database and run the nightclub.sql file to add it to your database
5. Go to client/main.lua line 144 and put your own phone notification script. It's already configured for those who uses QS-Smartphone.
6. Go inside the config file and edit to your liking

## Preview
[Youtube](https://www.youtube.com/watch?v=qEzkv861Rfw&ab_channel=SquirrelsScripts)

## Features
* Ownable nightclub with price
* Configureable club decore for everyone
* Editable prices for decore
* Employees and real npcs dancing within clubs
* Missions to improve popularity
* Prifit and Loss system
* Highly  Editable
* Visitable clubs

## Dependency
1. [ESX](https://github.com/esx-framework/esx_core)
2. [ox_lib](https://github.com/overextended/ox_lib)
3. [oxmysql](https://github.com/overextended/oxmysql)

## Notification
The notifications are set to ox_lib, but if you're using okokNotify you can uncomment them since I'm using okokNotify on my server.
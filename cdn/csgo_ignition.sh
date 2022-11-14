#!/bin/bash
GSLT=25C13BCAA62CECA1864A0A91929B3622
screen -dm bash -c "cd /root/csgo-server && bash /root/csgo-server/srcds_run -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $GSLT"

#!/bin/bash
GSLT=#your gslt here
screen -dm bash -c "cd /root/csgo-server && bash /root/csgo-server/srcds_run -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $GSLT"
#After entering your gslt here, do systemctl restart csgo-server
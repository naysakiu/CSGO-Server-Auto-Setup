#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

echo "      Thanks For Buying From Ignition."
echo "With this script you can setup your CS:GO server"
echo "      Made By SuperHori♡#6969"
read -p "Press any key to start installing ..."

apt -y install sudo
sudo apt update
sudo apt -y upgrade

curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
apt update
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install mariadb-server nginx git file tar bzip2 gzip unzip bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 libsdl2-2.0-0:i386

cd /etc/mysql
rm my.cnf
wget https://raw.githubusercontent.com/naysaku/CSGO-Server-Auto-Setup/main/cdn/my.cnf
cd /etc/mysql/mariadb.conf.d
rm 50-server.cnf
wget https://raw.githubusercontent.com/naysaku/CSGO-Server-Auto-Setup/main/cdn/50-server.cnf
systemctl restart mysql
systemctl restart mariadb
cd

mkdir steam-cmd
cd steam-cmd
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
./steamcmd.sh +force_install_dir /root/csgo-server +login anonymous +app_update 740 +quit

## set up 32 bit libraries
mkdir -p /root/.steam/sdk32
cp -v /root/steam-cmd/linux32/steamclient.so /root/.steam/sdk32/steamclient.so

## set up 64 bit libraries
mkdir -p /root/.steam/sdk64
cp -v /root/steam-cmd/linux64/steamclient.so /root/.steam/sdk64/steamclient.so

cd /etc/nginx/
rm nginx.conf
wget https://raw.githubusercontent.com/naysaku/CSGO-Server-Auto-Setup/main/cdn/nginx.conf
cd

fastdlip=`hostname -i`
{
    echo '//FastDownload'; \
    echo 'sv_downloadurl "http://'$fastdlip'/csgo"'; \
    echo 'sv_allowdownload 1'; \
    echo 'sv_allowupload 0'; \
} >> "/root/csgo-server/csgo/cfg/server.cfg"

echo "Warning, write these down somewhere."
read -p "Database username?: " db
read -p "Database user password?: " password
mysql -u root<<MYSQL_SCRIPT
CREATE DATABASE ${db};
CREATE USER '${db}'@'%' IDENTIFIED BY '${password}';
GRANT ALL PRIVILEGES ON *.* TO '${db}'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cd /etc/systemd/system
wget https://raw.githubusercontent.com/naysaku/CSGO-Server-Auto-Setup/main/cdn/csgo-server.service
cd /root
mkdir gslt_config
cd /root/gslt_config
read -p "Enter your GSLT:" gsltprint
{
    echo 'GSLT='$gsltprint''; \
    echo 'screen -dm bash -c "cd /root/csgo-server && bash /root/csgo-server/srcds_run -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $GSLT"'; \
} >> "/root/gslt_config/csgo_ignition.sh"
chmod +x csgo_ignition.sh
cd
systemctl enable csgo-server
echo ""
echo "Server installed!!!"
echo ""
echo "Your can connect on your database on https://phpmyadmin.ignitionhost.ro"
echo "Connect to the db using the server ip, database username and password"
echo "-----------------------------------------------------------------------------"
echo "DO NOT EVER RUN THE SERVER USING csgo_ignition.sh."
echo "You can control the server using systemctl start/restart/stop csgo-server."
echo "The server starts up automatically on every startup and after this setup."
echo "Use screen -r to enter the console, to exit the console hit Ctrl+A and then D"
echo "-----------------------------------------------------------------------------"
echo "Your FastDL link is http://$fastdlip/csgo."
read -p "Your Game Server Login Token is $gsltprint."
rm csgo.sh
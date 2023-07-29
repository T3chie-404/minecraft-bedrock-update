#!/bin/bash

# Enter as $1 the complete download url for the new version to be installed.
# https://www.minecraft.net/en-us/download/server/bedrock

NC='\033[0m' # No Color
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[1;32m'
MAGENTA='\033[0;35m'
CYAN='\033[1;36m'

if [ "$#" -ne 1 ]
then
        echo -e $RED "\n:::ERROR::: $CYAN Usage= $YELLOW start-upgrade.sh <DOWNLOAD_URL>\n" $NC
        exit 1
fi

echo -e $GREEN "\nStarting update"$NC ; sleep .2

echo -e $MAGNETA "\n    Backing up files"$NC ; sleep .5 ;

cp permissions.json permissions.json.bak &&
        echo -e $NC "\n\tpermissions.json copied" &&
        sleep .2 ;
cp server.properties server.properties.bak &&
        echo -e "\n\tserver.properties copied" &&
        sleep .2 ;
cp valid_known_packs.json valid_known_packs.json.bak &&
        echo -e "\n\tvalid_known_packs.json copied" &&
        sleep .2
cp allowlist.json allowlist.json.bak &&
        echo -e $NC "\n\tallowlist.json copied" &&
        sleep .2 ;

echo -e $GREEN "\n Using download link: $CYAN $1 $GREEN \n Script will Auto-Continue in 5 seconds\n" $RED

if read -r -s -n 1 -t 5 -p "Press any Key to Abort" key
        then
                echo -e " ...aborted!\n" $NC
                sleep 1
                exit
        else
                echo -e " ...continued\n" $NC
                sleep 1
fi

echo -e $GREEN "\nDownloading New Release" $NC
wget $1 -O /home/mcserver/minecraft_bedrock/bedrock-server.zip
unzip -o /home/mcserver/minecraft_bedrock/bedrock-server.zip -d /home/mcserver/minecraft_bedrock/
rm /home/mcserver/minecraft_bedrock/bedrock-server.zip
echo -e $GREEN "\nRestoring Backup Config..."
        sleep 5

cp permissions.json.bak permissions.json &&
        echo -e $NC "\n\tpermissions.json restored..." &&
        sleep .5 ;
cp server.properties.bak server.properties &&
        echo -e "\n\tserver.properties restored..." &&
        sleep .5 ;
cp valid_known_packs.json.bak valid_known_packs.json &&
        echo -e "\n\tvalid_known_packs.json restored..." &&
        sleep .5
cp allowlist.json.bak allowlist.json &&
        echo -e $NC "\n\tallowlist.json restored..." &&
        sleep .5 ;
echo -e $GREEN "\n Restore Complete\n\n Preparing to Start Minecraft Server...\n\n" $MAGENTA &&

if read -s -n 1 -t 5 -p "Press any key to abort" key
        then
                echo -e " ...aborted!\n" $NC
                sleep 1
                exit
        else
                echo -e " ...continued\n" $NC
                sleep 1
fi

sleep 5

echo -e $GREEN "\n "DONE"\n" $NC

echo -e $CYAN "STARTING MINECRAFT SERVER\n Use 'stop' to stop server" $NC
sleep 3

cd /home/mcserver/minecraft_bedrock/
sudo LD_LIBRARY_PATH=. ./bedrock_server

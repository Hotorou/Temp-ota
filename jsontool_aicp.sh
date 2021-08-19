#!/bin/bash
#This is for bliss

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"
if [ "$1" ]; then
    file_path=$1
    file_name=$(basename $file_path)
    device_name=$(echo $file_name | cut -d "-" -f 3)
    if [ -f $file_path ]; then
        if [[ $file_name == *"AICP"* ]]; then # only generate for official builds
            echo -e "${GREEN} Generating $device_name ota json ${NC}"
            file_size=$(stat -c%s $file_path)
            currenttime=$(date +%s)
            datetime=$(($currenttime - 86400))
            id=$(sha256sum $file_path | awk '{ print $1 }')
            link="https://noob-buildbot.zunayeddihan.workers.dev/0:/aicp/${file_name}"
            echo "{" > $file_path.json
            echo "  \"response\": [" >> $file_path.json
            echo "    {" >> $file_path.json
            echo "     \"datetime\": ${datetime}," >> $file_path.json
            echo "     \"filename\": \"${file_name}\"," >> $file_path.json
            echo "     \"id\": \"${id}\"," >> $file_path.json
            echo "     \"size\": ${file_size}," >> $file_path.json
            echo "     \"url\": \"${link}\"," >> $file_path.json
            echo "     \"version\": \"14.5\"," >> $file_path.json #need to change this value everytime
            echo "    }" >> $file_path.json
            echo "  ]" >> $file_path.json
            echo "}" >> $file_path.json
            mv "${file_path}.json" "daisy.json"
            echo -e "${GREEN}Done generating ${YELLOW}daisy.json${NC}"
        else
            echo -e "${YELLOW}Skipped generating json for a non-official build${NC}"
        fi
    fi
fi

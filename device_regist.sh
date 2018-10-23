#!/bin/bash device_regist.sh

#-------------------------------------------------------
# Paste from https://console.actions.google.com/ below
#-------------------------------------------------------
# From the link: Project - Menu - Project Settings - Copy Project ID and paste into below
ProjectID=YOUR_PROJECT_ID_HERE

# From the link: Project - Menu - Device Registration - Copy Model ID and paste into below
DeviceModelID=YOUR_DEVICE_MODEL_ID_HERE

Origin=$(pwd)

echo "=============================================================="
echo " Register 'credential.json' to Google"
echo " ** You must run this script at your device, not remote."
echo "=============================================================="
credentials="credentials.json"
credentials_Loc=$Origin/$credentials
if [[ ! -f $credentials_Loc ]]; then
    echo " ERROR - 'credentials.json' file not found."
    echo " Place your 'credentials.json' file to $Origin"
    echo " Ex) 'scp credentials.json linaro@ip_addr:$Origin'"
    trap - ERR
    exit -1 
fi

# enable virtual env
python3 -m venv env
source env/bin/activate
google-oauthlib-tool --client-secrets credentials.json --scope https://www.googleapis.com/auth/assistant-sdk-prototype --save --headless

echo "=============================================================="
echo " Register Project ID & Device Model ID to Google"
echo "=============================================================="
registinfo="registinfo-google.txt"
registinfo_Loc=$Origin/$registinfo
if [[ -f $registinfo_Loc ]]; then
    IFS=$'\r\n' GLOBIGNORE="*" command eval 'Line=($(cat $registinfo))'
    ProjectID=${Line[1]}
    DeviceModelID=${Line[3]}
fi

# If registinfo is not edited, delete exist variables
if [ "$ProjectID" = "YOUR_PROJECT_ID_HERE" ]; then
    ProjectID=""
fi
if [ "$DeviceModelID" = "YOUR_DEVICE_MODEL_ID_HERE" ]; then
    DeviceModelID=""
fi

while [[ -z $ProjectID ]] ; do
    read -p "Project ID : " ProjectID
done

while [[ -z $DeviceModelID ]] ; do
    read -p "Device Model ID : " DeviceModelID
done

googlesamples-assistant-devicetool --project-id $ProjectID list --model

echo "=============================================================="
echo " Create google_assistant.sh script for sample application"
echo "=============================================================="
echo "#!/bin/bash" | tee ./google_assistant.sh > /dev/null
echo "python3 -m venv env" | tee -a ./google_assistant.sh > /dev/null
echo "source env/bin/activate" | tee -a ./google_assistant.sh > /dev/null
echo "aplay $Origin/startup.wav" | tee -a ./google_assistant.sh > /dev/null
echo "cd new-project" | tee -a ./google_assistant.sh > /dev/null
echo "python -m pushtotalk --project-id  $ProjectID --device-model-id $DeviceModelID --lang en-us" | tee -a ./google_assistant.sh > /dev/null

echo "=============================================================="
echo " Create auto startup script for sample application"
echo "=============================================================="
echo "#!/bin/bash" | tee ./google_assistant_startup.sh > /dev/null
echo "cd $Origin" | tee -a ./google_assistant_startup.sh > /dev/null
echo "bash google_assistant.sh" | tee -a ./google_assistant_startup.sh > /dev/null

sudo mv ./google_assistant_startup.sh /etc/profile.d/

chmod +x *.sh

echo "=============================================================="
echo " Deice Registration Finished! Run sample application as"
echo " '$ ./google_assistant.sh'"
echo "=============================================================="

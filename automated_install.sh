#!/bin/bash automated_install.sh

echo "=============================================================="
echo " AiVA-96 for Google Assistant SDK on DragonBoard 410c"
date "+ Installation Started = %H:%M:%S"
echo "=============================================================="
echo " 1/4. Update & Upgrade OS"
echo "=============================================================="
sudo apt-get update
#sudo apt-mark hold linux-image-4.14.0-qcomlt-arm64
#sudo apt-get upgrade -y

echo "=============================================================="
echo " 2/4. Install Python and tools"
echo "=============================================================="
sudo apt-get install -y python3
sudo apt-get install -y python3-pip python3-venv
sudo apt-get install -y python3-dev python3-serial
sudo apt-get install -y portaudio19-dev libffi-dev libssl-dev

python3 -m venv env
source env/bin/activate
python -m pip install --upgrade pip 
python -m pip install setuptools wheel

echo "=============================================================="
echo " 3/4. Install grpcio and tools"
echo "=============================================================="
Python_Version=`python -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))'`
echo "Python version: $Python_Version "

if [ "$Python_Version" = "2.7" ]; then
  python -m pip install https://github.com/wizeiot/grpcio-build/raw/master/1.15.0/grpcio-1.15.0-cp27-cp27mu-linux_aarch64.whl
  python -m pip install https://github.com/wizeiot/grpcio-build/raw/master/1.15.0/grpcio_tools-1.15.0-cp27-cp27mu-linux_aarch64.whl
elif [ "$Python_Version" = "3.5" ]; then
  python -m pip install https://github.com/wizeiot/grpcio-build/raw/master/1.15.0/grpcio-1.15.0-cp35-cp35m-linux_aarch64.whl
  python -m pip install https://github.com/wizeiot/grpcio-build/raw/master/1.15.0/grpcio_tools-1.15.0-cp35-cp35m-linux_aarch64.whl
elif [ "$Python_Version" = "3.6" ]; then
  python -m pip install https://github.com/wizeiot/grpcio-build/raw/master/1.15.0/grpcio-1.15.0-cp36-cp36m-linux_aarch64.whl
  python -m pip install https://github.com/wizeiot/grpcio-build/raw/master/1.15.0/grpcio_tools-1.15.0-cp36-cp36m-linux_aarch64.whl
else
  echo " Wheels not found, new build needs up to 2 hours. Please wait!" 
  date "+ Started = %H:%M:%S"
  echo "=============================================================="
  python -m pip install grpcio
  python -m pip install grpcio-tools
fi

echo "=============================================================="
echo " 4/4. Install Google SDKs"
echo "=============================================================="
python -m pip install --upgrade google-auth-oauthlib[tool]
python -m pip install --upgrade google-assistant-sdk[samples]

git clone https://github.com/googlesamples/assistant-sdk-python
cp -r assistant-sdk-python/google-assistant-sdk/googlesamples/assistant/grpc new-project
cp pushtotalk.py ./new-project/

echo "=============================================================="
date "+ Installation Finished = %H:%M:%S"
echo " Now, copy your 'credentials.json' file into here and run"
echo " '$ bash device_regist.sh' at device."
echo "=============================================================="

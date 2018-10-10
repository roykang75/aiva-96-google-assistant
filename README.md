# Google Assistant using AiVA-96 & DragonBoard 410c

The WizeIoT’s AiVA mezzanine board for DragonBoard and 96Boards enables developers of the smart home devices such as smart speaker, smart panels, kitchen equipment and other commercial and industrial electronics products to evaluate and prototype far-field hands-free voice interface using Amazon Alexa, Google Assistant, Microsoft Cortana voice service.

Built around XMOS XVF3000 voice processor with direct interfacing to a line array of four digital microphones, the AiVA board is an ideal platform for developers who want to integrate AI speaker into their products.

The Google Assistant project aims at deploying Google Assistant on a DragonBoard410c by 96Boards. Recently, Google released a software development kit (SDK) which allows third party developers to build their own Google Assistant on hardware of their choice. The SDK lets us add features such as hotword detection, voice control and natural language processing to devices of our choice. In this project we will make our own version of Google Assistant using a **AiVA for DragonBoard 410c** (model name  AiVA-96). This development kit provides most advanced far-field voice capture using the XMOS XVF3000 voice processor. Combined with a DragonBoard 410c (96Boards) this kit allows you to quickly prototype and evaluate talking with Google Assistant.

To find out more, visit: https://wizeiot.com/aiva-96/ home page and: https://developers.google.com/assistant/sdk/guides/library/python/?hl=en

This repository provides a simple-to-use automated script to install the Google Assistant SDK on a DragonBoard 410c with AiVA-96.

Prerequisites
---
You will need:

- [AiVA-96 board](https://www.wizeiot.com/aiva-96/)
- [DragonBoard 410c](https://www.96boards.org/product/dragonboard410c/) or [compatible 96Boards](https://www.96boards.org/products/)
- [96Boards Compliant Power Supply](http://www.96boards.org/product/power/)
- MicroSD card (min. 16GB)
- Monitor with HDMI input, HDMI cable
- USB keyboard and mouse
- Wi-Fi with internet connectivity

You will also need an Google account: https://developers.google.com/assistant/sdk/?hl=en

Hardware setup
---
- Make sure the DragonBoard is powered off
- Connect I/O devices (Monitor, Keyboard, etc...)
- Connect AiVA-96 boards on top of DragonBoard
- Connect AiVA-96 MEMS mic board and speakers
- Power on your DragonBoard 410c with 96Boards compliant power supply
- To make sure the microphone and speakers are connected successfully, go to Application Menu -> Sound & Video -> PulseAudio Volume Control and check the input and output device, set as "WizeIoT AiVA-96 DevKit (UAC1.0) Analog Stereo". 

    ![AiVA-96 and DB410c](../../wiki/assets/aiva_db410c.jpg)

Google Assistant SDK installation and DragonBoard 410c audio setup
---
Full instructions to install the Google Assistant SDK on to a DragonBoard 410c and configure the audio to use the AiVA-96 are detailed in the Getting Started Guide available from: https://wizeiot.com/aiva-96/ home page.

Brief instructions and additional notes are below:


1. Create a new Google Assistant Project and Device by following
    + Configure a Developer Project and Account Settings
    https://developers.google.com/assistant/sdk/guides/library/python/embed/config-dev-project-and-account?hl=en

    + Register the Device Model  
    https://developers.google.com/assistant/sdk/guides/library/python/embed/register-device?hl=en  
    (Download credentials file to your PC.)

2. Install Debian (Stretch) on the DragonBoard 410c
   + You shoud use [Debian 17.09](http://releases.linaro.org/96boards/dragonboard410c/linaro/debian/17.09/dragonboard410c_sdcard_install_debian-283.zip), or higher. Note: '*apt-get upgrade*' from 18.01 possibly bring boot crash.
   + Write downloaded image file to your MicroSD card with [Etcher](https://etcher.io/) or other image writer software.
   + Turn on DragonBoard 410c's 'SD BOOT' dip switch and power on to install Debian.
   + After install Debian, remove MicroSD and power off and on.

3. Open a terminal on the DragonBoard 410c and clone this repository. 
    ```
    $ cd ~; git clone https://github.com/wizeiot/aiva-96-google-assistant.git
    ```

4. Run the installation script. We will begin with updating the already available packages and install the newer versions of packages we have. Than install Google Assistant SDK and their environmental tools.
    ```
    $ cd aiva-96-google-assistant/
    $ bash automated_install.sh
    ```
    It takes at least 5 ~ 10 min depending on your network speed.  
   
5. Copy your credentials file to DragonBoard 410c from your PC or Mac terminal,  
    ```
    $ scp credentials.json linaro@db410c_ip_address:/home/linaro/aiva-06-google-assistant
    ```
    You can also use [WinSCP](https://winscp.net/eng/download.php) or [FileZillia](https://filezilla-project.org/download.php?type=client) for transfer file. *Initial Debian password should be same as id.*

6. Run the device registration script
    ```
    $ bash device_regist.sh
    ```
    Be ready for [Project ID](../../wiki/Project-ID) and [Device Model ID](../../wiki/Model-ID) before run registration script.
   
    When "Please visit this URL to authorize this application: https://accounts.google.com/..." comes up on your terminal, click with your mouse right button and choose 'Open Link' for open from your browser. Than sign-in to your Google account and get authorization code. When code appears, copy (Ctrl+C) from browser and paste (Ctrl+Shift+V) into terminal.
   
    When script asks [Project ID](../../wiki/Project-ID) and [Device Model ID](../../wiki/Model-ID), type it to continue. When registration finished, 'google_assitant.sh' file will be created.  

6. Run Google Assistant
    ```
    $ bash google_assistant.sh
    ```

    *If need other language, change --lang option in google_assistant.sh*

7. Troubleshooting: This helps us do a simple speaker and microphone test, just to make sure that the hardware is functional.
    ```
    $ speaker-test -t wav
    $ arecord --format=S16_LE --duration=5 --rate=16000 --file-type=raw out.raw
    $ aplay --format=S16_LE --rate=16000 --file-type=raw out.raw
    ```
    If there is an error that says a certain package is missing, check the path of the imported packages in the code and make sure they are in the right place.

Enjoy your Google Assistant and don't forget to visit https://www.iotoi.io community for find out more projects. 

See [Project ID](../../wiki/Project-ID)  
See [Device Model ID](../../wiki/Model-ID)


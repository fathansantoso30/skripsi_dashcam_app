# Dashcam App
A final year project for undergraduate program

Dashcam App is a companion app for my ESP32-CAM project that can be used to:
- connect with ESP32-CAM via WiFi
- view, record, and take screenshot of the live streaming from ESP32-CAM camera feed
- view, download, and see list of video file that was saved on ESP32-CAM microSD Card


## Screenshot
Live Stream Page

<img src="/screenshot/ss%20live%20stream.jpg" alt="Live Stream Page" width="125"/> <img src="/screenshot/ss%20camera%20feed%20on.jpg" alt="Camera Feed On" width="125"/> <img src="/screenshot/ss%20screenshot%20saved%20portrait.jpg" alt="Screenshot Saved Portrait" width="125"/> <img src="/screenshot/ss%20record%20on%20portrait.jpg" alt="Record On Portrait" width="125"/> <img src="/screenshot/ss%20record%20saving.jpg" alt="Record Saving" width="125"/> <img src="/screenshot/ss%20record%20saved.jpg" alt="Record Saved" width="125"/>

Live Stream Landscape

<img src="/screenshot/ss%20live%20stream%20landscape.jpg" alt="Live Stream Landscape" height="125"/> <img src="/screenshot/ss%20record%20on%20landscape.jpg" alt="Record On Landscape" height="125"/> <img src="/screenshot/ss%20record%20saving%20landscape.jpg" alt="Record Saving Landscape" height="125"/> <img src="/screenshot/ss%20record%20saved%20landscape.jpg" alt="Record Saved Landscape" height="125"/> <img src="/screenshot/ss%20screenshot%20saved%20landscape.jpg" alt="Screenshot Saved Landscape" height="125"/> 

Album Page

<img src="/screenshot/ss%20album.jpg" alt="Album" width="125"/> <img src="/screenshot/ss%20download%20progress.jpg" alt="Download Progress" width="125"/> <img src="/screenshot/ss%20download%20saved.jpg" alt="Download Saved" width="125"/>

Video Player Page

<img src="/screenshot/ss%20video%20player%20no%20playback.jpg" alt="Video Player No Playback" width="125"/> <img src="/screenshot/ss%20video%20player.jpg" alt="Video Player" width="125"/>

Video Player Landscape/Fullscreen

<img src="/screenshot/ss%20video%20player%20landscape%20no%20playback.jpg" alt="Video Player Landscape No Playback" height="125"/> <img src="/screenshot/ss%20video%20player%20landscape.jpg" alt="Video Player Landscape" height="125"/>



## Prerequisite
- ESP32-CAM with OV2640
- MicroSD Card
- ESP32-CAM MB Micro USB Programmer
- Micro USB to USB cable
- Arduino IDE
- Android Smartphone

## Minimum Requirement Smartphone
- Operating System: Android 7.0 Nougat or higher
- RAM: 2 GB or higher
- Storage: At least 1 GB of free storage space

## How to use

1. Download and open program for your ESP32-CAM using Arduino IDE from [here](https://github.com/fathansantoso30/skripsi_esp32cam).
2. Connect the ESP32-CAM MB Programmer with your ESP32-CAM and put your microSD Card.
3. Connect ESP32-CAM to your PC, make sure you has installed the CH340 driver for the ESP32-CAM to be detected on Arduino IDE
4. Choose the corresponding port and board then upload the program.
5. Your ESP32-CAM now should have emitted access point named ESP32-CAM.
6. Download and install the latest app from the release tab or [here](https://github.com/fathansantoso30/skripsi_dashcam_app/releases).
7. Connect your device with the ESP32-CAM WiFi and turn on Location sensor. Location sensor need to be on to make sure your connection is connected to the ESP32-CAM.
8. The app is ready to be used.

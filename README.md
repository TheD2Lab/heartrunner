# Heartrunner2.0
## General 

### Hardware Requirement
This application requires
- Scosche Rythum Heart rate monitor
- iOS device with iOS 13+ , device has to developer mode enabled (https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device)
<br>
(Limited to iPad at the moment, changable in .xcodeproj destination setting)


### Install the application onto ipad
usually installing the application onto a device requires a lightnigh cable connected to the device physically.
In Xcode, choose the device you want to install the application on to.
<br>
 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/xcode_choose_device.png?raw=true)
<br>

After successfully install, go to the iOS Device and General > VPN & Device Management > Press on  Trust developer account.

<br>

 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/setting.PNG?raw=true)
<br>
-----

## Key Files
- Main.storyboard <br> - Flow control of the application, connecting all files together.
- scanViewController.swift <br> - Contains code to connect to call SDK and scan for heart rate monitors.
- dataViewController.swift <br> - Store away data from heart rate monitor to csv file and reading file locally.
- GameScene.swift <br> - The actual code for visualization, reads reading file real time and submit data to update function. <br> didmove function - the screen setup  init<br>  update function - changes properties on screen real time.

------
## Trouble Dhooting

### - Issue while installing
In xcode, go to signing and capabilities and  update the bundle id. then try installing again.
<br>
 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/xcode_bundle_id.png?raw=true)
<br>
There is a maximum capacity of device can be installed without an iOS developer account, hence you cannot distribute the application at mass without submissing to AppStore.  

### - iPad app not available
Due to the application was not packaged as AppStore ready archive, the application will need to be reinstall onto the iPad to run, as mentioned in installation section

### - Heart rate reading is below 60 constantly
This is the heart rate monitor reading issue, you can stop the application, give the user a different monitor, pick a different remaining time in the application and combining the file at the end. 

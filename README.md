# Heartrunner2.0
## 1. General 

### 1.1 Hardware Requirement
This application requires
- Scosche Rythum Heart rate monitor
- iOS device with iOS 13+ , device has to developer mode enabled (https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device)



### 1.2. Install the application onto ipad
Installing the application onto a device requires a lightning cable connected to the device physically.
In Xcode, choose the device you want to install the application on to, as figure 1 shown.


 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/xcode_choose_device.png?raw=true)

###### Figure 1. choosing install device in xocde
<br>

After seeing a prompt of "successfully install" from xcode, go to the iOS Device and General > VPN & Device Management > Press on  Trust developer account, as figure 2 shown.


 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/setting.PNG?raw=true)

 ###### Figure 2. iOS setting to allow permission to run the installed application.

-----

## 2. Key Files
```swift
Main.storyboard 
```
- Flow control of the application, connecting all screens and files together.
```swift
scanViewController.swift
```
- Contains code to connect to call SDK and scan for heart rate monitors.
```swift
dataViewController.swift 
```
- Store away data from heart rate monitor to csv file and reading file locally.
```swift
GameScene.swift
```
- The actual code for visualization, reads reading file real time and submit data to update function.

```swift
// in GameScene.swift, didMove function is responsible for screen set up init
override func didMove(to view: SKView) 
```

```swift
// in GameScene.swift, update function is responsible for updating  properties on screen real time per screen update, at 60 fps
override func update(_ currentTime: TimeInterval) 
```
-----

## 3. After running the application
Since all the data files are stored locally on the device, it requires to move the file to another permanant location like cloud to further process the data.

------
## 4. Trouble Shooting

#### 4.1 Issue while installing
Issue with: during application installing from xcode to device.

The solution: In xcode, go to signing and capabilities and  update the bundle id. then try installing again, as figure 3 shown.
<br>
 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/xcode_bundle_id.png?raw=true)

 ###### Figure 3. changing bundle ID in xcode

<br>

There is a maximum capacity of device can be installed without an iOS developer account, hence you cannot distribute the application at mass without submissing to AppStore.  

<br>

#### 4.2 iPad app not available
Issue with: Application will not run on device.

The error: When click on app on ipad, it prompts "App is not available".

The solution: Reinstall the application from xcode.
Due to the application was not packaged as AppStore ready archive, the application will need to be reinstall onto the iPad to run after a period of time, expected to be the development contract expires, please refer to section 1.2


<br>

#### 4.3 Heart rate reading is below 60 constantly
Issue with: heart rate is constantly showing below 60 during exercise.

The error: The heart rate monitor is having problem reading, can due to contact spot moved.

The solution: switch to another monitor and restart the application with the remaining time in the application and combining the file at the end. 

# Heartrunner2.0
## 1. General 

### 1.1 Hardware Requirement
This application requires
- Scosche Rhythm Heart Rate Monitor
- iPad with iPadOS 13+ (Developer mode must be enabled)

To turn on developer mode: https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device

### 1.2. iPad Installation
In addition to the application hardware requirements, the installation process requires: 
- Computer with Xcode installed 
- Cable to connect iPad to the computer (ex. Lightning cable) 

Installation steps: 
- Open the HeartRunner application in Xcode. 
- Connect the iPad to your computer using the appropriate cable. 
- If you see a pop-up asking, “Trust This Computer?”, tap “Trust”. 
- In Xcode, select the iPad that you connected to the computer (see Figure 1). 
- In Xcode, click the “play” button to run the application on your iPad. Xcode should indicate that the build was successful. 
- On the iPad, go to Settings > General > VPN & Device Management. Tap on “Trust Developer Account” to allow the iPad to run the application. 
- Find the installed application on your iPad. 

 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/xcode_choose_device.png?raw=true)

###### Figure 1. Choosing a target application for the build.
<br>

After seeing a prompt of "successfully install" from xcode, go to the iOS Device and General > VPN & Device Management > Press on  Trust developer account, as figure 2 shown.


 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/setting.PNG?raw=true)

 ###### Figure 2. Trusting developer account from the iPad.

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
- Stores away data from heart rate monitor to csv file and reading file locally.
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

## 3. Saving Data from the Application
After each time the application is run, a .CSV file detailing the user’s heart rates and associated time stamps is saved to the local machine (iPad) files. For more organized and permanent storage of this data, these .CSV files should be moved to a different location (such as to a Google Drive folder).

------
## 4. Troubleshooting

#### 4.1 Issue while installing
Issue with: during application installing from Xcode to device. 

The solution: In Xcode, go to signing and capabilities and update the bundle ID. Try installing again, as shown in Figure 3. 

Note: iOS developer accounts have limitations on how many devices an application can be installed on without submitting the application to the App Store. In order to bypass this limitation, we can change the Bundle ID. 

<br>
 ![screenshot](https://github.com/TheD2Lab/heartrunner/blob/main/xcode_bundle_id.png?raw=true)

 ###### Figure 3. Changing the bundle ID in Xcode.

<br>

#### 4.2 iPad app not available
Issue with: Application will not run on device. 

The error: When you launch the app on iPad, the device prompts "App is not available". 

The solution: Reinstall the application from Xcode. Due to the application was not packaged as App Store ready archive, the application will need to be reinstalled onto the iPad to run after a period of time (when the development contract expires; refer to section 1.2).

<br>

#### 4.3 Heart rate reading is below 60 constantly. 

Issue with: Heart rate is constantly shown as below 60 during exercise. 

The error: The heart rate monitor is having problems providing accurate readings, sometimes due to improper attachment onto the user. 

The solution: Switch to another monitor and restart the application, setting the exercise session time as what would be the remaining time in the original session before the error. Combine the files at the end. 

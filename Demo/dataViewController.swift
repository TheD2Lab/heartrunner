//
//  dataViewController.swift
//  Demo
//
//  Created by Scosche on 2/15/19.
//  Copyright © 2019 Scosche. All rights reserved.
//

import Foundation
import ScoscheSDK24
import CoreBluetooth
import UIKit
//import SwiftUI

/// dataViewController: Demo of connecting to a Scosche devices with BLE interface. View uses ScoscheViewController to extend a standard UIViewController with services that report monitor activity.
///
/// - Parameter monitor: ScoscheMonitor
class dataViewController: SchoscheViewController, UITableViewDelegate, UITableViewDataSource  {
    //MARK:- IB Refs
    
    @IBOutlet var tableview: UITableView!
    
    // set cell type
    enum cellType {
        case normal
        case user
        case mode
        case fit
    }
    // combine cell type with string for display
    struct cellRow {
        let type: cellType
        let value: String
    }
    
    //MARK:- Local Vars
    var listData: [cellRow] = []
    var returnState: cellType = .normal
//    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
    var readings: [Int] = []
    var temp: Int = 0
    var filename: String = "reading"
    
    
    //MARK:- Functions
    func currentLocalTime() -> String {
        var currentDate = Date()
        // 1) Create a DateFormatter() object.
        let format = DateFormatter()
         
        // 2) Set the current timezone to .current, or America/Chicago.
        format.timeZone = .current
         
        // 3) Set the format of the altered date.
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         
        // 4) Set the current date, altered by timezone.
        let dateString = format.string(from: currentDate)

        return dateString
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> = Set("1234567890 ")
        return String(text.filter {okayChars.contains($0) })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ScoscheDeviceConnect(monitor: monitor, monitorView: self)
        listData.append(cellRow(type: .normal, value: "Start Up: \(monitor.deviceName ?? "Unknown")"))
        
        //everytime this runs use a new file name with date
        let timestamp = removeSpecialCharsFromString(text: "\(currentLocalTime())")
        filename = "record \(timestamp).csv"
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    var heartratedata = [[String]]()
    
    func CSVRecordFile(read: String){
        let output = OutputStream.toMemory()
//        let filename = filename
        let docurl = getDocumentsDirectory().appendingPathComponent(filename)
        let csvWritter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter:",".utf16.first!)
        
        csvWritter?.writeField("HeartRate")
        csvWritter?.writeField("timestamp")
        csvWritter?.finishLine()
        
        let time = currentLocalTime()
        

        heartratedata.append([read, "\(time)"])
        
        for(elements) in heartratedata.enumerated(){
            csvWritter?.writeField(elements.element[0])
            csvWritter?.writeField(elements.element[1])
            csvWritter?.finishLine()
        }
        
        csvWritter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        do{
            try buffer.write(to: docurl)
        }catch{
            
        }
    }
    
    
    func CSVReadingFile(read: String){
        let stringToSave = "\(read)"
        let readingfilename = "reading.txt"
        let path = getDocumentsDirectory().appendingPathComponent(readingfilename)
        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
        
    }
    
    override func reloadTableData(){
        CSVRecordFile(read: "\(heartRate)")
        CSVReadingFile(read: "\(heartRate)")
        
        listData = []
        listData.append(cellRow(type: .normal, value: "Sensor Name: \(monitor.deviceName ?? "Unknown")"))
        if monitor.r24SportMode != nil {
            listData.append(cellRow(type: .mode, value: "Sport Mode: \(sportMode)"))
        }
        listData.append(cellRow(type: .normal, value: "Connection Status: \(connected)"))
        listData.append(cellRow(type: .normal, value: "Heart Rate: \(heartRate)"))
        listData.append(cellRow(type: .normal, value: "RR Interval: \(rrInterval)"))
        listData.append(cellRow(type: .normal, value: "Signal Quality: \(signalQuality)"))
        listData.append(cellRow(type: .normal, value: "Battery Level: \(batteryLevel)"))
        listData.append(cellRow(type: .user, value: "User Name: \(userInfo.name)"))
        listData.append(cellRow(type: .user, value: "Resting Heart Rate: \(userInfo.restinghr)"))
        listData.append(cellRow(type: .user, value: "Maximum Heart Rate: \(userInfo.maxhr)"))
        listData.append(cellRow(type: .user, value: "Gender: \(userInfo.gender)"))
        listData.append(cellRow(type: .user, value: "Age in Months: \(userInfo.age)"))
        listData.append(cellRow(type: .user, value: "Weight: \(userInfo.weight)"))
        listData.append(cellRow(type: .user, value: "Height: \(userInfo.height)"))
        listData.append(cellRow(type: .normal, value: "Zone One: \(userInfo.hrZoneOne)"))
        listData.append(cellRow(type: .normal, value: "Zone Two: \(userInfo.hrZoneTwo)"))
        listData.append(cellRow(type: .normal, value: "Zone Three: \(userInfo.hrZoneThree)"))
        listData.append(cellRow(type: .normal, value: "Zone Four: \(userInfo.hrZoneFour)"))
        if fitFileList.count == 0 {
            listData.append(cellRow(type: .normal, value: "FitFile Count: \(fitFileList.count)"))
        } else {
            listData.append(cellRow(type: .fit, value: "FitFile Count: \(fitFileList.count)"))
        }
        
        listData.append(cellRow(type: .normal, value: "VDC Signal: \(vdcSignal)"))
        listData.append(cellRow(type: .normal, value: "VDC Optical: \(vdcOptical)"))
        listData.append(cellRow(type: .normal, value: "VDC Heart Rate: \(vdcHeartRate)"))
        listData.append(cellRow(type: .normal, value: "VDC Step Rate: \(vdcStepRate)"))
        listData.append(cellRow(type: .normal, value: "VDC Stride Rate: \(vdcStrideRate)"))
        listData.append(cellRow(type: .normal, value: "VDC Distance: \(vdcDistance)"))
        listData.append(cellRow(type: .normal, value: "VDC Calories: \(vdcTotalCalories)"))
        listData.append(cellRow(type: .normal, value: "VDC Data 1: \(vdcRRIDataRegister1)"))
        listData.append(cellRow(type: .normal, value: "VDC Data 2: \(vdcRRIDataRegister2)"))
        listData.append(cellRow(type: .normal, value: "VDC Data 3: \(vdcRRIDataRegister3)"))
        listData.append(cellRow(type: .normal, value: "VDC Data 4: \(vdcRRIDataRegister4)"))
        listData.append(cellRow(type: .normal, value: "VDC Data 5: \(vdcRRIDataRegister5)"))
        listData.append(cellRow(type: .normal, value: "VDC Data Timestamp: \(vdcRRITimestamp)"))
        listData.append(cellRow(type: .normal, value: "VDC Data Status: \(vdcRRIStatus)"))
        tableview.reloadData()

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "gotoWorkout" {
//            if let destinationVC = segue.destination as? workoutViewController {
//                destinationVC.fitFileList = fitFileList
//            }
//        }
//        if segue.identifier == "gotoUser" {
//            if let destinationVC = segue.destination as? userViewController {
//                destinationVC.tempUserInfo = userInfo
//
//            }
//        }
//        if segue.identifier == "gotoMode" {
//            if let destinationVC = segue.destination as? modeViewController {
//                destinationVC.tempMode = sportMode
//            }
//        }
//    }
    
    @IBAction func unwindToData(_ unwindSegue: UIStoryboardSegue) {
        print("Unwind to data view")
        
        if returnState == .user {
            ScoscheDeviceUpdateInfo(monitor: monitor, userInfo: userInfo)
            ScoscheUserInfoWrite(userInfo: userInfo)
        }
        if returnState == .mode {
            self.onModeChangeAction?(sportMode)
        }
        reloadTableData()
    }
    
    //MARK:- Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = listData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! dataTableViewCell
        cell.header.text = row.value
        if row.type == .normal {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    
    // setting run time
    @IBAction func twentymin(_ sender: UIButton) {
        let stringToSave = "20"
        let runfilename = "runtime.txt"
        let path = getDocumentsDirectory().appendingPathComponent(runfilename)
        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    @IBAction func fifthteenmin(_ sender: UIButton) {
        let stringToSave = "15"
        let runfilename = "runtime.txt"
        let path = getDocumentsDirectory().appendingPathComponent(runfilename)
        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    @IBAction func tenmin(_ sender: UIButton) {
        let stringToSave = "10"
        let runfilename = "runtime.txt"
        let path = getDocumentsDirectory().appendingPathComponent(runfilename)
        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
    @IBAction func fivemin(_ sender: UIButton) {
        let stringToSave = "1"
        let runfilename = "runtime.txt"
        let path = getDocumentsDirectory().appendingPathComponent(runfilename)
        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = listData[indexPath.row]
//        if row.type == .fit {
//           self.performSegue(withIdentifier: "gotoWorkout", sender: nil)
//        }
//        if row.type == .user {
//            self.performSegue(withIdentifier: "gotoUser", sender: nil)
//        }
//        if row.type == .mode {
//            self.performSegue(withIdentifier: "gotoMode", sender: nil)
//        }
//    }
}

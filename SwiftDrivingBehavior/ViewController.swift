//
//  ViewController.swift
//  SwiftDrivingBehavior
//
//  Created by Preuttipan Janpen on 17/8/2562 BE.
//  Copyright © 2562 preuttipan. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

import Firebase
import FirebaseDatabase

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var viewNavigationBar: NavigationBar!
    
    @IBOutlet weak var labelBattery: UILabel!
    @IBOutlet weak var labelX: UILabel!
    @IBOutlet weak var labelY: UILabel!
    @IBOutlet weak var labelZ: UILabel!
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLong: UILabel!
    @IBOutlet weak var labelHorizontalAccuracy: UILabel!
    @IBOutlet weak var labelVerticalAccuracy: UILabel!
    @IBOutlet weak var labelSatelliteCount: UILabel!
    @IBOutlet weak var switchBackgroundTask: UISwitch!
    
    var motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    var timer:Timer?
    
    private var startTime: Date?
    
    
    //MARK: Firebase Database
    var ref: DatabaseReference!
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    let file = "logfile.txt"
    
    override func viewDidLoad() {
        
        print("Test scm pulling from jenkins 2")
        super.viewDidLoad()
        
        ref = Database.database().reference().child(UserDefaults.standard.value(forKey: "deviceName") as! String)
        
        
        switchBackgroundTask.isOn = true
        registerBackgroundTask()
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setupGetLocation), userInfo:nil, repeats: true)
        
        viewNavigationBar.title = "HELLO MAIN Controller"
        viewNavigationBar.leftButtonTitle = "Back"
        viewNavigationBar.leftButtonImage = UIImage(named: "blue-arrow")!
        
        viewNavigationBar.buttonLeft.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        
    }
    
    @IBAction func onSwitchBackgroundTask(_ sender: UISwitch) {
        if sender.isOn {
            print("switch is on")
//            registerBackgroundTask()
        } else {
            print("switch is off")
//            endBackgroundTask()
        }
    }
    
    @objc func setupGetLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
//            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var gyroX = Double()
        var gyroY = Double()
        var gyroZ = Double()
        
        guard let locValue = locations.last else { return }

        let time = locValue.timestamp
        
        guard let startTime = startTime else {
            self.startTime = time
            return
        }
        
        let elapsedTime = time.timeIntervalSince(startTime)
        
        labelLat.text = "Lat : \(locValue.coordinate.latitude)"
        labelLong.text = "Lon : \(locValue.coordinate.longitude)"
        
        labelHorizontalAccuracy.text = "Horizontal Acc : \(locValue.horizontalAccuracy)"
        labelVerticalAccuracy.text = "Vertical Acc : \(locValue.verticalAccuracy)"
        labelSatelliteCount.text = "Satellite Count : " + satelliteCount(Float(locValue.horizontalAccuracy), Float(locValue.verticalAccuracy))
        
        labelBattery.text = "Battery : \(String(Int(UIDevice.current.batteryLevel * 100)))%"
//        print("\(time) : \(elapsedTime) --> locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)")
        
        
//        writeFile(text: "\n\(time),\(locValue.coordinate.latitude),\(locValue.coordinate.longitude)")
        
        
        //MARK: Gyro Data
        motionManager.gyroUpdateInterval = 1
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
            if let gyroData = data {
                gyroX = Double(gyroData.rotationRate.x).rounded(toPlaces: 3)
                gyroY = Double(gyroData.rotationRate.y).rounded(toPlaces: 3)
                gyroZ = Double(gyroData.rotationRate.z).rounded(toPlaces: 3)
                self.labelX.text = "Gyro X : " + String(Double(gyroData.rotationRate.x).rounded(toPlaces: 3))
                self.labelY.text = "Gyro Y : " + String(Double(gyroData.rotationRate.y).rounded(toPlaces: 3))
                self.labelZ.text = "Gyro Z : " + String(Double(gyroData.rotationRate.z).rounded(toPlaces: 3))
            }
            self.motionManager.stopGyroUpdates()
            
            self.writeToFirebase(X: gyroX, Y: gyroY, Z: gyroZ, latitude: locValue.coordinate.latitude, longtitude: locValue.coordinate.longitude, horizontal_acc: locValue.horizontalAccuracy, vertical_acc: locValue.verticalAccuracy, satellite_count: self.satelliteCount(Float(locValue.horizontalAccuracy), Float(locValue.verticalAccuracy)))
        }
        
        if elapsedTime > 19 {
            self.startTime = time
            print("************")
        }
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
    }
    
    @objc func onClickBack() {
        print("Left Button")
    }
}

extension ViewController {
    
    func writeToFirebase(X gyroX: Double, Y gyroY: Double, Z gyroZ: Double, latitude: Double, longtitude: Double, horizontal_acc: Double, vertical_acc: Double, satellite_count: String) {
        
        let key = ref.childByAutoId().key!
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yy h:mm:ss"
        
        let rawData:[String:Any] = [
            "id": key,
            "gyro_x": gyroX,
            "gyro_y": gyroY,
            "gyro_z": gyroZ,
            "latitude": latitude,
            "longtitude": longtitude,
            "horizontal_acc": horizontal_acc,
            "vertical_acc": vertical_acc,
            "satellite_count": satellite_count,
            "timestamp": dateFormat.string(from: date),
            "battery": UIDevice.current.batteryLevel * 100
        ]
        
        ref.child(key).setValue(rawData)
    }
    
    func registerBackgroundTask() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTaskIdentifier != .invalid, "backgroundTaskIdentifier is no invalid")
        
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        backgroundTaskIdentifier = .invalid
        
//        timer?.invalidate()
//        timer = nil
    }
    
    func createFile() {
        let text = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Can't create file.")
            }
        }
    }
    
    func writeFile(text:String) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)

            if let fileUpdater = try? FileHandle(forUpdating: fileURL) {

                fileUpdater.seekToEndOfFile()

                fileUpdater.write(text.data(using: .utf8)!)

                fileUpdater.closeFile()
            }
        }
    }
    
    func readFile() -> String {
        var contentOfFile = ""
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                contentOfFile = try String(contentsOf: fileURL, encoding: .utf8)
                
            } catch { return "Can't read file." }
        }
        
        return contentOfFile
    }
    
    func satelliteCount(_ horizontalAccuracy:Float, _ verticalAccuracy:Float) -> String {
        var satelliteCount = "0"
        if verticalAccuracy > 0 {
            if horizontalAccuracy >= 0 && horizontalAccuracy <= 60 {
                satelliteCount = "5"
            } else {
                satelliteCount = "4"
            }
        } else {
            if horizontalAccuracy >= 60 && horizontalAccuracy <= 300 {
                satelliteCount = "3"
            } else if horizontalAccuracy > 300 {
                satelliteCount = "less than 3"
            } else {
                satelliteCount = "Can't Count"
            }
        }
        return satelliteCount
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

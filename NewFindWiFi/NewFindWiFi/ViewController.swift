//
//  ViewController.swift
//  NewFindWiFi
//
//  Created by Vaibhav Sharma on 08/06/23.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import CoreTelephony
import NetworkExtension


/*
class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var previousSSID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocation()
        print("You are connected with wifi :- ", getSupportedInterfaces() ?? "not found")
        previousSSID = getSupportedInterfaces()?.first?.ssid ?? ""
        changeNetworkSelectionCall()
    }
    
    func changeNetworkSelectionCall() {
        // Schedule a timer to periodically check for Wi-Fi changes
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.checkWiFiChange()
        }
        // Start the timer
        timer.fire()
    }
    
    func setupLocation() {
        // Create a CLLocationManager and assign a delegate
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Request a user’s location once
        locationManager.requestAlwaysAuthorization()
    }
    
    func getSupportedInterfaces() -> [NetworkInfo]? {
        
        if let interfaceNames = CNCopySupportedInterfaces() as? [String] {
            var networkInfos = [NetworkInfo]()
            for interfaceName in interfaceNames {
                var networkInfo = NetworkInfo(interface: interfaceName, success: false, ssid: nil, bssid: nil)
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interfaceName as CFString) as? [String: Any],
                   let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String {
                    networkInfo.success = true
                    networkInfo.ssid = ssid
                    networkInfo.bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String
                    print("networkInfo : -> \(networkInfo)")
                    networkInfos.append(networkInfo)
                }
            }
            return networkInfos
        }
        return nil
    }
    
    
    
    func checkWiFiChange() {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            print("Failed to retrieve supported interfaces")
            return
        }
        
        for interfaceName in interfaceNames {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interfaceName as CFString) as? [String: Any],
               let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String {
                if ssid != previousSSID {
                    print("Wi-Fi SSID changed to: \(ssid)")
                    previousSSID = ssid
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print(status)
        }
    }
}
*/


class ViewController: UIViewController {
    typealias NEHotspotHelperHandler = (NEHotspotHelperCommand) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetUp()
        scanForWiFiNetworks()
    }
    
    func connectWithDesiredWifiNetwork() {
        let manager = NEHotspotConfigurationManager.shared
        
        let hotspotConfiguration = NEHotspotConfiguration(ssid: "your wifi name", passphrase: "wifi password", isWEP: false)
            hotspotConfiguration.joinOnce = false
            hotspotConfiguration.lifeTimeInDays = 1

        
        manager.apply(hotspotConfiguration) { (error) in
            if let error = error {
                print("Failed to connect to Wi-Fi network: \(error.localizedDescription)")
            } else {
                print("Connected to Wi-Fi network successfully!")
            }
        }
    }

    func locationSetUp() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request location permission
        locationManager.startUpdatingLocation() // Start updating location

    }
    
    func scanForWiFiNetworks() {
        let options: [String: NSObject] = [kNEHotspotHelperOptionDisplayName : "NewFindWiFi" as NSObject]
        let queue: DispatchQueue = DispatchQueue(label: "com.myapp.appname", attributes: DispatchQueue.Attributes.concurrent)
        
        NSLog("Started wifi list scanning.")
        
        
        NEHotspotHelper.register(options: options, queue: queue) { (command)  in
            print(command)
        }
        
        /*
        let isAvailable = NEHotspotHelper.register(options: options, queue: queue) { (command) in
            switch command.commandType {
            case .evaluate,
                    .filterScanList:
                let originalNetworklist = command.networkList ?? []
                let networkList = originalNetworklist.compactMap { network -> NEHotspotNetwork? in
                    print("networkName: \(network.ssid); strength: \(network.signalStrength)")
//                    if network.ssid == targetSsid {
//                        network.setConfidence(.high)
//                        network.setPassword(targetPassword)
//                        return network
//                    }
                    return nil
                }
                let response = command.createResponse(.success)
                response.setNetworkList(networkList)
                response.deliver()
            default:
                break
            }
        }
         */
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle permission status changes
    }
}


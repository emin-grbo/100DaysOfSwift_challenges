//
//  ViewController.swift
//  Project22_iBeacon
//
//  Created by Emin Roblack on 4/17/19.
//  Copyright © 2019 Emin Roblack. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconTypeLabel: UILabel!
    var locationManager: CLLocationManager?
    
    var firstDetect = false
    
    var circle = UIView()
    
    var beacons = [
    "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5",
    "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6",
    "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
    "74278BDA-B644-4520-8F0C-720EAF059935"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circle = UIView(frame: CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 256, height: 256))
        circle.backgroundColor = .black
        circle.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        circle.layer.cornerRadius = 128
        circle.layer.zPosition = -1
        view.addSubview(circle)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                if CLLocationManager.isRangingAvailable(){
                    startScanning()
                }
            }
        }
    }


    
    func startScanning() {
        let beaconReagons = [CLBeaconRegion(proximityUUID: UUID(uuidString: beacons[0])!,
                                            major: 123, minor: 456, identifier: "Apple"),
                             CLBeaconRegion(proximityUUID: UUID(uuidString: beacons[1])!,
                                            major: 123, minor: 456, identifier: "RadiusNetworks"),
                             CLBeaconRegion(proximityUUID: UUID(uuidString: beacons[2])!,
                                            major: 123, minor: 456, identifier: "Apple2"),
                             CLBeaconRegion(proximityUUID: UUID(uuidString: beacons[3])!,
                                            major: 123, minor: 456, identifier: "Apple3")]
        
        for beaconRegion in beaconReagons {
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        }
        
    }
    
    
    func update(distance: CLProximity) {
        
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.distanceReading.textColor = .white
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.distanceReading.textColor = .white
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.distanceReading.textColor = .white
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconTypeLabel.text = "Unknown"
                self.distanceReading.textColor = .black
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first {
            if beacon.proximity == .unknown {
                update(distance: .unknown)
            } else {
                update(distance: beacon.proximity)
                
                // switching beacon name and info.
                switch beacon.proximityUUID.uuidString {
                case self.beacons[0]:
                    beaconTypeLabel.text = "Apple Beacon"
                case self.beacons[1]:
                    beaconTypeLabel.text = "Radius Beacon"
                case self.beacons[2]:
                    beaconTypeLabel.text = "Apple Beacon2"
                case self.beacons[3]:
                    beaconTypeLabel.text = "Apple Beacon3"
                default:
                    beaconTypeLabel.text = "Unknown"
                }
            }
            
            // Showing an alert once beacon is first detected.
            if !firstDetect {
                let vc = UIAlertController(title: "Beacon Detected", message: "We detected the first beacon", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(vc, animated: true)
            }
            firstDetect = true
        }
    }
}


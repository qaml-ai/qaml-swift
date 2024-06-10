//
//  AppDelegate.swift
//  qaml-test-harness
//
//  Created by Miguel Salinas on 5/23/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("testingPermissions") {
            PermissionRequester().requestPermissions()
        }
        return true
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

import CoreLocation
import AVFoundation
import Photos

class PermissionRequester: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager?
    
    func requestPermissions() {
        requestLocationPermission()
        requestCameraPermission()
        requestPhotoLibraryPermission()
    }
    
    private func requestLocationPermission() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Camera permission granted")
            } else {
                print("Camera permission denied")
            }
        }
    }
    
    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Photo library permission granted")
            case .denied, .restricted, .notDetermined:
                print("Photo library permission denied")
            @unknown default:
                fatalError("Unknown photo library permission status")
            }
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted")
        case .denied, .restricted, .notDetermined:
            print("Location permission denied")
        @unknown default:
            fatalError("Unknown location permission status")
        }
    }
}


//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Olexsii Levchenko on 7/30/22.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }

    
    @IBAction func getLocation(_ sender: UIButton) {
        let authStatus = locationManager.authorizationStatus
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniendAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
    func showLocationServicesDeniendAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = "Latitude: \(String(format: "%.8f", location.coordinate.latitude))"
            longitudeLabel.text = "Longitude: \(String(format: "%.8f", location.coordinate.longitude))"
        } else {
            latitudeLabel.text = "Latitude:"
            longitudeLabel.text = "Longitude:"
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        location = newLocation
        updateLabels()
    }
}

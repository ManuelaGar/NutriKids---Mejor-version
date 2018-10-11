//
//  InicioViewController.swift
//  NutriKids
//
//  Created by Manuela Garcia on 9/08/18.
//  Copyright © 2018 Manuela Garcia. All rights reserved.
//

import UIKit
import CoreLocation

class InicioViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var loc : [String : String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRegistro" {
            let registroVC = segue.destination as! RegistroViewController
            registroVC.loc = self.loc
        } else if segue.identifier == "goToIniciarSesion" {
            let inicioVC = segue.destination as! IniciarSesionViewController
            inicioVC.loc = self.loc
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            print("Longitude = \(longitude), Latitude = \(latitude)")
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let place = placemark?[0] {
                        if let country = place.country {
                            if let region = place.administrativeArea {
                                if let city = place.locality {
                                    if let address = place.thoroughfare {
                                        self.loc = ["País": "\(country)", "Region" : "\(region)" ,"Ciudad" : "\(city)", "Dirección" : "\(address)", "Longitude" : longitude, "Latitude" : latitude]
                                    }
                                }
                            }
                            print(self.loc)
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


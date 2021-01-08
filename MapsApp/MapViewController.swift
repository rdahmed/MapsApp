//
//  MapViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 12/25/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapsSettingsButtonsView: UIView!
    
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    let regionRadius = 1000.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkLocationServices()
    }
    
    
    // MARK: - Actions
    
    @IBAction func returnBackToUserLocation(_ sender: Any) {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    
    // MARK: - Helpers
    
    func setupUI() {
        mapsSettingsButtonsView.layer.cornerRadius = 8
        mapsSettingsButtonsView.layer.shadowColor = UIColor.lightGray.cgColor
        mapsSettingsButtonsView.layer.shadowOpacity = 1
        mapsSettingsButtonsView.layer.shadowOffset = .zero
        mapsSettingsButtonsView.layer.shadowRadius = 4
        
        favouritesView.layer.cornerRadius = 16
        searchBar.backgroundColor = .none
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // let the user know that they have to turn this on
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(region, animated: true)
        }
    }
}


// MARK: - Location Manager Delegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}


// MARK: - Navigation

extension MapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapsSettingsViewController {
            destination.delegate = self
        }
    }
}

extension MapViewController: MapsSettingsViewControllerProtocol {
    
    func didUpdateMapType(_ viewController: UIViewController, new mapType: MKMapType) {
        mapView.mapType = mapType
    }
    
}

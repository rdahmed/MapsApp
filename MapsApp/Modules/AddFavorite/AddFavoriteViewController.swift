//
//  AddFavoriteViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/11/21.
//

import UIKit
import MapKit

class AddFavoriteViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    let regionRadius = 1000.0
    lazy var location: LocationUIModel? = {
        guard let coordinate = locationManager.location?.coordinate else { return nil }
        let location = LocationUIModel(coordinate: coordinate)
        return location
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        centerViewOnUserLocation()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(close),
            name: .favoriteLocationAdded,
            object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        mapView.delegate = self
        addToFavoritesButton.layer.cornerRadius = 8
        addToFavoritesButton.clipsToBounds = true
    }
    
    func centerViewOnUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if let coordinate = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Map View Delegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        location?.coordinate = mapView.centerCoordinate
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FavoriteDetailsViewController {
            destination.favoriteLocation = self.location
        }
    }
}

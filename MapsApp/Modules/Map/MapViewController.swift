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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var settingsButtonContainerView: UIView!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let regionRadius = 1000.0
    private lazy var locations: [LocationUIModel] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        checkLocationServices()
        fetchLocation()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addToFavorites),
            name: .favoriteLocationAdded,
            object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func returnBackToUserLocation(_ sender: Any) {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func addToFavorites(_ notification: Notification) {
        guard let favoriteLocation = notification.object as? LocationUIModel else { return }
        locations.append(favoriteLocation)
        collectionView.reloadData()
    }
    
    func fetchLocation() {
        
        guard let url = URL(string: "https://run.mocky.io/v3/b5086734-076f-4042-831f-2fb1c6f66ac8") else {
            print("Not valid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            do {
                let apiModels = try JSONDecoder().decode([LocationAPIModel].self, from: data!)
                let uiModels = apiModels.map { LocationUIModel($0) }
                self.locations = uiModels
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    // MARK: - UI Helpers
    
    func setupUI() {
        settingsButtonContainerView.layer.cornerRadius = 8
        settingsButtonContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        settingsButtonContainerView.layer.shadowOpacity = 1
        settingsButtonContainerView.layer.shadowOffset = .zero
        settingsButtonContainerView.layer.shadowRadius = 4
        
        favoritesView.layer.cornerRadius = 16
        searchBar.delegate = self
        searchBar.backgroundColor = .none
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Location Helpers
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // let the user know that they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            centerMapOnCoordinate(locationManager.location?.coordinate)
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
    
    func centerMapOnCoordinate(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func animateToLocation(_ location: LocationUIModel) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(location)
        centerMapOnCoordinate(location.coordinate)
    }
    
    func clearMapViewAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

// MARK: - Location Manager Delegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        clearMapViewAnnotations()
        searchBar.resignFirstResponder()
    }
}

// MARK: - Navigation

extension MapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapsSettingsViewController {
            destination.selectedIndex = mapView.mapType.rawValue
            destination.delegate = self
        } else if let destination = segue.destination as? SeeAllFavoritesViewController {
            destination.favoriteLocations = self.locations
            destination.delegate = self
        }
    }
}

// MARK: - MapsSettingsViewControllerDelegate

extension MapViewController: MapsSettingsViewControllerDelegate {
    
    func didUpdateMapType(_ viewController: UIViewController, new mapType: MKMapType) {
        mapView.mapType = mapType
    }
}

// MARK: - SearchBarDelegate

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

// MARK: - FavoritesDelegate

extension MapViewController: FavoritesTableViewDelegate {
    
    func didTapLocation(_ viewController: SeeAllFavoritesViewController, _ location: LocationUIModel) {
        viewController.dismiss(animated: true)
        animateToLocation(location)
    }
}

// MARK: - UICollectionViewDataSource

extension MapViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 + locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteLocationCell", for: indexPath) as! FavoriteLocationCollectionViewCell
        
        if indexPath.row == 0 {
            // Add Cell (Static)
            cell.typeImageView.image = UIImage(systemName: "plus.circle.fill")
            cell.locationNameLabel.text = "Add"
       
        } else {
            // User Locations
            let location = locations[indexPath.item - 1]
            cell.locationNameLabel.text = location.displayTitle
            cell.typeImageView.image = UIImage(named: location.iconName ?? "") ?? UIImage(named: "Folder")
            
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MapViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            performSegue(withIdentifier: "addFavoriteSegue", sender: nil)
        } else {
            let location = locations[indexPath.row - 1]
            animateToLocation(location)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}

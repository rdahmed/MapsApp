//
//  SeeAllFavoritesViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/20/21.
//

import UIKit

protocol FavoritesTableViewDelegate: class {
    func didTapLocation(_ viewController: SeeAllFavoritesViewController, _ location: FavoriteLocation)
}

class SeeAllFavoritesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var favoriteLocationsTableView: UITableView!
    @IBOutlet weak var emptyTemplateLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: FavoritesTableViewDelegate?
    var favouriteLocations = [FavoriteLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        favoriteLocationsTableView.dataSource = self
        favoriteLocationsTableView.delegate = self
        favoriteLocationsTableView.tableHeaderView = UIView()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Table View Data Source & Delegate

extension SeeAllFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteLocationsTableView.isHidden = favouriteLocations.isEmpty
        return favouriteLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoritLocationTableViewCell else {
            return UITableViewCell()
        }
        let location = favouriteLocations[indexPath.row]
        
        cell.locationImageView.image = UIImage(named: location.iconName ?? "")
        cell.locationLabel.text = location.displayTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = favouriteLocations[indexPath.row]
        delegate?.didTapLocation(self, location)
    }
}
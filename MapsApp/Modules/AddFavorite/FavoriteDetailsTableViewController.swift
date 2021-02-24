//
//  FavoriteDetailsTableViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/14/21.
//

import UIKit
import CoreLocation

class FavoriteDetailsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Properties
    
    var favoriteLocation: LocationUIModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let favoriteLocation = favoriteLocation {
            setupUI(with: favoriteLocation)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationNameTextField.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    private func setupUI(with location: LocationUIModel) {
        locationLabel.text = location.cooridnateString
        locationNameTextField.text = location.title
        iconImageView.image = UIImage(named: location.iconName ?? "")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UINavigationController,
           let rootViewController = destination.viewControllers.first as? IconPickerTableViewController {
            rootViewController.delegate = self
        }
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Icon Picker Table View Delegate

extension FavoriteDetailsTableViewController: IconPickerTableViewControllerDelegate {
    func iconPicker(_ picker: IconPickerTableViewController, didPick iconName: String) {
        iconImageView.image = UIImage(named: iconName)
        favoriteLocation?.iconName = iconName
        dismiss(animated: true)
    }
}

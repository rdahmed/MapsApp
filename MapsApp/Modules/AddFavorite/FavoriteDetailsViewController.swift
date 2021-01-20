//
//  FavoriteDetailsViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/12/21.
//

import UIKit
import CoreLocation

class FavoriteDetailsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private var tableViewController: FavoriteDetailsTableViewController?
    var favoriteLocation: FavoriteLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true)
        
        favoriteLocation?.title = tableViewController?.locationNameTextField.text
        favoriteLocation?.iconName = tableViewController?.favoriteLocation?.iconName
        
        NotificationCenter.default.post(
            name: .favoriteLocationAdded,
            object: favoriteLocation)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FavoriteDetailsTableViewController {
            tableViewController = destination
            destination.favoriteLocation = self.favoriteLocation
        }
    }
}

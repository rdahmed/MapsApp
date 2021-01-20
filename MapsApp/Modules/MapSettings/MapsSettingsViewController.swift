//
//  MapsSettingsViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 12/31/20.
//

import UIKit
import MapKit

protocol MapsSettingsViewControllerDelegate: AnyObject {
    func didUpdateMapType(_ viewController: UIViewController, new mapType: MKMapType)
}

class MapsSettingsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mapsSettingsView: UIView!
    @IBOutlet weak var mapTypesSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    weak var delegate: MapsSettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        mapsSettingsView.layer.cornerRadius = 16
    }
    
    // MARK: - Actions

    @IBAction func close(_ sender: Any) {
        delegate?.didUpdateMapType(self, new: .standard)
        dismiss(animated: true)
    }
    
    @IBAction func changeMapType(_ sender: Any) {
        guard let type = MKMapType(rawValue: UInt(mapTypesSegmentedControl.selectedSegmentIndex)) else { return }
        delegate?.didUpdateMapType(self, new: type)
    }
}

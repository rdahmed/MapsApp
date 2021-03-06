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
    var selectedIndex: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapTypesSegmentedControl.selectedSegmentIndex = Int(selectedIndex ?? 0)
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        mapsSettingsView.layer.cornerRadius = 16
    }
    
    // MARK: - Actions

    @IBAction func touchOutside(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func changeMapType(_ sender: Any) {
        guard let type = MKMapType(rawValue: UInt(mapTypesSegmentedControl.selectedSegmentIndex)) else { return }
        delegate?.didUpdateMapType(self, new: type)
    }
}

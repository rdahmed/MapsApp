//
//  ChooseIconTableViewController.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/14/21.
//

import UIKit

protocol IconPickerTableViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerTableViewController, didPick iconName: String)
}

class IconPickerTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: IconPickerTableViewControllerDelegate?
    let icons = ["No Icon", "Groceries", "Folder", "Appointments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Table View Data Source & Delegate

extension IconPickerTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}

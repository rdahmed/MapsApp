//
//  FavoriteLocation.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/18/21.
//

import Foundation
import CoreLocation
import MapKit

class FavoriteLocation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var iconName: String?
    
    var displayTitle: String? {
        if let title = title {
            return title.isEmpty ? cooridnateString : title
        } else {
            return nil
        }
    }
    
    var cooridnateString: String {
        String(format: "%6f, %6f", coordinate.latitude, coordinate.longitude)
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}

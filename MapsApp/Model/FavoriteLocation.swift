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
    
    init(coordinate: CLLocationCoordinate2D,
         title: String? = nil,
         subtitle: String? = nil,
         iconName: String? = nil)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
    }
    
}

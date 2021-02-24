//
//  LocationModels.swift
//  MapsApp
//
//  Created by Radwa Ahmed on 1/18/21.
//

import Foundation
import CoreLocation
import MapKit

class LocationUIModel: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var iconName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    init(_ apiModel: LocationAPIModel) {
        self.coordinate = CLLocationCoordinate2D(
            latitude: apiModel.coordinate.latitude,
            longitude: apiModel.coordinate.longitude)
        self.title = apiModel.name
        self.iconName = apiModel.imageName
    }
    
    // MARK: - Formatters
    
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
    
}

struct LocationAPIModel: Codable {
    
    var name: String?
    var coordinate: Coordinate
    var imageName: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coordinate
        case imageName = "image_name"
    }
    
}

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "long"
    }
}

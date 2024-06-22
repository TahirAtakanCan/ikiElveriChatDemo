//
//  MapAnnotation.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 22.06.2024.
//

import Foundation
import MapKit


class MapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}

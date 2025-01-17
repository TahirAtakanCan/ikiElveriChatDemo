//
//  LocationMessage.swift
//  ikiElveriChatDemo
//
//  Created by Tahir Atakan Can on 21.06.2024.
//

import Foundation
import CoreLocation
import MessageKit

class LocationMessage: NSObject, LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}

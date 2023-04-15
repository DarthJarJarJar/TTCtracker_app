//
//  Location.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

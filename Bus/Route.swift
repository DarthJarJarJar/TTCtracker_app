//
//  Route.swift
//  Bus
//
//  Created by Ayaan on 2023-04-15.
//

import Foundation

struct Route: Identifiable, Codable {
    var tag: String
    var title: String
    var showing: Bool
    var id: Int 
}

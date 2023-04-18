//
//  Network.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//


import Foundation
import SwiftUI
import MapKit
import SWXMLHash

extension UserDefaults {
    var routes: [Route] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "routes") else { return [] }
            return (try? PropertyListDecoder().decode([Route].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "routes")
        }
    }
}





class Network: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var routes: [Route] = PersistenceManager.getRoutes()
    @Published var loadingVehicles: Bool = false
    @Published var routesToFetch: [String] = []
    @AppStorage("routesString") var routesString: String = ""
    @Published var startUpCheck = true
    @Published var allVehicles: [Vehicle] = []
    

    
    func syncRoutes(rs: String) {
        var rscopy = ""
        if !rs.isEmpty {
            rscopy = String(routesString.dropLast())
        }
        
        let array = rscopy.components(separatedBy: ",")
        
        for r in self.routes {
            if array.contains(r.tag) {
                let i = self.routes.firstIndex { $0.tag == r.tag }!
                routes[i].showing = true
            }
        }
    }
    
    func makeBinding(item: Route) -> Binding<Bool> {
        let i = self.routes.firstIndex { $0.id == item.id }!
        return .init(
            get: { self.routes[i].showing },
            set: { self.routes[i].showing = $0 }
        )
    }
    
    func checkRoutes() -> Bool{
        for route in self.routes {
            if route.showing {
                return true
            }
        }
        
        return false
    }
    
    
    func showingRoutes() -> [String] {
        var arr: [String] = []
        
        for route in self.routes {
            if route.showing {
                arr.append(route.tag)
            }
        }
        
        return arr
    }
    
    
    func getDirection(d: String) -> String {
        if d == "0" {
            return "S"
        } else if d == "1" {
            return "N"
        } else {
            return ""
        }
    }
    
    func getAllVehicleLocations() {
        let url = NSURL(string: "https://retro.umoiq.com/service/publicXMLFeed?command=vehicleLocations&a=ttc&r=&t=1681774773517")

        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            if data != nil
            {
                let feed=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let xml = SWXMLHash.parse(feed)
            
                
                
                // print(xml["body"]["vehicle"][0])
                var tempVehicles: [Vehicle] = []
                
                let showing = self.showingRoutes()
                
                
                for vehicle in xml["body"]["vehicle"].all {
                    
                    let x =  vehicle.element?.attribute(by: "dirTag")?.text.components(separatedBy: "_")
                    // print(x)
                    
                    let v = Vehicle(dirTag: vehicle.element?.attribute(by: "dirTag")?.text ?? "", heading: vehicle.element?.attribute(by: "heading")?.text ?? "" , id: vehicle.element?.attribute(by: "id")?.text ?? "", lat: vehicle.element?.attribute(by: "lat")?.text ?? "", lon: vehicle.element?.attribute(by: "lon")?.text ?? "", predictable: vehicle.element?.attribute(by: "predictable")?.text ?? "", routeTag: vehicle.element?.attribute(by: "routeTag")?.text ?? "", secsSinceReport: vehicle.element?.attribute(by: "secsSinceReport")?.text ?? "", speed: vehicle.element?.attribute(by: "speed")?.text ?? "" , direction: self.getDirection(d: x?[1] ?? "") , route: x?[2] ?? "" )
                    
                    if showing.contains(v.routeTag) {
                        tempVehicles.append(v)
                    }
                   
                    

                }
                
            
                
                self.allVehicles = tempVehicles

            }
        }
        task.resume()
    }
    
    func getRoutes() {
        let url = NSURL(string: "https://retro.umoiq.com/service/publicXMLFeed?command=routeList&a=ttc")

        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            if data != nil
            {
                let feed=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let xml = SWXMLHash.parse(feed)
            
                
                
                var tempRoutes: [Route] = []
                
            
                
                
                for route in xml["body"]["route"].all {
                    
                    let r = Route(tag: route.element?.attribute(by: "tag")?.text ?? "", title: route.element?.attribute(by: "title")?.text ?? "", showing: false, id: Int(route.element?.attribute(by: "tag")?.text ?? "0") ?? 0)
                    
        
                    tempRoutes.append(r)
                   
                    

                }
                
            
                
                self.routes = tempRoutes

            }
        }
        task.resume()
    }
    
    
}



//
//  Network.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//


import Foundation
import SwiftUI
import MapKit


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
    
    @Published var routesToFetch: [String] = []
    @AppStorage("routesString") var routesString: String = ""
    
    
    
    func getVehicles(route: String) {
        
        print("entering")
        guard let url = URL(string: "https://bus-api.onrender.com?r=\(route)") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpMethod = "GET"
        requestHeader.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let dataTask = URLSession.shared.dataTask(with: requestHeader) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUsers = try JSONDecoder().decode([Vehicle].self, from: data)
            
                        self.vehicles = decodedUsers
                        
                        
                        
                        
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        print(vehicles)
        
        dataTask.resume()
    }
    
    func getAllRoutes() {
        
        self.routesString = ""
        
        for r in routes {
            if r.showing {
                self.routesString = self.routesString + r.tag + ","
            }
        }
    
        
        print(self.routesString)
        
        if self.routesString.isEmpty {
            self.vehicles = []
            //getVehicles(route: routesString)
        
        } else {
            getVehicles(route: self.routesString)
          
        }
        
    
    }
    
    
    func getRoutes() {
        print("entering")
        guard let url = URL(string: "https://bus-api.onrender.com/routes") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpMethod = "GET"
        requestHeader.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let dataTask = URLSession.shared.dataTask(with: requestHeader) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUsers = try JSONDecoder().decode([Route].self, from: data)
                        self.routes = decodedUsers
                        PersistenceManager.saveRoutes(domainSchema: self.routes)
                        
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    
    
    func printVehicles() {
        for v in vehicles {
            print(v)
        }
    }
    
    
    func syncRoutes(rs: String) {
        var rscopy = ""
        if !rs.isEmpty {
            rscopy = String(routesString.dropLast())
        }
        
        let array = rscopy.components(separatedBy: ",")
        
        for r in self.routes {
            if array.contains(r.tag) {
                var i = self.routes.firstIndex { $0.tag == r.tag }!
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
    
  
}



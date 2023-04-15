//
//  Network.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//


import Foundation
import SwiftUI
import MapKit

class Network: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var routes: [Route] = []
    @Published var routesToFetch: [String] = []
    
    
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
        
        var routesString = ""
        
        for r in routes {
            if r.showing {
                routesString = routesString + r.tag + ","
            }
        }
    
        
        print(routesString)
        
        if routesString.isEmpty {
            self.vehicles = []
            //getVehicles(route: routesString)
        
        } else {
            getVehicles(route: routesString)
          
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
    
  
}



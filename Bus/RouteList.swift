//
//  RouteList.swift
//  Bus
//
//  Created by Ayaan on 2023-04-15.
//

import SwiftUI




struct RouteList: View {
    @EnvironmentObject var network: Network
    @State var searchKey: String = ""
    @State var e: Bool = false
    
    var body: some View {
        
        
        NavigationView {
            
            if network.routes.isEmpty {
                Text("Fetching routes...")
                    .navigationTitle("Routes")
            } else {
                List {
                    ForEach(filteredList) {route in
                        Toggle(route.title, isOn: network.makeBinding(item: route) )
                            .toggleStyle(.automatic)
                            .onChange(of: route.showing) { newValue in
                                print(route)
                                PersistenceManager.saveRoutes(domainSchema: network.routes)
                                network.vehicles = []
                                DispatchQueue.main.async {
                                    network.getAllVehicleLocations()
                                }
                            }
                    }
                }
                .navigationTitle("Routes")
                .searchable(text: $searchKey)
            }
        
            
            
        }
        
        
        
    }
    
    
    var filteredList:[Route] {
        if searchKey.isEmpty {
            return network.routes
        } else {
           
            return network.routes.filter { $0.title.localizedCaseInsensitiveContains(searchKey)}
        }
    }
}

struct RouteList_Previews: PreviewProvider {
    static var previews: some View {
        RouteList()
            .environmentObject(Network())
    }
}

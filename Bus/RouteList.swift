//
//  RouteList.swift
//  Bus
//
//  Created by Ayaan on 2023-04-15.
//

import SwiftUI

struct RouteList: View {
    @EnvironmentObject var network: Network
    @State private var hi: Bool = false
    @State private var s = ""
    var body: some View {
        
      
            List {
                
                ForEach($network.routes) {$route in
                    Toggle(route.title, isOn: $route.showing)
                        .toggleStyle(.automatic)
                        .onChange(of: route.showing) { newValue in
                            
                            network.getAllRoutes()
                        }
                }
            
            }
            
       
        
    }
}

struct RouteList_Previews: PreviewProvider {
    static var previews: some View {
        RouteList()
            .environmentObject(Network())
    }
}

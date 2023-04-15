//
//  ContentView.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//

import SwiftUI
import MapKit


let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()


struct ContentView: View {
    @State private var isShowing: Bool = false
    @EnvironmentObject var network: Network
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.848240, longitude: -79.254290), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))

    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $mapRegion, annotationItems: network.vehicles) { vehicle in
                //MapMarker(coordinate: location.coordinate)
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(vehicle.lat)!, longitude: Double(vehicle.lon)!)) {
                    BusLabel(label: vehicle.route + " " + vehicle.direction, speed: vehicle.speed, updated:vehicle.secsSinceReport)
                                 
                
                    }
            }
            
            Button("Routes") {
                isShowing.toggle()
            }
            .cornerRadius(50)
            .buttonStyle(.borderedProminent)
            .padding(50)
            .cornerRadius(200)
            .sheet(isPresented: $isShowing) {
                RouteList()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            
        
        }
        
        .ignoresSafeArea(.all)
        .onReceive(timer) { time in
            network.getAllRoutes()
            }
        .onAppear {
            network.getAllRoutes()
            network.getRoutes()
        
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}

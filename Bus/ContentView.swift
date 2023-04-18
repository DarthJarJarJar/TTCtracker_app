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
    @State var startUp = true
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
    
   

    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            
            
            if network.routes.isEmpty || (network.allVehicles.isEmpty && !network.showingRoutes().isEmpty && network.startUpCheck) {
                Image(systemName: "bus")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .onAppear {
                        startUp = false
                    }
            } else {
                Map(coordinateRegion: $mapRegion, annotationItems: network.allVehicles) { vehicle in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(vehicle.lat)!, longitude: Double(vehicle.lon)!)) {
                        ZStack {
                            Image(systemName: "bus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)




                            Text(getTag(route:vehicle.route, direction:vehicle.direction))
                                .fontWeight(.heavy)
                                .font(.caption2)
                                        .padding(4)
                                        .background(.white)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.black, lineWidth: 2)
                                                
                                        )
                                .offset(y:-15)
                            
                           
                                



                        }
                       
                        }
                }
                
                Button {
                    isShowing.toggle()
                } label: {
                    HStack {
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            
                        Text("Routes")
                            .fontWeight(.bold)
                            .padding(5)
                    }
                    .padding(5)
                }
                .cornerRadius(50)
                .buttonStyle(.borderedProminent)
                .padding(50)
                .cornerRadius(200)
                .sheet(isPresented: $isShowing) {
                    RouteList()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                        .environmentObject(network)
                }
                
                
                if network.loadingVehicles {
                    ProgressView()
                        .padding(20)
                }
            }
            
            
            
            
        
        }
        
        .ignoresSafeArea(.all)
        .onReceive(timer) { time in
            network.getAllVehicleLocations()
            //network.getAllRoutes()
            }
        .onAppear {
            
            //network.getAllRoutes()
            network.getAllVehicleLocations()
            
            if network.routes.isEmpty {
                network.getRoutes()     
            }

        
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}

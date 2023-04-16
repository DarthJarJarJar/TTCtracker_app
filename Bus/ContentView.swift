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
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
    
   

    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            
            
            if network.routes.isEmpty {
                Image(systemName: "bus")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
            } else {
                Map(coordinateRegion: $mapRegion, annotationItems: network.vehicles) { vehicle in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(vehicle.lat)!, longitude: Double(vehicle.lon)!)) {
                        ZStack {
                            Image(systemName: "bus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)




                            Text(getTag(route:vehicle.route, direction:vehicle.direction))
                                    .padding(3)
                                    .background(.white)

                                    .foregroundColor(.black)

                                    .border(.black)
                                    .font(.custom("Ac", size: 10))
                                    .offset(y:-18)



                        }
                       
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

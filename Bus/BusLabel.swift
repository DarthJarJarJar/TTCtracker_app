//
//  BusLabel.swift
//  Bus
//
//  Created by Ayaan on 2023-04-14.
//

import SwiftUI

struct BusLabel: View {
    @State var label: String
    @State var speed: String
    @State var updated: String
    @State var expanded = false
    
    var body: some View {
        ZStack {
            Image(systemName: "bus")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
            
            
            
            if expanded {
                VStack {
                    Text("Route: \(label)")
                    Text("Speed (km/h): \(speed)")
                    Text("Last Updated (s): \(updated)")
                }
                .padding(3)
                .background(.white)
                
                .foregroundColor(.black)
            
                .border(.black)
                .font(.caption)
                .offset(y:-35)
                .frame(width: 500, height:500).clipped()
                    
            } else {
                Text(label)
                    .padding(3)
                    .background(.white)
                    
                    .foregroundColor(.black)
                
                    .border(.black)
                    .font(.custom("Ac", size: 10))
                    .offset(y:-18)
            }
                
                
        }
        .onTapGesture {
            expanded.toggle()
        }
    }
}

struct BusLabel_Previews: PreviewProvider {
    var expand = false
    static var previews: some View {
        BusLabel(label: "102D N", speed:"36", updated:"10")
    }
}

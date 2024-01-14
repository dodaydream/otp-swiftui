//
//  TransitUpcomingTrip.swift
//  OTPSwiftUI
//
//  Created by Stanley Cao on 2024-01-14.
//

import SwiftUI

struct TransitUpcomingTrip: View {
    
    var color: Color?
    
    var body: some View {
        Group {
            HStack {
                VStack (alignment: .leading){
                    Text("17").font(.largeTitle).fontWeight(.heavy)
                    Text("Byron via Oxford").fontWeight(.semibold).padding(.bottom, 4)
                    Text("Oxford/Stuart").font(.caption2)
                }
                Spacer()
                VStack (alignment: .trailing) {
                    Text("1").font(.title).fontWeight(.bold)
                }
            }.padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(color)
                .foregroundColor(.white)
                .overlay(Divider(), alignment: .bottom)
        }
    }
}

#Preview {
    TransitUpcomingTrip(color: Color.red)
}

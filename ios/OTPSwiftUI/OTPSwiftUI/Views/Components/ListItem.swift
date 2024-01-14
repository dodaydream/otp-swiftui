//
//  ListItem.swift
//  OTPSwiftUI
//
//  Created by Stanley Cao on 2024-01-13.
//

import SwiftUI

struct ListItem<LeftIcon: View>: View {
    
    var title: String
    
    var subtitle: String?
    
    var leftIcon: LeftIcon?
    
    init (
        _ title: String,
        subtitle: String? = nil,
        leftIcon: (() -> LeftIcon)? = nil
    ) where LeftIcon == Image {
        self.title = title
        self.subtitle = subtitle
        self.leftIcon = leftIcon?()
    }
    
    @ViewBuilder
    private func makeContent() -> some View {
        
        if (subtitle != nil) {
            VStack (alignment: .leading) {
                Text(title)
                Text(subtitle!).font(.caption)
            }
        } else {
            Text(title)
        }
    }
    
    var body: some View {
        Button {} label: {
            HStack {
                leftIcon
                
                if (leftIcon != nil) {
                    Spacer().frame(width: 12)
                }
                
                makeContent()
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(ListItemButton())
    }
}

struct ListItemButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .frame(height: 64)
            .background(.background)
            .cornerRadius(8)
            .shadow(radius: 4)
            .padding(.horizontal, 16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        ListItem("Title")
        
        ListItem("Title", subtitle: "Subtitle", leftIcon: {
            Image(systemName: "house.fill")
        })
        
        ListItem("Title", subtitle: "Subtitle")
    }
}

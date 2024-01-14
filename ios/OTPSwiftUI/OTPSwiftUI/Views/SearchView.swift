//
//  SearchView.swift
//  OTPSwiftUI
//
//  Created by Stanley Cao on 2024-01-13.
//

import SwiftUI
import Combine

struct SearchButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(Constant.COLOR_PRIMARY)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
    }
}

struct SearchView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State var isOpened = false //false
    @FocusState private var isFocused: Bool
    @State var scrollPosition: CGPoint = .zero
    @State var initialScrollPositionY: CGFloat?
    @State var scrollViewOffset: CGFloat = UIScreen.main.bounds.height
    
    var windowHeight = UIScreen.main.bounds.height
    
    @Binding var offsetY: CGFloat
    
    let OFFSET = 128.0
    
    @Namespace private var animation
    
    @ViewBuilder private func buildSearchBarPlaceholder () -> some View {
        Button {
            withAnimation {
                isOpened.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                Text("Where do you want to go").font(.title2).foregroundStyle(.white).padding(.horizontal, 6)
                Spacer()
            }
            .frame(height: 48)
        }
        .buttonStyle(SearchButton())
        .shadow(radius: 10)
        .padding(.horizontal, 24)
        
    }
    
    @ViewBuilder private func buildSearchBar() -> some View {
        VStack (alignment: .leading) {
            
            Spacer().frame(height: safeAreaInsets.top)
            
            HStack (alignment: .top) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                TextField("", text: .constant(""), prompt: Text("Search for place or bus route").foregroundStyle(.white.opacity(0.8))
                          )
                    .foregroundColor(.white)
                    .focused($isFocused)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    @ViewBuilder private func buildScrollViewContent() -> some View {
        ListItem("Select from the map")
        
        ListItem("Home", subtitle: "123 Fake Street", leftIcon: {
            Image(systemName: "house.fill")
        })
    }
    
    var body: some View {
        
        if (!isOpened) {
            buildSearchBarPlaceholder()
                .transition(.scale(scale: 1))
                .offset(y: offsetY)
                .matchedGeometryEffect(id: "zoom", in: animation)
        } else {
            ZStack (alignment: .top) {
                buildSearchBar()
                    .offset(y: 0)
                    // .frame(height: windowHeight)
                    .background(Constant.COLOR_PRIMARY)
                    .transition(.scale(scale: 1))
                    .matchedGeometryEffect(id: "zoom", in: animation)
                    .overlay {
                        if (scrollPosition.y > 30) {
                            Color.black.frame(maxHeight: .infinity).opacity(0.5)
                        }
                    }
                
                
                GeometryReader { geo in
                    ScrollView (showsIndicators: false) {
                        VStack (alignment: .leading) {
                            buildScrollViewContent().offset(y: -8).zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            Spacer()
                        }.background(GeometryReader { geometry in
                            Color.white.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                        }).frame(height: geo.size.height)
                            .offset(y: 8)
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                                self.scrollPosition = value
                                isFocused = false
                            }
                    }
                    .coordinateSpace(name: "scroll")
                    .offset(y: scrollViewOffset)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .animation(.spring(), value: scrollViewOffset)
                    .onAppear {
                        scrollViewOffset = OFFSET
                        isFocused = true
                    }.onDisappear {
                        scrollViewOffset = windowHeight
                        isFocused = false
                    }
                }
            }
            .onChange(of: scrollPosition) {
                if (scrollPosition.y > 130) {
                    scrollViewOffset = windowHeight
                    withAnimation (.spring) {
                        isOpened.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView(offsetY: .constant(0))
}

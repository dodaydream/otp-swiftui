//
//  ContentView.swift
//  OTPSwiftUI
//
//  Created by Stanley Cao on 2024-01-11.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

class LocationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var location: CLLocation = CLLocation(latitude: 42.9849, longitude: -81.2453)

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse{
            print("Authorized")
            manager.startUpdatingLocation()
        } else {
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var scrollPosition: CGPoint?
    
    @State private var selectedLocation = CLLocationCoordinate2D(latitude: 42.9849, longitude: -81.2453)
    
    var locationManager = CLLocationManager()
    
    @StateObject private var locationDelegate = LocationDelegate()
    
    @State private var mapCamPos: MapCameraPosition = .automatic
    
    let DEFAULT_LIST_HEIGHT = 200.0
    let SEARCH_BAR_HEIGHT = 56.0
    
    let screenHeight = UIScreen.main.bounds.height
    
    private var mapMaxHeight: CGFloat {
        return screenHeight - DEFAULT_LIST_HEIGHT
    }
    
    private var mapHeight: CGFloat {
        guard let offsetY = scrollPosition?.y else { return mapMaxHeight }
        
        let height = mapMaxHeight + offsetY
        
        return height > 0 ? height : 0
    }
    
    private func requestLocationPermission() {
        print("request location permission")
        locationManager.delegate = locationDelegate
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            
            ScrollView (showsIndicators: false) {
                VStack (alignment: .leading, spacing: 0) {
                    Map (position: $mapCamPos){
                        UserAnnotation()
                    }.onReceive(locationDelegate.$location) { location in
                        print("onlocationreceived")
                        mapCamPos = .region(MKCoordinateRegion(center: location.coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                    }
                    .frame(height: mapHeight)
                    .padding(.top, mapMaxHeight - mapHeight)
                    .clipped()

                    ForEach([Color.blue, Color.cyan, Color.red, Color.green, Color.orange, Color.mint, Color.pink, Color.teal, Color.yellow], id: \.self) { color in
                        TransitUpcomingTrip(color: color)
                    }
                }
                .padding(.bottom, safeAreaInsets.bottom)
                .background(Color.yellow)
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    self.scrollPosition = value
                }
            }
            
            SearchView(offsetY: .constant(
                (mapHeight - SEARCH_BAR_HEIGHT + 12) > 52 ? mapHeight - SEARCH_BAR_HEIGHT + 12 : 52
            ))
        }
        .coordinateSpace(name: "scroll")
        .ignoresSafeArea()
        .onAppear {
            requestLocationPermission()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

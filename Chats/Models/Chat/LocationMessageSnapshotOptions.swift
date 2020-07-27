//
//  LocationMessageSnapshotOptions.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import MapKit

/// An object grouping the settings used by the `MKMapSnapshotter` through the `LocationMessageDisplayDelegate`.
public struct LocationMessageSnapshotOptions {

    /// Initialize LocationMessageSnapshotOptions with given parameters
    ///
    /// - Parameters:
    ///   - showsBuildings: A Boolean value indicating whether the snapshot image should display buildings.
    ///   - showsPointsOfInterest: A Boolean value indicating whether the snapshot image should display points of interest.
    ///   - span: The span of the snapshot.
    ///   - scale: The scale of the snapshot.
    public init(showsBuildings: Bool = false, showsPointsOfInterest: Bool = false, span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0), scale: CGFloat = UIScreen.main.scale) {
        self.showsBuildings = showsBuildings
        self.showsPointsOfInterest = showsPointsOfInterest
        self.span = span
        self.scale = scale
    }
    
    /// A Boolean value indicating whether the snapshot image should display buildings.
    ///
    /// The default value of this property is `false`.
    public var showsBuildings: Bool
    
    /// A Boolean value indicating whether the snapshot image should display points of interest.
    ///
    /// The default value of this property is `false`.
    public var showsPointsOfInterest: Bool
    
    /// The span of the snapshot.
    ///
    /// The default value of this property uses a width of `0` and height of `0`.
    public var span: MKCoordinateSpan
    
    /// The scale of the snapshot.
    ///
    /// The default value of this property uses the `UIScreen.main.scale`.
    public var scale: CGFloat
    
}

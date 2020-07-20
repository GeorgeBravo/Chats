//
//  LocationMessageCell.swift
//  Chats
//
//  Created by Касилов Георгий on 06.07.2020.
//  Copyright © 2020 Касилов Георгий. All rights reserved.
//

import UIKit
import MapKit

/// A subclass of `MessageContentCell` used to display location messages.
final class LocationMessageCell: MessageContentCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        snapShotter?.cancel()
        mapSnapshotImageView.image = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// The activity indicator to be displayed while the map image is loading.
    private var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    /// The image view holding the map image.
    private lazy var mapSnapshotImageView = UIImageView
        .create {
            $0.contentMode = .scaleAspectFit
    }
    
    private weak var snapShotter: MKMapSnapshotter?
    
    override func setup(with viewModel: TableViewCellModel) {
        super.setup(with: viewModel)
        guard let model = viewModel as? ChatTableViewLocationCellModel else { return }
        
        let options = LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
//        let animationBlock = displayDelegate.animationBlockForLocation(message: message, at: indexPath, in: messagesCollectionView)
        
        activityIndicator.startAnimating()
        
        let snapshotOptions = MKMapSnapshotter.Options()
        snapshotOptions.region = MKCoordinateRegion(center: model.locationItem.location.coordinate, span: options.span)
        snapshotOptions.showsBuildings = options.showsBuildings
        snapshotOptions.showsPointsOfInterest = options.showsPointsOfInterest
        
        let snapShotter = MKMapSnapshotter(options: snapshotOptions)
        self.snapShotter = snapShotter
        snapShotter.start { (snapshot, error) in
            defer {
                self.activityIndicator.stopAnimating()
            }
            guard let snapshot = snapshot, error == nil else {
                return
            }
            

            
            UIGraphicsBeginImageContextWithOptions(snapshotOptions.size, true, 0)
            
            snapshot.image.draw(at: .zero)
            
            var point = snapshot.point(for: model.locationItem.location.coordinate)
            //Move point to reflect annotation anchor
            point.x -= annotationView.bounds.size.width / 2
            point.y -= annotationView.bounds.size.height / 2
            point.x += annotationView.centerOffset.x
            point.y += annotationView.centerOffset.y
            
            annotationView.image?.draw(at: point)
            let composedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            self.mapSnapshotImageView.image = composedImage
        }
    }
}

// MARK: - Setup Views
extension LocationMessageCell: TableViewCellSetup {
    private func setupViews() {
        selectionStyle = .none
        self.horizontalStackViewContainerView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        messageContainerView.addSubview(mapSnapshotImageView) {
            $0.size([\.width: 240, \.height: 240])
            $0.top == messageContainerView.topAnchor
            $0.bottom == messageContainerView.bottomAnchor
            $0.leading == messageContainerView.leadingAnchor
            $0.trailing == messageContainerView.trailingAnchor
        }
    
        messageContainerView.addSubview(activityIndicator) {
            $0.centerY == messageContainerView.centerYAnchor
            $0.centerX == messageContainerView.centerXAnchor
        }
        
        super.setupSubviews()
    }
}

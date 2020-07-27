import Foundation
import CoreLocation
import Contacts
import MapKit

// class because protocol
public class Location: NSObject, LocationItem {
	public let name: String?
	
	// difference from placemark location is that if location was reverse geocoded,
	// then location point to user selected location
	public var location: CLLocation
	public let placemark: CLPlacemark
	
	public var address: String {
        if let postalAddress = placemark.postalAddress {
            let formatter = CNPostalAddressFormatter()
            formatter.style = .mailingAddress
            return formatter.string(from: postalAddress)
        } else {
            return "\(coordinate.latitude), \(coordinate.longitude)"
        }
	}
	
	public init(name: String?, location: CLLocation? = nil, placemark: CLPlacemark) {
		self.name = name
		self.location = location ?? placemark.location!
		self.placemark = placemark
	}
}

extension Location: MKAnnotation {
    
    @objc public var coordinate: CLLocationCoordinate2D {
		return location.coordinate
	}
	
    public var title: String? {
		return address
	}
}

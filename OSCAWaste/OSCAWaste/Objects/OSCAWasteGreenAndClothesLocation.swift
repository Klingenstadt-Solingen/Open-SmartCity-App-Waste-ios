import Foundation
import OSCAEssentials
import CoreLocation


public enum WasteLocationType: String, Codable, Equatable, Hashable  {
    case Grünschnittcontainer = "Grünschnittcontainer"
    case Altkleidercontainer = "Altkleidercontainer"
}

public struct OSCAWasteGreenAndClothesLocation: Codable, Equatable, Hashable {
    public static func == (lhs: OSCAWasteGreenAndClothesLocation, rhs: OSCAWasteGreenAndClothesLocation) -> Bool {
        lhs.objectId == rhs.objectId
    }

    public var objectId: Int

    public var locationType: String

    public var systemDesignation: String

    public var zipCode: String

    public var location: String

    public var district: String

    public var street: String

    public var streetNumber: String

    public var addition: String

    public var openingHours: [String]

    public var iconNumber: Int

    public var position: Position

    public var url: String?

    public var recyclingCenterText: String

    public var categories: Array<Kategorie>

    public var address: String
}

public struct Position: Codable, Equatable, Hashable{

    public var latitude: Double

    public var longitude: Double

    public func toCLLocationCoordinate2D() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

public struct Kategorie: Codable, Equatable, Hashable{
    
    public var objectId: Int
    
    public var name: String
               
    public var description: String
               
    public var iconNumber: Int
               
    public var location: String
               
    public var options: String
}

public struct OSCAWasteGreenAndClothesLocationParameter: Codable, Hashable, Equatable {
  var id: String?
  var wasteLocationType: WasteLocationType
}

//
//  OSCAWasteLocation.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 01.08.22.
//

import OSCAEssentials
import Foundation

public struct OSCAWasteLocation: OSCAParseClassObject, Equatable {
  /// Auto generated id
  public private(set) var objectId : String?
  /// UTC date when the object was created
  public private(set) var createdAt: Date?
  /// UTC date when the object was changed
  public private(set) var updatedAt: Date?
  /// The name of the location
  public var name                  : String?
  /// The phone number of the location
  public var telephone             : String?
  /// The email of the location
  public var email                 : String?
  /// The location description
  public var description           : String?
  /// The location of the organization
  public var location              : Location?
  /// URL to the source system
  public var sourceUrl             : String?
  /// The unique id of the location in the source system
  public var sourceId              : String?
  /// URL of the ite
  public var url                   : String?
  /// URL of the image
  public var image                 : String?
  /// Opening hours of the location
  public var openingHours          : OpeningHours?
  
  public struct Location: Codable, Hashable, Equatable {
    /// The locaion id
    public var id      : String?
    /// The address of the location
    public var address : Address
    /// The geopoint of the location
    public var geopoint: ParseGeoPoint?
  }
  
  public struct Address: Codable, Hashable, Equatable {
    /// The street address of the location
    public var streetAddress  : String?
    /// The locality of the location
    public var addressLocality: String?
    /// The postal code of the location
    public var postalCode     : String?
  }
  
  public struct OpeningHours: Codable, Hashable, Equatable {
    /// Opening hours for monday
    public var monday   : [String]?
    /// Opening hours for tuesday
    public var tuesday  : [String]?
    /// Opening hours for wednesday
    public var wednesday: [String]?
    /// Opening hours for thursday
    public var thursday : [String]?
    /// Opening hours for friday
    public var friday   : [String]?
    /// Opening hours for saturday
    public var saturday : [String]?
    /// Opening hours for sunday
    public var sunday   : [String]?
  }
}

extension OSCAWasteLocation {
  /// The type of the waste
  public var wasteType: OSCAWasteBinType? {
    switch name {
    case "Metall- und Elektroschrott":
      return OSCAWasteBinType.electricalWaste
      
    case "Grünschnitt Mobil":
      return OSCAWasteBinType.greenWaste
      
    case "Entsorgungshof/ Deponie Bärenloch/ Wertstoffhof":
      return OSCAWasteBinType.disposalYard
      
    case "Müllheizkraftwerk":
      return OSCAWasteBinType.wasteToEnergy
      
    default: return nil
    }
  }
}

extension OSCAWasteLocation {
  /// Parse class name
  public static var parseClassName : String { return "WasteLocation" }
}// end extension OSCAWasteLocation

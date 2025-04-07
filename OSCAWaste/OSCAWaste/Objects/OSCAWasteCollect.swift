//
//  OSCAWasteCollect.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 20.05.22.
//

import Foundation
import OSCAEssentials

/// ```json
/// {
///   "name": "Duales System",
///   "description": "Testdescription",
///   "type": 50,
///   "date": "2022-12-13T23:00:00.000Z",
///   "location": {
///     "name": "Testlocation",
///     "streetAddress": "Teststreet 1",
///     "addressLocality": "Solingen",
///     "postalCode": "42699",
///     "geopoint": {
///       "latitude": 51.1710385,
///       "longitude": 7.0369401
///      }
///   },
///   "color": "#00FF00",
///   "icon": "https://example.com"
/// }
/// ```
public struct OSCAWasteCollect: Equatable {
  public struct Location: Codable, Hashable, Equatable {
    /// location's name
    public var name           : String?
    /// location's street address
    public var streetAddress  : String?
    /// location's address locality
    public var addressLocality: String?
    /// location's zip code
    public var postalCode     : String?
    /// location's geo reference
    public var geopoint       : ParseGeoPoint?
  }// end public struct Location
  /// waste collect's name
  public var name: String?
  /// waste collect's description text
  public var description: String?
  /// waste collect's type
  public var type: Int?
  
  public var binType: OSCAWasteCollectBinType? = nil
  /// waste collect's pickup date
  public var date: String?
  /// waste collect's location object
  public var location: OSCAWasteCollect.Location?
  /// waste collect's color
  public var color: String?
  /// waste collect's icon URL
  public var icon: String?
  /// to avoid duplicate identifiers
  public var collectionId: String?
  /// waste collect time of collection information if available
  public var time: String?
  
    init(name: String?, description: String?, type: Int, date: String?, location: OSCAWasteCollect.Location?, color: String?, icon: String?, collectionId: String?, time: String?) {
        self.name = name
        self.description = description
        self.type = type
        self.date = date
        self.location = location
        self.color = color
        self.icon = icon
        self.collectionId = collectionId
        self.time = time
    
    self.binType = OSCAWasteCollectBinType(id: self.type, name: "")
  }
  
  public var filterTypeId : Int? {
    switch(self.type) {
        case 42: return 1;
        case 44: return 2;
        case 10: return 3;
        case 12: return 4;
        case 20: return 6;
        case 50: return 7;
        case 70: return 8;
        case 45: return 9;
        case 46: return 10;
        case 47: return 11;
        case 26: return 12;
        case 27: return 13;
        case 15: return 14;
        case 16: return 15;
        case 56: return 16;
        case 57: return 17;
        case 100: return 18;
        default: return nil;
      }
  }
  
  public mutating func setBinType(_ type: OSCAWasteCollectBinType?) {
    self.binType = type ?? OSCAWasteCollectBinType.fromStaticTypeId(id: self.type)
  }
}// end public struct OSCAWasteCollect

extension OSCAWasteCollect: Codable, Hashable {}

public struct OSCAWasteCollectBinType: Equatable {
  public var id: Int?
  public var name: String?
  
  public static func with(id: Int? = nil, name: String? = nil) -> OSCAWasteCollectBinType {
    return Self(id: id, name: name)
  }
  
  public static func fromStaticTypeId(id: Int? = nil) -> OSCAWasteCollectBinType {
    return Self(id: id, name: getDefaultNameFor(id: id))
  }
}

extension OSCAWasteCollectBinType: Decodable, Encodable, Hashable {}

extension OSCAWasteCollectBinType {
  public static func getDefaultNameFor(id: Int?) -> String? {
    switch(id) {
        case 10: return "Biotonne"
        case 12: return "Biotonne zweiwöchentlich"
        case 15: return "Bio-Großbehälter für Wohnanlagen"
        case 16: return "Bio-Großbehälter (2-wö.) für Wohnanlagen"
        case 20: return "Altpapier"
        case 25: return "Altpapier-Großbehälter für Wohnanlagen"
        case 26: return "Altpapier-Großbehälter (2-wö.) für Wohnanlagen"
        case 27: return "Altpapier-Großbehälter (4-wö.) für Wohnanlagen"
        case 30: return "Altglas"
        case 40: return "Restmüll"
        case 41: return "Restmüll wöchentlich"
        case 42: return "Restmüll zweiwöchentlich"
        case 44: return "Restmüll vierwöchentlich"
        case 45: return "Restmüll-Großbehälter für Wohnanlagen"
        case 46: return "Restmüll-Großbehälter (2-wö.) für Wohnanlagen"
        case 47: return "Restmüll-Großbehälter (4-wö.) für Wohnanlagen"
        case 50: return "Duales System"
        case 56: return "Duales System Großbehälter (2-wö.)"
        case 57: return "Duales System Großbehälter (4-wö.)"
        case 70: return "Weihnachtsbaum"
        case 80: return "Sperrmüll"
        case 90: return "Sonstige"
        case 91: return "Elektroschrott"
        case 92: return "Leuchtstofflampen und LEDs"
        case 93: return "Altkleider"
        case 94: return "Sondermüll (Batterien)"
        case 95: return "Schadstoffmobil"
        case 100: return "Grünschnittcontainer"
        case 101: return "Laubsammlung"
        default: return nil
      }
  }
}

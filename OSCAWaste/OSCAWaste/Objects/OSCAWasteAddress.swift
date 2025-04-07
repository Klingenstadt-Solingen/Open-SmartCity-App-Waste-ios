//
//  OSCAWasteAddress.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 19.04.22.
//

import Foundation
import OSCAEssentials

public struct OSCAWasteAddress: OSCAParseClassObject, Equatable {
  /// Auto generated id
  public private(set) var objectId                        : String?
  /// UTC date when the object was created
  public private(set) var createdAt                       : Date?
  /// UTC date when the object was changed
  public private(set) var updatedAt                       : Date?
  /// The street of the location
  public var streetAddress                                : String?
  /// The house number of the location
  public var houseNumber                                  : String?
  /// The source system URL string
  public var source                                       : String?
  /// The unique id inside the source system
  public var sourceId                                     : String?
  
  public var addition                                  : String?
  
  public var fullAddress: String? {
    guard let streetAddress = self.streetAddress,
          let houseNumber = self.houseNumber
    else { return nil }
    let addition = self.addition ?? ""
    return "\(streetAddress), \(houseNumber)\(addition)"
  }
}// end public struct OSCAWasteAddress

extension OSCAWasteAddress {
  /// optional computed variable URL of the source system
  public var sourceURL                                    : URL? {
    guard let sourceString = self.source else { return nil }
    return URL(string: sourceString)
  }// end public var sourceURL
}// end extension public struct OSCAWasteAddress

extension OSCAWasteAddress {
  /// Parse class name
  public static var parseClassName : String { return "WasteAddress" }
}// end extension OSCAWasteAddress

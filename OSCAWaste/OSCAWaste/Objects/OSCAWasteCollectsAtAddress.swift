//
//  OSCAWasteCollectsAtAddress.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 20.05.22.
//

import Foundation

public struct OSCAWasteCollectsAtAddress {
  public let address: String?
  public var collection: [OSCAWasteCollect]?
}// end public struct OSCAWasteCollectsAtAddress


extension OSCAWasteCollectsAtAddress: Decodable {}// end extension public struct OSCAWasteCollectsAtAddress

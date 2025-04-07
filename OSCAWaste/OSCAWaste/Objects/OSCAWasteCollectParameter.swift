//
//  OSCAWasteCollectParameter.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 20.05.22.
//

import Foundation

public struct OSCAWasteCollectParameter {
  var id: String?
  var filter: [Int]? = nil
  var greenWasteDistricts: [String]? = nil
}// end public struct OSCAWasteCollectParameter

extension OSCAWasteCollectParameter: Codable, Hashable, Equatable {}// end extension public struct OSCAWasteCollectParameter

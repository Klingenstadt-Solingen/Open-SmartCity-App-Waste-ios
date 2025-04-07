//
//  OSCAWasteBinType.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 01.08.22.
//

import Foundation

public enum OSCAWasteBinType: String {
  // MARK: - Picked up waste
  case organicWaste    = "organic_waste"
  case residualWaste   = "residual_waste"
  case recycledPaper   = "recycled_paper"
  case dualSystem      = "dual_system"
  case christmasTree   = "christmas_tree"
  case bulkWaste       = "bulk_waste"
  // MARK: - Special waste
  case electricalWaste = "electrical_waste"
  case greenWaste      = "green_waste"
  case disposalYard    = "disposal_yard"
  case wasteToEnergy   = "waste_to_energy"
  case unknown         = "unknown"
  
  public func localizedString() -> String {
    return NSLocalizedString(self.rawValue,
                             bundle: OSCAWaste.bundle,
                             comment: "")
  }
}

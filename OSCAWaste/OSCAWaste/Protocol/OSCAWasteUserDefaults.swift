//
//  OSCAWasteUserDefaults.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 20.07.22.
//

import Foundation

public protocol OSCAWasteUserDefaults {
  func setOSCAWasteAddress(_ wasteAddress: OSCAWasteAddress) throws -> Void
  func getOSCAWasteAddress() throws -> OSCAWasteAddress
  func setOSCAWasteReminder(_ isReminding: Bool) -> Void
  func getOSCAWasteReminder() -> Bool
  func setOSCAWasteDashboardEnabled(_ enabled: Bool) throws -> Void
  func getOSCAWasteDashboardEnabled() throws -> Bool
}

//
//  UserDefaults+OSCAWaste.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 20.07.22.
//

import Foundation

extension UserDefaults: OSCAWasteUserDefaults {
  public func setOSCAWasteAddress(_ wasteAddress: OSCAWasteAddress) throws {
    try setObject(wasteAddress, forKey: OSCAWaste.Keys.userDefaultsWasteAddress.rawValue)
    NotificationCenter.default.post(name: .userWasteAddressDidChange, object: nil, userInfo: nil)
  }
  
  public func getOSCAWasteAddress() throws -> OSCAWasteAddress {
    return try getObject(forKey: OSCAWaste.Keys.userDefaultsWasteAddress.rawValue, castTo: OSCAWasteAddress.self)
  }
    
    public func setOSCAWasteDashboardEnabled(_ enabled: Bool) {
        set(enabled, forKey: OSCAWaste.Keys.userDefaultsWasteDashboardEnabled.rawValue)
    }

    public func getOSCAWasteDashboardEnabled() -> Bool {
      return bool(forKey: OSCAWaste.Keys.userDefaultsWasteDashboardEnabled.rawValue) ?? false
    }
  
  public func setOSCAWasteReminder(_ isReminding: Bool) {
    set(isReminding, forKey: OSCAWaste.Keys.userDefaultsWasteReminder.rawValue)
    NotificationCenter.default.post(name: .wasteReminderDidChange, object: nil, userInfo: nil)
  }
  
  public func getOSCAWasteReminder() -> Bool {
    return bool(forKey: OSCAWaste.Keys.userDefaultsWasteReminder.rawValue)
  }
  
  public func getOSCAWasteSelectedBinTypeIds() -> [Int] {
    do {
      return try getObject(
        forKey: OSCAWaste.Keys.userDefaultsBinTypes.rawValue,
        castTo: [Int].self
      )
    } catch {
      return []
    }
  }
  
  public func setOSCAWasteSelectedBinTypes(ids: [Int]) throws {
    try setObject(ids, forKey: OSCAWaste.Keys.userDefaultsBinTypes.rawValue)
  }
}

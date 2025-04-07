//
//  Notification.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 06.10.22.
//

import Foundation

public extension NSNotification.Name {
  static let userWasteAddressDidChange = Notification.Name(rawValue: "OSCAWaste_UserWasteAddressDidChange")
  static let wasteReminderDidChange = Notification.Name(rawValue: "OSCAWaste_WasteReminderDidChange")
}

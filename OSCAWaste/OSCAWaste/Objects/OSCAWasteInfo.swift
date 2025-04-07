//
//  OSCAWasteInfo.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 01.03.23.
//

import Foundation

public struct OSCAWasteInfo: Codable, Equatable, Hashable {
  public var title: String?
  public var description: String?
  public var icon: String?
  public var color: String?
}

extension OSCAWasteInfo {
  public struct LanguageQueryParameter: Codable, Equatable, Hashable {
    public var lang: String
    
    public init(lang: String) {
      self.lang = lang
    }
  }
}

//
//  OSCAFunctionReqestResource+wasteInfo.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 01.03.23.
//

import Foundation
import OSCANetworkService

extension OSCAFunctionRequestResource {
  public static func wasteInfo(baseURL: URL, headers: [String: CustomStringConvertible], cloudFunctionParameter: OSCAWasteInfo.LanguageQueryParameter) -> OSCAFunctionRequestResource<OSCAWasteInfo.LanguageQueryParameter> {
    let cloudFunctionName = "waste-info"
    return OSCAFunctionRequestResource<OSCAWasteInfo.LanguageQueryParameter>(
      baseURL: baseURL,
      cloudFunctionName: cloudFunctionName,
      cloudFunctionParameter: cloudFunctionParameter,
      headers: headers)
  }
}

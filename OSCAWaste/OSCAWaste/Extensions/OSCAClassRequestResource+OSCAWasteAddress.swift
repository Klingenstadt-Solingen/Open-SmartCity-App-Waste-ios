//
//  OSCAClassRequestResource+OSCAWasteAddress.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 19.05.22.
//

import Foundation
import OSCANetworkService

extension OSCAClassRequestResource {
  ///```console
  /// curl -vX GET \
  /// -H "X-Parse-Application-Id: ApplicationId" \
  /// -H "X-PARSE-CLIENT-KEY: ClientKey" \
  /// -H 'Content-Type: application/json' \
  /// 'https://parse-dev.solingen.de/classes/WasteAddress'
  ///  ```
  static func wasteAddress(baseURL: URL, headers: [String: CustomStringConvertible], query: [String: CustomStringConvertible] = [:]) -> OSCAClassRequestResource<OSCAWasteAddress> {
    let parseClass = OSCAWasteAddress.parseClassName
    return OSCAClassRequestResource<OSCAWasteAddress>(baseURL: baseURL,
                                                      parseClass: parseClass,
                                                      parameters: query,
                                                      headers: headers)
  }// end static func wasteAddress
}// end extension public struct OSCAClassRequestResource

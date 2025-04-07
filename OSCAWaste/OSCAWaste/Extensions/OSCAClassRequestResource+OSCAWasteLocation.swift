//
//  OSCAClassRequestResource+OSCAWasteLocation.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 01.08.22.
//

import OSCANetworkService
import Foundation

extension OSCAClassRequestResource {
  ///```console
  /// curl -vX GET \
  /// -H "X-Parse-Application-Id: ApplicationId" \
  /// -H "X-PARSE-CLIENT-KEY: ClientKey" \
  /// -H 'Content-Type: application/json' \
  /// 'https://parse-dev.solingen.de/classes/WasteLocation'
  ///  ```
  static func wasteLocation(baseURL: URL, headers: [String: CustomStringConvertible], query: [String: CustomStringConvertible] = [:]) -> OSCAClassRequestResource<OSCAWasteLocation> {
    let parseClass = OSCAWasteLocation.parseClassName
    return OSCAClassRequestResource<OSCAWasteLocation>(baseURL: baseURL,
                                                       parseClass: parseClass,
                                                       parameters: query,
                                                       headers: headers)
  }
}

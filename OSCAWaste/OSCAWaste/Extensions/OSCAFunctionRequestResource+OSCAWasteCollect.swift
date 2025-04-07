//
//  OSCAFunctionRequestResource+OSCAWasteCollect.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 20.05.22.
//

import Foundation
import OSCANetworkService

extension OSCAFunctionRequestResource {
  static func wasteCollect(baseURL: URL,
                           headers: [String: CustomStringConvertible],
                           cloudFunctionParameter: OSCAWasteCollectParameter) -> OSCAFunctionRequestResource<OSCAWasteCollectParameter> {
    let cloudFunctionName = "waste-collection"
    return OSCAFunctionRequestResource<OSCAWasteCollectParameter>(baseURL: baseURL, cloudFunctionName: cloudFunctionName, cloudFunctionParameter: cloudFunctionParameter, headers: headers)
  }// end static func wasteCollect

  static func wasteFilter(baseURL: URL,
                           headers: [String: CustomStringConvertible],
                           cloudFunctionParameter: OSCAWasteCollectParameter) -> OSCAFunctionRequestResource<OSCAWasteCollectParameter> {
    let cloudFunctionName = "waste-filter"
    return OSCAFunctionRequestResource<OSCAWasteCollectParameter>(baseURL: baseURL, cloudFunctionName: cloudFunctionName, cloudFunctionParameter: cloudFunctionParameter, headers: headers)
  }
}// end extension public struct OSCAFunctionRequestResource

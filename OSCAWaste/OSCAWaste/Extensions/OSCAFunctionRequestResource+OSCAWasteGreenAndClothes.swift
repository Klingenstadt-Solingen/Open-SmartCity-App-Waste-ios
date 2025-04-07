//
//  OSCAClassRequestResource+OSCAWasteLocation.swift
//  OSCAWaste
//
//  Created by Ömer Kurutay on 01.08.22.
//

import OSCANetworkService
import Foundation

extension OSCAFunctionRequestResource {

    static func wasteGreenAndClothesLocation(baseURL: URL, headers: [String: CustomStringConvertible], cloudFunctionParameter: OSCAWasteGreenAndClothesLocationParameter) -> OSCAFunctionRequestResource<OSCAWasteGreenAndClothesLocationParameter> {
        let cloudFunctionName = "waste-container"
        return OSCAFunctionRequestResource<OSCAWasteGreenAndClothesLocationParameter>(baseURL: baseURL, cloudFunctionName: cloudFunctionName, cloudFunctionParameter: cloudFunctionParameter, headers: headers)
  }
    
    static func wasteGreenAndClothesDistrict(baseURL: URL,cloudFunctionParameter: OSCAWasteGreenAndClothesDistrictParameter, headers: [String: CustomStringConvertible]) -> OSCAFunctionRequestResource<OSCAWasteGreenAndClothesDistrictParameter> {
      let cloudFunctionName = "waste-districts"
        return OSCAFunctionRequestResource<OSCAWasteGreenAndClothesDistrictParameter>(baseURL: baseURL, cloudFunctionName: cloudFunctionName,cloudFunctionParameter: cloudFunctionParameter, headers: headers)
    }
}

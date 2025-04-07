//
//  OSCAWaste.swift
//  OSCAWaste
//
//  Created by Stephan Breidenbach on 19.04.22.
//

import Combine
import Foundation
import OSCAEssentials
import OSCANetworkService

public struct OSCAWasteDependencies {
  let defaultGeoPoint: OSCAGeoPoint?
  let networkService: OSCANetworkService
  let userDefaults: UserDefaults
  let analyticsModule: OSCAAnalyticsModule?
  public init(defaultGeoPoint: OSCAGeoPoint? = nil,
              networkService: OSCANetworkService,
              userDefaults: UserDefaults,
              analyticsModule: OSCAAnalyticsModule? = nil
  ) {
    self.defaultGeoPoint = defaultGeoPoint
    self.networkService = networkService
    self.userDefaults = userDefaults
    self.analyticsModule = analyticsModule
  } // end public init
} // end public struct OSCAWasteDependencies

/// OSCA waste module
public struct OSCAWaste: OSCAModule {
    
  public static let greenWasteAppointmentDistrictsKey = "green_waste_appointment_districts"
  /// module DI container
  var moduleDIContainer: OSCAWasteDIContainer!

  let transformError: (OSCANetworkError) -> OSCAWasteError = { networkError in
      print(networkError)
      print(networkError.localizedDescription)
      print(networkError.localizedDescription)
    switch networkError {
    case OSCANetworkError.invalidResponse:
      return OSCAWasteError.networkInvalidResponse
    case OSCANetworkError.invalidRequest:
      return OSCAWasteError.networkInvalidRequest
    case let OSCANetworkError.dataLoadingError(statusCode: code, data: data):
      return OSCAWasteError.networkDataLoading(statusCode: code, data: data)
    case let OSCANetworkError.jsonDecodingError(error: error):
      return OSCAWasteError.networkJSONDecoding(error: error)
    case OSCANetworkError.isInternetConnectionError:
      return OSCAWasteError.networkIsInternetConnectionFailure
    } // end switch case
  } // end let transformError

  /// version of the module
  public var version: String = "1.0.4"
  /// bundle prefix of the module
  public var bundlePrefix: String = "de.osca.waste"
  /// module `Bundle`
  ///
  /// **available after module initialization only!!!**
  public internal(set) static var bundle: Bundle!

  private var networkService: OSCANetworkService!
  
  public private(set) var defaultGeoPoint: OSCAGeoPoint?

  public private(set) var userDefaults: UserDefaults

  /**
   create module and inject module dependencies

   ** This is the only way to initialize the module!!! **
   - Parameter moduleDependencies: module dependencies
   ```
   call: OSCAWaste.create(with moduleDependencies)
   ```
   */
  public static func create(with moduleDependencies: OSCAWasteDependencies) -> OSCAWaste {
    var module: Self = Self(defaultGeoPoint: moduleDependencies.defaultGeoPoint,
                            networkService: moduleDependencies.networkService,
                            userDefaults: moduleDependencies.userDefaults)
    module.moduleDIContainer = OSCAWasteDIContainer(dependencies: moduleDependencies)
    return module
  } // end public static create

  /// initializes the events module
  ///  - Parameter networkService: Your configured network service
  private init(defaultGeoPoint: OSCAGeoPoint? = nil,
               networkService: OSCANetworkService,
               userDefaults: UserDefaults) {
    self.defaultGeoPoint = defaultGeoPoint
    self.networkService = networkService
    self.userDefaults = userDefaults
    var bundle: Bundle?
    #if SWIFT_PACKAGE
      bundle = Bundle.module
    #else
      bundle = Bundle(identifier: bundlePrefix)
    #endif
    guard let bundle: Bundle = bundle else { fatalError("Module bundle not initialized!") }
    Self.bundle = bundle
  } // end public init
} // end public struct OSCAWaste

extension OSCAWaste {
  public func fetchImageData(from url: URL) -> AnyPublisher<Data, OSCAWasteError> {
    let publisher = self.networkService.fetch(url)
    return publisher
      .mapError(self.transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  }
  
  public typealias OSCAWasteInfoPublisher = AnyPublisher<[OSCAWasteInfo], OSCAWasteError>

  /// ```console
  /// curl -vX POST 'https://parse-dev.solingen.de/functions/waste-info' \
  /// -H "X-Parse-Application-Id: <APP_ID>" \
  /// -H "X-Parse-Client-Key:  <CLIENT_KEY>" \
  /// -H 'Content-Type: application/json' \
  ///  -d '{"lang":"de_DE"}' \
  /// | python3 -m json.tool
  /// ```
  public func fetchWasteInfos(for language: String = "de_DE") -> OSCAWasteInfoPublisher {
    // init cloud function parameter object
    let cloudFunctionParameter = OSCAWasteInfo
      .LanguageQueryParameter(lang: language)

    var publisher: AnyPublisher<[OSCAWasteInfo], OSCANetworkError>
    #if MOCKNETWORK
    //    publisher = self.networkService.fetch(OSCABundleRequestResource<OSCAWasteCollectPublisher>)
    #else
    var headers = self.networkService.config.headers
    if let sessionToken = self.userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }
    
    publisher = self.networkService
      .fetch(OSCAFunctionRequestResource<OSCAWasteInfo.LanguageQueryParameter>
      .wasteInfo(baseURL: networkService.config.baseURL,
                 headers: headers,
                 cloudFunctionParameter: cloudFunctionParameter))
    #endif
    return publisher
      .mapError(self.transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  }
  
  public typealias OSCAWasteAddressPublisher = AnyPublisher<[OSCAWasteAddress], OSCAWasteError>
  /**
   curl -X GET \
   -H "X-Parse-Application-Id: <APP_ID>" \
   -H "X-Parse-Client-Key: <CLIENT_KEY>" \
   https://parse-dev.solingen.de/classes/WasteAddress \
   | python3 -m json.tool > OSCAWasteAddressTests.json
   */
  public func fetchAllWasteAddresses(maxCount: Int = 1000,
                                     query: [String: String] = [:]) -> OSCAWasteAddressPublisher {
    guard maxCount > 0 else {
      return Empty(completeImmediately: true,
                   outputType: [OSCAWasteAddress].self,
                   failureType: OSCAWasteError.self).eraseToAnyPublisher()
    } // end guard

    var parameters = query
    parameters["limit"] = "\(maxCount)"

    var headers = networkService.config.headers
    if let sessionToken = userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }

    var publisher: AnyPublisher<[OSCAWasteAddress], OSCANetworkError>
    #if MOCKNETWORK
      publisher = networkService.fetch(OSCABundleRequestResource<WasteAddress>.wasteAddress(bundle: Self.bundle, fileName: "WasteAddress.json"))
    #else
      publisher = networkService.fetch(OSCAClassRequestResource<OSCAWasteAddress>
        .wasteAddress(baseURL: networkService.config.baseURL,
                      headers: headers,
                      query: parameters))
    #endif
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  } // end public func fetchAll

  public func fetchAllWasteLocations(maxCount: Int = 1000,
                                     query: [String: String] = [:]) -> AnyPublisher<[OSCAWasteLocation], OSCAWasteError> {
    guard maxCount > 0 else {
      return Empty(completeImmediately: true,
                   outputType: [OSCAWasteLocation].self,
                   failureType: OSCAWasteError.self).eraseToAnyPublisher()
    }

    var parameters = query
    parameters["limit"] = "\(maxCount)"

    var headers = networkService.config.headers
    if let sessionToken = userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }

    let publisher: AnyPublisher<[OSCAWasteLocation], OSCANetworkError> = networkService.fetch(OSCAClassRequestResource<OSCAWasteLocation>
      .wasteLocation(baseURL: networkService.config.baseURL,
                     headers: headers,
                     query: parameters))
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  }

  public typealias OSCAWasteCollectPublisher = AnyPublisher<OSCAWasteCollectsAtAddress, OSCAWasteError>

  /// ```console
  /// curl -vX POST 'https://parse-dev.solingen.de/functions/waste-collection' \
  /// -H "X-Parse-Application-Id: <APP_ID>" \
  /// -H "X-Parse-Client-Key:  <CLIENT_KEY>" \
  /// -H 'Content-Type: application/json' \
  ///  -d '{"id":1974281}' \
  /// | python3 -m json.tool
  /// ```
  public func fetchWasteCollections(for wasteAddress: OSCAWasteAddress) -> OSCAWasteCollectPublisher {
    guard let objectId = wasteAddress.objectId
    else {
      return Empty(completeImmediately: true,
                   outputType: OSCAWasteCollectsAtAddress.self,
                   failureType: OSCAWasteError.self).eraseToAnyPublisher()
    } // end guard
    // init cloud function parameter object
    let cloudFunctionParameter = OSCAWasteCollectParameter(id: objectId)

    var publisher: AnyPublisher<OSCAWasteCollectsAtAddress, OSCANetworkError>
    #if MOCKNETWORK
    //    publisher = self.networkService.fetch(OSCABundleRequestResource<OSCAWasteCollectPublisher>)
    #else
      var headers = networkService.config.headers
      if let sessionToken = userDefaults.string(forKey: "SessionToken") {
        headers["X-Parse-Session-Token"] = sessionToken
      }

      publisher = networkService.fetch(OSCAFunctionRequestResource<OSCAWasteCollectParameter>
        .wasteCollect(baseURL: networkService.config.baseURL,
                      headers: headers,
                      cloudFunctionParameter: cloudFunctionParameter))
    #endif
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  } // end public func fetchWasteCollections
  
  public func fetchWasteCollections(for wasteAddress: OSCAWasteAddress, binTypes: [Int]? = nil) -> OSCAWasteCollectPublisher {
    guard let sourceId = wasteAddress.objectId
    else {
      return Empty(completeImmediately: true,
                   outputType: OSCAWasteCollectsAtAddress.self,
                   failureType: OSCAWasteError.self).eraseToAnyPublisher()
    } // end guard
      let greenWasteDistricts = UserDefaults.standard.stringArray(
        forKey: OSCAWaste.greenWasteAppointmentDistrictsKey
      )
    // init cloud function parameter object
      let cloudFunctionParameter = OSCAWasteCollectParameter(
        id: sourceId,
        filter: binTypes,
        greenWasteDistricts: greenWasteDistricts
      )

    var publisher: AnyPublisher<OSCAWasteCollectsAtAddress, OSCANetworkError>
    #if MOCKNETWORK
    //    publisher = self.networkService.fetch(OSCABundleRequestResource<OSCAWasteCollectPublisher>)
    #else
      var headers = networkService.config.headers
      if let sessionToken = userDefaults.string(forKey: "SessionToken") {
        headers["X-Parse-Session-Token"] = sessionToken
      }

      publisher = networkService.fetch(OSCAFunctionRequestResource<OSCAWasteCollectParameter>
        .wasteCollect(baseURL: networkService.config.baseURL,
                      headers: headers,
                      cloudFunctionParameter: cloudFunctionParameter))
    #endif
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  } // end public func fetchWasteCollections

  /// ```console
  /// curl -vX POST 'https://parse-dev.solingen.de/functions/elastic-search' \
  /// -H "X-Parse-Application-Id: <APP_ID>" \
  /// -H "X-Parse-Client-Key: <CLIENT_KEY>" \
  /// -H 'Content-Type: application/json' \
  /// -d '{"index":"waste_address","query":"Wittkuller"}'
  /// ```
  public func elasticSearch(for query: String, at index: String = "waste_address", isRaw: Bool = true) -> OSCAWasteAddressPublisher {
    guard !query.isEmpty,
          !index.isEmpty
    else {
      return Empty(completeImmediately: true,
                   outputType: [OSCAWasteAddress].self,
                   failureType: OSCAWasteError.self).eraseToAnyPublisher()
    } // end guard
    // init cloud function parameter object
    let cloudFunctionParameter = ParseElasticSearchQuery(index: index,
                                                         query: query, raw: isRaw)

    var publisher: AnyPublisher<[OSCAWasteAddress], OSCANetworkError>
    #if MOCKNETWORK

    #else

      var headers = networkService.config.headers
      if let sessionToken = userDefaults.string(forKey: "SessionToken") {
        headers["X-Parse-Session-Token"] = sessionToken
      }

      publisher = networkService.fetch(OSCAFunctionRequestResource<ParseElasticSearchQuery>
        .elasticSearch(baseURL: networkService.config.baseURL,
                       headers: headers,
                       cloudFunctionParameter: cloudFunctionParameter))
    #endif
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  } // end public func elasticSearch for waste Address
  
  
  public typealias OSCAWasteCollectFilterPublisher = AnyPublisher<[OSCAWasteCollectBinType], OSCAWasteError>
  
  public func fetchAvailableBinTypes(for wasteAddress: OSCAWasteAddress) -> OSCAWasteCollectFilterPublisher {
    guard let objectId = wasteAddress.objectId
    else {
      return Empty(completeImmediately: true,
                   outputType: [OSCAWasteCollectBinType].self,
                   failureType: OSCAWasteError.self).eraseToAnyPublisher()
    }
    
    let cloudFunctionParameter = OSCAWasteCollectParameter(id: objectId)

    var publisher: AnyPublisher<[OSCAWasteCollectBinType], OSCANetworkError>
    #if MOCKNETWORK
      
    #else
      var headers = networkService.config.headers
      if let sessionToken = userDefaults.string(forKey: "SessionToken") {
        headers["X-Parse-Session-Token"] = sessionToken
      }

      publisher = networkService.fetch(OSCAFunctionRequestResource<OSCAWasteCollectParameter>
        .wasteFilter(baseURL: networkService.config.baseURL,
                      headers: headers,
                      cloudFunctionParameter: cloudFunctionParameter))
    #endif
    return publisher
      .mapError(transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  }
    
  /// ```console
  /// curl -vX POST 'https://parse-dev.solingen.de/functions/waste-info' \
  /// -H "X-Parse-Application-Id: <APP_ID>" \
  /// -H "X-Parse-Client-Key:  <CLIENT_KEY>" \
  /// -H 'Content-Type: application/json' \
  ///  -d '{"lang":"de_DE"}' \
  /// | python3 -m json.tool
  /// ```
    public typealias OSCAWasteGreenAndClothesDistrictPublisher = AnyPublisher<[OSCAWasteGreenAndClothesDistrict], OSCAWasteError>
    
    public func fetchWasteGreenAndClothesDistrict(wasteLocationType: WasteLocationType) -> OSCAWasteGreenAndClothesDistrictPublisher {

      var publisher: AnyPublisher<[OSCAWasteGreenAndClothesDistrict], OSCANetworkError>
    #if MOCKNETWORK
    //    publisher = self.networkService.fetch(OSCABundleRequestResource<OSCAWasteCollectPublisher>)
    #else
        let cloudFunctionParameter = OSCAWasteGreenAndClothesDistrictParameter(wasteLocationType: wasteLocationType)
    var headers = self.networkService.config.headers
    if let sessionToken = self.userDefaults.string(forKey: "SessionToken") {
    headers["X-Parse-Session-Token"] = sessionToken
    }

    publisher = self.networkService
          .fetch(OSCAFunctionRequestResource<OSCAWasteGreenAndClothesDistrictParameter>.wasteGreenAndClothesDistrict(baseURL: networkService.config.baseURL,cloudFunctionParameter: cloudFunctionParameter,
               headers: headers))
    #endif
    return publisher
        .mapError(self.transformError)
        .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
        .eraseToAnyPublisher()
  }
    
  /// ```console
  /// curl -vX POST 'https://parse-dev.solingen.de/functions/waste-info' \
  /// -H "X-Parse-Application-Id: <APP_ID>" \
  /// -H "X-Parse-Client-Key:  <CLIENT_KEY>" \
  /// -H 'Content-Type: application/json' \
  ///  -d '{"lang":"de_DE"}' \
  /// | python3 -m json.tool
  /// ```
    public typealias OSCAWasteGreenAndClothesLocationPublisher = AnyPublisher<[OSCAWasteGreenAndClothesLocation], OSCAWasteError>
    
  public func fetchWasteGreenAndClothesLocation(id: String, wasteLocationType: WasteLocationType) -> OSCAWasteGreenAndClothesLocationPublisher {

    var publisher: AnyPublisher<[OSCAWasteGreenAndClothesLocation], OSCANetworkError>
    #if MOCKNETWORK
    //    publisher = self.networkService.fetch(OSCABundleRequestResource<OSCAWasteCollectPublisher>)
    #else
    var headers = self.networkService.config.headers
    if let sessionToken = self.userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }

    publisher = self.networkService
          .fetch(OSCAFunctionRequestResource<OSCAWasteGreenAndClothesLocationParameter>.wasteGreenAndClothesLocation(baseURL: networkService.config.baseURL,
                                                                                                                     headers: headers, cloudFunctionParameter: OSCAWasteGreenAndClothesLocationParameter(id: id, wasteLocationType: wasteLocationType)))
    #endif
    return publisher
      .mapError(self.transformError)
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .eraseToAnyPublisher()
  }
  
} // end extension public struct OSCAWaste

extension OSCAWaste {
  /// UserDefaults object keys
  public enum Keys: String {
    case userDefaultsWasteAddress = "OSCAWaste_userAddress"
    case userDefaultsWasteReminder = "OSCAWaste_WasteReminder"
    case userDefaultsBinTypes = "OSCAWaste_BinTypes"
    case userDefaultsWasteDashboardEnabled = "OSCAWaste_WasteDashboard"
  }
}
 

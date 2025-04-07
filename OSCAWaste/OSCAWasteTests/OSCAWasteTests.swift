//
//  OSCAWasteTests.swift
//  OSCAWasteTests
//
//  Created by Stephan Breidenbach on 19.04.22.
//  Reviewed by Stephan Breidenbach on 21.06.22
//
#if canImport(XCTest) && canImport(OSCATestCaseExtension)

import XCTest
@testable import OSCAWaste
import OSCANetworkService
import OSCAEssentials
import OSCATestCaseExtension
import Combine

class OSCAWasteTests: XCTestCase {
  static let moduleVersion = "1.0.4"
  private var cancellables: Set<AnyCancellable>!
  
  override func setUpWithError() throws -> Void{
    // Put setup code here. This method is called before the invocation of each test method in the class.
    try super.setUpWithError()
    // initialize cancellables
    self.cancellables = []
  }// end override func setUpWithError
  
  func testModuleInit() throws -> Void {
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    XCTAssertEqual(module.version, OSCAWasteTests.moduleVersion)
    XCTAssertEqual(module.bundlePrefix, "de.osca.waste")
    let bundle = OSCAWaste.bundle
    XCTAssertNotNil(bundle)
    XCTAssertNotNil(self.devPlistDict)
    XCTAssertNotNil(self.productionPlistDict)
  }// end func testModuleInit
  
  func testTransformError() throws -> Void {
    let module = try makeDevModule()
    XCTAssertEqual(module.transformError(OSCANetworkError.invalidResponse), OSCAWasteError.networkInvalidResponse)
    XCTAssertEqual(module.transformError(OSCANetworkError.invalidRequest), OSCAWasteError.networkInvalidRequest)
    let testData = Data([1,2,3])
    XCTAssertEqual(module.transformError(OSCANetworkError.dataLoadingError(statusCode: 1, data: testData)), OSCAWasteError.networkDataLoading(statusCode: 1, data: testData))
    let error: Error = OSCAWasteError.networkInvalidResponse
    XCTAssertEqual(module.transformError(OSCANetworkError.jsonDecodingError(error: error)), OSCAWasteError.networkJSONDecoding(error: error))
    XCTAssertEqual(module.transformError(OSCANetworkError.isInternetConnectionError),OSCAWasteError.networkIsInternetConnectionFailure)
  }// end func testTransformError
  
  func testFetchAllWasteAddresses() throws -> Void {
    var wasteAddresses: [OSCAWasteAddress] = []
    var error: Error?
    let maxCount: Int = 1
    
    let expectation = self.expectation(description: "fetchAllWasteAddresses")
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    module.fetchAllWasteAddresses(maxCount: maxCount)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(encounteredError):
          error = encounteredError
          expectation.fulfill()
        }// end switch
      } receiveValue: { allWasteAddressesFromNetwork in
        wasteAddresses = allWasteAddressesFromNetwork
      }// end sink
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10)
    
    XCTAssertNil(error)
    XCTAssertTrue(wasteAddresses.count == maxCount)
  }// end func testFetchAllWasteAddresses
  
  func testFetchWasteCollectionsForWasteAddress() throws -> Void {
    var wasteAddresses: [OSCAWasteAddress] = []
    var wasteCollectResponse: OSCAWasteCollectsAtAddress?
    var error: Error?
    
    var expectation = self.expectation(description: "fetchAllWasteAddresses")
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    module.fetchAllWasteAddresses(maxCount: 1)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(encounteredError):
          error = encounteredError
          expectation.fulfill()
        }// end switch case
      } receiveValue: { allWasteAddressesFromNetwork in
        wasteAddresses = allWasteAddressesFromNetwork
      }// end sink
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10)
    XCTAssertNil(error)
    XCTAssertTrue(wasteAddresses.count == 1)
    XCTAssertNotNil(wasteAddresses.first?.sourceId)
    
    expectation = self.expectation(description: "fetchWasteCollectionsForWasteAddress")
    module.fetchWasteCollections(for: wasteAddresses.first!)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(encounteredError):
          error = encounteredError
          expectation.fulfill()
        }// end switch case
      }, receiveValue: { result in
        wasteCollectResponse = result
      })// end sink
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10)
    XCTAssertNil(error)
    XCTAssertNotNil(wasteCollectResponse)
    XCTAssertNotNil(wasteCollectResponse!.collection)
    XCTAssertTrue(!wasteCollectResponse!.collection!.isEmpty)
    guard let addressFromResponse      = wasteCollectResponse?.address,
          let streetAddressFromRequest = wasteAddresses.first?.streetAddress,
          let houseNumberFromRequest   = wasteAddresses.first?.houseNumber
    else { XCTFail("Address failed"); return }
    XCTAssertEqual(addressFromResponse, "\(streetAddressFromRequest) \(houseNumberFromRequest)")
  }// end func testFetchWasteCollectionsForWasteAddress
  
  func testElasticSearchForWasteAddress() throws -> Void {
    var wasteAddresses: [OSCAWasteAddress] = []
    let queryString = "wittkuller"
    var error: Error?
    
    let expectation = self.expectation(description: "elasticSearchForWasteAddress")
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    module.elasticSearch(for: queryString)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(encounteredError):
          error = encounteredError
          expectation.fulfill()
        }// end switch case
      } receiveValue: { wasteAddressesFromNetwork in
        wasteAddresses = wasteAddressesFromNetwork
      }// end sink
      .store(in: &self.cancellables)
    
    waitForExpectations(timeout: 10)
    XCTAssertNil(error)
  }// end testElasticSearchForWasteAddress
}// end class OSCAWasteTests

// MARK: - factory methods
extension OSCAWasteTests {
  public func makeDevModuleDependencies() throws -> OSCAWasteDependencies {
    let networkService = try makeDevNetworkService()
    let userDefaults   = try makeUserDefaults(domainString: "de.osca.waste")
    let dependencies = OSCAWasteDependencies(
      networkService: networkService,
      userDefaults: userDefaults)
    return dependencies
  }// end public func makeDevModuleDependencies
  
  public func makeDevModule() throws -> OSCAWaste {
    let devDependencies = try makeDevModuleDependencies()
    // initialize module
    let module = OSCAWaste.create(with: devDependencies)
    return module
  }// end public func makeDevModule
  
  public func makeProductionModuleDependencies() throws -> OSCAWasteDependencies {
    let networkService = try makeProductionNetworkService()
    let userDefaults   = try makeUserDefaults(domainString: "de.osca.waste")
    let dependencies = OSCAWasteDependencies(
      networkService: networkService,
      userDefaults: userDefaults)
    return dependencies
  }// end public func makeProductionModuleDependencies
  
  public func makeProductionModule() throws -> OSCAWaste {
    let productionDependencies = try makeProductionModuleDependencies()
    // initialize module
    let module = OSCAWaste.create(with: productionDependencies)
    return module
  }// end public func makeProductionModule
}// end extension final class OSCAWasteTests
#endif

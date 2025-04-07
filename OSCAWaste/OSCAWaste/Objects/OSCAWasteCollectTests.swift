// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let functionResponse = try FunctionResponse(json)

import Foundation

// MARK: - FunctionResponse
struct FunctionResponse: Codable {
    let result: Result
}

// MARK: FunctionResponse convenience initializers and mutators

extension FunctionResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FunctionResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        result: Result? = nil
    ) -> FunctionResponse {
        return FunctionResponse(
            result: result ?? self.result
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Result
struct Result: Codable {
    let address: String
    let collection: [Collection]
}

// MARK: Result convenience initializers and mutators

extension Result {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Result.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        address: String? = nil,
        collection: [Collection]? = nil
    ) -> Result {
        return Result(
            address: address ?? self.address,
            collection: collection ?? self.collection
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Collection
struct Collection: Codable {
    let name: CollectionName
    let collectionDescription: Description
    let type: Int
    let date: String
    let location: Location
    let color: Color
    let icon: String

    enum CodingKeys: String, CodingKey {
        case name
        case collectionDescription = "description"
        case type, date, location, color, icon
    }
}

// MARK: Collection convenience initializers and mutators

extension Collection {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Collection.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: CollectionName? = nil,
        collectionDescription: Description? = nil,
        type: Int? = nil,
        date: String? = nil,
        location: Location? = nil,
        color: Color? = nil,
        icon: String? = nil
    ) -> Collection {
        return Collection(
            name: name ?? self.name,
            collectionDescription: collectionDescription ?? self.collectionDescription,
            type: type ?? self.type,
            date: date ?? self.date,
            location: location ?? self.location,
            color: color ?? self.color,
            icon: icon ?? self.icon
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum Description: String, Codable {
    case testdescription = "Testdescription"
}

enum Color: String, Codable {
    case the0000Ff = "#0000FF"
    case the00Ff00 = "#00FF00"
    case the0C0C0C = "#0C0C0C"
}

// MARK: - Location
struct Location: Codable {
    let name: LocationName
    let streetAddress: StreetAddress
    let addressLocality: AddressLocality
    let postalCode: String
    let geopoint: Geopoint
}

// MARK: Location convenience initializers and mutators

extension Location {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Location.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: LocationName? = nil,
        streetAddress: StreetAddress? = nil,
        addressLocality: AddressLocality? = nil,
        postalCode: String? = nil,
        geopoint: Geopoint? = nil
    ) -> Location {
        return Location(
            name: name ?? self.name,
            streetAddress: streetAddress ?? self.streetAddress,
            addressLocality: addressLocality ?? self.addressLocality,
            postalCode: postalCode ?? self.postalCode,
            geopoint: geopoint ?? self.geopoint
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum AddressLocality: String, Codable {
    case solingen = "Solingen"
}

// MARK: - Geopoint
struct Geopoint: Codable {
    let latitude, longitude: Double
}

// MARK: Geopoint convenience initializers and mutators

extension Geopoint {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Geopoint.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        latitude: Double? = nil,
        longitude: Double? = nil
    ) -> Geopoint {
        return Geopoint(
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum LocationName: String, Codable {
    case testlocation = "Testlocation"
}

enum StreetAddress: String, Codable {
    case teststreet1 = "Teststreet 1"
}

enum CollectionName: String, Codable {
    case altpapier = "Altpapier"
    case dualesSystem = "Duales System"
    case restmüllWöchentlich = "Restmüll wöchentlich"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

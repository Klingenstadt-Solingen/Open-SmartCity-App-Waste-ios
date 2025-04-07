import Foundation
import OSCAEssentials

public struct OSCAWasteGreenAndClothesDistrict: Codable, Equatable, Hashable {
    public var objectId: String?
    public var location: String?
    public var name: String?
}

public struct OSCAWasteGreenAndClothesDistrictParameter: Codable, Hashable, Equatable{
    var wasteLocationType: WasteLocationType
}

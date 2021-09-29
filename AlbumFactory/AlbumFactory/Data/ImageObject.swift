import Foundation

public struct ImageObject: Decodable {

    // MARK: - Inner Types

    public enum Size: String, Decodable {
        case small
        case medium
        case large
        case extraLarge = "extralarge"
        case mega
        case empty      = ""
    }

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }

    // MARK: - Properties
    // MARK: Immutable

    public let imageURLString: String
    public let size: Size

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        imageURLString = try values.decode(String.self, forKey: .text)
        size = try values.decode(Size.self, forKey: .size)
    }
}

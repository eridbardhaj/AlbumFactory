import Foundation

public struct Artist: Decodable, Equatable, Identifiable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case id              = "mbid"
        case name
        case listeners
        case visitUrl        = "url"
        case images          = "image"
        case image           = "#text"
    }

    // MARK: - Properties
    // MARK: Immutable

    public let id: String
    public let name: String
    public let listeners: String?
    public let visitUrl: String?
    public let imageUrl: String?

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        listeners = try values.decodeIfPresent(String.self, forKey: .listeners)
        visitUrl = try values.decodeIfPresent(String.self, forKey: .visitUrl)

        var reviewCountContainer = try values.nestedUnkeyedContainer(forKey: .images)
        let firstReviewCountContainer = try reviewCountContainer.nestedContainer(keyedBy: CodingKeys.self)

        imageUrl = try firstReviewCountContainer.decode(String.self, forKey: .image)
    }

    // MARK: - Initializers

    public init(id: String,
                name: String,
                listeners: String?,
                visitUrl: String?,
                imageUrl: String?) {
        self.id = id
        self.name = name
        self.listeners = listeners
        self.visitUrl = visitUrl
        self.imageUrl = imageUrl
    }
}

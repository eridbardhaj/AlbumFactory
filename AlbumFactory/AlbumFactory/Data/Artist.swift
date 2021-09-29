import Foundation

public struct Artist: Decodable, Equatable, Identifiable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case listeners
        case visitUrl        = "url"
        case images          = "image"
        case image           = "#text"
    }

    // MARK: - Properties
    // MARK: Immutable

    public let id = UUID()
    public let mbid: String?
    public let name: String
    public let listeners: String?
    public let visitUrl: String?
    public let imageUrl: String?

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try values.decode(String.self, forKey: .mbid)
        name = try values.decode(String.self, forKey: .name)
        listeners = try values.decodeIfPresent(String.self, forKey: .listeners)
        visitUrl = try values.decodeIfPresent(String.self, forKey: .visitUrl)

        let imageObjects = try values.decode([ImageObject].self, forKey: .images)
        imageUrl = imageObjects
            .first { $0.size == .extraLarge }
            .map { $0.imageURLString }
    }

    // MARK: - Initializers

    public init(id: String,
                mbid: String?,
                name: String,
                listeners: String?,
                visitUrl: String?,
                imageUrl: String?) {
        self.mbid = mbid
        self.name = name
        self.listeners = listeners
        self.visitUrl = visitUrl
        self.imageUrl = imageUrl
    }
}

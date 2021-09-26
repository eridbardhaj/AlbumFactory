import Foundation

public struct Album: Decodable, Equatable, Identifiable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case id         = "mbid"
        case name
        case artist
        case visitUrl   = "url"
        case images     = "image"
        case image      = "#text"
    }

    // MARK: - Properties
    // MARK: Immutable

    public let id: String
    public let name: String
    public let artist: String
    public let visitUrl: URL
    public let imageUrl: URL

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        artist = try values.decode(String.self, forKey: .artist)
        visitUrl = try values.decode(URL.self, forKey: .visitUrl)

        var reviewCountContainer = try values.nestedUnkeyedContainer(forKey: .images)
        let firstReviewCountContainer = try reviewCountContainer.nestedContainer(keyedBy: CodingKeys.self)

        imageUrl = try firstReviewCountContainer.decode(URL.self, forKey: .image)
    }

    public init(id: String,
                name: String,
                artist: String,
                visitUrl: URL,
                imageUrl: URL) {
        self.id = id
        self.name = name
        self.artist = artist
        self.visitUrl = visitUrl
        self.imageUrl = imageUrl
    }
}

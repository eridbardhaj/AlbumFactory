import Foundation

public struct Artist: Decodable, Equatable, Identifiable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case mbid
        case name
        case listeners
        case plays           = "playcount"
        case images          = "image"
        case image           = "#text"
        case content
        case stats
        case bio
    }

    // MARK: - Properties
    // MARK: Immutable

    public let id = UUID()
    public let mbid: String
    public let name: String
    public let listeners: String?
    public let plays: String?
    public let content: String?
    public let imageUrl: String?

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try values.decode(String.self, forKey: .mbid)
        name = try values.decode(String.self, forKey: .name)

        if let stats = try? values.nestedContainer(keyedBy: CodingKeys.self, forKey: .stats) {
            listeners = try stats.decodeIfPresent(String.self, forKey: .listeners)
            plays = try stats.decodeIfPresent(String.self, forKey: .plays)
        } else {
            listeners = try values.decodeIfPresent(String.self, forKey: .listeners)
            plays = try values.decodeIfPresent(String.self, forKey: .plays)
        }

        let bio = try? values.nestedContainer(keyedBy: CodingKeys.self, forKey: .bio)
        content = try bio?.decodeIfPresent(String.self, forKey: .content)

        let imageObjects = try values.decode([ImageObject].self, forKey: .images)
        imageUrl = imageObjects
            .first { $0.size == .extraLarge }
            .map { $0.imageURLString }
    }

    // MARK: - Initializers

    public init(mbid: String,
                name: String,
                listeners: String?,
                plays: String?,
                content: String?,
                imageUrl: String?) {
        self.mbid = mbid
        self.name = name
        self.listeners = listeners
        self.plays = plays
        self.content = content
        self.imageUrl = imageUrl
    }

    public init(persistedArtist: PersistedArtist) {
        self.mbid = persistedArtist.mbid
        self.name = persistedArtist.name
        self.plays = persistedArtist.plays
        self.listeners = persistedArtist.listeners
        self.content = persistedArtist.content
        self.imageUrl = persistedArtist.imageUrl
    }
}

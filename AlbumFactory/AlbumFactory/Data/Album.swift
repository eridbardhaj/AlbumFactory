import Foundation

public struct Album: Decodable, Equatable, Identifiable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case id
        case mbid
        case name
        case plays      = "playcount"
        case listeners
        case artist
        case visitUrl   = "url"
        case images     = "image"
        case image      = "#text"
        case tracks
        case track
    }

    enum TrackCodingKeys: String, CodingKey {
        case tracks
        case track
    }

    // MARK: - Properties
    // MARK: Immutable

    public let id = UUID()
    public let mbid: String?
    public let name: String?
    public let plays: String?
    public let listeners: String?
    public let visitUrl: String?
    public let imageUrl: String?
    public let tracks: [Track]

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try values.decodeIfPresent(String.self, forKey: .mbid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        do {
            plays = try values.decode(String.self, forKey: .plays)
        } catch DecodingError.typeMismatch {
            plays = String(try values.decodeIfPresent(Int.self, forKey: .plays) ?? -1)
        }
        listeners = try values.decodeIfPresent(String.self, forKey: .listeners)
        visitUrl = try values.decodeIfPresent(String.self, forKey: .visitUrl)

        var reviewCountContainer = try values.nestedUnkeyedContainer(forKey: .images)
        let firstReviewCountContainer = try reviewCountContainer.nestedContainer(keyedBy: CodingKeys.self)

        imageUrl = try firstReviewCountContainer.decodeIfPresent(String.self, forKey: .image)

        let tracksContainer = try? values.nestedContainer(keyedBy: TrackCodingKeys.self, forKey: .tracks)
        tracks = try tracksContainer?.decodeIfPresent([Track].self, forKey: .track) ?? []
    }

    // MARK: - Initializers

    public init(mbid: String?,
                name: String?,
                plays: String?,
                listeners: String?,
                visitUrl: String?,
                imageUrl: String?,
                tracks: [Track]) {
        self.mbid = mbid
        self.name = name
        self.plays = plays
        self.listeners = listeners
        self.visitUrl = visitUrl
        self.imageUrl = imageUrl
        self.tracks = tracks
    }
}

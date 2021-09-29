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
    public let mbid: String
    public let name: String
    public let plays: String?
    public let listeners: String?
    public let imageUrl: String?
    public var artist: Artist?
    public var tracks = [Track]()

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mbid = try values.decodeIfPresent(String.self, forKey: .mbid) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""

        do {
            plays = try values.decode(String.self, forKey: .plays)
        } catch DecodingError.typeMismatch {
            plays = String(try values.decodeIfPresent(Int.self, forKey: .plays) ?? -1)
        }
        listeners = try values.decodeIfPresent(String.self, forKey: .listeners)

        let imageObjects = try values.decode([ImageObject].self, forKey: .images)
        imageUrl = imageObjects
            .first { $0.size == .extraLarge }
            .map { $0.imageURLString }

        let tracksContainer = try? values.nestedContainer(keyedBy: TrackCodingKeys.self, forKey: .tracks)
        tracks = try tracksContainer?.decodeIfPresent([Track].self, forKey: .track) ?? []
    }

    // MARK: - Initializers

    public init(mbid: String,
                name: String,
                artist: Artist?,
                plays: String?,
                listeners: String?,
                imageUrl: String?,
                tracks: [Track]) {
        self.mbid = mbid
        self.name = name
        self.artist = artist
        self.plays = plays
        self.listeners = listeners
        self.imageUrl = imageUrl
        self.tracks = tracks
    }

    public init(persistedAlbum: PersistedAlbum) {
        self.mbid = persistedAlbum.mbid
        self.name = persistedAlbum.name
        self.plays = persistedAlbum.plays
        self.listeners = persistedAlbum.listeners
        self.imageUrl = persistedAlbum.imageUrl
        self.artist = persistedAlbum.artist.map { Artist(persistedArtist: $0) }
        self.tracks = persistedAlbum.tracks.map { Track(name: $0.name, duration: $0.duration, visitUrl: $0.visitUrl) }
    }

    public mutating func updateTracks(tracks: [Track]) {
        self.tracks = tracks
    }

    public mutating func updateArtist(artist: Artist) {
        self.artist = artist
    }
}

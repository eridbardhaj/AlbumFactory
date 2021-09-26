import Foundation

public struct Track: Decodable, Equatable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case artist
        case name
        case duration
        case visitUrl        = "url"
    }

    // MARK: - Properties
    // MARK: Immutable

    public let artist: Artist
    public let name: String
    public let duration: Int
    public let visitUrl: URL

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artist = try values.decode(Artist.self, forKey: .artist)
        name = try values.decode(String.self, forKey: .name)
        duration = try values.decode(Int.self, forKey: .duration)
        visitUrl = try values.decode(URL.self, forKey: .visitUrl)
    }

    public init(artist: Artist,
                name: String,
                duration: Int,
                visitUrl: URL) {
        self.artist = artist
        self.name = name
        self.duration = duration
        self.visitUrl = visitUrl
    }
}

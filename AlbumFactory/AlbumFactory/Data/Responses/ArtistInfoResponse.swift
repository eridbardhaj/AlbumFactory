import Foundation

public struct ArtistInfoResponse: Decodable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case artist
    }

    // MARK: - Properties
    // MARK: Immutable

    public let artist: Artist

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artist = try values.decode(Artist.self, forKey: .artist)
    }
}

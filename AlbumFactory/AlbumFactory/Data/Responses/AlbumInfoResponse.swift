import Foundation

public struct AlbumInfoResponse: Decodable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case album
    }

    // MARK: - Properties
    // MARK: Immutable

    public let album: Album

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        album = try values.decode(Album.self, forKey: .album)
    }
}

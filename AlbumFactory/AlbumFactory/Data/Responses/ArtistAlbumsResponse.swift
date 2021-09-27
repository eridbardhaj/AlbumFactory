import Foundation

public struct ArtistAlbumsResponse: Decodable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
        case album
    }

    // MARK: - Properties
    // MARK: Immutable

    public let albums: [Album]

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let topAlbums = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .topAlbums)
        albums = try topAlbums.decodeIfPresent([Album].self, forKey: .album) ?? []
    }
}

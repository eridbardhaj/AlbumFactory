import Foundation

public struct ArtistSearchResponse: Decodable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case results
        case artistMatches = "artistmatches"
        case artist
    }

    // MARK: - Properties
    // MARK: Immutable

    public let artists: [Artist]

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let results = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .results)
        let artistMatches = try results.nestedContainer(keyedBy: CodingKeys.self, forKey: .artistMatches)
        artists = try artistMatches.decodeIfPresent([Artist].self, forKey: .artist) ?? []
    }
}

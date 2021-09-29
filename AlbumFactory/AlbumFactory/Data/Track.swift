import Foundation

public struct Track: Decodable, Equatable, Identifiable {

    // MARK: - Inner Types

    enum CodingKeys: String, CodingKey {
        case name
        case duration
        case visitUrl        = "url"
    }

    // MARK: - Properties
    // MARK: Immutable

    public let id = UUID()
    public let name: String
    public let duration: Int?
    public let visitUrl: String?

    // MARK: - Protocol Conformance
    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        visitUrl = try values.decodeIfPresent(String.self, forKey: .visitUrl)
    }

    // MARK: - Initializers

    public init(name: String,
                duration: Int?,
                visitUrl: String?) {
        self.name = name
        self.duration = duration
        self.visitUrl = visitUrl
    }
}

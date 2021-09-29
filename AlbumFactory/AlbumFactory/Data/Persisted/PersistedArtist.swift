import Foundation
import RealmSwift

public final class PersistedArtist: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var mbid: String
    @Persisted var name: String
    @Persisted var plays: String?
    @Persisted var listeners: String?
    @Persisted var content: String?
    @Persisted var imageUrl: String?
    @Persisted(originProperty: "artist") var album: LinkingObjects<PersistedAlbum>

    convenience init(artist: Artist) {
        self.init()

        mbid = artist.mbid
        name = artist.name
        plays = artist.plays
        listeners = artist.listeners
        content = artist.content
        imageUrl = artist.imageUrl
    }
}

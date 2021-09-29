import Foundation
import RealmSwift

public final class PersistedArtist: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var mbid: String?
    @Persisted var name: String
    @Persisted var listeners: String?
    @Persisted var visitUrl: String?
    @Persisted var imageUrl: String?
    @Persisted(originProperty: "artist") var album: LinkingObjects<PersistedAlbum>
}

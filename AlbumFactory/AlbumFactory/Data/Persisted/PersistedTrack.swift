import Foundation
import RealmSwift

public final class PersistedTrack: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var duration: Int?
    @Persisted var visitUrl: String?
    @Persisted(originProperty: "tracks") var album: LinkingObjects<PersistedAlbum>

    convenience init(track: Track) {
        self.init()
        name = track.name
        duration = track.duration
        visitUrl = track.visitUrl
    }
}

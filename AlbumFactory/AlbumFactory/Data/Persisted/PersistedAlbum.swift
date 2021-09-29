import Foundation
import RealmSwift

public final class PersistedAlbum: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var mbid: String
    @Persisted var name: String
    @Persisted var plays: String?
    @Persisted var listeners: String?
    @Persisted var imageUrl: String?
    @Persisted var artist: PersistedArtist?
    @Persisted var tracks = RealmSwift.List<PersistedTrack>()

    convenience init(album: Album) {
        self.init()

        mbid = album.mbid
        name = album.name
        plays = album.plays
        listeners = album.listeners
        imageUrl = album.imageUrl
        artist = album.artist.map { PersistedArtist(artist: $0) }
        tracks.append(objectsIn: album.tracks.map { PersistedTrack(track: $0) })
    }
}

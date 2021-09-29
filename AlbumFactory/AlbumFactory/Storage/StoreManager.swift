import Foundation
import RealmSwift
import Combine

protocol StoreManagerType: AnyObject {
    func storeAlbum(album: Album)
    func updateAlbumTracks(album: Album)
    func deleteAlbum(album: Album)
    func isAlbumStored(album: Album) -> Bool

    var results: Results<PersistedAlbum> { get } 
}

enum StoreManagerError: Error {
    case albumNotFound
}

class StoreManager: StoreManagerType {

    // MARK: - Properties
    // MARK: Immutable

    private let realm: Realm

    // MARK: Mutable

    @ObservedResults(PersistedAlbum.self) var results

    // MARK: - Initializers

    init(realm: Realm = DependencyResolver.realm) {
        self.realm = realm
    }

    // MARK: - Protocol Conformance
    // MARK: StoreManagerType

    func updateAlbumTracks(album: Album) {
        guard let persistedAlbum = results.first(where: { $0.mbid == album.mbid }) else { return }
        do {
            try realm.write {
                persistedAlbum.tracks.append(
                    objectsIn: album.tracks.map { PersistedTrack(track: $0) }
                )
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func storeAlbum(album: Album) {
        let persistedAlbum = PersistedAlbum(album: album)
        do {
            try realm.write {
                realm.create(PersistedAlbum.self, value: persistedAlbum, update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteAlbum(album: Album) {
        guard let persistedAlbum = results.first(where: { $0.mbid == album.mbid }) else { return }

        do {
            try realm.write {
                realm.delete(persistedAlbum)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func isAlbumStored(album: Album) -> Bool {
        results.contains(where: { $0.mbid == album.mbid })
    }
}

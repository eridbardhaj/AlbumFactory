import Foundation
import RealmSwift
import Combine

protocol Storable: AnyObject {
    func storeAlbum(album: Album)
    func deleteAlbum(album: Album)
}

enum StoreManagerError: Error {
    case albumNotFound
}

class StoreManager: Storable {

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
    // MARK: Storable

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

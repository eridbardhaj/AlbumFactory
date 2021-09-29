import Foundation
import RealmSwift
import Combine

protocol Storable: AnyObject {
    func storeAlbum(album: Album) -> AnyPublisher<Never, Error>
    func deleteAlbum(album: Album) -> AnyPublisher<Never, Error>
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

    func storeAlbum(album: Album) -> AnyPublisher<Never, Error> {
        write(object: PersistedAlbum(album: album))
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func deleteAlbum(album: Album) -> AnyPublisher<Never, Error> {
        guard let persistedAlbum = results.first(where: { $0.albumId == album.id }) else {
            return Fail(error: StoreManagerError.albumNotFound)
                .eraseToAnyPublisher()
        }

        return delete(object: persistedAlbum)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    func albums() -> Results<PersistedAlbum> {
        realm.objects(PersistedAlbum.self)
    }

    func isAlbumStored(album: Album) -> Bool {
        results.contains(where: { $0.mbid == album.mbid })
    }

    // MARK: - Internal

    private func write<RealmObject: Object>(object: RealmObject) -> AnyPublisher<RealmObject, Error> {
        Future { [realm] observer in
            do {
                try realm.write {
                    let storedObject = realm.create(RealmObject.self, value: object, update: .modified)
                    observer(.success(storedObject))
                }
            } catch let error {
                observer(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    private func delete<RealmObject: Object & ObjectKeyIdentifiable>(object: RealmObject) -> AnyPublisher<Void, Error> {
        Future { [realm] observer in
            do {
                try realm.write {
                    realm.delete(object)
                    observer(.success(()))
                }
            } catch let error {
                observer(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

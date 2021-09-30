import Foundation
import RealmSwift

class StoreManagerTypeMock: StoreManagerType {

    // MARK: - Inner Types

    class CalledCount {
        var storeAlbum = 0
        var updateAlbumTracks = 0
        var deleteAlbum = 0
        var isAlbumStored = 0
    }

    class ReturnValue {
        var isAlbumStored: Bool = false
    }

    // MARK: - Properties
    // MARK: Immutable

    let calledCount = CalledCount()
    let returnValue = ReturnValue()

    // MARK: - Protocol Conformance
    // MARK: StoreManagerType

    func storeAlbum(album: Album) {
        calledCount.storeAlbum += 1
    }

    func updateAlbumTracks(album: Album) {
        calledCount.updateAlbumTracks += 1
    }

    func deleteAlbum(album: Album) {
        calledCount.deleteAlbum += 1
    }

    func isAlbumStored(album: Album) -> Bool {
        calledCount.deleteAlbum += 1
        return returnValue.isAlbumStored
    }

    var results: Results<PersistedAlbum> {
        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test")).objects(PersistedAlbum.self)
    }
}


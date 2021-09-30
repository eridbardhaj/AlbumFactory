import Foundation
import XCTest
import Nimble
import Combine
@testable import AlbumFactory

class NetworkKitTests: XCTestCase {

    // MARK: - Properties
    // MARK: Mutable

    var networkKit: NetworkKit!
    var agentMock: NetworkAgentTypeMock!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()

        setupMocks()
    }

    // MARK: - Setups

    private func setupMocks() {
        agentMock = NetworkAgentTypeMock()
        networkKit = NetworkKit(agent: agentMock)
    }

    // MARK: - Tests
    // MARK: artistDetails

    func test_artistDetails_subscriberFails_imageDownloaderCalled() {
        let expectedArtist = Artist(mbid: "123", name: "", listeners: nil, plays: nil, content: nil, imageUrl: nil)
        let expectedResponse = ArtistInfoResponse(artist: expectedArtist)
        let urlResponse = URLResponse(url: URL(string: "www.dummy.com")!, mimeType: nil, expectedContentLength: 123, textEncodingName: nil)
        agentMock.returnValue.run = Just(Response(value: expectedResponse, response: urlResponse))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        var retrievedResponse: ArtistInfoResponse?
        _ = networkKit.artistDetails("123")
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    retrievedResponse = $0
                })

        expect(expectedResponse).toEventually(equal(retrievedResponse))
        expect(self.agentMock.calledCount.run).to(equal(1))
    }
}

import Foundation
import AlamofireImage
@testable import AlbumFactory
import XCTest
import Nimble

class ImageLoaderTests: XCTestCase {

    // MARK: - Properties
    // MARK: Mutable

    var imageLoader: ImageLoader!
    var imageDownloaderMock: ImageDownloaderTypeMock!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()

        setupMocks()
    }

    // MARK: - Setups

    private func setupMocks() {
        imageDownloaderMock = ImageDownloaderTypeMock()
        imageLoader = ImageLoader(imageDownloader: imageDownloaderMock)
    }

    // MARK: - Tests
    // MARK: imageForURL

    func test_imageForURL_subscriberFails_imageDownloaderCalled() {
        imageDownloaderMock.returnValue.downloadResult = Result<Image, AFIError>.failure(AFIError.requestCancelled)

        var retrievedImage: Image? = nil
        _ = imageLoader.image(for: URL(string: "https://www.dummywebsite.com")!)
            .sink(receiveValue: { image in
                retrievedImage = image
            })

        expect(retrievedImage).toEventually(beNil())
        expect(self.imageDownloaderMock.calledCount.download).to(equal(1))
    }

    func test_imageForURL_subscriberSucceeds_imageIsReceived() {
        let expectedImage = Image(systemName: "circle.fill")!
        imageDownloaderMock.returnValue.downloadResult = Result<Image, AFIError>.success(expectedImage)

        var retrievedImage: Image? = nil
        _ = imageLoader.image(for: URL(string: "https://www.dummywebsite.com")!)
            .sink(receiveValue: { image in
                retrievedImage = image
            })

        expect(expectedImage).toEventually(be(retrievedImage))
        expect(self.imageDownloaderMock.calledCount.download).to(equal(1))
    }

    func test_imageForURLString_urlCannotBeBuilt_nilReceived() {
        imageDownloaderMock.returnValue.downloadResult = Result<Image, AFIError>.failure(.requestCancelled)

        var retrievedImage: Image? = nil
        _ = imageLoader.image(for: nil)
            .sink(receiveValue: { image in
                retrievedImage = image
            })

        expect(retrievedImage).toEventually(beNil())
        expect(self.imageDownloaderMock.calledCount.download).to(equal(0))
    }

    func test_imageForURLString_subscriberSucceeds_imageReceived() {
        let expectedImage = Image(systemName: "circle.fill")!
        imageDownloaderMock.returnValue.downloadResult = Result<Image, AFIError>.success(expectedImage)

        var retrievedImage: Image? = nil
        _ = imageLoader.image(for: "https://www.dummywebsite.com")
            .sink(receiveValue: { image in
                retrievedImage = image
            })

        expect(expectedImage).toEventually(be(retrievedImage))
        expect(self.imageDownloaderMock.calledCount.download).to(equal(1))
    }
}

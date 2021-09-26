import Foundation

extension String {

    /// Unwrapped value of a URL. Use carefully, please input the correct stirng, otherwise it will crash
    var requiredURL: URL {
        guard let url = URL(string: self) else { fatalError("Cannot create a URL from this string") }
        return url
    }
}

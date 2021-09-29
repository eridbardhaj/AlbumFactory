import Foundation

extension Int {

    var hhMMFormattedString: String? {
        let seconds = self % 60
        let minutes = (self / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

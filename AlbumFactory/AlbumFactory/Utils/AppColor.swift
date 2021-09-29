import SwiftUI

enum AppColor {
    case dark
    case gray
    case lightOrange
    case orange
    case white

    var color: Color {
        Color(self.uiColor)
    }

    var uiColor: UIColor {
        switch self {
        case .dark:           return #colorLiteral(red: 0.09371323138, green: 0.1056246981, blue: 0.1222684458, alpha: 1)
        case .gray:           return #colorLiteral(red: 0.2983165681, green: 0.2908555567, blue: 0.2490644455, alpha: 1)
        case .lightOrange:    return #colorLiteral(red: 1, green: 0.7568627451, blue: 0.1803921569, alpha: 1)
        case .orange:         return #colorLiteral(red: 1, green: 0.5745739937, blue: 0.001978197834, alpha: 1)
        case .white:          return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

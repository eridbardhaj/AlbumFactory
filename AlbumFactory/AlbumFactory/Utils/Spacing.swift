import UIKit
import SwiftUI

enum Spacing {
    static let defaultHorizontal: CGFloat   = 12
    static let defaultVertical: CGFloat     = 8
    static let defaultEdgeInsets: EdgeInsets = EdgeInsets(
        top: defaultVertical,
        leading: defaultHorizontal,
        bottom: defaultVertical,
        trailing: defaultHorizontal
    )
}

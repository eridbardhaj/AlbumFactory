import SwiftUI

public typealias CollectionViewRowHeightBlock = (_ row: Int, _ rowMetrics: GeometryProxy, _ itemSpacing: CGFloat, _ numberOfColumns: Int) -> CGFloat

public enum CollectionViewRowHeight {
    case constant(CGFloat)
    case sameAsItemWidth
    case dynamic(CollectionViewRowHeightBlock)
}

public class CollectionViewLayout: ObservableObject {
    @Published public var rowPadding: EdgeInsets
    @Published public var numberOfColumns: Int
    @Published public var itemSpacing: CGFloat
    @Published public var rowHeight: CollectionViewRowHeight
    @Published public var scrollViewInsets: EdgeInsets

    public init(rowPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                numberOfColumns: Int = 2,
                itemSpacing: CGFloat = 2,
                rowHeight: CollectionViewRowHeight = .sameAsItemWidth,
                scrollViewInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)) {
        self.rowPadding = rowPadding
        self.numberOfColumns = numberOfColumns
        self.itemSpacing = itemSpacing
        self.rowHeight = rowHeight
        self.scrollViewInsets = scrollViewInsets
    }
}

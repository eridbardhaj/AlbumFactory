import Combine
import SwiftUI

fileprivate let ScrollViewCoordinateSpaceKey = "ScrollViewCoordinateSpace"

public struct CollectionView<Item, ItemContent>: View where ItemContent: View, Item: Identifiable & Equatable {

    // MARK: - Inner Types

    private struct ItemRow: Identifiable {
        let id: Int
        let items: [Item]
    }

    private struct Row<Content>: View where Content: View {
        let content: () -> Content

        init(@ViewBuilder content: @escaping () -> Content) {
            self.content = content
        }

        var body: some View {
            self.content()
        }
    }

    // MARK: - Properties
    // MARK: Mutable

    @ObservedObject private var layout: CollectionViewLayout
    @Binding private var items: [Item]

    // MARK: Computed

    private var numberOfColumns: Int { layout.numberOfColumns }
    private var itemSpacing: CGFloat { layout.itemSpacing }
    private var rowHeight: CollectionViewRowHeight { layout.rowHeight }

    // MARK: Immutable

    private let itemBuilder: (Item, GeometryProxy) -> ItemContent
    private let tapAction: ((Item, GeometryProxy) -> Void)?
    private let longPressAction: ((Item, GeometryProxy) -> Void)?
    private let pressAction: ((Item, Bool) -> Void)?

    // MARK: - Initializers

    public init(items: Binding<[Item]>,
                layout: CollectionViewLayout = CollectionViewLayout(),
                tapAction: ((Item, GeometryProxy) -> Void)? = nil,
                longPressAction: ((Item, GeometryProxy) -> Void)? = nil,
                pressAction: ((Item, Bool) -> Void)? = nil,
                @ViewBuilder itemBuilder: @escaping (Item, GeometryProxy) -> ItemContent) {
        self._items = items
        self.itemBuilder = itemBuilder
        self.tapAction = tapAction
        self.longPressAction = longPressAction
        self.pressAction = pressAction
        self.layout = layout
    }

    public var body: some View {
        let rows = items.chunked(into: numberOfColumns)
            .enumerated()
            .map { ItemRow(id: $0.offset, items: $0.element) }

        return Group {
            GeometryReader { metrics in
                ScrollView {
                    VStack(spacing: itemSpacing) {
                        ForEach(rows) { row in
                            createRowView(for: row, metrics: metrics)
                                .padding(padding(for: row.id, rowCount: rows.count))
                        }
                    }.coordinateSpace(name: ScrollViewCoordinateSpaceKey)
                }
                .padding(.leading, layout.scrollViewInsets.leading)
                .padding(.trailing, layout.scrollViewInsets.trailing)
            }
        }
    }

    private func padding(for row: Int, rowCount: Int) -> EdgeInsets {
        let leading = layout.rowPadding.leading
        let trailing = layout.rowPadding.trailing

        var top = layout.rowPadding.top
        var bottom = layout.rowPadding.bottom

        if row == 0 {
            top += layout.scrollViewInsets.top
        }

        if row == rowCount - 1 {
            bottom += layout.scrollViewInsets.bottom
        }

        return EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    private func createRowView(for row: ItemRow, metrics: GeometryProxy) -> some View {
        return Row() {
            HStack(spacing: itemSpacing) {
                ForEach(row.items) { item in
                    CollectionCellContentView(
                        item: item,
                        tapAction: tapAction,
                        longPressAction: longPressAction,
                        pressAction: pressAction,
                        itemBuilder: itemBuilder
                    ).frame(
                        width: getColumnWidth(for: metrics.size.width),
                        height: getRowHeight(for: row.id, metrics: metrics),
                        alignment: .topLeading
                    )
                }
                Spacer()
            }.frame(height: getRowHeight(for: row.id, metrics: metrics))
        }
    }

    private func getColumnWidth(for width: CGFloat) -> CGFloat {
        let horizontalPadding = CGFloat(layout.rowPadding.leading + layout.rowPadding.trailing)
        let spacingBetweenItems = layout.itemSpacing * CGFloat(layout.numberOfColumns - 1)
        let columnWidth = (width - (horizontalPadding + spacingBetweenItems)) / CGFloat(numberOfColumns)

        return columnWidth
    }

    private func getRowHeight(for row: Int, metrics: GeometryProxy?) -> CGFloat {
        guard let metrics = metrics else { return 0 }

        switch rowHeight {
        case .constant(let constant):
            return constant
        case .sameAsItemWidth:
            return getColumnWidth(for: metrics.size.width)
        case .dynamic(let rowHeightBlock):
            return rowHeightBlock(row, metrics, itemSpacing, numberOfColumns)
        }
    }
}

public extension CollectionView {
    func rowPadding(_ padding: EdgeInsets) -> Self {
        layout.rowPadding = padding
        return self
    }

    func itemSpacing(_ itemSpacing: CGFloat) -> Self {
        layout.itemSpacing = itemSpacing
        return self
    }

    func numberOfColumns(_ numberOfColumns: Int) -> Self {
        layout.numberOfColumns = numberOfColumns
        return self
    }

    func rowHeight(_ rowHeight: CollectionViewRowHeight) -> Self {
        layout.rowHeight = rowHeight
        return self
    }

    func scrollViewInsets(_ scrollViewInsets: EdgeInsets) -> Self {
        layout.scrollViewInsets = scrollViewInsets
        return self
    }
}

struct CollectionView_Previews: PreviewProvider {
    struct ItemModel: Identifiable, Equatable {
        let id: Int
        let color: Color
    }

    @State static var items = [
        ItemModel(id: 0, color: Color.red),
        ItemModel(id: 1, color: Color.blue),
        ItemModel(id: 2, color: Color.green),
        ItemModel(id: 3, color: Color.yellow),
        ItemModel(id: 4, color: Color.orange),
    ]

    static var previews: some View {
        CollectionView(items: $items) { item, _ in
            Rectangle()
                .foregroundColor(item.color)
        }
    }
}

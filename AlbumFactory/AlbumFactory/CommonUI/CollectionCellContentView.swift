import SwiftUI

struct CollectionCellContentView<Item, ItemContent>: View where ItemContent: View, Item: Identifiable {
    let item: Item

    private let itemBuilder: (Item, GeometryProxy) -> ItemContent
    private let tapAction: ((Item, GeometryProxy) -> Void)?
    private let longPressAction: ((Item, GeometryProxy) -> Void)?
    private let pressAction: ((Item, Bool) -> Void)?

    init(item: Item,
         tapAction: ((Item, GeometryProxy) -> Void)? = nil,
         longPressAction: ((Item, GeometryProxy) -> Void)? = nil,
         pressAction: ((Item, Bool) -> Void)? = nil,
         @ViewBuilder itemBuilder: @escaping (Item, GeometryProxy) -> ItemContent) {
        self.item = item
        self.tapAction = tapAction
        self.longPressAction = longPressAction
        self.pressAction = pressAction
        self.itemBuilder = itemBuilder
    }

    var body: some View {
        GeometryReader { itemMetrics in
            ZStack {
                Group {
                    itemBuilder(item, itemMetrics)
                }
                .zIndex(2)
                .allowsHitTesting(false)

                Group {
                    Rectangle()
                        .foregroundColor(Color.clear)
                }
                .background(Color(UIColor.systemBackground))
                .allowsHitTesting(true)
                .zIndex(1)
                .onTapGesture {
                    tapAction?(item, itemMetrics)
                }
                .onLongPressGesture(minimumDuration: 0.25, maximumDistance: 10, pressing: { pressing in
                    pressAction?(item, pressing)
                }) {
                    longPressAction?(item, itemMetrics)
                }
            }
        }
    }
}

struct CollectionItemView_Previews: PreviewProvider {
    struct ItemModel: Identifiable, Equatable {
        let id: Int
        let color: Color
    }

    static var previews: some View {
        Group {
            CollectionCellContentView(item: ItemModel(id: 1, color: .blue)) { item, _ in
                Rectangle()
                    .background(item.color)
            }
        }
    }
}

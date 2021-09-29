import SwiftUI

struct CollectionCellContentView<Item, ItemContent>: View where ItemContent: View, Item: Identifiable {
    let item: Item

    private let itemBuilder: (Item, GeometryProxy) -> ItemContent
    private let tapAction: ((Item, GeometryProxy) -> Void)?

    init(item: Item,
         tapAction: ((Item, GeometryProxy) -> Void)? = nil,
         @ViewBuilder itemBuilder: @escaping (Item, GeometryProxy) -> ItemContent) {
        self.item = item
        self.tapAction = tapAction
        self.itemBuilder = itemBuilder
    }

    var body: some View {
        GeometryReader { itemMetrics in
            ZStack {
                Group {
                    itemBuilder(item, itemMetrics)
                }
                .zIndex(2)
                .allowsHitTesting(true)
                .onTapGesture {
                    tapAction?(item, itemMetrics)
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

import SwiftUI

struct EmptyContentView: View {

    private let text: String
    private let action: (() -> Void)?

    init(text: String, action: (() -> Void)? = nil) {
        self.text = text
        self.action = action
    }

    var body: some View {
        VStack(spacing: Spacing.defaultVertical) {
            Image("generic_error")
                .resizable()
                .frame(width: 100, height: 100)
            Text(text)
                .font(AppFont.subHeading.font)
                .foregroundColor(AppColor.dark.color)
            Button(
                action: { action?() },
                label: {
                    Text("Try again")
                        .font(AppFont.subHeading.font)
                        .foregroundColor(AppColor.orange.color)
                }
            )
        }
        .background(AppColor.white.color)
    }
}

struct EmptyContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyContentView(text: "Something went wrong!")
    }
}

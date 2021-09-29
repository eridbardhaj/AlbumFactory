import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Spacing.defaultVertical) {
            Text("Loading...")
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

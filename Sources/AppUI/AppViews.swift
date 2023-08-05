import SkipUI

public struct SkipUISampleView: SkipView {
    // SKIP NOWARN
    // SKIP INSERT: @androidx.compose.runtime.Composable
    @SkipBuilder public func view() -> some SkipView {
        SkipVStack {
            SkipHStack {
                SkipText(text: "Tab 1:").eval()
                SkipText(text: AppTabs.allCases[0].title).eval()
            }.eval()
            SkipHStack {
                SkipText(text: "Tab 2:").eval()
                SkipText(text: AppTabs.allCases[1].title).eval()
            }.eval()
            SkipHStack {
                SkipText(text: "Tab 3:").eval()
                SkipText(text: AppTabs.allCases[2].title).eval()
            }.eval()
            SkipHStack {
                SkipText(text: "Tab 4:").eval()
                SkipText(text: AppTabs.allCases[3].title).eval()
            }.eval()
            SkipHStack {
                SkipText(text: "Tab 5:").eval()
                SkipText(text: AppTabs.allCases[4].title).eval()
            }.eval()
            #if !SKIP
            SwiftUIAdapterView {
                SwiftUI.Text("Any SwiftUI View")
                    .foregroundStyle(SwiftUI.Color.orange)
                    .font(SwiftUI.Font.title)
            }.eval()
            #else
            ComposeAdapterFunction {
                androidx.compose.material.Text(text: "Any Compose View",
                    color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                    style: androidx.compose.material.MaterialTheme.typography.h5
                )
            }.eval()
            #endif
        }
    }
}

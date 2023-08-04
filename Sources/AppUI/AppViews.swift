import SkipUI

public struct FavoritesLabelView: SkipView {
    // SKIP NOWARN
    // SKIP INSERT: @androidx.compose.runtime.Composable
    @SkipBuilder public func view() -> some SkipView {
        SkipHStack {
            SkipText(text: "L1:").eval()
            SkipHStack {
                SkipText(text: "L2:").eval()
                SkipHStack {
                    SkipText(text: "L3:").eval()
                    SkipHStack {
                        SkipText(text: "L4:").eval()
                        SkipHStack {
                            SkipText(text: "L5:").eval()
                            SkipHStack {
                                SkipText(text: "L6:").eval()
                                SkipText(text: AppTabs.favorites.title).eval()
                            }.eval()
                        }.eval()
                    }.eval()
                }.eval()
            }.eval()
        }
    }
}

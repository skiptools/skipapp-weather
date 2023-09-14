import SwiftUI

#if !SKIP
/// Returns the Icon for this tab.
///
/// On iOS returns `SwiftUI.Image`
extension AppTabs {
    func icon() -> Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .content: return Image(systemName: "star")
        case .search: return Image(systemName: "magnifyingglass")
        case .settings: return Image(systemName: "gear")
        }
    }
}
#else
import AndroidxComposeMaterial3
import AndroidxComposeMaterialIcons
import AndroidxComposeMaterialIconsFilled
import AndroidxComposeUiGraphicsVector.ImageVector

/// Returns the Icon for this tab.
///
/// On Android returns `androidx.compose.ui.graphics.vector.ImageVector`
extension AppTabs {
    @Composable func icon() {
        Icon(imageVector: self.image, contentDescription: self.title.value)
    }

    private var image: ImageVector {
        switch self {
        case .home: return Icons.Default.Home
        case .content: return Icons.Default.Star
        case .search: return Icons.Default.Search
        case .settings: return Icons.Default.Settings
        }
    }
}
#endif


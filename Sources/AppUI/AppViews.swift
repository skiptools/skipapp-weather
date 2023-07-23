// An example of common UI code shared between Compose and SwiftUI
import Foundation
#if SKIP
import AndroidxComposeRuntime

import AndroidxComposeMaterial.Text
import AndroidxComposeFoundationLayout.Column
import AndroidxComposeFoundationLayout.Row

typealias ComposableView = Void
#else
import SwiftUI

typealias Column = VStack
typealias Row = HStack

typealias ComposableView = View
#endif

// SKIP INSERT: @Composable
func AppText(text: String) -> some ComposableView {
    Column {
        Row {
            Text(text)
        }
    }
}

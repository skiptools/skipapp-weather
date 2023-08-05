import SkipUI
// SKIP INSERT: import androidx.compose.runtime.*
// SKIP INSERT: import androidx.compose.ui.*
// SKIP INSERT: import androidx.compose.ui.unit.*
// SKIP INSERT: import androidx.compose.foundation.layout.*

public struct SkipUISampleView: SkipView {
    let label: String

    // wrap the return in a @Composable function so we can call other @Composable functions like `remember` in the variable initializers
    // SKIP INSERT: @Composable override fun view(): SkipView {

    // SKIP REPLACE: var sliderValue1 by remember { mutableStateOf(0.0f) }
    @State var sliderValue1: Float = 0.0
    // SKIP REPLACE: var sliderValue2 by remember { mutableStateOf(100.0f) }
    @State var sliderValue2: Float = 100.0

    // SKIP INSERT: return object : SkipView {

    // SKIP NOWARN
    // SKIP INSERT: @Composable
    @SkipBuilder public func view() -> some SkipView {
        SkipVStack {
            SkipHStack {
                SkipText(label + ": ").eval()
                SkipText(AppTabs.defaultTab.title).eval()
                SkipZStack {
                    SkipText("T").eval()
                    SkipText("U").eval()
                }.eval()
            }.eval()

            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                SwiftUI.Text("Custom SwiftUI View")
                    .foregroundStyle(SwiftUI.Color.orange)
                    .font(SwiftUI.Font.title)
            }.eval()
            #else
            androidx.compose.material.Text(text: "Custom Compose View",
                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                style: androidx.compose.material.MaterialTheme.typography.h5
            )
            #endif

            SkipDivider().eval()

            SkipButton(action: {
                sliderValue1 = Float(0.0)
                sliderValue2 = Float(100.0)
            }, label: {
                SkipText("Reset").eval()
            }).eval(modifier: {
                #if canImport(SwiftUI) // $0 is a SwiftUI.View
                $0.buttonStyle(.borderedProminent).padding(50)
                #else // $0 is a androidx.compose.ui.Modifier
                $0.padding(50.dp)
                #endif
            })
            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                Slider(value: $sliderValue1, in: 0.0...100.0)
            }.eval()
            #else
            androidx.compose.material.Slider(
                value: Float(sliderValue1),
                onValueChange: { sliderValue1 = $0 },
                valueRange: Float(0.0)...Float(100.0)
            )
            #endif

            SkipText("Slider 1: \(Int(sliderValue1))%").eval()

            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                Slider(value: $sliderValue2, in: 0.0...100.0)
            }.eval()
            #else
            androidx.compose.material.Slider(
                value: Float(sliderValue2),
                onValueChange: { sliderValue2 = $0 },
                valueRange: Float(0.0)...Float(100.0)
            )
            #endif

            SkipText("Slider 2: \(Int(sliderValue2))%").eval()
        }
    }

    // SKIP INSERT: } // end: return object : SkipView
    // SKIP INSERT: } // end: @Composable override fun view(): SkipView
}

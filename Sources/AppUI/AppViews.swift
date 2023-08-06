import SkipUI
// SKIP INSERT: import androidx.compose.runtime.*

public struct SkipUISampleView: SkipView {
    public var style = Style()
    let label: String

    // SKIP INSERT: @Composable override fun view(): SkipView {
    // SKIP REPLACE: var sliderValue by remember { mutableStateOf(50.0) }
    @State var sliderValue = 50.0 // nested in an anonymous inner class returned from view() in Kotlin
    // SKIP INSERT: return object : SkipView {

    // SKIP NOWARN
    // SKIP INSERT: @Composable
    public func view() -> some SkipView {
        return innerView()
    }

    // SKIP NOWARN
    // SKIP INSERT: @Composable
    private func innerView() -> some SkipView {
        SkipVStack {
            SkipText("Welcome To SkipUI")
                .eval(style: style.font(.largeTitle))
            SkipText("native component demo screen")
                .eval(style: style.font(.title).color(.indigo))

            SkipHStack {
                SkipText(label + ": ").eval(style: style.font(.subheadline))
                SkipText(AppTabs.defaultTab.title).eval(style: style.font(.headline))
            }.eval()

            SkipGroup { // red, white, and blue "O"s of different sizes
                SkipDivider().eval()
                SkipZStack {
                    SkipText("O").eval(style: style.font(.title).color(.red))
                    SkipText("O").eval(style: style.font(.title2).color(.white))
                    SkipText("O").eval(style: style.font(.title3).color(.blue))
                }.eval()
                SkipDivider().eval()
            }.eval()

            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                Slider(value: $sliderValue, in: 0.0...100.0)
            }.eval()
            #else
            androidx.compose.material.Slider(
                modifier: style.modifier,
                value: Float(sliderValue),
                onValueChange: { sliderValue = Double($0) },
                valueRange: Float(0.0)...Float(100.0)
            )
            #endif

            SkipText("Slider: \(Int(sliderValue))%")
                .eval(style: style.opacity(Double(sliderValue) / 100.0))

            SkipButton(action: {
                logger.info("reset button tapped")
                sliderValue = 50.0
            }, label: {
                SkipText("Reset").eval()
            }).eval()

            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                SwiftUI.Text("Custom SwiftUI View")
                    .foregroundStyle(SwiftUI.Color.orange)
                    .font(SwiftUI.Font.title)
            }.eval()
            #else
            androidx.compose.material.Text(modifier: style.modifier, text: "Custom Compose View",
                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                style: androidx.compose.material.MaterialTheme.typography.h5
            )
            #endif
        }
    }

    // SKIP INSERT: } // end: return object : SkipView
    // SKIP INSERT: } // end: @Composable override fun view(): SkipView
}

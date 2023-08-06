import SkipUI
// SKIP INSERT: import androidx.compose.runtime.*

public struct SkipUISampleView: SkipView {
    public var style = Style()

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
    public func view() -> some SkipView {
        return innerView()//.eval(style: style)
    }

    // SKIP NOWARN
    // SKIP INSERT: @Composable
    private func innerView() -> some SkipView {
        SkipVStack {
            SkipHStack {
                SkipText(label + ": ").eval(style: style)
                SkipText(AppTabs.defaultTab.title).eval(style: style)
                SkipZStack {
                    SkipText("T").eval(style: style)
                    SkipText("U").eval(style: style)
                }.eval(style: style)
            }.eval(style: style)

            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                SwiftUI.Text("Custom SwiftUI View")
                    .foregroundStyle(SwiftUI.Color.orange)
                    .font(SwiftUI.Font.title)
            }.eval(style: style)
            #else
            androidx.compose.material.Text(modifier: style.modifier, text: "Custom Compose View",
                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                style: androidx.compose.material.MaterialTheme.typography.h5
            )
            #endif

            SkipDivider().eval(style: style)

            SkipButton(action: {
                sliderValue1 = Float(0.0)
                sliderValue2 = Float(100.0)
            }, label: {
                SkipText("Reset").eval(style: style)
            }).eval(style: style)


            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                Slider(value: $sliderValue1, in: 0.0...100.0)
            }.eval(style: style)
            #else
            androidx.compose.material.Slider(
                modifier: style.modifier,
                value: Float(sliderValue1),
                onValueChange: { sliderValue1 = $0 },
                valueRange: Float(0.0)...Float(100.0)
            )
            #endif

            SkipText("Slider 1: \(Int(sliderValue1))%")
                .eval(style: style.opacity(Double(sliderValue1) / 100.0))

            #if canImport(SwiftUI)
            SwiftUIAdapterView {
                Slider(value: $sliderValue2, in: 0.0...100.0)
            }.eval(style: style)
            #else
            androidx.compose.material.Slider(
                modifier: style.modifier,
                value: Float(sliderValue2),
                onValueChange: { sliderValue2 = $0 },
                valueRange: Float(0.0)...Float(100.0)
            )
            #endif

            SkipText("Slider 2: \(Int(sliderValue2))%")
                .eval(style: style.opacity(Double(sliderValue2) / 100.0))
        }
    }

    // SKIP INSERT: } // end: return object : SkipView
    // SKIP INSERT: } // end: @Composable override fun view(): SkipView
}

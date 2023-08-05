import SkipUI
// SKIP INSERT: import androidx.compose.runtime.*
public struct SkipUISampleView: SkipView {
    // SKIP REPLACE: var sliderValue by mutableStateOf(50.0f)
    @State var sliderValue: Float = 50.0

    // SKIP INSERT: @Composable
    public func view() -> some SkipView {
        SkipVStack {
            SkipHStack {
                SkipText(text: "Label:").eval()
                SkipText(text: AppTabs.defaultTab.title).eval()
            }.eval()

            #if SKIP
            androidx.compose.material.Text(text: "Custom Compose View",
                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                style: androidx.compose.material.MaterialTheme.typography.h5
            )
            #else
            SwiftUIAdapterView {
                SwiftUI.Text("Custom SwiftUI View")
                    .foregroundStyle(SwiftUI.Color.orange)
                    .font(SwiftUI.Font.title)
            }.eval()
            #endif

            #if SKIP
            androidx.compose.material.Slider(
                value: Float(sliderValue),
                onValueChange: { sliderValue = $0 },
                valueRange: Float(0.0)...Float(100.0)
            )
            #else
            SwiftUIAdapterView {
                Slider(value: $sliderValue, in: 0.0...100.0)
            }.eval()
            #endif

            SkipText(text: "Slider: \(Int(sliderValue))%").eval()

            #if SKIP
            androidx.compose.material.Button(enabled: sliderValue != Float(50.0), onClick: {
                sliderValue = Float(50.0)
            }) {
                androidx.compose.material.Text("Reset")
            }
            #else
            SwiftUIAdapterView {
                Button(action: {
                    sliderValue = 50.0
                }, label: {
                    Text("Reset")
                })
                .disabled(sliderValue == 50.0)
            }.eval()
            #endif
        }
    }
}

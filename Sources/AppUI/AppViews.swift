// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
//import SwiftUI
import SkipUI
// SKIP INSERT: import androidx.compose.runtime.*

//let _ = SkipUIPublicModuleName()

#if !SKIP
extension SwiftUI.View {
//    func eval() -> Self { self } // SwiftUI
    func eval() -> SwiftUIAdapterView<Self> { SwiftUIAdapterView { self } } // SkipUI
}
#endif

struct SkipSampleView: View {
    /// The title of the view
    let label: String

    // in Kotlin, all @State and @StateObject instances are nested within an anonymous inner SkipView instance that is constructed by the @Composable view() function (because `remember` is itself @Composable and cannot be called from a constructor)

    /* SKIP INSERT:
    @Composable override fun view(): SkipView {
        return object : SkipView {
     */

    // now we are inside a @Composable context, and we can use `remember`

    // SKIP REPLACE: var sliderValue by remember { mutableStateOf(50.0) }
    @State var sliderValue = 50.0

    #if canImport(SwiftUI)
    var body: some View {
        view()
    }
    #endif

    // SKIP INSERT: @Composable
    func view() -> some View {
        return VStack {
            Text("Welcome To SkipUI")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .eval()

            Text("native component demo screen")
                .font(.title)
                .foregroundStyle(.indigo)
                .eval()

            HStack {
                Text(label + ": ")
                    .font(.subheadline)
                    .foregroundStyle(.mint)
                    .eval()
                Text(AppTabs.defaultTab.title)
                    .font(.headline)
                    .foregroundStyle(.mint)
                    .eval()
            }
            .eval()

            Spacer()
                .frame(height: 100.0)
                .eval()

            #if canImport(SwiftUI)
            Slider(value: $sliderValue, in: 0.0...100.0)
                .eval()
            #else
            androidx.compose.material.Slider(
                value: Float(sliderValue),
                onValueChange: { sliderValue = Double($0) },
                valueRange: Float(0.0)...Float(100.0)
            )
            #endif

            Text("Slider: \(Int(sliderValue))%")
                .font(.title)
                .foregroundStyle(.orange)
                .opacity(Double(sliderValue) / 100.0)
                .eval()

            Button(action: {
                logger.info("reset button tapped")
                sliderValue = 50.0
            }, label: {
                Text("Reset")
                    .eval()
            })
            .eval()

            Group { // red, white, and blue "O"s of different sizes
                Divider()
                    .background(.green)
                    .eval()
                ZStack {
                    VStack {
                        HStack {
                            ZStack { }
                                .frame(width: 30.0, height: 30.0)
                                .background(.purple)
                                .eval()
                            ZStack { }
                                .frame(width: 30.0, height: 30.0)
                                .background(.orange)
                                .eval()
                        }
                        .eval()
                        HStack {
                            ZStack { }
                                .frame(width: 30.0, height: 30.0)
                                .background(.green)
                                .eval()
                            ZStack { }
                                .frame(width: 30.0, height: 30.0)
                                .background(.red)
                                .eval()
                        }
                        .eval()
                    }
                    .eval()
                    Text("o")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .eval()
                }
                .rotationEffect(.degrees((sliderValue / 100.0) * 360.0))
                .eval()
                Divider()
                    .background(.green)
                    .eval()
            }
            .eval()

            #if canImport(SwiftUI)
            Text("Custom SwiftUI View")
                .foregroundStyle(.orange)
                .font(.title)
                .eval()
            #else
            androidx.compose.material.Text(text: "Custom Compose View",
                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                style: androidx.compose.material.MaterialTheme.typography.h5
            )
            #endif
        }
    }

    // SKIP INSERT: } // end: return object : SkipView
    // SKIP INSERT: } // end: @Composable override fun view(): SkipView
}

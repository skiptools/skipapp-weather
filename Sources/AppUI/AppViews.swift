// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation

#if !SKIP
import SwiftUI
extension View { func eval() -> Self { self } } // performs @Composable invoke in Kotlin
#else
import SkipUI
// SKIP INSERT: import androidx.compose.runtime.* // needed for remember/getValue/setValue
#endif

struct SkipSampleView: View {
    /// The title of the view
    let label: String

    /// The default slider value
    static let defaultValue = 50.0

    // Move all @State/@StateObject/@ObservedObject properties into a nested anonymous inner SkipView constructed from a @Composable view() function, thereby enabling the use of `remember` to track state

    // SKIP INSERT: @Composable override fun view(): SkipView { return object : SkipView {

    // …and now that we are inside a @Composable context, and we can use `remember` for our local state
    // SKIP REPLACE: var sliderValue by remember { mutableStateOf(defaultValue) }
    @State var sliderValue = defaultValue

    #if canImport(SwiftUI)
    var body: some View {
        view()
    }
    #endif

    // SKIP NOWARN
    // SKIP INSERT: @Composable
    @ViewBuilder func view() -> some View {
        VStack {
            Text("Welcome To SkipUI")
                .font(.largeTitle)
                .foregroundStyle(.mint)
                .eval()

            Text("native component demo screen")
                .font(.title)
                .foregroundStyle(.indigo)
                .eval()

            HStack {
                Text(label + ": ")
                    .font(.subheadline)
                    .foregroundStyle(.cyan)
                    .eval()
                Text(AppTabs.defaultTab.title)
                    .font(.headline)
                    .foregroundStyle(.teal)
                    .eval()
            }
            .eval()

            Spacer()
                .frame(height: 100.0)
                .eval()

            Slider(value: Binding(get: { sliderValue }, set: { sliderValue = $0 }), in: 0.0...100.0)
                .eval()

            Text("Slider: \(Int(sliderValue))%")
                .font(.title)
                .foregroundStyle(.orange)
                .opacity(Double(sliderValue) / 100.0)
                .eval()

            HStack {
                Button(action: {
                    logger.info("dance button tapped")
                    Task {
                        repeat {
                            withAnimation {
                                var random = SystemRandomNumberGenerator()
                                func rnd() -> Double { Double(random.next()) / Double(UInt64.max) }
                                sliderValue = rnd() * 100.0
                            }
                            try await Task.sleep(nanoseconds: 1_000_000 * 300) // 300ms
                        } while sliderValue != Self.defaultValue
                    }
                }, label: {
                    Text("Dance")
                        .eval()
                })
                .eval()

                Button(action: {
                    logger.info("reset button tapped")
                    withAnimation {
                        sliderValue = Self.defaultValue
                    }
                }, label: {
                    Text("Reset")
                        .eval()
                })
                //#if !SKIP // per-target customization mechanism, except error: “Skip does not support this Swift syntax [postfixIfConfigExpr]”
                //.buttonStyle(.borderedProminent)
                //#endif

                .eval()
            }
            .eval()

            VStack {
                Divider()
                    .background(.gray)
                    .eval()
                ZStack {
                    //Circle().fill(Color.white).opacity(0.3).eval()
                    VStack {
                        HStack {
                            ZStack { }
                                .frame(width: sliderValue, height: sliderValue)
                                .background(.purple)
                                .eval()
                            ZStack { }
                                .frame(width: sliderValue, height: sliderValue)
                                .background(.orange)
                                .eval()
                        }
                        .eval()
                        HStack {
                            ZStack { }
                                .frame(width: sliderValue, height: sliderValue)
                                .background(.green)
                                .eval()
                            ZStack { }
                                .frame(width: sliderValue, height: sliderValue)
                                .background(.red)
                                .eval()
                        }
                        .eval()
                    }
                    .eval()
                }
                .rotationEffect(.degrees((sliderValue / 100.0) * 360.0))
                .frame(height: 250.0)
                .eval()
                Divider()
                    .background(.gray)
                    .eval()
            }
            .eval()

            #if !SKIP
            Text("Custom SwiftUI View")
                .foregroundStyle(.orange)
                .font(.title2)
                .eval()
            #else
            androidx.compose.material.Text(text: "Custom Compose View",
                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                style: androidx.compose.material.MaterialTheme.typography.h5
            )
            #endif
        }
    }

    // SKIP INSERT: } } // end: @Composable override fun view(): SkipView
}

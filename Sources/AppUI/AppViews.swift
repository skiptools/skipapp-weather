// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import SwiftUI

// SKIP INSERT: import androidx.compose.runtime.* // needed for remember/getValue/setValue
// SKIP INSERT: import androidx.compose.runtime.saveable.* // needed for rememberSaveable/restore

extension View { func eval() -> Self { self } } // performs @Composable invoke in Kotlin

struct SkipSampleView: View {
    /// The title of the view
    let label: String

    /// The default slider value
    static let defaultValue = 100.0

    // Move all @State/@StateObject/@ObservedObject properties into a nested anonymous inner SkipView constructed from a @Composable view() function, thereby enabling the use of `remember` to track state

    // SKIP INSERT: @Composable override fun view(): SkipView { return object : SkipView {

    // …and now that we are inside a @Composable context, and we can use `remember` for our local state
    // SKIP REPLACE: var sliderValue by rememberSaveable { mutableStateOf(defaultValue) }
    @State private var sliderValue = defaultValue

    // SKIP INSERT: @Composable override fun view(): SkipView { return body() }

    @ViewBuilder var body: some View {
        VStack {
            Text("Welcome To SkipUI")
                .font(.largeTitle)
                .eval() // should no longer be needed
            
            Text("native component demo screen")
                .font(.title)
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
                .frame(height: 50.0)
                .eval()

            Slider(value: Binding(get: { sliderValue }, set: { sliderValue = $0 }), in: 0.0...100.0)
                .eval()

            Text("Slider: \(Int(sliderValue))%")
                .font(.title)
                .foregroundStyle(.red)
                .eval()

            HStack {
                Button(action: {
                    logger.info("animate button tapped")
                    Task {
                        // TODO: support animated property changes
                        //withAnimation {
                        //TODO: Double.random(in: 0.0...100.0)
                        var random = SystemRandomNumberGenerator()
                        func rnd() -> Double { Double(random.next()) / Double(UInt64.max) }
                        sliderValue = rnd()
                        //}

                        repeat {
                            repeat {
                                sliderValue += 1.0
                                try await Task.sleep(nanoseconds: 1_000_000 * 16) // 16ms=60fps
                            } while sliderValue < 99.0 && sliderValue != Self.defaultValue
                            while sliderValue > 1.0 && sliderValue != Self.defaultValue {
                                sliderValue -= 1.0
                                try await Task.sleep(nanoseconds: 1_000_000 * 16) // 16ms=60fps
                            }
                        } while sliderValue != Self.defaultValue
                    }
                }, label: {
                    Text("Animate")
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
                //#if canImport(SwiftUI) // per-target customization mechanism, except error: “Skip does not support this Swift syntax [postfixIfConfigExpr]”
                //.buttonStyle(.borderedProminent)
                //#endif
                .eval()
            }
            .eval()

            let cellWidth = 80.0
            VStack {
                Divider()
                    .background(.gray)
                    .eval()

                let colorWidth = cellWidth * sliderValue / 100.0

                // create 4 layers of the 4-colored squared with different rotations
                let colors = ZStack {
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue / 100.0) * 360.0) + (90.0 * 0.0)), c1: .indigo, c2: .blue, c3: .yellow, c4: .green)
                        .eval()
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.75 / 100.0) * 360.0) + (90.0 * 0.25)), c1: .red, c2: .purple, c3: .orange, c4: .mint)
                        .eval()
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.50 / 100.0) * 360.0) + (90.0 * 0.50)), c1: .yellow, c2: .red, c3: .brown, c4: .cyan)
                        .eval()
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.25 / 100.0) * 360.0) + (90.0 * 0.75)), c1: .orange, c2: .pink, c3: .teal, c4: .purple)
                        .eval()
                }
                .frame(width: cellWidth, height: cellWidth)

                VStack {
                    HStack {
                        colors.eval()
                        colors.eval()
                        colors.eval()
                        colors.eval()
                    }
                    .eval()
                    HStack {
                        colors.eval()
                        colors.eval()
                        colors.eval()
                        colors.eval()
                    }
                    .eval()
                    HStack {
                        colors.eval()
                        colors.eval()
                        colors.eval()
                        colors.eval()
                    }
                    .eval()
                    HStack {
                        colors.eval()
                        colors.eval()
                        colors.eval()
                        colors.eval()
                    }
                    .eval()
                }
                .eval()

                Divider()
                    .background(.gray)
                    .eval()
            }
            .eval()

            ZStack {
                #if !SKIP
                Text("Custom SwiftUI View")
                    .foregroundStyle(.orange)
                    .font(.title2)
                    .eval()
                #else
                androidx.compose.material3.Text(text: "Custom Compose View",
                                                color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                                                style: androidx.compose.material.MaterialTheme.typography.h5
                )
                #endif
            }
            .opacity(Double(sliderValue) / 100.0)
            .eval()

        }
    }

    // SKIP INSERT: } } // end: @Composable override fun view(): SkipView
}


/// Four colored squares arranged in a grid using a ZStack, HStack, and VStack
struct FourColorView: View {
    let width: CGFloat
    let rotation: Angle
    let c1: Color
    let c2: Color
    let c3: Color
    let c4: Color

    // SKIP INSERT: @Composable override fun view(): SkipView { return object : SkipView {
    // SKIP INSERT: @Composable override fun view(): SkipView { return body() }

    @ViewBuilder var body: some View {
        ZStack {
            VStack {
                HStack {
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c1)
                        .eval()
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c2)
                        .eval()
                }
                .eval()
                HStack {
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c3)
                        .eval()
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c4)
                        .eval()
                }
                .eval()
            }
            .eval()
        }
        .opacity(0.5)
        .rotationEffect(rotation)
    }

    // SKIP INSERT: } } // end: @Composable override fun view(): SkipView
}


// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SwiftUI

struct SkipSampleView: View {
    let label: String

    static let defaultSliderValue = 100.0
    @State var sliderValue = Self.defaultSliderValue

    var body: some View {
        VStack {
            Text("Welcome to SkipUI")
                .font(.largeTitle)
            Text("native component demo screen")
                .font(.title)

            HStack {
                Text(label + ": ")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                Text(AppTabs.defaultTab.title)
                    .font(.headline)
                    .foregroundStyle(.teal)
                    #if !SKIP
                    .bold()
                    #endif
            }

            Spacer()
                .frame(height: 50.0)

            Slider(value: $sliderValue, in: 0.0...100.0)

            Text("Slider: \(Int(sliderValue))%")
                .font(.title)
                .foregroundStyle(.red)

            HStack {
                Button(action: {
                    logger.info("Animate button tapped")
                    Task {
                        let sliderChange = 0.3
                        repeat {
                            repeat {
                                sliderValue += sliderChange
                                try await Task.sleep(nanoseconds: 1_000_000 * 16) // 16ms ~= 60fps
                            } while sliderValue < 99.0 && sliderValue != Self.defaultSliderValue
                            while sliderValue > 1.0 && sliderValue != Self.defaultSliderValue {
                                sliderValue -= sliderChange
                                try await Task.sleep(nanoseconds: 1_000_000 * 16) // 16ms ~= 60fps
                            }
                        } while sliderValue != Self.defaultSliderValue
                    }
                }, label: {
                    Text("Animate")
                })

                Button(action: {
                    logger.info("Reset button tapped")
                    withAnimation {
                        sliderValue = Self.defaultSliderValue
                    }
                }, label: {
                    Text("Reset")
                })
            }

            let cellWidth = 80.0
            VStack {
                Divider()
                    .background(.gray)

                let colorWidth = cellWidth * sliderValue / 100.0

                // Create 4 layers of the 4-colored squared with different rotations
                let colors = ZStack {
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 1.00 / 100.0) * 360.0) + (90.0 * 0.00)), c1: .indigo, c2: .blue, c3: .yellow, c4: .green)
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.75 / 100.0) * 360.0) + (90.0 * 0.25)), c1: .red, c2: .purple, c3: .orange, c4: .mint)
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.50 / 100.0) * 360.0) + (90.0 * 0.50)), c1: .yellow, c2: .red, c3: .brown, c4: .cyan)
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.25 / 100.0) * 360.0) + (90.0 * 0.75)), c1: .orange, c2: .pink, c3: .teal, c4: .purple)

                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.25 / 100.0) * 360.0) + (90.0 * 0.00)), c1: .red, c2: .green, c3: .purple, c4: .orange)
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.50 / 100.0) * 360.0) + (90.0 * 0.25)), c1: .yellow, c2: .orange, c3: .pink, c4: .indigo)
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 0.75 / 100.0) * 360.0) + (90.0 * 0.50)), c1: .brown, c2: .teal, c3: .cyan, c4: .gray)
                    FourColorView(width: colorWidth, rotation: .degrees(((sliderValue * 1.00 / 100.0) * 360.0) + (90.0 * 0.75)), c1: .cyan, c2: .orange, c3: .teal, c4: .pink)
                }
                .frame(width: cellWidth, height: cellWidth)

                VStack {
                    HStack {
                        colors
                        colors
                        colors
                        colors
                    }
                    HStack {
                        colors
                        colors
                        colors
                        colors
                    }
                    HStack {
                        colors
                        colors
                        colors
                        colors
                    }
                    HStack {
                        colors
                        colors
                        colors
                        colors
                    }
                }

                Divider()
                    .background(.gray)
            }

            ZStack {
#if !SKIP
                Text("Custom SwiftUI View")
                    .foregroundStyle(.orange)
                    .font(.title2)
#else
                androidx.compose.material3.Text(text: "Custom Compose View",
                    color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                    style: androidx.compose.material.MaterialTheme.typography.h5
                )
#endif
            }
            .opacity(Double(sliderValue) / 100.0)
        }
    }
}

/// Four colored squares arranged in a grid using a ZStack, HStack, and VStack.
struct FourColorView: View {
    let width: CGFloat
    let rotation: Angle
    let c1: Color
    let c2: Color
    let c3: Color
    let c4: Color

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c1)
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c2)
                }
                HStack {
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c3)
                    ZStack { }.frame(width: width / 4.0, height: width / 4.0)
                        .background(c4)
                }
            }
        }
        .opacity(0.4)
        .rotationEffect(rotation)
    }
}

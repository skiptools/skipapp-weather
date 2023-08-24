// Copyright 20222 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SwiftUI

struct SkipSampleView: View {
    let label: String
    @State var widgetCount = 5.0
    @State var widgetRotation = Self.maxWidgetRotation / 2.0

//    struct ListItem {
//        let i: Int
//        let s: String
//    }
//    func items() -> [ListItem] {
//        var items: [ListItem] = []
//        for i in 0..<100 {
//            items.append(ListItem(i: i, s: "Item \(i)"))
//        }
//        return items
//    }
//
//    var body: some View {
//        List {
//            Group {
//                Text("Row 1")
//                Text("Row 2")
//            }
//            VStack {
//                Text("Row 3")
//                Text("Row 4")
//            }
//        }

//        List(0..<100) {
//            Text("Row \($0)")
//        }

//        List(items(), id: \.i) {
//            Text($0.s)
//        }
//    }

//    @State var tapCount = 0
//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("Button")
//                    .font(.title)
//                Divider()
//                Button(action: { tapCount += 1 }) {
//                    Text("Tap count: \(tapCount)")
//                }
//                Button("Tap count: \(tapCount)") {
//                    tapCount += 1
//                }
//            }
//        }
//    }

//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("Font")
//                    .font(.title)
//                Divider()
//
//                Text("Plain")
//                Text("Bold").bold()
//                Text("Italic").italic()
//                Text("Title bold italic").font(.title).bold().italic()
//                Group {
//                    Text("Thin footnote container")
//                    Text("Overridden to title font").font(.title)
//                }
//                .font(.footnote).fontWeight(.thin)
//            }
//        }
//    }

//    var body: some View {
//        ScrollView {
//            VStack {
//                Text("Color")
//                    .font(.title)
//                Divider()
//                
//                Color.red
//                    .frame(width: 100.0, height: 100.0)
//                Color.red
//                    .opacity(0.5)
//                    .frame(width: 100.0, height: 100.0)
//                Color(red: 1.0, green: 0.0, blue: 0.0)
//                    .frame(width: 100.0, height: 100.0)
//                Color(white: 0.5, opacity: 1.0)
//                    .frame(width: 100.0, height: 100.0)
//                Color.accentColor
//                    .frame(width: 100.0, height: 100.0)
//            }
//        }
//    }

    static let maxWidgetRotation = 100.0

>>>>>>> ddf4b36 (Update with latest tests and SkipUI changes)
    var body: some View {
        VStack(spacing: 4.0) {
            Text("Welcome to SkipUI")
                .font(.largeTitle)

            Spacer().frame(height: 10.0)

            VStack {
                HStack {
                    Slider(value: $widgetRotation, in: 0.0...100.0)
                }
                Text("Angle: \(Int(widgetRotation * 3.6))°")
                    .font(Font.title3
                        #if !SKIP
                        .monospacedDigit() // fixed-width digits on iOS
                        #endif
                    )
            }

            VStack {
                HStack {
                    Slider(value: $widgetCount, in: 1.0...8.0)
                }
                Text("Widgets: \(4 * 16 * Int(widgetCount))")
                    .font(.title3
                        #if !SKIP
                        .monospacedDigit() // fixed-width digits on iOS
                        #endif
                    )
            }

            let cellWidth = 80.0
            VStack {
                Divider()
                    .background(.gray)

                let colorWidth = cellWidth * widgetRotation / 100.0
                let opacity = 1.0 - (Double(Int(widgetCount)) * 0.1)

                // Create 4 layers of the 4-colored squared with different rotations
                let colors = ZStack {
                    if widgetCount > 0.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 1.00 / 100.0) * 360.0) + (90.0 * 0.00)), c1: .indigo, c2: .blue, c3: .yellow, c4: .green)
                    }
                    if widgetCount > 1.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 0.75 / 100.0) * 360.0) + (90.0 * 0.25)), c1: .red, c2: .purple, c3: .orange, c4: .mint)
                    }
                    if widgetCount > 2.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 0.50 / 100.0) * 360.0) + (90.0 * 0.50)), c1: .yellow, c2: .red, c3: .brown, c4: .cyan)
                    }
                    if widgetCount > 3.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 0.25 / 100.0) * 360.0) + (90.0 * 0.75)), c1: .orange, c2: .pink, c3: .teal, c4: .purple)
                    }

                    if widgetCount > 4.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 0.25 / 100.0) * 360.0) + (90.0 * 0.00)), c1: .red, c2: .green, c3: .purple, c4: .orange)
                    }
                    if widgetCount > 5.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 0.50 / 100.0) * 360.0) + (90.0 * 0.25)), c1: .yellow, c2: .orange, c3: .pink, c4: .indigo)
                    }
                    if widgetCount > 6.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 0.75 / 100.0) * 360.0) + (90.0 * 0.50)), c1: .brown, c2: .teal, c3: .cyan, c4: .gray)
                    }
                    if widgetCount > 7.0 {
                        FourColorView(width: colorWidth, opacity: opacity, rotation: .degrees(((widgetRotation * 1.00 / 100.0) * 360.0) + (90.0 * 0.75)), c1: .cyan, c2: .orange, c3: .teal, c4: .pink)
                    }
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

            HStack {
                Button(action: {
                    logger.info("Animate button tapped")
                    Task {
                        widgetRotation = min(99.0, 100.0)

                        let sliderChange = 0.3
                        repeat {
                            repeat {
                                widgetRotation += sliderChange
                                try await Task.sleep(nanoseconds: 1_000_000 * 16) // 16ms ~= 60fps
                            } while widgetRotation < 99.0 && widgetRotation != Self.maxWidgetRotation
                            while widgetRotation > 1.0 && widgetRotation != Self.maxWidgetRotation {
                                widgetRotation -= sliderChange
                                try await Task.sleep(nanoseconds: 1_000_000 * 16) // 16ms ~= 60fps
                            }
                        } while widgetRotation != Self.maxWidgetRotation
                    }
                }, label: {
                    Text("Animate")
                })

                Button(action: {
                    logger.info("Reset button tapped")
                    withAnimation {
                        widgetRotation = Self.maxWidgetRotation
                    }
                }, label: {
                    Text("Reset")
                })
            }


            ZStack {
#if !SKIP
                Text("Custom SwiftUI View")
                    .foregroundStyle(.orange)
                    .font(.title2)
#else
                ComposeView { _ in
                    androidx.compose.material3.Text(text: "Custom Compose View",
                        color: androidx.compose.ui.graphics.Color(0xFFFFA500),
                        style: androidx.compose.material.MaterialTheme.typography.h5
                    )
                }
#endif
            }
            .opacity(Double(widgetRotation) / 100.0)
        }
    }
}

/// Four colored squares arranged in a grid using a ZStack, HStack, and VStack.
struct FourColorView: View {
    let width: CGFloat
    let opacity: CGFloat
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
        .opacity(opacity)
        .rotationEffect(rotation)
    }
}

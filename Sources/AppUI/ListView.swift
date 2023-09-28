import SwiftUI
import Foundation
import Observation
import WeatherAppModel

struct ListNavigationView: View {
    static let title = "Cities"

    var body: some View {
        NavigationStack {
            ListView()
                .navigationTitle(Self.title)
        }
    }
}

struct ListView : View {
    @AppStorage("celsius") var celsius: Bool = true

    var body: some View {
        List(City.allCases, id: \.location.latitude) { city in
            NavigationLink(value: city) {
                rowView(city: city)
            }
        }
        .navigationDestination(for: City.self) { city in
            WeatherView(latitude: String(city.location.latitude), longitude: String(city.location.longitude), showLocationButton: false)
                .navigationTitle(city.cityName + ", " + city.countryName)
        }
    }

    private func rowView(city: City) -> some View {
        HStack(alignment: .center) {
            city.iconView()

            VStack(alignment: .leading) {
                Text(city.cityName).font(.headline).bold()
                Text(city.countryName).font(.subheadline)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2.0) {
                HStack {
                    if city.location.isSummer {
                        Text("🌞")
                    }
                    Text("S:")
                    Text(city.averageTempSummer.temperatureString(celsius: celsius, withUnit: false))
                        .foregroundStyle(city.averageTempSummer.temperatureColor)
                }
                HStack {
                    if city.location.isWinter {
                        Text("❄️")
                    }
                    Text("W:")
                    Text(city.averageTempWinter.temperatureString(celsius: celsius, withUnit: false))
                        .foregroundStyle(city.averageTempWinter.temperatureColor)
                }
            }
            .font(.footnote)
        }
    }
}

extension City {
    /// A pseudo-random image and color for a city based on the latitude and longitude
    func iconView() -> some View {
        Image(systemName: self.symbolName)
            .foregroundStyle(cityColors[Int(abs(self.location.latitude * 100.0)) % cityColors.count])
    }
}

extension Location {
    /// Returns true if it is currently summer in the location
    var isSummer: Bool {
        (latitude > 0.0 ? [3, 4, 5, 6, 7, 8, 9] : [0, 1, 2, 10, 11, 12]).contains(currentMonth)
    }

    /// Returns true if it is currently winter in the location
    var isWinter: Bool {
        !isSummer
    }

    private var currentMonth: Int {
        Calendar.current.dateComponents([Calendar.Component.month], from: Date()).month ?? -1
    }
}

extension Double {
    /// Interpolates an RGB 3-tuple based on a parameter expressing the fraction between the colors blue and red.
    var temperatureColor: Color {
        let p = (self * 3.0) / 100.0 // 0.0 is 0% and 50.0 is 100%
        let rgb = interpolateRGB(fromColor: (r: 0.0, g: 0.0, b: 1.0), toColor: (r: 1.0, g: 0.0, b: 0.0), fraction: p)
        return Color(red: rgb.r, green: rgb.g, blue: rgb.b)
    }
}

private func interpolateRGB(fromColor: (r: CGFloat, g: CGFloat, b: CGFloat), toColor: (r: CGFloat, g: CGFloat, b: CGFloat), fraction: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    let clampedFraction = max(0.0, min(1.0, fraction))

    let ir = fromColor.r + (toColor.r - fromColor.r) * clampedFraction
    let ig = fromColor.g + (toColor.g - fromColor.g) * clampedFraction
    let ib = fromColor.b + (toColor.b - fromColor.b) * clampedFraction

    return (ir, ig, ib)
}

private let cityColors = [Color.blue, Color.red, Color.green, Color.yellow, Color.orange, Color.brown, Color.cyan, Color.indigo, Color.mint, Color.yellow, Color.pink, Color.purple, Color.teal]


import Foundation
import Observation
import SwiftUI
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
            WeatherView(latitude: String(city.location.latitude), longitude: String(city.location.longitude))
                .navigationTitle(city.cityName)
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
        Image(systemName: cityIconNames[Int(abs(self.location.longitude * 100.0)) % cityIconNames.count])
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


private let cityIconNames = ["calendar", "calendar.circle.fill", "camera", "lightbulb.fill", "cloud", "cloud.fill", "music.note", "globe.americas", "globe.americas.fill", "sun.max", "sun.max.fill", "moon", "moon.fill", "book", "book.fill", "gamecontroller", "gamecontroller.fill", "flag", "flag.fill", "heart", "heart.fill", "bolt", "bolt.fill", "camera.metering.center.weighted", "bandage", "bandage.fill", "headphones.circle", "headphones.circle.fill", "book", "book.fill", "calendar.circle", "calendar.circle.fill", "car", "square.and.pencil", "person.2", "person.2.fill", "message", "message.fill", "paperplane", "paperplane.fill", "hourglass", "bell.slash", "mic", "mic.fill", "eye.slash", "eye.slash.fill", "car.fill", "cloud", "cloud.fill", "creditcard", "creditcard.fill", "envelope", "envelope.fill", "film", "film.fill", "gift", "heart.slash", "heart.slash.fill", "video", "video.fill", "printer", "printer.fill", "cart", "cart.fill", "wifi.slash", "person.badge.plus", "person.badge.plus.fill", "folder", "folder.fill", "pianokeys", "gamecontroller", "gamecontroller.fill", "sunrise", "sunrise.fill", "lock", "lock.fill", "paperclip.circle", "paperclip.circle.fill", "alarm", "alarm.fill", "arrow.down.circle", "arrow.down.circle.fill", "bell.slash.fill", "house", "house.fill", "gearshape", "gearshape.fill", "star", "star.fill", "person.crop.circle", "person.crop.circle.fill", "gift.fill", "lightbulb", "camera.fill", "magnifyingglass.circle", "magnifyingglass.circle.fill", "music.note", "pencil", "phone", "phone.fill", "trash", "trash.fill", "wrench", "wrench.fill", "info", "house"]

private let cityColors = [Color.blue, Color.red, Color.green, Color.yellow, Color.orange, Color.brown, Color.cyan, Color.indigo, Color.mint, Color.yellow, Color.pink, Color.purple, Color.teal]


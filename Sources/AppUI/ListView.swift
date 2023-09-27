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
            city.icon.frame(width: 20.0)

            VStack(alignment: .leading) {
                Text(city.cityName).font(.headline)
                Text(city.countryName).font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(temperatureRange(for: city))
                    .font(.caption)
                    #if !SKIP
                    .lineLimit(1)
                    #endif
                Text("\(Int((Double(city.sunnyDays) / 360.0) * 100.0))% Sunny")
                    .font(.caption2)
            }
            .frame(width: 80.0)
        }
    }

    private func temperatureRange(for city: City) -> String {
        return "\(convert(city.averageTempWinter)) – \(convert(city.averageTempSummer))"
    }

    private func convert(_ temperature: Double) -> String {
        let temp = celsius ? temperature : ((temperature * 9/5) + 32)
        // Celsius temperatures are generally formatted with 1 decimal place, whereas Fahrenheit is not
        let fmt = String(format: "%.\(celsius ? 1 : 0)f", temp)
        return "\(fmt) °\(celsius ? "C" : "F")"
    }
}

extension City {
    /// A pseudo-random image and color for a city based on the latitude and longitude
    var icon: some View {
        Image(systemName: cityIconNames[Int(abs(self.location.latitude)) % cityIconNames.count])
            .foregroundStyle(cityColors[Int(abs(self.location.longitude)) % cityColors.count])
    }
}

private let cityIconNames = ["square.and.pencil", "person.2", "person.2.fill", "message", "message.fill", "paperplane", "paperplane.fill", "bell.slash", "bell.slash.fill", "house", "house.fill", "gearshape", "gearshape.fill", "star", "star.fill", "person.crop.circle", "person.crop.circle.fill", "calendar", "calendar.circle.fill", "camera", "camera.fill", "cloud", "cloud.fill", "music.note", "globe.americas", "globe.americas.fill", "sun.max", "sun.max.fill", "moon", "moon.fill", "book", "book.fill", "gamecontroller", "gamecontroller.fill", "flag", "flag.fill", "heart", "heart.fill", "bolt", "bolt.fill", "camera.metering.center.weighted", "bandage", "bandage.fill", "headphones.circle", "headphones.circle.fill", "hourglass", "mic", "mic.fill", "eye.slash", "eye.slash.fill", "heart.slash", "heart.slash.fill", "video", "video.fill", "printer", "printer.fill", "cart", "cart.fill", "wifi.slash", "person.badge.plus", "person.badge.plus.fill", "folder", "folder.fill", "pianokeys", "gamecontroller", "gamecontroller.fill", "sunrise", "sunrise.fill", "lock", "lock.fill", "paperclip.circle", "paperclip.circle.fill", "alarm", "alarm.fill", "arrow.down.circle", "arrow.down.circle.fill", "book", "book.fill", "calendar.circle", "calendar.circle.fill", "car", "car.fill", "cloud", "cloud.fill", "creditcard", "creditcard.fill", "envelope", "envelope.fill", "film", "film.fill", "gift", "gift.fill", "lightbulb", "lightbulb.fill", "magnifyingglass.circle", "magnifyingglass.circle.fill", "music.note", "pencil", "phone", "phone.fill", "trash", "trash.fill", "wrench", "wrench.fill", "info", "house"]

private let cityColors = [Color.blue, Color.red, Color.green, Color.yellow, Color.orange, Color.brown, Color.cyan, Color.indigo, Color.mint, Color.yellow, Color.pink, Color.purple, Color.teal]


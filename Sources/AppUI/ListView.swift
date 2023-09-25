import Foundation
import Observation
import SwiftUI
import WeatherAppModel

struct ListNavigationView: View {
    let title: LocalizedStringKey

    var body: some View {
        NavigationStack {
            ListView()
                .navigationTitle(Text(title, bundle: .module))
        }
    }
}

struct ListView : View {
    var body: some View {
        List(City.allCases, id: \.location.latitude) { city in
            NavigationLink(value: city) {
                rowView(city: city)
            }
        }
        .navigationDestination(for: City.self) { city in
            WeatherView(latitude: String(city.location.latitude), longitude: String(city.location.longitude))
                .navigationTitle(Text(city.cityName))
        }
    }

    private func randomIcon() -> some View {
        let names = ["square.and.pencil", "person.2", "person.2.fill", "message", "message.fill", "paperplane", "paperplane.fill", "bell.slash", "bell.slash.fill", "house", "house.fill", "gearshape", "gearshape.fill", "star", "star.fill", "person.crop.circle", "person.crop.circle.fill", "calendar", "calendar.circle.fill", "camera", "camera.fill", "cloud", "cloud.fill", "music.note", "globe.americas", "globe.americas.fill", "sun.max", "sun.max.fill", "moon", "moon.fill", "book", "book.fill", "gamecontroller", "gamecontroller.fill", "flag", "flag.fill", "heart", "heart.fill", "bolt", "bolt.fill", "camera.metering.center.weighted", "bandage", "bandage.fill", "headphones.circle", "headphones.circle.fill", "hourglass", "mic", "mic.fill", "eye.slash", "eye.slash.fill", "heart.slash", "heart.slash.fill", "video", "video.fill", "printer", "printer.fill", "cart", "cart.fill", "wifi.slash", "person.badge.plus", "person.badge.plus.fill", "folder", "folder.fill", "pianokeys", "gamecontroller", "gamecontroller.fill", "sunrise", "sunrise.fill", "lock", "lock.fill", "paperclip.circle", "paperclip.circle.fill", "alarm", "alarm.fill", "arrow.down.circle", "arrow.down.circle.fill", "book", "book.fill", "calendar.circle", "calendar.circle.fill", "car", "car.fill", "cloud", "cloud.fill", "creditcard", "creditcard.fill", "envelope", "envelope.fill", "film", "film.fill", "gift", "gift.fill", "lightbulb", "lightbulb.fill", "magnifyingglass.circle", "magnifyingglass.circle.fill", "music.note", "pencil", "phone", "phone.fill", "trash", "trash.fill", "wrench", "wrench.fill", "info", "house"]
        let colors = [Color.blue, Color.red, Color.green, Color.yellow, Color.orange, Color.brown, Color.cyan, Color.indigo, Color.mint, Color.yellow, Color.pink, Color.purple, Color.teal]

        var rnd = SystemRandomNumberGenerator()

        let name = names[Int(rnd.next() % UInt64(names.count))]
        let color = colors[Int(rnd.next() % UInt64(colors.count))]
        return Image(systemName: name).foregroundStyle(color)
    }

    private func rowView(city: City) -> some View {
        HStack(alignment: .center) {
            randomIcon()

            VStack(alignment: .leading) {
                Text(city.cityName).font(.headline)
                Text(city.countryName).font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(Int(city.averageTempWinter)) – \(Int(city.averageTempSummer)) °C")
                    .font(.caption)
                Text("\(Int((Double(city.sunnyDays) / 360.0) * 100.0))% Sunny")
                    .font(.caption2)
            }
            .frame(width: 80.0)
        }
    }
}

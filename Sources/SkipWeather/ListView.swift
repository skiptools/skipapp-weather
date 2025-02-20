import SwiftUI
import Foundation
import SkipWeatherModel
import SkipDevice

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
    var body: some View {
        List(City.allCases, id: \.location.latitude) { city in
            NavigationLink(value: city) {
                rowView(city: city)
            }
        }
        .navigationDestination(for: City.self) { city in
            WeatherView(location: city.location)
                .navigationTitle(city.cityName + ", " + city.countryName)
        }
    }

    private func rowView(city: City) -> some View {
        HStack {
            city.iconView()

            VStack(alignment: .leading) {
                Text(city.cityName).font(.headline).bold()
                Text(city.countryName).font(.subheadline)
            }

            Spacer()

            if city.location.isSummer {
                Text("🌞").font(.title2)
            } else {
                Text("❄️").font(.title2)
            }
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

    private var currentMonth: Int {
        Calendar.current.dateComponents([Calendar.Component.month], from: Date()).month ?? -1
    }
}

private let cityColors = [Color.blue, Color.red, Color.green, Color.yellow, Color.orange, Color.brown, Color.cyan, Color.indigo, Color.mint, Color.yellow, Color.pink, Color.purple, Color.teal]

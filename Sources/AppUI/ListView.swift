import Foundation
import Observation
import SwiftUI
import AppModel

struct ListView : View {
    var body: some View {
        List(City.allCases, id: \.location.latitude) { city in
            rowView(city: city)
        }
    }

    private func rowView(city: City) -> some View {
        HStack(alignment: .center) {
            Text("☆").font(.title).foregroundStyle(Color.gray)

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

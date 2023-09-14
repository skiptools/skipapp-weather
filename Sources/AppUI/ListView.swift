import Foundation
import Observation
import SwiftUI
import AppModel

struct ListView : View {
    var body: some View {
        //NavigationStack {

        // LOGCAT> 08-30 22:16:32.316 17646 17646 E AndroidRuntime: java.lang.IllegalArgumentException: Type of the key app.model.Location@3b5ead3b is not supported. On Android you can only use types which can be stored inside the Bundle.
        //return List(City.allCases, id: \.location) { city in

        return List(City.allCases, id: \.location.latitude) { city in
            rowView(city: city)
        }
        //.navigationTitle(Text("World Cities"))
        //}
    }

    private func rowView(city: City) -> some View {
        HStack(alignment: .center) {
            Text("☆").font(.title).foregroundStyle(Color.gray)

            VStack(alignment: .leading) {
                Text(city.cityName).font(.headline)
                Text(city.countryName).font(.subheadline)
            }
            Spacer()
            //Divider() // on Android this is horizontal
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

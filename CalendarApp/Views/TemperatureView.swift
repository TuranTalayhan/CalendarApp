//
//  temperatureView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 03/03/2025.
//

import SwiftUI

struct TemperatureView: View {
    let temperature: Double

    var body: some View {
        if temperature <= 0 {
            Text("snowflake")
        } else if temperature <= 10 {
            Text("cloudy")

        } else if temperature <= 20 {
            Text("sunny")

        } else if temperature <= 30 {
            Text("more sunny")

        } else if temperature <= 35 {
            Text("even more sunny")

        } else {
            Text("desert")
        }
        Text("\(temperature, specifier: "%.1f") °C")
    }
}

#Preview {
    TemperatureView(temperature: 6.3)
}

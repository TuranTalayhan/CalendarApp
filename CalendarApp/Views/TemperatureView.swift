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
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(Color.blue.opacity(0.2))
            VStack {
                if temperature <= 0 {
                    Text("❄️")
                    
                } else if temperature <= 10 {
                    Text("☁️")
                    
                } else if temperature <= 20 {
                    Text("🌤")
                    
                } else if temperature <= 30 {
                    Text("☀️")
                    
                } else if temperature <= 35 {
                    Text("🔥")
                    
                } else {
                    Text("🏜")
                }
                
                Text("\(temperature, specifier: "%.1f") °C")
            }
            .padding()
        }
        .fixedSize()
    }
}

#Preview {
    TemperatureView(temperature: 6.3)
}

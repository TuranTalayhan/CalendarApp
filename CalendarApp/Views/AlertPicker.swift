//
//  AlertPicker.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 11/03/2025.
//

import SwiftUI

struct AlertPicker: View {
    @Binding var alert: Int

    var body: some View {
        Picker("Alert", selection: $alert) {
            Text("None").tag(-1)
            Text("At time of event").tag(0)
            Text("5 minutes before").tag(5)
            Text("10 minutes before").tag(10)
            Text("15 minutes before").tag(15)
            Text("30 minutes before").tag(30)
            Text("1 hour before").tag(60)
            Text("2 hours before").tag(60 * 2)
            Text("1 day before").tag(60 * 24)
            Text("2 day before").tag(60 * 24 * 2)
            Text("1 week before").tag(60 * 24 * 7)
        }
    }
}

#Preview {
    AlertPicker(alert: .constant(-1))
}

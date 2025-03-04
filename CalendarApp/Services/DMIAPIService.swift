//
//  DMIAPIService.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 25/02/2025.
//

import Foundation

class DMIAPIService {
    private let apiKey: String

    init() {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API Key not found. Make sure it's set in Custom iOS Target Properties or Info.plist.")
        }
        self.apiKey = key
    }

    func fetchWeatherData() async throws -> CoverageJSONResponse {
        guard let url = URL(string: "https://dmigw.govcloud.dk/v1/forecastedr/collections/harmonie_dini_sf/position?coords=POINT%2812.561%2055.715%29&crs=crs84&parameter-name=temperature-0m&api-key=" + apiKey) else {
            fatalError("Loaded URL is invalid")
        }
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(CoverageJSONResponse.self, from: data)

        return decoded
    }
}

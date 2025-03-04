//
//  CoverageJSONResponse.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 27/02/2025.
//

// MARK: - API Response Model

struct CoverageJSONResponse: Codable {
    let type: String
    let domain: Domain
    let parameters: [String: Parameter]
    let ranges: [String: RangeData]
}

// MARK: - Domain

struct Domain: Codable {
    let type: String
    let domainType: String
    let axes: Axes
    let referencing: [Referencing]?
}

// MARK: - Axes

struct Axes: Codable {
    let x: CoordinateAxis?
    let y: CoordinateAxis?
    let z: CoordinateAxis?
    let t: TimeAxis
}

struct TimeAxis: Codable {
    let values: [String]
}

struct CoordinateAxis: Codable {
    let values: [Double]
}

// MARK: - Referencing

struct Referencing: Codable {
    let coordinates: [String]
    let system: System
}

struct System: Codable {
    let type: String
    let id: String?
    let calendar: String?
}

// MARK: - Parameter

struct Parameter: Codable {
    let type: String
    let description: LocalizedTitle
    let unit: Unit?
    let observedProperty: ObservedProperty
}

struct LocalizedTitle: Codable {
    let en: String
}

struct Unit: Codable {
    let label: LocalizedTitle
    let symbol: Symbol
}

struct Symbol: Codable {
    let value: String
    let type: String
}

struct ObservedProperty: Codable {
    let id: String?
    let label: LocalizedTitle
}

// MARK: - Ranges

struct RangeData: Codable {
    let type: String
    let dataType: String
    let axisNames: [String]
    let shape: [Int]
    let values: [Double?]
}

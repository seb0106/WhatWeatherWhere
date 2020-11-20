//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation

struct CurrentWeatherData: Codable{
    let coord: Coordination?
    let weather: [Weather]
    let base: String?
    let main: MainValues?
    let visibility: Int?
    let wind: Wind?
    let clouds: Cloud?
    let sys: Sys?
    let name: String?
    let cod: Int?
}

//
//  CovidData.swift
//  Covid
//
//  Created by Mac15 on 18/12/20.
//

import Foundation

struct CovidData: Codable{
    let country: String
    let cases: Int
    let deaths: Int
    let recovered: Int
    let todayCases: Int
    let todayDeaths: Int
    let todayRecovered: Int
    let countryInfo: CountryInfo
}

struct CountryInfo: Codable{
    let flag: String
}

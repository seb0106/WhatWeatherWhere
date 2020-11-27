//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit
class WeatherDetailViewController: UITableViewController{
    var weather: WeatherData?
    var weatherTitle = [
        "Location",
        "Destricption",
        "Temperature",
        "Max-temperature",
        "Min-temperature",
    ]
    var weatherData: [ String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if weather?.tempNow ?? 273.15 >= 234.15 {
            weather?.tempMin = round((weather?.tempMin ?? 273.15) - 273.15)
            weather?.tempMax = round((weather?.tempMax ?? 273.15) - 273.15)
            weather?.tempNow = round((weather?.tempNow ?? 273.15) - 273.15)
            
        }
        else if   weather?.tempNow ?? 0 <= -240{
            weather?.tempMin = round((weather?.tempMin ?? 273.15) + 273.15)
            weather?.tempMax = round((weather?.tempMax ?? 273.15) + 273.15)
            weather?.tempNow = round((weather?.tempNow ?? 273.15) + 273.15)
        }
        else {
            weather?.tempMin = weather?.tempMin ?? 0
            weather?.tempMax = weather?.tempMax ?? 0
            weather?.tempNow = weather?.tempNow ?? 0
        }
        weatherData.append(weather?.name ?? "")
        weatherData.append(weather?.descriptionOfWeather ?? "")
        weatherData.append((weather?.tempNow.description ?? "") + "℃")
        weatherData.append((weather?.tempMax.description ?? "") + "℃")
        weatherData.append((weather?.tempMin.description ?? "") + "℃")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomDetailCell
        cell.titleLabel.text = weatherTitle[indexPath.row]
        cell.valueLabel.text = weatherData[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherTitle.count
    }
    
    
    
}

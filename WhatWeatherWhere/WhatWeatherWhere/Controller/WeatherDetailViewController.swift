//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit
class WeatherDetailViewController: UITableViewController{
    var weather: WeatherData?
    var weatherTitle = [
        "Name",
        "Beschreibung",
        "Temperatur",
        "Max-Temperatur",
        "Mindest-Temperatur",
    ]
    var weatherData: [ String] = []
   override func viewDidLoad() {
        super.viewDidLoad()
    weather?.tempMin = weather?.tempMin ?? 0 - 273.15
    weather?.tempMax = weather?.tempMax ?? 0 - 273.15
    weather?.tempNow = weather?.tempNow ?? 0 - 273.15
    weatherData.append(weather?.name ?? "")
    weatherData.append(weather?.descriptionOfWeather ?? "")
    weatherData.append(weather?.tempNow.description ?? "")
    weatherData.append(weather?.tempMax.description ?? "")
    weatherData.append(weather?.tempMin.description ?? "")
    }
    
    func convertObjectToArray(){
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

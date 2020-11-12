//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation

class CurrentWeatherClient {
    //Temp Apikey
    struct Auth{
        static var apiKey = "182edae54e3e43662808b5d50103f4b4"
    }
    
    enum endpoint {
        static var base = "api.openweathermap.org/data/2.5/"
        case currentWeather(Double, Double)
        
        var stringValue: String{
            switch self{
            case .currentWeather(let lan, let lon):
                return endpoint.base + "weather?lat=\(lan)&lon=\(lon)&appid=" + Auth.apiKey
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskGETRequest<ResponseType: Codable>(url: URL, _: ResponseType.Type, completion: @escaping(ResponseType?, Error?)->Void)-> URLSessionDataTask{
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard let data = data else{
                DispatchQueue.main.async{
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch{
                print(error)
                //TODO: Error Handling
                let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) as? Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
            }
        }
        task.resume()
        return task
    }
    
    
   class func getCurrentWeather(lat: Double, lon: Double, completion: @escaping(CurrentWeatherData?,Error?)->Void){
    taskGETRequest(url: endpoint.currentWeather(lat, lon).url, CurrentWeatherData.self){
        response, error in
        if let response = response{
            completion(response, nil)
        }
        else{
            completion(nil, error)
            print(error)
        }
        
    }
    }
    
}

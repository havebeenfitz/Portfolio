//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChandgeCityDelegate {
    
    let WEATHER_URL = "https://api.darksky.net/forecast/"
    let API_KEY = "161e839fc001e6fdaccf2742c5dfe017/"
    var latLon = ""
    
    let locationManager = CLLocationManager()
    let weatherData = WeatherDataModel()

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    
    //MARK: - Networking
    
    func getWeatherData(latLon: String) {
        
        let url = WEATHER_URL + API_KEY + latLon
        
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess {
                
                print(response.value!)
                let weatherJson = JSON(response.value!)
                self.updateWeatherData(json: weatherJson)
                
            } else {
                
                print(response.result.error!)
                self.cityLabel.text = "No Connection"
                
            }
        }
    }

    //MARK: - JSON Parsing

    func updateWeatherData(json: JSON?) {
        
        if let json = json {
            weatherData.temperature = fahrenheitToCelcius(json["currently"]["temperature"].doubleValue)
            weatherData.weatherIconName = json["currently"]["icon"].stringValue
            let location = CLLocation(latitude: json["latitude"].doubleValue, longitude: json["longitude"].doubleValue)
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                
                if let city = placemark {
                    self.weatherData.city = city.last?.locality
                    
                } else if let error = error {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.updateUIWithWeatherData()
                }
            }
           
        }
    
    }

    //MARK: - UI Updates
 
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherData.city
        temperatureLabel.text = "\(weatherData.temperature)°"
        weatherIcon.image = UIImage(named: weatherData.weatherIconName!)
    
    }
    
    //MARK: - Location Manager Delegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy > 0 {
                
                locationManager.stopUpdatingLocation()
                
                let lat = String(location.coordinate.latitude)
                let lon = String(location.coordinate.longitude)
                latLon = lat + "," + lon
                getWeatherData(latLon: latLon)
                
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    
    func userTypedANewCity(city: String) {
        
        //weatherData.city = city
        CLGeocoder().geocodeAddressString(city, completionHandler: { (placemark, error) in
            
            guard let placemark = placemark  else { return }
            //guard error != nil else { return }
            
            let latitude = placemark.first!.location!.coordinate.latitude
            let longitude = placemark.first!.location!.coordinate.longitude
            let latLon = "\(String(describing: latitude)),\(String(describing: longitude))"
            
            self.getWeatherData(latLon: latLon)
        })
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
            
        }
        
    }
    
}



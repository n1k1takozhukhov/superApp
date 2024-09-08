import Foundation
import CoreLocation

final class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    //MARK: Variables
    private let locationManager = CLLocationManager()
    private var latitude: Double?
    private var longitude: Double?
    var condition: Bool = true {
        didSet {
            updateImageName()
        }
    }
    private(set) var imageName: String = "square.and.arrow.up.on.square"
    private var weatherAPIKey = "b54cce5494a443e9aa670214240809"
    var onWeatherUpdate: ((String, String) -> Void)?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    //MARK: Selectors
    func toggleCondition() {
        condition.toggle()
    }
    
    private func updateImageName() {
        imageName = condition ? "square.and.arrow.up.on.square" : "square.and.arrow.up.on.square.fill"
    }
    
    //MARK: Location
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        fetchWeatherData()
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: Weather API
    private func fetchWeatherData() {
        guard let lat = latitude, let lon = longitude else { return }
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(weatherAPIKey)&q=\(lat),\(lon)&aqi=no"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let location = json["location"] as? [String: Any],
                   let city = location["name"] as? String,
                   let current = json["current"] as? [String: Any],
                   let tempC = current["temp_c"] as? Double {
                    DispatchQueue.main.async {
                        self.onWeatherUpdate?(city, "\(tempC)°C")
                    }
                }
            } catch {
                print("Error decoding JSON:", error)
            }
        }
        task.resume()
    }
}

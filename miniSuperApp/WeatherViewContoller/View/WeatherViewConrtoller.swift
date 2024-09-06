import UIKit
import CoreLocation
import WeatherKit

final class WeatherViewController: UIViewController {
    //MARK: Variables
    private let viewModel = WeatherViewModel()
    private let locationManager = CLLocationManager()
    
    //MARK: UI Components
    private let titleLabel = makeTitle()
    private let switchFrameSize = makeImage()
    private let weatherCityTitle = makeTitle()
    private let weatherTitle = makeTitle()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setupConstrain()
        updateUI()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSheetPresentation()
    }
    
    //MARK: Selectors
    private func updateUI() {
        view.backgroundColor = .systemBackground
        switchFrameSize.image = UIImage(systemName: viewModel.imageName)
        updateSheetPresentation()

        titleLabel.text = "WeatherViewController ☁️"
        titleLabel.font = .systemFont(ofSize: 28)
        
        weatherCityTitle.text = "Current city - Loading..."
        weatherCityTitle.font = .systemFont(ofSize: 24)
        
        weatherTitle.text = "Current temperature - Loading..."
        weatherTitle.font = .systemFont(ofSize: 18)
    }
}

//MARK: - CoreLocation Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        getWeather(latitude: latitude, longitude: longitude)
        getCityName(from: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}

//MARK: - WeatherKit API
@available(iOS 16.0, *)
extension WeatherViewController {
    func getWeather(latitude: Double, longitude: Double) {
        let weatherService = WeatherService()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        Task {
            do {
                let weather = try await weatherService.weather(for: location)
                let currentWeather = weather.currentWeather
                DispatchQueue.main.async {
                    self.weatherTitle.text = "Current temperature - \(currentWeather.temperature)°"
                }
            } catch {
                print("Error getting weather: \(error.localizedDescription)")
            }
        }
    }
    
    func getCityName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error getting city name: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown city"
                
                // Обновляем название города
                DispatchQueue.main.async {
                    self.weatherCityTitle.text = "Current city - \(city)"
                }
            }
        }
    }
}

//MARK: - Screen Rotation
extension WeatherViewController {
    private func updateSheetPresentation() {
        guard let sheetPresentation = self.presentationController as? UISheetPresentationController else { return }
        
        if viewModel.condition {
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
            sheetPresentation.detents = [.medium()]
        } else {
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            sheetPresentation.detents = [.large()]
        }
        sheetPresentation.prefersGrabberVisible = true
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        switchFrameSize.isUserInteractionEnabled = true
        switchFrameSize.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        viewModel.toggleCondition()
        updateUI()
    }
}

//MARK: - Setup Constrain
private extension WeatherViewController {
    func setupConstrain() {
        setupSwitchFrameSize()
        setupConstrains()
        setupWeatherCityTitle()
        setupWeatherTitle()
    }
    
    func setupSwitchFrameSize() {
        view.addSubview(switchFrameSize)
        
        NSLayoutConstraint.activate([
            switchFrameSize.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            switchFrameSize.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func setupConstrains() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    func setupWeatherCityTitle() {
        view.addSubview(weatherCityTitle)
        
        NSLayoutConstraint.activate([
            weatherCityTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            weatherCityTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupWeatherTitle() {
        view.addSubview(weatherTitle)
        
        NSLayoutConstraint.activate([
            weatherTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherTitle.topAnchor.constraint(equalTo: weatherCityTitle.bottomAnchor, constant: 20)
        ])
    }
}

//MARK: - Make UI
private extension WeatherViewController {
    static func makeTitle() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .label
        return view
    }
    
    static func makeImage() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.contentMode = .scaleAspectFit
        return view
    }
}

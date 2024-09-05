import UIKit
import CoreLocation

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

        titleLabel.text = "WeatherViewConrtoller ☁️"
        titleLabel.font = .systemFont(ofSize: 28)
        
        weatherCityTitle.text = "Current city - ☠️"
        weatherCityTitle.font = .systemFont(ofSize: 24)
        
        weatherTitle.text = "Сurrent temperature - 🥶"
        weatherTitle.font = .systemFont(ofSize: 18)
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

import UIKit

final class WeatherViewController: UIViewController {
    //MARK: Variables
    private let viewModel = WeatherViewModel()
    
    //MARK: UI Components
    private let titleLabel = makeTitle()
    private let switchFrameSize = makeImage()
    private let weatherCityTitle = makeTitle()
    private let weatherTitle = makeTitle()
    private lazy var dismissButton = makeDismissButton()
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrain()
        updateUI()
        updateScreed()
        setupTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSheetPresentation()
    }
    
    //MARK: Selectors
    private func updateScreed() {
        switchFrameSize.image = UIImage(systemName: viewModel.imageName)
        updateSheetPresentation()
    }
    
    private func updateUI() {
        view.backgroundColor = .systemBackground
        updateSheetPresentation()

        titleLabel.text = "WeatherView ☁️"
        titleLabel.font = .systemFont(ofSize: 28)
        
        weatherCityTitle.text = "Current city - loading..."
        weatherCityTitle.font = .systemFont(ofSize: 18)
        
        weatherTitle.text = "Current temperature - loading..."
        weatherTitle.font = .systemFont(ofSize: 18)
        
        viewModel.onWeatherUpdate = { [weak self] city, temperature in
            guard let self = self else { return }
            self.weatherCityTitle.text = "Current city - \(city)"
            self.weatherTitle.text = "\(temperature)"
            self.weatherTitle.font = .systemFont(ofSize: 56)
        }
        
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.addAction(UIAction { [ weak self] _ in
            guard let self = self else { return }
            self.didTapDismissButton()
        }, for: .touchUpInside)
    }
    
    private func didTapDismissButton() {
        self.dismiss(animated: true)
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
        updateScreed()
    }
}

//MARK: - Setup Constrain
private extension WeatherViewController {
    func setupConstrain() {
        setupDismissButton()
        setupSwitchFrameSize()
        setupConstrains()
        setupWeatherCityTitle()
        setupWeatherTitle()
    }
    
    func setupDismissButton() {
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func setupSwitchFrameSize() {
        view.addSubview(switchFrameSize)
        
        NSLayoutConstraint.activate([
            switchFrameSize.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            switchFrameSize.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor)
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
            weatherCityTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            weatherCityTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupWeatherTitle() {
        view.addSubview(weatherTitle)
        
        NSLayoutConstraint.activate([
            weatherTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherTitle.topAnchor.constraint(equalTo: weatherCityTitle.bottomAnchor, constant: 60)
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
    
    func makeDismissButton() -> UIButton {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

import UIKit
import CoreLocation

final class CrosswordViewController: UIViewController {
    //MARK: Variables
    private let viewModel = CrosswordViewModel()
    private let locationManager = CLLocationManager()
    
    //MARK: UI Components
    private let titleLabel = makeLabel()
    private let switchFrameSize = makeImage()
    private let crosswordStackView = makeStackView()
    private let searchQuestions = makeLabel()
    private let resultLabel = makeLabel()
    private lazy var checkButton = makeCheckButton()

    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrain()
        updateUI()
        setupTapGesture()
        viewModel.initializeCrosswordCells()
        createCrosswordGrid()
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
        
        titleLabel.text = "CrosswordViewController ☁️"
        titleLabel.font = .systemFont(ofSize: 28)
        
        let getSearchQuestions = viewModel.crosswordData.enumerated().map { index, item in
                return "\(index + 1). \(item.question)"
            }.joined(separator: "\n")
        searchQuestions.text = getSearchQuestions
        searchQuestions.textAlignment = .left
        resultLabel.font = .systemFont(ofSize: 16)
        
        checkButton.setTitle("Проверить ответы", for: .normal)
        checkButton.addAction(UIAction { [ weak self] _ in
            guard let self = self else { return }
            self.checkButtonTapped()
        }, for: .touchUpInside)
    }
    
    private func checkButtonTapped() {
        viewModel.verifyAnswers()
        resultLabel.text = viewModel.resultMessage
        resultLabel.textColor = viewModel.resultMessage == "Кроссворд заполнен правильно!" ? .green : .red
    }
    
    private func createCrosswordGrid() {
        for i in 0..<viewModel.crosswordCells.count {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 2
            horizontalStackView.distribution = .fill
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            crosswordStackView.addArrangedSubview(horizontalStackView)
            
            for j in 0..<viewModel.crosswordCells[i].count {
                let cell = viewModel.crosswordCells[i][j]
                
                let textField = UITextField()
                textField.borderStyle = .line
                textField.textAlignment = .center
                textField.tag = i * 100 + j
                
                if let questionNumber = cell.questionNumber {
                    let label = UILabel()
                    label.text = "\(questionNumber)"
                    label.textColor = .gray
                    label.font = .systemFont(ofSize: 10)
                    textField.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        label.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 2),
                        label.topAnchor.constraint(equalTo: textField.topAnchor, constant: 2)
                    ])
                }
                
                textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
                textField.translatesAutoresizingMaskIntoConstraints = false
                horizontalStackView.addArrangedSubview(textField)
                
                NSLayoutConstraint.activate([
                    textField.widthAnchor.constraint(equalToConstant: 30),
                    textField.heightAnchor.constraint(equalToConstant: 30)
                ])
            }
            
            let spacerView = UIView()
            spacerView.translatesAutoresizingMaskIntoConstraints = false
            horizontalStackView.addArrangedSubview(spacerView)
            
            NSLayoutConstraint.activate([
                spacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
                spacerView.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
    
    @objc private func textFieldChanged(_ textField: UITextField) {
        let row = textField.tag / 100
        let col = textField.tag % 100
        if let text = textField.text {
            if text.count <= 1 {
                viewModel.crosswordCells[row][col].textField = text
            } else if text.count > 1 {
                let newText = String(text.prefix(1))
                textField.text = newText
                viewModel.crosswordCells[row][col].textField = newText
            }
        }
    }
}


//MARK: - Screen Rotation
extension CrosswordViewController {
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
private extension CrosswordViewController {
    func setupConstrain() {
        setupSwitchFrameSize()
        setupConstrains()
        setupCrosswordStackView()
        setupSearchQuestions()
        setupCheckButton()
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
    
    func setupCrosswordStackView() {
        view.addSubview(crosswordStackView)
        
        NSLayoutConstraint.activate([
            crosswordStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            crosswordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            crosswordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupSearchQuestions() {
        view.addSubview(searchQuestions)
        
        NSLayoutConstraint.activate([
            searchQuestions.topAnchor.constraint(equalTo: crosswordStackView.bottomAnchor, constant: 20),
            searchQuestions.leadingAnchor.constraint(equalTo: crosswordStackView.leadingAnchor),
            searchQuestions.trailingAnchor.constraint(equalTo: crosswordStackView.trailingAnchor),
        ])
    }
    
    func setupCheckButton() {
        view.addSubview(checkButton)
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.topAnchor.constraint(equalTo: searchQuestions.bottomAnchor, constant: 20),
            checkButton.widthAnchor.constraint(equalToConstant: 200),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}


//MARK: - Make UI
private extension CrosswordViewController {
    static func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .label
        view.numberOfLines = 0
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
    
    static func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }
    
    func makeCheckButton() -> UIButton {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 8
        return view
    }
}

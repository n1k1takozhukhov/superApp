import UIKit
import CoreLocation

final class CrosswordViewController: UIViewController {
    //MARK: Variables
    private let viewModel = CrosswordViewModel()
    private let locationManager = CLLocationManager()
    
    //MARK: UI Components
    private let scrollView = makeScrollView()
    private let contentView = UIView()
    private let titleLabel = makeLabel()
    private let switchFrameSize = makeImage()
    private let crosswordStackView = makeStackView()
    private let searchQuestions = makeLabel()
    private let resultLabel = makeLabel()
    private lazy var checkButton = makeCheckButton()
    private lazy var dismissButton = makeDismissButton()

    
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
        titleLabel.text = "Crossword game Ⳃ"
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
            self.didTapCheckButtonTapped()
        }, for: .touchUpInside)
        
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.addAction(UIAction { [ weak self] _ in
            guard let self = self else { return }
            self.didTapDismissButton()
        }, for: .touchUpInside)
    }
    
    private func didTapCheckButtonTapped() {
        viewModel.verifyAnswers()
        resultLabel.text = viewModel.resultMessage
        resultLabel.textColor = viewModel.resultMessage == "Кроссворд заполнен правильно!" ? .green : .red
    }
    
    private func didTapDismissButton() {
        self.dismiss(animated: true)
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
        
        if let text = textField.text, text.count > 0 {
            let newText = String(text.prefix(1).uppercased())
            textField.text = newText
            viewModel.crosswordCells[row][col].textField = newText
            moveToNextTextField(currentRow: row, currentCol: col)
        }
    }

    private func moveToNextTextField(currentRow: Int, currentCol: Int) {
        let nextCol = currentCol + 1
        var nextRow = currentRow
        
        if nextCol >= viewModel.crosswordCells[currentRow].count {
            nextRow += 1
            if nextRow < viewModel.crosswordCells.count {
                let nextTextField = crosswordStackView.viewWithTag(nextRow * 100) as? UITextField
                nextTextField?.becomeFirstResponder()
            }
        } else {
            let nextTextField = crosswordStackView.viewWithTag(currentRow * 100 + nextCol) as? UITextField
            nextTextField?.becomeFirstResponder()
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
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        setupDismissButton()
        setupSwitchFrameSize()
        setupTitleLabel()
        setupCrosswordStackView()
        setupSearchQuestions()
        setupCheckButton()
    }
    
    func setupDismissButton() {
        contentView.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 30),
            dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
    
    func setupSwitchFrameSize() {
        contentView.addSubview(switchFrameSize)
        
        NSLayoutConstraint.activate([
            switchFrameSize.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            switchFrameSize.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    func setupCrosswordStackView() {
        contentView.addSubview(crosswordStackView)
        
        NSLayoutConstraint.activate([
            crosswordStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            crosswordStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            crosswordStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    func setupSearchQuestions() {
        contentView.addSubview(searchQuestions)
        
        NSLayoutConstraint.activate([
            searchQuestions.topAnchor.constraint(equalTo: crosswordStackView.bottomAnchor, constant: 20),
            searchQuestions.leadingAnchor.constraint(equalTo: crosswordStackView.leadingAnchor),
            searchQuestions.trailingAnchor.constraint(equalTo: crosswordStackView.trailingAnchor),
        ])
    }
    
    func setupCheckButton() {
        contentView.addSubview(checkButton)
        contentView.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            checkButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkButton.topAnchor.constraint(equalTo: searchQuestions.bottomAnchor, constant: 20),
            checkButton.widthAnchor.constraint(equalToConstant: 200),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}


//MARK: - Make UI
private extension CrosswordViewController {
    static func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.isScrollEnabled = true
        return view
    }

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
    
    func makeDismissButton() -> UIButton {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

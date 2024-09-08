import UIKit
import CoreLocation

final class TicTacToeViewController: UIViewController {
    //MARK: Variables
    private let viewModel = TicTacToeViewModel()
    private var gridViews: [[UIImageView]] = []
    
    //MARK: UI Components
    private let titleLabel = makeLabel()
    private let switchFrameSize = makeImageView()
    private let statsLabel = makeLabel()
    private lazy var dismissButton = makeDismissButton()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrain()
        updateUI()
        setupTapGesture()
        setupGrid()
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
        
        titleLabel.text = "TicTacToeViewController"
        titleLabel.font = .systemFont(ofSize: 28)
        
        statsLabel.text = "Игры: \(viewModel.totalGameCounter) | O: \(viewModel.oWinCounter) | X: \(viewModel.xWinCounter)"
        
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.addAction(UIAction { [ weak self] _ in
            guard let self = self else { return }
            self.didTapDismissButton()
        }, for: .touchUpInside)
    }
    
    private func didTapDismissButton() {
        dismiss(animated: true)
    }
    
    private func setupGrid() {
        let gridSize: CGFloat = 300
        let cellSize = gridSize / 3
        let gridContainer = UIView()
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridContainer)
        
        NSLayoutConstraint.activate([
            gridContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridContainer.widthAnchor.constraint(equalToConstant: gridSize),
            gridContainer.heightAnchor.constraint(equalToConstant: gridSize)
        ])
        
        for row in 0..<3 {
            var rowViews: [UIImageView] = []
            for col in 0..<3 {
                let cell = UIImageView(image: UIImage(systemName: "square.dotted"))
                cell.contentMode = .scaleAspectFit
                cell.isUserInteractionEnabled = true
                cell.tag = row * 3 + col
                cell.translatesAutoresizingMaskIntoConstraints = false
                gridContainer.addSubview(cell)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
                cell.addGestureRecognizer(tapGesture)
                
                gridContainer.addSubview(cell)
                rowViews.append(cell)
                
                NSLayoutConstraint.activate([
                    cell.widthAnchor.constraint(equalToConstant: cellSize),
                    cell.heightAnchor.constraint(equalToConstant: cellSize),
                    cell.leadingAnchor.constraint(equalTo: gridContainer.leadingAnchor, constant: CGFloat(col) * cellSize),
                    cell.topAnchor.constraint(equalTo: gridContainer.topAnchor, constant: CGFloat(row) * cellSize)
                ])
            }
            gridViews.append(rowViews)
        }
    }
    
    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UIImageView else { return }
        let row = cell.tag / 3
        let col = cell.tag % 3
        
        if viewModel.makeMove(at: row, col: col) {
            let symbol = viewModel.currentPlayer == "X" ? "o.circle" : "xmark"
            cell.image = UIImage(systemName: symbol)
            
            if let winner = viewModel.checkWhoWin() {
                let message = winner == "X" ? "Крестики победили!" : "Нолики выиграли!"
                displayAlert(message: message)
            } else if viewModel.isDraw() {
                displayAlert(message: "Ничья!")
            }
        }
    }
    
    private func displayAlert(message: String) {
        let alert = UIAlertController(title: "Итог", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Новая игра", style: .default) { [weak self] _ in
            self?.viewModel.handleResult()
            self?.viewModel.resetGame()
            self?.resetGrid()
            self?.updateUI()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func resetGrid() {
        for row in gridViews {
            for cell in row {
                cell.image = UIImage(systemName: "square.dotted")
            }
        }
    }
}


//MARK: - Screen Rotation
extension TicTacToeViewController {
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
private extension TicTacToeViewController {
    func setupConstrain() {
        setupDismissButton()
        setupSwitchFrameSize()
        setupConstrains()
        setupStatsLabel()
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
    
    private func setupStatsLabel() {
        view.addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            statsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsLabel.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor)
        ])
    }
}


//MARK: - Make UI
private extension TicTacToeViewController {
    static func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .label
        return view
    }
    
    static func makeImageView() -> UIImageView {
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

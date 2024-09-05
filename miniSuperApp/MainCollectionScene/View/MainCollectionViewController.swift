import UIKit

final class MainCollectionViewController: UIViewController {
    //MARK: Variables
    private let viewModel: MainCollectionViewModel
    
    //MARK: UI Components
    private let titleLabel = makeTitle()
    private lazy var collectionView = makeCollectionView()
    
    //MARK: LifeCycle
    init(viewModel: MainCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrain()
        updateUI()
        updateCollectionView()
    }
    
    //MARK: Selectors
    private func updateUI() {
        view.backgroundColor = .systemBackground
        titleLabel.text = "mini Applications"
    }
    
    private func updateCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)

    }
}

//MARK: - UICollectionViewDataSource
extension MainCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellCounter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(at: indexPath.row)
        cell.configure(with: cellViewModel)
        return cell
    }
}


//MARK: - UICollectionViewDelegate
extension MainCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = viewModel.cellViewModel(at: indexPath.row)
        let viewController: UIViewController

        switch cellViewModel.model.type {
        case .weather:
            viewController = WeatherViewController()
        case .crossword:
            viewController = CrosswordViewController()
        case .ticTacToe:
            viewController = TicTacToeViewController()
        }

        viewController.modalPresentationStyle = .pageSheet // для 1/2 экрана
        present(viewController, animated: true, completion: nil)
    }
}


//MARK: - Setup Constrain
private extension MainCollectionViewController {
    func setupConstrain() {
        setupTitleLabel()
        setupCollectionView()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - Make UI
private extension MainCollectionViewController {
    static func makeTitle() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 32)
        view.textColor = .label
        return view
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemSize = UIScreen.main.bounds.height / 8
        layout.itemSize = CGSize(width: view.frame.width, height: itemSize)
        return UICollectionView(
            frame: .zero, collectionViewLayout: layout)
    }
}

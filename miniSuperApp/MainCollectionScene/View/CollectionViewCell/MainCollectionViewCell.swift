import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    //MARK: Variables
    static let identifier = "MainCollectionViewCell"
    private var viewModel: MainCollectionViewCellViewModel?
    
    //MARK: UI Components
    private let titleLabel = makeTitle()
    
    //MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstrain()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    func configure(with viewModel: MainCollectionViewCellViewModel) {
        self.viewModel = viewModel
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = viewModel?.model.text
    }
    
}

//MARK: - Setup Constrain
private extension MainCollectionViewCell {
    func setupConstrain() {
        setupConstrains()
    }
    
    func setupConstrains() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

//MARK: - Make UI
private extension MainCollectionViewCell {
    static func makeTitle() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .black
        return view
    }
}

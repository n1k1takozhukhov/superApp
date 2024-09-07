import Foundation

final class MainCollectionViewModel {
    private(set) var models: [AppDataModel]
    
    init(models: [AppDataModel]) {
        self.models = Array(repeating: models, count: 15).flatMap { $0 }
        shuffleModels()
    }
    
    var cellCounter: Int {
        return models.count
    }
    
    func cellViewModel(at index: Int) -> MainCollectionViewCellViewModel {
        return MainCollectionViewCellViewModel(model: models[index])
    }
    
    func shuffleModels() {
        models.shuffle()
    }
}

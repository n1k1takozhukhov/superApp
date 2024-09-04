import Foundation

final class MainCollectionViewModel {
    let models: [AppDataModel]
    
    init(models: [AppDataModel]) {
        self.models = models
    }
    
    var cellCounter: Int {
        return AppDataModel.sampleAppDataModel.count
    }
    
    func cellViewModel(at index: Int) -> MainCollectionViewCellViewModel {
        return MainCollectionViewCellViewModel(model: models[index])
    }
}

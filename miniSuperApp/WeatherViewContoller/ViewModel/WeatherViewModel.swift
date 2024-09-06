final class WeatherViewModel {
    //MARK: Variables
    var condition: Bool = true {
        didSet {
            updateImageName()
        }
    }
    private(set) var imageName: String = "square.and.arrow.up.on.square"
    
    //MARK: Selectors
    func toggleCondition() {
        condition.toggle()
        print("Toggle \(condition)")
    }
    
    private func updateImageName() {
        imageName = condition ? "square.and.arrow.up.on.square" : "square.and.arrow.up.on.square.fill"
    }
}

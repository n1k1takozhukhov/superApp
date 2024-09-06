import UIKit

final class CrosswordViewModel {
    //MARK: Variables
    var condition: Bool = true {
        didSet {
            updateImageName()
        }
    }
    private(set) var imageName: String = "square.and.arrow.up.on.square"
    let crosswordData: [CrosswordItem] = [
        CrosswordItem(question: "Имя кандидата", answer: "НИКИТА"),
        CrosswordItem(question: "Название компании в которую все хотят", answer: "ВКОНТАКТЕ"),
        CrosswordItem(question: "Что оценивает это приложение", answer: "ЗНАНИЯ")
    ]
    var crosswordCells: [[CrosswordCell]] = []
    var resultMessage: String = ""
    
    //MARK: Selectors
    func toggleCondition() {
        condition.toggle()
    }
    
    private func updateImageName() {
        imageName = condition ? "square.and.arrow.up.on.square" : "square.and.arrow.up.on.square.fill"
    }
    
    func getTitle() -> String {
        return "WeatherViewConrtoller"
    }
    
    func initializeCrosswordCells() {
        var cells: [[CrosswordCell]] = []
        
        for i in 0..<crosswordData.count {
            let word = crosswordData[i].answer
            var row: [CrosswordCell] = []
            
            for j in 0..<word.count {
                row.append(CrosswordCell(questionNumber: j == 0 ? i + 1 : nil, textField: ""))
            }
            cells.append(row)
        }
        self.crosswordCells = cells
    }
    
    func checkAnswers() -> Bool {
        for i in 0..<crosswordData.count {
            let word = crosswordData[i].answer
            for j in 0..<word.count {
                let cell = crosswordCells[i][j]
                let answerChar = String(word[word.index(word.startIndex, offsetBy: j)])
                if cell.textField.uppercased() != answerChar {
                    return false
                }
            }
        }
        return true
    }
    
    func verifyAnswers() {
        if checkAnswers() {
            resultMessage = "Кроссворд заполнен правильно!"
        } else {
            resultMessage = "В кроссворде ошибки, проверьте и попробуйте снова"
        }
    }
}

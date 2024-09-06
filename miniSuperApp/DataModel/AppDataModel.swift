import Foundation

struct AppDataModel {
    let text: String
    let type: MiniAppType
    
    enum MiniAppType {
        case weather
        case crossword
        case ticTacToe
    }
}

struct CrosswordItem {
    let question: String
    let answer: String
}

struct CrosswordCell {
    var questionNumber: Int?
    var textField: String
}


#if DEBUG
extension AppDataModel {
    static var sampleAppDataModel: [AppDataModel] = [
        AppDataModel(text: "Weather", type: .weather),
        AppDataModel(text: "Crossword", type: .crossword),
        AppDataModel(text: "Tic Tac Toe", type: .ticTacToe)
    ]
}
#endif

import Foundation

struct AppDataModel {
    let text: String
    let type: MiniAppType
}


enum MiniAppType {
    case weather
    case crossword
    case ticTacToe
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

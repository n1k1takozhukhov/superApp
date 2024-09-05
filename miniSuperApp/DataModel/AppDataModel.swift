import Foundation

struct AppDataModel {
    let text: String
}

#if DEBUG
extension AppDataModel {
    static var sampleAppDataModel: [AppDataModel] = [
        AppDataModel(text: "text1"),
        AppDataModel(text: "text2"),
        AppDataModel(text: "text3"),
        AppDataModel(text: "text4")
    ]
}
#endif

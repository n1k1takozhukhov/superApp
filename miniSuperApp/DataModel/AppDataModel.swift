import Foundation

struct AppDataModel {
    let text: String
}

#if DEBUG
extension AppDataModel {
    static var sampleAppDataModel: [AppDataModel] = [
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1"),
        AppDataModel(text: "text1")
    ]
}
#endif

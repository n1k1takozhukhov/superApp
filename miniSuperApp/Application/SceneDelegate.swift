import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var dataModel: [AppDataModel] = AppDataModel.sampleAppDataModel
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewModel = MainCollectionViewModel(models: dataModel)
        window?.rootViewController = UINavigationController(rootViewController: MainCollectionViewController(viewModel: viewModel))
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {    }
    
    func sceneWillResignActive(_ scene: UIScene) {    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {    }
}

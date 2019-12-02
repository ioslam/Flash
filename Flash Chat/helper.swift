
import UIKit
class helper: NSObject {
    
   class func restartApp() {
        guard let Window = UIApplication.shared.keyWindow  else {return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if getApiToken() == nil {
            vc = sb.instantiateInitialViewController()!
        } else {
            vc = sb.instantiateViewController(withIdentifier: "ChatVC")
    }
    Window.rootViewController = vc
    UIView.transition(with: Window, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }
    
    class func getApiToken() -> String? {
        let user_Defaults = UserDefaults.standard
        return user_Defaults.object(forKey: "access") as? String
    }
    class func setApiToken(api_token: String) {
        let user_Defaults = UserDefaults.standard
        user_Defaults.setValue(api_token, forKey: "access")
        user_Defaults.synchronize()
        restartApp()
    }
}

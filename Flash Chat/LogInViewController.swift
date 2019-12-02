//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        guard let email = emailTextfield.text, !email.isEmpty else {return}
              guard let password = passwordTextfield.text, !password.isEmpty else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){
            authResult, error in
            if let user = authResult?.user{
                helper.setApiToken(api_token: user.uid)
                SVProgressHUD.show()
            } else {
                SVProgressHUD.showError(withStatus: "nooo")
                return
            }
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
    
}

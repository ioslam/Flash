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
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!){
            authResult, error in
            guard let user = authResult?.user, error == nil
                else {
                return print(error!)
            }
            print("\(user.email!) signed")
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
    
}
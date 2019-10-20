
import UIKit
import Firebase
import FirebaseDatabase

class ChatViewController: UIViewController {
   
    
    lazy var refresher: UIRefreshControl = {
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return ref
    }()
    // Declare instance variables here
    var messagesArray: [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveMessages()
        self.messageTableView.addSubview(self.refresher)
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.dataSource = self

        if messageTextfield.text! == "" {
            sendButton.isEnabled = false
        }
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell",bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        
        messageTableView.separatorStyle = .none
        messageTableView.reloadData()
    }

    
    //MARK: - TableView DataSource Methods
    
    
    @objc func refresh(){
        self.refresher.endRefreshing()
        self.messagesArray.removeAll()
        self.retrieveMessages()
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
        }
        
    }
    
    //TODO: - Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
      func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    //MARK:- TextField Delegate Methods
    
    

    //TODO:- Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations:{
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    //TODO: - Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
                   self.heightConstraint.constant = 55
                   self.view.layoutIfNeeded()
               }
    }
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        tableViewTapped()
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextfield.text!]
        
            messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, ref) in
                
                if error != nil{
                    print(error!)
            } else {
                print("success sent")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
                self.sendButton.isEnabled = false
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages(){
       
            let messageDB = Database.database().reference().child("Messages")
            messageDB.observe(.childAdded) {  (snapshot) in
                                
//            let snapData = snapshot.value as! Dictionary<String,String>
            guard let snapData = snapshot.value as? [String:String] else {return}

            let  text = snapData["MessageBody"]!
            let sender = snapData["Sender"]!
            let message = Message()
            message.messageBody = text
            message.messageSender = sender
            
            self.messagesArray.append(message)
               
            self.configureTableView()
            self.messageTableView.reloadData()
                
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
//TODO: Log out the user and send them back to WelcomeViewController
         do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch  {
            print("unx err")
        }
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (messageTextfield.text! as NSString).replacingCharacters(in: range, with: string)
        if text == "" {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled =  true
        }
        return true
    }
}

extension ChatViewController: UITableViewDataSource {
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messagesArray[indexPath.row].messageBody
        cell.senderUsername.text = messagesArray[indexPath.row].messageSender
        cell.avatarImageView.image = UIImage(named: "egg")
       
        //Message We Sent
        if  cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            cell.avatarImageView.backgroundColor = UIColor.darkGray
            cell.messageBackground.backgroundColor = UIColor.darkGray
            
        } else {
            
            cell.avatarImageView.backgroundColor = UIColor.orange
            cell.messageBackground.backgroundColor = UIColor.orange
        }
        return cell
    }
    
}


//
//  AddFriendController.swift
//  hang
//
//  Created by Nolan Canady on 4/18/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase

class AddFriendController: UIViewController,UITextFieldDelegate {

    //this is the screen for adding in new friends to your friends list
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logolarge")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    //creates container view for inputs
    let inputsContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
        
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Friend Code"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        button.setTitle("Add Friend", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 26
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Add Status", "Add Friend"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor(red:0.10, green:0.87, blue:0.19, alpha:1.00)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    //right here changes what happens when the button is clicked based off of the segemented index
    @objc func handleLoginRegister() {
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin() //add status
        } else {
            handleRegister() //add friend
        }
        
    }
    
    //var didTheRegister = 0
    
    @objc func handleRegister() {
        //if(didTheRegister == 0){
        print("called myself")
        guard let friendCode = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        //need to add way to make sure that friend isn't already added
        
        
        //if the button has been pressed to add a new friends, reference the database and grab the users ordered by friends lsit
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "friendCode")
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] { //parse through all of the users in the database
                if let value = child.value as? NSDictionary {
                    var loopcount = 0 //because I'm an idiot, this code loops endlessly so why not see how many times it looped?
                    let user = Users()
                    let key = child.key //grab this persons uid
                    var friendNumFriends = Int(value["numFriends"] as? String ?? "0")! //grab how many friends they have
                    let userfriendCode = value["friendCode"] as? String ?? "N/A" //grab their friends code
                    let name = value["name"] as? String ?? "N/A" //grab their name
                   // print(userfriendCode)
                    //print(friendCode)
                    //print("HEY LOOK AT ME OH MY GOD I AM ONLY CALLED ONCE")
                    if(userfriendCode == friendCode){ //if their friend code is the one we entered
                        print("found the guy")
                        guard let currentGuy = Auth.auth().currentUser?.uid else{ //grab current users uid
                            return
                        }
                        var myNumFriends = 0 //remember how many friends I have
                        let currentQuery = rootRef.child("users").child(currentGuy) //reference and grab our current user
                        currentQuery.observe(.value){(snapshot) in //look through their entry to grab their number of friends
                            //for child in snapshot.children.allObjects as! [DataSnapshot]{
                                let value2 = snapshot.value as? NSDictionary
                                print(value2)
                                    print("got that value")
                                    myNumFriends = value2?["numFriends"] as? Int ?? 0
                                    //remember how many friends they have and print it (for some reason this doesn't always work)
                                    print("my friends after grabbed")
                                    print(myNumFriends)
                                
                            //}
                        }
                        
                        let ref = Database.database().reference(fromURL: "https://hang-8b734.firebaseio.com/")
                        let usersReference = ref.child("users").child(currentGuy).child("friendsList")
                        let newFriendsReference = ref.child("users").child(key).child("friendsList")
                        //increase each persons number of friends by 1 (because now we are friends)
                        friendNumFriends = friendNumFriends + 1
                        myNumFriends = myNumFriends + 1
                        print("friends Num")
                        print(friendNumFriends)
                        print("myNumFriends")
                        print(myNumFriends)
                        //convert those ints to strings to share with firebase
                        var sMyFriendsNum = "\(myNumFriends)"
                        var sFriendsFriendsNum = "\(friendNumFriends)"
                        //create vars that we can push into firebase (their friend number plus each others uid)
                        let friendValues = [sFriendsFriendsNum:currentGuy]
                        let userValues = [sMyFriendsNum:key]
                        //if(row == 0){
                        //    values = ["available":"false", "status":"unavailable"]
                        //}else{
                        //    values = ["available":"true", "status":status[row]]
                        //}
                        //availableUsers = [Users]()
                        //unavailableUsers = [Users]()
                        //ref.child("users").child(key).child("friendsList").setValue([currentGuy: ""])
                        //ref.child("users").child(currentGuy).child("friendsList").setValue([key:""])
                        print("past this")
                        //create and reference both person's location in the database
                        let userReference2 = ref.child("users").child(currentGuy)
                        let friendReference2 = ref.child("users").child(key)
                        //also remember to update each persons number of friends
                        let unumvals = ["numFriends":sMyFriendsNum]
                        print(unumvals)
                        let fnumvals = ["numFriends":sFriendsFriendsNum]
                        
                        //run through and update each othe data points and check for errors
                        usersReference.updateChildValues(userValues, withCompletionBlock: { (err, ref) in
                            
                            if err != nil {
                                print(err!)
                                return
                            }
                            
                            //self.dismiss(animated: true, completion: nil)
                            
                            print("updated that thing1")
                            
                        })
                        userReference2.updateChildValues(unumvals, withCompletionBlock: { (err, ref) in
                            
                            if err != nil {
                                print(err!)
                                return
                            }
                            
                            //self.dismiss(animated: true, completion: nil)
                            
                            print("updated that thing2")
                            
                        })
                        friendReference2.updateChildValues(fnumvals, withCompletionBlock: { (err, ref) in
                            
                            if err != nil {
                                print(err!)
                                return
                            }
                            
                            //self.dismiss(animated: true, completion: nil)
                            
                            print("updated that thing3")
                            
                        })
                        newFriendsReference.updateChildValues(friendValues, withCompletionBlock: { (err, ref) in
                            
                            if err != nil {
                                print(err!)
                                return
                            }
                            
                            //self.dismiss(animated: true, completion: nil)
                            
                            print("updated that thing4")
                            
                        })
                       
                        //let addFriendController = AddFriendController()
                        
                        //self.navigationController?.pushViewController(addFriendController, animated:true)
                        
                        //navigate away from this screen... but this just keeps looping anyway for some reason
                        //its probably really easy to break the loop using the IBOutlet stuff when we fully switch over to storyboard
                        let friendsController = FriendsController()
                        loopcount = loopcount + 1
                        print(loopcount)
                        self.navigationController?.pushViewController(friendsController, animated:true)
                        continue
                    }else{
                        print("its not me!")
                    }
                    //let key = child.key
                    //let availability = value["available"] as? String ?? "Name not found"
                    //let name = value["name"] as? String ?? "Name not found"
                    //let email = value["email"] as? String ?? "Email not found"
                    //let status = value["status"] as? String ?? "Status not found"
                    //user.name = name
                    //user.email = email
                    //user.availability = availability
                    //user.status = status
                    //self.users.append(user)
                    // print(user.name, user.availability)
                    
                    //if(user.availability == "true"){
                        //self.availableUsers.append(key)
                        //self.availableUsers.append(user)
                        //print("got that");
                    //}else{
                        //self.unavailableUsers.append(key)
                        //self.unavailableUsers.append(user)
                        
                    //}
                    // print("availableUsers --")
                    // print(self.availableUsers)
                    // print("unavailableUsers --")
                    
                    // print(self.unavailableUsers)
                }
            }
        }
       // }
        //didTheRegister = 1
    }
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of input container view
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of name field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //change height of email field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 0)
        emailTextFieldHeightAnchor?.isActive = true
        
        //change height of password field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 0)
        passwordTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view.backgroundColor = UIColor.white
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //adds subviews to main view
        view.addSubview(logoImageView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLogoImageView()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -16).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupLogoImageView() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -32).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 144).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var nameSeparatorViewHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //adds x, y, width, and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150);inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3);nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorViewHeightAnchor = nameSeparatorView.heightAnchor.constraint(equalToConstant:1)
        nameSeparatorViewHeightAnchor?.isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 16).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    //    @objc func keyboardWillShow(sender: NSNotification) {
    //        self.view.frame.origin.y -= 100
    //    }
    //    @objc func keyboardWillHide(sender: NSNotification) {
    //        self.view.frame.origin.y += 100
    //    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc  func keyboardWillChange(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if nameTextField.isFirstResponder || emailTextField.isFirstResponder || passwordTextField.isFirstResponder{
                self.view.frame.origin.y = -86
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }

}

//
//  ViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/15/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase

class
FriendsController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let cellid = "cellid"
    let sections = ["Available", "Unavailable"]
    var users = [Users]()
    var availableUsers = [Users]()
    var unavailableUsers = [Users]()

    let status = ["not","💩", "🌲", "❤️"]
    let statusText = ["available","shit", "tree", "heart"]
    let pickerView = UIPickerView()
    var rotationAngle: CGFloat!
    let width:CGFloat = 300
    let height:CGFloat = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //adds logout item to left of navigation controller
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"logout", style: .plain, target: self, action: #selector(handleLogout))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Status picker rotation
        rotationAngle = -90 * (.pi/180)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        pickerView.frame = CGRect(x: 0 - 150 , y: 0, width: view.frame.width + 300, height: 100)
        pickerView.center = self.view.center
        self.view.addSubview(pickerView)
        pickerView.backgroundColor = UIColor.white
        pickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        fetchUser()
    }
    
    func fetchUser() {
        DispatchQueue.main.async { self.tableView.reloadData() }

        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = Users()
                    //let key = child.key
                    let availability = value["available"] as? String ?? "Name not found"
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    let status = value["status"] as? String ?? "Status not found"
                    user.name = name
                    user.email = email
                    user.availability = availability
                    user.status = status
                    self.users.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                   // print(user.name, user.availability)
                    if(user.availability == "true"){
                        //self.availableUsers.append(key)
                        self.availableUsers.append(user)
                        print("got that");
                    }else{
                        //self.unavailableUsers.append(key)
                        self.unavailableUsers.append(user)

                    }
                    print("availableUsers --")
                    print(self.availableUsers)
                    print("unavailableUsers --")

                    print(self.unavailableUsers)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = self.sections[section]
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return availableUsers.count

        }
        return unavailableUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //hack for now
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let user = indexPath.section == 0 ? availableUsers[indexPath.row] : unavailableUsers[indexPath.row]
        cell.textLabel?.text = user.name
        if(user.availability == "true"){
        cell.detailTextLabel?.text = user.status
        }else{
            cell.detailTextLabel?.text = "unavailable"
        }
        return cell
    }
    
    class UserCell: UITableViewCell {
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkIfUserIsLogeedIn()
    }
    
    func checkIfUserIsLogeedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]  {
                    
                    self.navigationItem.title = dictionary["name"] as? String

                }
                
            }, withCancel: nil)
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        guard let currentGuy = Auth.auth().currentUser?.uid else{
            return
        }
        let ref = Database.database().reference(fromURL: "https://hang-8b734.firebaseio.com/")
        let usersReference = ref.child("users").child(currentGuy)
        var values = ["available":"", "status":""]
        if(row == 0){
            values = ["available":"false", "status":"unavailable"]
        }else{
            values = ["available":"true", "status":status[row]]
        }
        availableUsers = [Users]()
        unavailableUsers = [Users]()
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            print("updated that thing")
            
        })
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = status[row]
        let label2 = UILabel()
        label2.frame = CGRect(x:0, y:20, width:width, height:height)
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize:14)
        label2.text = statusText[row]
        view.addSubview(label2)
        view.addSubview(label)
        
        //View rotation
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        //presents login view
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
        perform(#selector(removeNavigationText), with: nil, afterDelay: 1)

    }
    
    @objc func removeNavigationText() {
        self.navigationItem.title = " "
    }


}


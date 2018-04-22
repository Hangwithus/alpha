//
//  ViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/15/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class
FriendsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    //fonts
    let semiBoldLabel = UIFont(name: "Nunito-SemiBold", size: UIFont.labelFontSize)
    let semiBoldLabelSmall = UIFont(name: "Nunito-SemiBold", size: UIFont.smallSystemFontSize)
    let boldLabel = UIFont(name: "Nunito-Bold", size: UIFont.labelFontSize)

    
    let cellid = "cellid"
    let sections = ["Available", "Unavailable"]
    var users = [Users]()
    var availableUsers = [Users]()
    var unavailableUsers = [Users]()
    var cellSelected = 0
    let tableView = UITableView()
    var pickerRowVariable = 0
    let pickerView = UIPickerView()
    var rotationAngle: CGFloat!
    let width:CGFloat = 300
    let height:CGFloat = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "navlogo")
        let logoImageView = UIImageView(image:logo)
        self.navigationItem.titleView = logoImageView
        self.navigationItem.title = "Friends"
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
        //adds logout item to left of navigation controller
        let settingsButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"settings"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = settingsButton
        let addButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"add"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = addButton

        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Status picker rotation
        rotationAngle = -90 * (.pi/180)
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        //pickerView.center = self.view.center
        self.view.addSubview(pickerView)
        pickerView.backgroundColor = UIColor.white
       //pickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
//        pickerView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalTo(self.view)
//            make.width.equalTo(self.view)
//        }
//
        fetchUser()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pickerView.frame = CGRect(x: 0 - 150 , y: view.frame.height-120, width: view.frame.width + 300, height: 120)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 120, 0)

    }
    
    func fetchUser() {
        DispatchQueue.main.async { self.tableView.reloadData() }

        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            self.availableUsers.removeAll()
            self.unavailableUsers.removeAll()
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
                    DispatchQueue.main.async { self.tableView.reloadData() }

                    print(self.unavailableUsers)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.00)
        let label = UILabel()
        label.text = self.sections[section]
        if #available(iOS 11.0, *) {
            label.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
        } else {
            // Fallback on earlier versions
        }
        label.adjustsFontForContentSizeCategory = true
        label.frame = CGRect(x: 12, y: 5, width: 100, height: 35)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return availableUsers.count

        }
        return unavailableUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //hack for now
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let user = indexPath.section == 0 ? availableUsers[indexPath.row] : unavailableUsers[indexPath.row]
       
      
        if #available(iOS 11.0, *) {
            cell.textLabel?.font = UIFontMetrics.default.scaledFont(for: semiBoldLabel!)
        } else {
            // Fallback on earlier versions
        }
        cell.textLabel?.adjustsFontForContentSizeCategory = true

        cell.textLabel?.text = user.name
        if(user.availability == "true"){
        cell.detailTextLabel?.text = user.status
        }else{
            cell.detailTextLabel?.text = "unavailable"
            if #available(iOS 11.0, *) {
                cell.detailTextLabel?.font = UIFontMetrics.default.scaledFont(for: semiBoldLabelSmall!)
            } else {
                // Fallback on earlier versions
            }
            cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
        }
        
        if indexPath.section == 0 && pickerRowVariable != 0 {
            cell.selectionStyle = .gray
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.selectionStyle = .none
            cell.accessoryType = .none

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0 || pickerRowVariable == 0 {
            return
        }
        
        let mapController = MapController()
        mapController.user = availableUsers[indexPath.row]
        self.navigationController?.pushViewController(mapController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkIfUserIsLogeedIn()
        if statusAdded == true {
            pickerView.reloadAllComponents()
            print("reloaded components")
        }
    }
    
    func checkIfUserIsLogeedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
//                if let dictionary = snapshot.value as? [String: AnyObject]  {
//
//                    //self.navigationItem.title = dictionary["name"] as? String
//
//                }
                
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
        pickerRowVariable = row
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
       
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
            print("updated that thing")
//            self.availableUsers = [Users]()
//            self.unavailableUsers = [Users]()
            
        })
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.textAlignment = .center
        if #available(iOS 11.0, *) {
            label.font = UIFontMetrics.default.scaledFont(for: boldLabel!)
        } else {
            // Fallback on earlier versions
        }
        label.text = status[row]
        let label2 = UILabel()
        label2.frame = CGRect(x:0, y:20, width:width, height:height)
        label2.textAlignment = .center
        if #available(iOS 11.0, *) {
            label2.font = UIFontMetrics.default.scaledFont(for: semiBoldLabel!)
        } else {
            // Fallback on earlier versions
        }
        label2.text = statusText[row]
        view.addSubview(label2)
        view.addSubview(label)
        
        //View rotation
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
      @objc func handleMap() {
        let addController = MapController()
        self.navigationController?.pushViewController(addController, animated: true)
    }
    
   @objc func handleSettings() {
        
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Sign Out button")
            do {
                try Auth.auth().signOut()
            } catch let logoutError {
                print(logoutError)
            }
            let loginController = LoginController()
            self.present(loginController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        

    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        self.present(loginController, animated: true, completion: nil)

    }
    
    @objc func handleAdd() {
  
        
        //presents login view
        let addController = CreateStatusController()
        let navigationController = UINavigationController(rootViewController: addController)
        present(navigationController, animated: true, completion: nil)
        
        // perform(#selector(removeNavigationText), with: nil, afterDelay: 1)
        
    }
//    @objc func removeNavigationText() {
//        self.navigationItem.title = " "
//    }


}


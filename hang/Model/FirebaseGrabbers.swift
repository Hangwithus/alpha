//
//  FirebaseGrabbers.swift
//  hang
//
//  Created by Nolan Canady on 4/25/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseData: NSObject{
    var name: String = "name not found"
    var UID: String = "uid not found"
    var phoneNumber: String = "phone number not found"
    var email: String = "email not found"
    var friendsList: [String] = ["friends list not found"]
    var friendsCode: String = "friends code not found"
    var status: String = "status not found"
    var timeHang: String = "time left not found"
    var numberOfFriends: String = "number of friends not found"
    var currentHang: [String] = ["current hang not found"]
    var location: [String] = ["location not found"]
    
    let fbRef = Database.database().reference(fromURL: "https://hang-8b734.firebaseio.com/")
    
    
    
    
    
    func performQuery(uid: String, data: String) -> String{
        let rootRef = Database.database().reference()
        print("that uid")
        print(uid)
        let query = rootRef.child("users").child(uid)
        var returnData = "instance not found"
        query.observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print("printing value")
            print(value)
            return returnData = value?[data] as? String ?? returnData
        }
        return returnData
    }
    
    func performQuery(uid: String, data: String) -> [String]{
        let rootRef = Database.database().reference()
        print("that uid")
        print(uid)
        let query = rootRef.child("users").child(uid)
        var returnData = ["instance not found"]
        query.observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print("printing value")
            print(value)
            returnData = value?[data] as? [String] ?? returnData
        }
        return returnData
    }
    
    func getLocation(uid: String) -> [String]{
        return performQuery(uid: uid, data: "location")
    }
    
    func getNumFriends(uid: String) -> String{
        return performQuery(uid: uid, data: "numFriends")
    }
    
    func getFriendsCode(uid: String) -> String{
        return performQuery(uid: uid, data: "friendCode")
    }
    
    func getFriendsList(uid: String) -> [String]{
        return performQuery(uid: uid, data: "friendsList")
    }
    
    func getEmail(uid: String) -> String{
        return performQuery(uid: uid, data: "email")
    }
    
    func getName(uid: String) -> String{
        return performQuery(uid: uid, data: "name")
    }
    
    func getStatus(uid: String) -> String{
        return performQuery(uid: uid, data: "status")
    }
}

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
    
    /*
 
        The code in this file isn't working because it is not async, but I still commented it anyway
        For further updates
     
     */
    
    
    //Establish vars for all the potential data we would be have for the app
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
    
    //reference the firebase database
    let fbRef = Database.database().reference(fromURL: "https://hang-8b734.firebaseio.com/")
    
    
    
    
    //perform a query that returns a single string
    //takes in the parameters of the uid in question and the string from the query we want to get
    func performQuery(uid: String, data: String) -> String{
        let rootRef = Database.database().reference() //reference the database
        print("that uid")
        print(uid) //print the uid to make sure we are fudging with the right user
        let query = rootRef.child("users").child(uid) //query and grab the users stuff
        var returnData = "instance not found" //let us know if the query failed
        query.observe(.value) { (snapshot) in //observe and look through the query
            let value = snapshot.value as? NSDictionary //make the data a readable dictionary
            print("printing value") //print it so we can double check that its the right stuff
            print(value)
            return returnData = value?[data] as? String ?? returnData //return this query
        }
        return returnData
    }
    
    //perfor a query that returns a string array (friends list, location), see the commented code above
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
    
    /*
 
     The below functions all work the same way, the just perform a query for a specifc data piece
 
     */
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

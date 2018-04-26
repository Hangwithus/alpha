//
//  User.swift
//  hang
//
//  Created by Joe Kennedy on 4/17/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit

class Users: NSObject {
    
    var name: String?
    var email: String?
    var availability: String?
    var status: String?
}

var status = ["not","💻", "🍱", "🍻"]
var statusText = ["available","working", "food", "beer"]
var statusAdded = false

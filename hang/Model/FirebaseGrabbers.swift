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
import ObjectMapper
import RxSwift
import RxCocoa

extension BaseMappable {
    static var firebaseIdKey : String {
        get {
            return "https://hang-8b734.firebaseio.com/"
        }
    }
    init?(snapshot: DataSnapshot) {
        guard var json = snapshot.value as? [String: Any] else {
            return nil
        }
        json[Self.firebaseIdKey] = snapshot.key as Any
        
        self.init(JSON: json)
    }
}

class UserCellData: Mappable{
    var name: String?
    var status: String?
    var longitude: Int?
    var latitude: Int?
    var timeLeft: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map){
        name <- map["name"]
        status <- map["status"]
        timeLeft <- map["duration"]
        longitude <- map["location.longitude"]
        latitude <- map["location.latitude"]
    }
}

extension DatabaseQuery {
    
    func rx_observeSingleEvent(of event: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create({ (observer) -> Disposable in
            self.observeSingleEvent(of: event, with: { (snapshot) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: { (error) in
                observer.onError(error)
            })
            return Disposables.create()
        })
    }
    
    func rx_observeEvent(event: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create({ (observer) -> Disposable in
            let handle = self.observe(event, with: { (snapshot) in
                observer.onNext(snapshot)
            }, withCancel: { (error) in
                observer.onError(error)
            })
            return Disposables.create {
                self.removeObserver(withHandle: handle)
            }
        })
    }
    func getPosts() -> Observable<[Post]> {
        let postRef = Database.database().reference()
            .child("posts")
        return postRef.rx_observeSingleEvent(of: .value)
            .map { Mapper<Post>().mapArray(snapshot: $0) }
    }
   /* getPosts().subscribe(onNext: { posts in
    //show the data or do whatever you want
    }, onError: { error in
    //show an alert
    }).disposed(by: disposeBag)*/
}


extension Mapper {
    func mapArray(snapshot: DataSnapshot) -> [N] {
        return snapshot.children.map { (child) -> N? in
            if let childSnap = child as? DataSnapshot {
                return N(snapshot: childSnap)
            }
            return nil
            //flatMap here is a trick
            //to filter out `nil` values
            }.flatMap { $0 }
    }
}

func getPosts(completion: @escaping (([Post]) -> Void)) {
    let postRef = Database.database().reference()
        .child("posts")
    postRef.observeSingleEvent(of: .value) { (snapshot) in
        completion(Mapper<Post>().mapArray(snapshot: snapshot))
    }
}


class Post: Mappable {
    var name: String?
    var friendCode: String?
    //var content: String?
    //var author: String?
    
    func mapping(map: Map) {
        name <- map["name"]
        friendCode <- map["friendCode"]
        //content <- map["content"]
        //author <- map["author"]
    }
    required init?(map: Map) { }
}

func getPost(postId: String, completion:@escaping ((Post?) -> Void)) {
    let postRef = Database.database()
        .reference().child("posts").child("postId")
    postRef.observeSingleEvent(of: .value, with: { (snapshot) in
        completion(Post(snapshot: snapshot))
    })
}

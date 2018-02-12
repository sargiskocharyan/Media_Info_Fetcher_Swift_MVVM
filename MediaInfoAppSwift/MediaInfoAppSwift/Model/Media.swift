//
//  Media.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class MediaCollection: Mappable {
    var mediaCollection: [Media]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mediaCollection <- map["mediaCollection"]
    }
}

class Media: Object, Mappable {
    dynamic open var title: String = ""
    dynamic open var category: String = ""
    dynamic open var body: String = ""
    dynamic open var shareUrl: String = ""
    dynamic open var coverPhotoUrl: String = ""
    dynamic open var isReviewed: Bool = false
    dynamic open var date: Double = 0.0 //timestamp
     open var gallery: List<Gallery> = List<Gallery>()
     open var video: List<Video> = List<Video>()
    
    required public convenience init?(map: Map) {
        self.init()
    }
    

    override open static func primaryKey() -> String? {
        return "title"
    }
    
    public func mapping(map: Map) {
        title         <- map["title"]
        category      <- map["category"]
        body          <- map["body"]
        shareUrl      <- map["shareUrl"]
        coverPhotoUrl <- map["coverPhotoUrl"]
        date          <- map["date"]
        isReviewed    <- map["isReviewed"]
        gallery       <- (map["gallery"], ListTransform<Gallery>())
        video         <- (map["video"], ListTransform<Video>())
    }
}


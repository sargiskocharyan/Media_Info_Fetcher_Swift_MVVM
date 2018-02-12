//
//  VIdeo.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Videos: Mappable {
    var videos: [Video]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        videos  <- map["videos"]
    }
}

class Video: Object, Mappable {
    dynamic open var title: String?
    dynamic open var thumbnailUrl: String?
    dynamic open var youtubeId: String?
    
    required public convenience init?(map: Map) {
        self.init()
    }
    
    
    override open static func primaryKey() -> String? {
        return "title"
    }
    func mapping(map: Map) {
        title        <- map["title"]
        thumbnailUrl <- map["thumbnailUrl"]
        youtubeId    <- map["youtubeId"]
    }
}


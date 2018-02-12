//
//  Gallery.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Galleries: Mappable {
    var galleries: [Gallery]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        galleries  <- map["galleries"]
    }
}

class Gallery: Object, Mappable {
    dynamic open var title: String?
    dynamic open var thumbnailUrl: String?
    dynamic open var contentUrl: String?

    
    required public convenience init?(map: Map) {
        self.init()
    }
    
    
    override open static func primaryKey() -> String? {
        return "title"
    }
    
    func mapping(map: Map) {
        title        <- map["title"]
        thumbnailUrl <- map["thumbnailUrl"]
        contentUrl   <- map["contentUrl"]
    }
}

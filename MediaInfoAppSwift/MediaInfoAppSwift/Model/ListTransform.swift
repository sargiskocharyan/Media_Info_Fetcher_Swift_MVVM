//
//  ListTransform.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/10/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import RealmSwift

open class ListTransform<T:Object> : TransformType where T:Mappable {
    public typealias Object = List<T>
    public typealias JSON = [[String:Any]]
    
    let mapper = Mapper<T>()
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        let result = List<T>()
        if let tempArray = value as? [Any] {
            for entry in tempArray {
                let mapper = Mapper<T>()
                let model : T = mapper.map(JSONObject: entry)!
                result.append(model)
            }
        }
        return result
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        var results = [[String:Any]]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}

//
//  NetworkingService.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/9/18.
//  Copyright © 2018 sargis. All rights reserved.
//

fileprivate let RemoteServerURL = "https://www.helix.am/temp/json.php"

import Foundation
import ObjectMapper
import RealmSwift

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol NetworkingServiceProtocol {
    func fetchMediaInfo( complete: @escaping ( _ success: Bool,  _ error: APIError? )->() )
}

class NetworkingService: NetworkingServiceProtocol {
    func fetchMediaInfo( complete: @escaping ( _ success: Bool,  _ error: APIError? )->() ) {
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: URL(string: RemoteServerURL)!) { data, response, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [String: Any] {
                    guard let mainInfoJson = dict["metadata"] as? Array<[String: AnyObject]> else {
                        return
                    }
                    let madiaCollection:[Media] = Mapper<Media>().mapArray(JSONArray: mainInfoJson)
                    let dataManager = DataManager()
                    dataManager.addNewMedia(fetchedMedia: madiaCollection)
                    dataManager.deleteUnwantedMedia(fetchedMedia: madiaCollection)
                    complete( true, nil )
                }
            }
            task.resume()
        }
    }
    
    
    
    
}

//
//  DataManager.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/11/18.
//  Copyright © 2018 sargis All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    
    func getAllMedia() -> Results<Media>? {
        let realm = try! Realm()
        let allMediaFromRealm = realm.objects(Media.self)
        return allMediaFromRealm.count > 0 ? allMediaFromRealm : nil
    }
    

    func deleteUnwantedMedia (fetchedMedia:[Media]) {
        var arrayFromDB:[String] = [String]()
        var arrayFromFetched:[String] = [String]()
        let realm = try! Realm()
        let allMediaFromRealm = realm.objects(Media.self)
        for items in allMediaFromRealm {
            arrayFromDB.append(items.title)
        }
        
        for items in fetchedMedia {
            arrayFromFetched.append(items.title)
        }
        //sort arrays and comparison
        let allMediaTitlesSet:Set<String> = Set<String>(arrayFromDB)
        let mediaTitlesToKeepSet:Set<String> = Set<String>(arrayFromFetched)
        let mediaTitlesToDelete = allMediaTitlesSet.subtracting(mediaTitlesToKeepSet).sorted()
        
        if mediaTitlesToDelete.isEmpty {
            print("no difference in Media to delete")
        } else {
            try! realm.write {
                realm.delete(allMediaFromRealm.filter("title IN %@", mediaTitlesToDelete))
            }
        }
    }
    
    func addNewMedia (fetchedMedia:[Media])  {
        var arrayFromDB:[String] = [String]()
        var arrayFromFetched:[String] = [String]()
        let realm = try! Realm()
        let allMediaFromRealm = realm.objects(Media.self)
        for items in allMediaFromRealm {
            arrayFromDB.append(items.title)
        }
        
        for items in fetchedMedia {
            arrayFromFetched.append(items.title)
        }
        
        let allMediaTitlesSetDb:Set<String> = Set<String>(arrayFromDB)
        let mediaTitlesFetchedSet:Set<String> = Set<String>(arrayFromFetched)
        let mediaTitlesToAdd = mediaTitlesFetchedSet.subtracting(allMediaTitlesSetDb).sorted()
        
        if mediaTitlesToAdd.isEmpty {
            print("no difference in Media to add")
        } else {
            try! realm.write {
                for media in fetchedMedia {
                    if mediaTitlesToAdd.contains(media.title) {
                        realm.add(media, update: true)
                    }
                }
            }
        }
    }
}

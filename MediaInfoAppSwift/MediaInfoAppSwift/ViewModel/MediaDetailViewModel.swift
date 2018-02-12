//
//  MediaDetailViewModel.swift
//  TestMediaInfoApp
//
//  Created by sargis on 2/10/18.
//  Copyright © 2018 sargis. All rights reserved.
//

import Foundation
import RealmSwift

class MediaDetailViewModel {
    
    var media: Media?
    var titleText:String?
    var categoryText:String?
    var dateText:String?
    var coverPhotoUrl:String?
    var bodyText:String?
    var gallery:List<Gallery>?
    var video:List<Video>?
    
    func initFetchMedia(mediaIndex:Int) {
        let realm = try! Realm()
        media = realm.objects(Media.self)[mediaIndex]
        titleText = media?.title
        categoryText = media?.category
        let date = Date(timeIntervalSince1970: (media?.date)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText = dateFormatter.string(from: date)
        coverPhotoUrl = media?.coverPhotoUrl
        let encodedString = media?.body
        if let data = encodedString?.data(using: .utf8) {
            let options: [String: Any] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
            ]
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                let decodedString = attributedString.string
                bodyText = decodedString
            }
        }
        else {
           bodyText = media?.body
        }
        
        if (media?.gallery.count)! > 0  {
            gallery = media?.gallery
        }
        if (media?.video.count)! > 0  {
            video = media?.video
        }
    }
    
    func markMediaAsSeen() {
        let realm = try! Realm()
        try! realm.write {
            media?.isReviewed = true
            realm.add(media!, update: true)
        }
    }
}
